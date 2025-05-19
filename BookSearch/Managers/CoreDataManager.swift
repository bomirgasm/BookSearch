//
//  CoreDataManager.swift
//  BookSearch
//
//  Created by Suzie Kim on 5/17/25.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func save(book: Book) {
        let entity = SavedBook(context: context)
        entity.title = book.title
        entity.authors = book.authors.joined(separator: ", ")
        entity.price = Int32(book.price ?? 0)
        entity.thumbnail = book.thumbnail
        entity.contents = book.contents

        do {
            try context.save()
            print("책 저장 완료: \(book.title)")
        } catch {
            print("책 저장 실패: \(error)")
        }
    }

    func fetchAll() -> [SavedBook] {
        let request: NSFetchRequest<SavedBook> = SavedBook.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("불러오기 실패: \(error)")
            return []
        }
    }

    func delete(_ book: SavedBook) {
        context.delete(book)
        try? context.save()
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedBook.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("❌ 전체 삭제 실패: \(error)")
        }
    }

}
