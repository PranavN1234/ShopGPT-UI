//
//  LoginService.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import Foundation

class LoginService {
    static let shared = LoginService()
    
    private init() {}
    
    func sendOTP(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://7e3a-2600-4808-6030-1400-a144-c0f9-d92e-d64.ngrok-free.app/send-otp") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["phone_number": phoneNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["status"] as? String {
                    completion(.success(status))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func verifyOTP(phoneNumber: String, otp: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://7e3a-2600-4808-6030-1400-a144-c0f9-d92e-d64.ngrok-free.app/verify-otp") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["phone_number": phoneNumber, "otp": otp]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let status = json["status"] as? String {
                    completion(.success(status))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

