//
//  BrandingView.swift
//  ShopGPT
//
//  Created by Surya Das on 5/28/24.
//

import SwiftUI

struct BrandingView: View {
    var body: some View {
        VStack {

            Text("ShopGPT")
                .font(.system(size: 45, weight: .bold, design: .rounded)) // Specified size, bold weight, rounded design
                .foregroundColor(.black)
                .padding(.top, 20) // Adds padding at the top of the text
            // Pushes the text to the top
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Ensures VStack fills the parent and aligns text to the top
        

        
    }
}


#Preview {
    BrandingView()
}
