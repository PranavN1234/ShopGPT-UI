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
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                BrandingView().padding(-30)
                Spacer()
                Text("")
                    .foregroundColor(.gray)
                    .padding()
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
                    Spacer()
                    Text("")
                        .foregroundColor(.gray)
                        .padding()
                    
                    HStack{
                        Button(action: {
                            viewModel.reset()
                            presentationMode.wrappedValue.dismiss()
                            navigateToUploadedView = false
                        }) {
                            VStack{
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                Text("Retake Image")
                                    .foregroundColor(.black)
                                
                            }
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .frame(width: 150, height: 100)
                            
                        }
                        
                        
                        Button(action: {
                            viewModel.uploadImage()
                        }) {
                            VStack{
                                Image(systemName:"square.and.arrow.up")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                Text("Upload Image")
                                    .foregroundColor(.black)
                                
                            }
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .frame(width: 150, height: 100)
                            
                        }
                        
                    }
                    .frame(alignment: .center)
                    Spacer()
                    
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



