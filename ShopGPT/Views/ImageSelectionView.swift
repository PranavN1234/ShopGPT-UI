//
//  ImageSelectionView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageSelectionView: View {
    @StateObject private var viewModel = ImageUploadViewModel()
    @ObservedObject var loginData: LoginViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                BrandingView().padding()
                
                ZStack {
                    Rectangle()
                        .fill(Color.white) // Sets the interior color to white
                        .frame(width: 300, height: 450) // Specify the size of the rectangle
                    
                        .overlay(
                            Rectangle()
                                .stroke(Color.gray, lineWidth: 4)
                                .cornerRadius(5)
                        )
                    
                    Image(systemName: "photo.on.rectangle")
                        .resizable() // Allows the image to resize
                        .aspectRatio(contentMode: .fit) // Maintains the aspect ratio while fitting within the frame
                        .frame(width: 75, height: 75)
                    
                }
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
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Text("Select Photo")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                        .frame(width: 150, height: 100)
                    }
                    

                    Button(action: {
                        viewModel.isCamera = true
                        viewModel.isShowingImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                            Text("Take a Photo")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                        .frame(width: 160, height: 100)
                    }
                    
                }
                .frame(alignment: .center)

                Spacer()
                
                
                
                NavigationLink(destination: ImageConfirmationView(viewModel: viewModel, loginData: loginData), isActive: $viewModel.isShowingImageConfirmation) {
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
    ImageSelectionView(loginData: LoginViewModel())
}
