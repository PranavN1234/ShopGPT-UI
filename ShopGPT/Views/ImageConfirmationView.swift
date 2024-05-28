//
//  ImageConfirmationView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageConfirmationView: View {
    @ObservedObject var viewModel: ImageUploadViewModel
    @State private var navigateToUploadedView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                    
                    if let productName = viewModel.productName {
                        Text("Product Name: \(productName)")
                            .font(.headline)
                            .padding()
                    }
                    
                    Button(action: { viewModel.reset() }) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        viewModel.uploadImage()
                    }) {
                        Text("Upload Image")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
            .onChange(of: viewModel.productName) { _ in
                if viewModel.productName != nil {
                    navigateToUploadedView = true
                }
            }
            .navigationDestination(isPresented: $navigateToUploadedView) {
                ImageUploadedView(viewModel: viewModel)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    ImageConfirmationView(viewModel: ImageUploadViewModel())
}
