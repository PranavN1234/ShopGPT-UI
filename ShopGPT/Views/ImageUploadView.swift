//
//  ImageUploadView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/26/24.
//

import SwiftUI

struct ImageUploadView: View {
    @StateObject private var viewModel = ImageUploadViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                } else {
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                        .padding()
                }

                if let productName = viewModel.productName {
                    Text("Product Name: \(productName)")
                        .font(.headline)
                        .padding()

                    Button(action: {
                        viewModel.navigateToLoadingAndFetchProducts()
                        navigationPath.append(NavigationDestination.loading)
                    }) {
                        Text("Shop for Products")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                HStack {
                    Button(action: {
                        viewModel.isCamera = false
                        viewModel.isShowingImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                            Text("Select from Gallery")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                    }
                    .padding()

                    Button(action: {
                        viewModel.isCamera = true
                        viewModel.isShowingImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            Text("Take a Photo")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                    }
                    .padding()
                }

                if viewModel.selectedImage != nil {
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
                }
            }
            .padding()
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePickerService(sourceType: viewModel.isCamera ? .camera : .photoLibrary, selectedImage: $viewModel.selectedImage)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .loading:
                    LoadingView()
                        .onAppear {
                            viewModel.fetchProducts()
                        }
                case .products:
                    ProductListView(products: viewModel.products)
                }
            }
            .onChange(of: viewModel.navigationDestination) { _, newValue in
                if let newValue = newValue {
                    navigationPath.append(newValue)
                }
            }
        }
    }
}

#Preview {
    ImageUploadView()
}
