//
//  LoginViewModel.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

class LoginViewModel: ObservableObject{
    @Published var phoneNumber = ""
    @Published var code = ""
    @Published var errorMessage = ""
    @Published var showAlert = false
    @Published var otpSent = false
    @Published var isLoggedIn = false
    @Published var tries: Int = 0
    
    func getCountryCode()->String{
        let regionCode = Locale.current.region?.identifier ?? ""
        
        return countryCodes[regionCode] ?? ""
    }
    
    func sendOTP(completion: @escaping (Bool) -> Void) {
        let fullPhoneNumber = "+\(getCountryCode())\(phoneNumber)"
        LoginService.shared.sendOTP(phoneNumber: fullPhoneNumber) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    if status == "pending" {
                        self.otpSent = true
                        print("Otp sent is set to true!")
                        print(self.otpSent)
                        completion(true)
                    } else {
                        self.errorMessage = "Failed to send OTP"
                        self.showAlert = true
                        completion(false)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    completion(false)
                }
            }
        }
    }
    
    func verifyOTP(completion: @escaping (Bool) -> Void) {
        let fullPhoneNumber = "+\(getCountryCode())\(phoneNumber)"
        LoginService.shared.verifyOTP(phoneNumber: fullPhoneNumber, otp: code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("verifyOTP response: \(response)")  // Add this line for logging
                    if let status = response["status"] as? String, status == "approved" {
                        if let triesString = response["tries"] as? String, let tries = Int(triesString) {
                            self.tries = tries
                            print("Tries updated to: \(self.tries)")  // Add this line for logging
                        } else if let tries = response["tries"] as? Int {
                            self.tries = tries
                            print("Tries updated to: \(self.tries)")  // Add this line for logging
                        } else {
                            print("Tries key not found or invalid in response")  // Add this line for logging
                        }
                        self.isLoggedIn = true
                        completion(true)
                    } else {
                        self.errorMessage = "Invalid OTP"
                        self.showAlert = true
                        completion(false)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    completion(false)
                }
            }
        }
    }
    
    func decrementUserTries() {
            let fullPhoneNumber = "+\(getCountryCode())\(phoneNumber)"
            let newTries = self.tries - 1
            print("updating tries to \(newTries)")

            LoginService.shared.updateTries(phoneNumber: fullPhoneNumber, newTries: newTries) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let updatedTries):
                        self.tries = updatedTries
                    case .failure(let error):
                        self.errorMessage = "Failed to decrement tries: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }
        }
}
