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
                    case .success(let status):
                        if status == "approved" {
                            completion(true)
                            self.isLoggedIn = true
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
}
