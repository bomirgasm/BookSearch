//
//  RecentBookManager.swift
//  BookSearch
//
//  Created by Suzie Kim on 5/19/25.
//

import Foundation

final class RecentBookManager {
    static let shared = RecentBookManager()
    private let key = "recent_books"

    func fetch() -> [Book] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let books = try? JSONDecoder().decode([Book].self, from: data) else {
            return []
        }
        return books
    }

    func add(_ book: Book) {
        var current = fetch()
        current.removeAll { $0.title == book.title } // 중복 제거
        current.insert(book, at: 0)
        if current.count > 10 {
            current = Array(current.prefix(10))
        }
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
