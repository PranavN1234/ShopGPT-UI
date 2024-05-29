//
//  ImageSelectionView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageSelectionView: View {
    @StateObject private var viewModel = ImageUploadViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("No image Selected")
                    .foregroundColor(.gray)
                    .padding()
                
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
                    }
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                    
                    Button(action: {
                        viewModel.isCamera = true
                        viewModel.isShowingImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            Text("Take a photo")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                    }
                    .padding()
                }
                
                NavigationLink(destination: ImageConfirmationView(viewModel: viewModel), isActive: $viewModel.isShowingImageConfirmation) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePickerService(sourceType: viewModel.isCamera ? .camera : .photoLibrary, selectedImage: $viewModel.selectedImage)
            }
            .onChange(of: viewModel.selectedImage) { _ in
                if viewModel.selectedImage != nil {
                    viewModel.isShowingImageConfirmation = true
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}



#Preview {
    ImageSelectionView()
}
