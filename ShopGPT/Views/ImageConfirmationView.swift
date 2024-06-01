//
//  ImageConfirmationView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct ImageConfirmationView: View {
    @ObservedObject var viewModel: ImageUploadViewModel
    @ObservedObject var loginData: LoginViewModel
    @State private var navigateToUploadedView = false
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                    BrandingView()
                        .padding()
                }
                
                if let selectedImage = viewModel.selectedImage {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 300, height: 450)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .cornerRadius(5)
                            )
                        
                        Image(uiImage: viewModel.selectedImage ?? UIImage(named: "defaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 450)
                    }
                    .padding()
                    Spacer()
                    
                    Text("")
                        .foregroundColor(.gray)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            viewModel.reset()
                            presentationMode.wrappedValue.dismiss()
                            navigateToUploadedView = false
                        }) {
                            Text("Retake Image")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Button(action: {
                            print("tries are \(loginData.tries)")
                            if loginData.tries > 0 {
                                isLoading = true
                                viewModel.uploadImage { success in
                                    if success {
                                        print("reducing tries")
                                        loginData.decrementUserTries()
                                        DispatchQueue.main.async {
                                            isLoading = false
                                            navigateToUploadedView = true
                                        }
                                    } else {
                                        isLoading = false
                                    }
                                }
                            } else {
                                loginData.errorMessage = "Maximum tries exceeded"
                                loginData.showAlert = true
                            }
                        }) {
                            Text("Upload Image")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigateToUploadedView) {
                ImageUploadedView(viewModel: viewModel, loginData: loginData)
            }
            .fullScreenCover(isPresented: $isLoading) {
                LoadingView()
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $loginData.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(loginData.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    ImageConfirmationView(viewModel: ImageUploadViewModel(), loginData: LoginViewModel())
}
