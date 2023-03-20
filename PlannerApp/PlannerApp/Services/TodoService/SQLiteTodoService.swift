//
//  SQLiteTodoService.swift
//  PlannerApp
//
//  Created by Yevtushenko Valeriia on 26.09.2022.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case insert
    case get
    case update
    case delete
}

class SQLiteTodoService {
    private let databasePath: String = "planner.app.database.sqlite"
    private var database: OpaquePointer?
    
    init() {
        database = openDatabase()
        configureTables()
    }
}

private extension SQLiteTodoService {
    func configureTables() {
        let createTodoTableString = """
        CREATE TABLE IF NOT EXISTS Todo(
        documentid TEXT PRIMARY KEY NOT NULL,
        name VARCHAR(255),
        deadline DATETIME,
        resolved BOOLEAN,
        tag VARCHAR(255),
        useruid VARCHAR(255),
        notificationid VARCHAR(255));
        """
        var createTableStatement: OpaquePointer?
        
        guard sqlite3_prepare_v2(database, createTodoTableString, -1, &createTableStatement, nil) == SQLITE_OK,
              sqlite3_step(createTableStatement) == SQLITE_DONE else {
            print("table could not be created.")
            return
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databasePath)
        var database: OpaquePointer?
        
        guard let url = fileURL,
              sqlite3_open(url.path, &database) == SQLITE_OK else {
            print("error opening database")
            return nil
        }
        
        return database
    }
}

extension SQLiteTodoService: TodoServiceProtocol {
    typealias TodoModel = Document<Todo>
    
    func get(by date: Date) async throws -> [TodoModel] {
        return try await withCheckedThrowingContinuation { continuation in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            
            guard let start = Calendar.current.date(from: components),
                  let end = Calendar.current.date(byAdding: .day, value: 1, to: start) else {
                continuation.resume(throwing: SQLiteError.get)
                return
            }
            
            let queryStatementString = "SELECT * FROM Todo WHERE deadline BETWEEN \(start.timeIntervalSince1970) AND \(end.timeIntervalSince1970);"
            var queryStatement: OpaquePointer?
            var todos: [TodoModel] = []
            
            guard sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK else {
                print("SELECT statement could not be prepared")
                continuation.resume(throwing: SQLiteError.insert)
                return
            }
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let documentId = sqlite3_column_text(queryStatement, 0),
                      let name = sqlite3_column_text(queryStatement, 1),
                      let tag = sqlite3_column_text(queryStatement, 4),
                      let userUID = sqlite3_column_text(queryStatement, 5),
                      let notificationid = sqlite3_column_text(queryStatement, 6) else {
                    return
                }
                    
                let deadline = sqlite3_column_double(queryStatement, 2)
                let isResolved = sqlite3_column_int(queryStatement, 3)
                var todo = Document(documentId: String(cString: documentId),
                         data: Todo(name: String(cString: name),
                                    deadline: Date(timeIntervalSince1970: deadline),
                                    isResolved: (isResolved != 0),
                                    userUID: String(cString: userUID),
                                    tag: String(cString: tag),
                                    notificationId: String(cString: notificationid)))
                
                todos.append(todo)
            }
            
            sqlite3_finalize(queryStatement)
            continuation.resume(returning: todos)
        }
    }
    
    func create(_ document: TodoModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let deadline = document.data.deadline.timeIntervalSince1970
            let isResolved = document.data.isResolved.intValue
            let notificationId = document.data.notificationId
            let userUID = document.data.userUID
            let tag = document.data.tag
            let name = document.data.name
            let insertStatementString = """
            INSERT INTO Todo
            VALUES
            ('\(document.documentId)', '\(name)', \(deadline), \(isResolved), '\(tag)', '\(userUID)', '\(notificationId)');
            """
            var insertStatement: OpaquePointer?
            
            guard sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) ==
                    SQLITE_OK,
                  sqlite3_step(insertStatement) == SQLITE_DONE else {
                continuation.resume(throwing: SQLiteError.insert)
                return
            }
            
            sqlite3_finalize(insertStatement)
            continuation.resume(returning: ())
        }
    }
    
    func update(_ document: TodoModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let deadline = document.data.deadline.timeIntervalSince1970
            let isResolved = document.data.isResolved.intValue
            let notificationId = document.data.notificationId
            let userUID = document.data.userUID
            let tag = document.data.tag
            let name = document.data.name
            let updateStatementString = """
            UPDATE Todo SET
            name = '\(name)',
            deadline = \(deadline),
            resolved = \(isResolved),
            tag = '\(tag)',
            useruid = '\(userUID)',
            notificationid = '\(notificationId)' WHERE documentid = '\(document.documentId)';
            """
            var updateStatement: OpaquePointer?
            
            guard sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) ==
                    SQLITE_OK,
                  sqlite3_step(updateStatement) == SQLITE_DONE else {
                continuation.resume(throwing: SQLiteError.update)
                return
            }
            
            sqlite3_finalize(updateStatement)
            continuation.resume(returning: ())
            
        }
    }
    
    func delete(_ documentId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let deleteStatementString = "DELETE FROM Todo WHERE documentid = '\(documentId)';"
            var deleteStatement: OpaquePointer?
            
            guard sqlite3_prepare_v2(database, deleteStatementString, -1, &deleteStatement, nil) ==
                    SQLITE_OK,
                  sqlite3_step(deleteStatement) == SQLITE_DONE else {
                continuation.resume(throwing: SQLiteError.delete)
                return
            }
            
            sqlite3_finalize(deleteStatement)
            continuation.resume(returning: ())
        }
    }
}
