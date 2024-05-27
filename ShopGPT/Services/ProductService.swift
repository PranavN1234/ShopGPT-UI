//
//  ProductService.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/26/24.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    private init() {}

    func fetchProducts(for productName: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://92d5-2600-4808-6030-1400-44e3-2d03-d24a-f11c.ngrok-free.app/shop-products") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["product_name": productName]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([String: [Product]].self, from: data)
                if let products = response["products"] {
                    completion(.success(products))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}