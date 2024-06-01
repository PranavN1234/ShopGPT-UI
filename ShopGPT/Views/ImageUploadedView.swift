//
//  ImageUploadedView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageUploadedView: View {
    @ObservedObject var viewModel: ImageUploadViewModel
    @ObservedObject var loginData: LoginViewModel
    @State private var isLoading = false

    var body: some View {
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
                    
                    NavigationLink(destination: ProductCarouselView(products: viewModel.products, loginData: loginData)
                                    .environmentObject(loginData),
                                   isActive: $viewModel.navigateToProducts) {
                        Button(action: {
                            isLoading = true
                            viewModel.navigateToLoadingAndFetchProducts {
                                DispatchQueue.main.async {
                                    isLoading = false
                                    viewModel.navigateToProducts = true
                                }
                            }
                        }) {
                            Text("Shop for Products")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isLoading) {
            LoadingView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ImageUploadedView(viewModel: ImageUploadViewModel(), loginData: LoginViewModel())
}
