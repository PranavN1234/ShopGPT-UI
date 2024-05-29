//
//  ImageConfirmationView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageConfirmationView: View {
    @ObservedObject var viewModel: ImageUploadViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToUploadedView = false
    
    var body: some View {
        NavigationStack{
            VStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        
                        .frame(height: 300)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
<<<<<<< Updated upstream
                    Button(action: {
                        viewModel.reset()
                        presentationMode.wrappedValue.dismiss()
                        navigateToUploadedView = false
                    }) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
=======
                    if let productName = viewModel.productName {
                        Text("Product Name: \(productName)")
                            .font(.headline)
                            .padding()
                    }
                    HStack{
                        Button(action: { viewModel.reset() }) {
                            Text("Retake Photo")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Button(action: {
                            viewModel.uploadImage()
                        }) {
                            Text("Upload Photo")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
>>>>>>> Stashed changes
                    }
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    
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
