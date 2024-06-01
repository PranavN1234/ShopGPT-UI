//
//  ContentView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/26/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginData = LoginViewModel()

    var body: some View {
        NavigationView {
            if loginData.isLoggedIn {
                ImageSelectionView(loginData: loginData)
            } else {
                LoginView()
            }
        }
        .environmentObject(loginData)
    }
}

#Preview {
    ContentView()
}
