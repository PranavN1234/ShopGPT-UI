//
//  ContentView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/26/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            LoginView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
