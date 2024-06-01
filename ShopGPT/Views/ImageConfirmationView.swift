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
                    
                    HStack {
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
