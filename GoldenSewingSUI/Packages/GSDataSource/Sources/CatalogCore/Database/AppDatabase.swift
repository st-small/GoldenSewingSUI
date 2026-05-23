import Foundation
import GRDB
import SQLiteData

public func makeAppDatabase(inMemory: Bool = false) throws -> any DatabaseWriter {
    let db: any DatabaseWriter = if inMemory {
        try DatabaseQueue()
    } else {
        try DatabaseQueue(path: appSupportDatabasePath())
    }

    var migrator = DatabaseMigrator()

    migrator.registerMigration("v1") { db in
        try #sql(
            """
            CREATE TABLE "categories" (
                "id" INTEGER PRIMARY KEY NOT NULL,
                "name" TEXT NOT NULL DEFAULT '',
                "slug" TEXT NOT NULL DEFAULT '',
                "description" TEXT NOT NULL DEFAULT '',
                "link" TEXT NOT NULL DEFAULT '',
                "count" INTEGER NOT NULL DEFAULT 0,
                "parent" INTEGER NOT NULL DEFAULT 0,
                "priority" INTEGER NOT NULL DEFAULT 0
            ) STRICT
            """
        ).execute(db)

        try #sql(
            """
            CREATE TABLE "products" (
                "id" INTEGER PRIMARY KEY NOT NULL,
                "categoryId" INTEGER NOT NULL DEFAULT 0,
                "name" TEXT NOT NULL DEFAULT '',
                "slug" TEXT NOT NULL DEFAULT '',
                "link" TEXT NOT NULL DEFAULT '',
                "date" TEXT NOT NULL DEFAULT '',
                "imageURL" TEXT NOT NULL DEFAULT '',
                "thumbnailURL" TEXT NOT NULL DEFAULT '',
                "isOffer" INTEGER NOT NULL DEFAULT 0,
                "isBestOffer" INTEGER NOT NULL DEFAULT 0,
                "additionalImages" TEXT NOT NULL DEFAULT '[]'
            ) STRICT
            """
        ).execute(db)
    }

    try migrator.migrate(db)
    return db
}

private func appSupportDatabasePath() throws -> String {
    let url = try FileManager.default.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
    ).appendingPathComponent("gs_catalog.sqlite")
    return url.path
}
