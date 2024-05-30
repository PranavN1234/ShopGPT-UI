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
//                Text("Product Name: product")
                            .font(.headline)
                        
                        Button(action: {
                            isLoading = true
                            viewModel.navigateToLoadingAndFetchProducts {
                                DispatchQueue.main.async {
                                    isLoading = false
                                    navigationPath.append(NavigationDestination.products)
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
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer()
            
            
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
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    ImageUploadedView(viewModel: ImageUploadViewModel())
}
