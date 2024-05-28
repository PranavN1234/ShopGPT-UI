//
//  ImageUploadedView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageUploadedView: View {
    @ObservedObject var viewModel: ImageUploadViewModel
    @State private var navigationPath = NavigationPath()
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                        
                        Button(action: {
                            isLoading = true
                            viewModel.navigateToLoadingAndFetchProducts {
                                DispatchQueue.main.async {
                                    isLoading = false
                                    navigationPath.append(NavigationDestination.products)
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
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .products:
                    ProductCarouselView(products: viewModel.products)
                        .onAppear {
                            viewModel.resetNavigation()
                        }
                default:
                    EmptyView()
                }
            }
            .fullScreenCover(isPresented: $isLoading) {
                LoadingView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ImageUploadedView(viewModel: ImageUploadViewModel())
}
