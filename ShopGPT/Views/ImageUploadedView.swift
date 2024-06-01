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
            BrandingView().padding(20)
            Spacer()
            if let selectedImage = viewModel.selectedImage {
                ZStack{
                        Image(uiImage: viewModel.selectedImage ?? UIImage(named: "defaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:300, height: 450)
                            .cornerRadius(10)
                    }
                    .padding()
                
                if let productName = viewModel.productName {
                    Text("Product Name: \(productName)")
                        .font(.headline)
                    
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
                            HStack {
                                Image(systemName: "cart")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                                Text("Shop for Products")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .frame(width: 290, height: 100)
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
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    ImageUploadedView(viewModel: ImageUploadViewModel(), loginData: LoginViewModel())
}
