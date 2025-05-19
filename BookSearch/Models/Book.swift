//
//  Book.swift
//  BookSearch
//
//  Created by Suzie Kim on 5/17/25.
//

struct KakaoBookResponse: Codable {
    let documents: [Book]
}

struct Book: Codable {
    let title: String
    let authors: [String]
    let contents: String
    let thumbnail: String
    let price: Int?
}

