//
//  APIManager.swift
//  BookSearch
//
//  Created by Suzie Kim on 5/17/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}

    func searchBooks(query: String, completion: @escaping ([Book]) -> Void) {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(encoded)") else { return }

        var request = URLRequest(url: url)
        request.setValue("KakaoAK 014e91b3ee74725ef06a455b36ff801f", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(KakaoBookResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.documents)
                }
            } catch {
                print("API Decode Error:", error)
            }
        }.resume()
    }
}
