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
                BrandingView()
                Spacer()
                Rectangle()
                            .fill(Color.white) // Sets the interior color to white
                            .frame(width: 200, height: 100) // Specify the size of the rectangle
                            .overlay(
                                Rectangle() // Overlay another rectangle for the border
                                    .stroke(Color.gray, lineWidth: 3) // Sets the border color to gray and width to 3
                            )
                            .padding()
                Spacer()
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
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)  // Adjust size as needed
                            Text("Select Photo")
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 150, height: 100) // Specify exact size for the button content
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
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.green)
                                .frame(width: 40, height: 40)  // Ensure image size is the same as the first button
                            Text("Take a Photo")
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 150, height: 100) // Ensure the frame is identical to the first button
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                
                Spacer()

                
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
