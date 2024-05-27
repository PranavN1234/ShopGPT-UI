//
//  ProductListView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/26/24.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]

    var body: some View {
        List(products) { product in
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("Price: \(product.price)")
                if let logo = product.logo, let url = URL(string: logo) {
                    AsyncImage(url: url)
                        .frame(width: 50, height: 50)
                }
                Link("Buy Now", destination: URL(string: product.link)!)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationTitle("Products")
    }
}

#Preview {
    ProductListView(products: [
    
    
    ])
}
