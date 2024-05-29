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
    
    var body: some View {
        NavigationStack {
            VStack {
                BrandingView().padding(-30)
                if let selectedImage = viewModel.selectedImage {
                    ZStack{
                        Rectangle()
                            .fill(Color.white) // Sets the interior color to white
                            .frame(width: 300, height: 450) // Specify the size of the rectangle
                        
                            .overlay(
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .cornerRadius(5)
                            )
                        
                        Image(uiImage: viewModel.selectedImage ?? UIImage(named: "defaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:300, height: 450)
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
                            Text("Retake Image")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                        
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
                    .frame(maxWidth: .infinity)
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


//import SwiftUI
//
//struct ImageConfirmationView: View {
//    @ObservedObject var viewModel: ImageUploadViewModel
//    @Environment(\.presentationMode) var presentationMode
//    @State private var navigateToUploadedView = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                BrandingView().padding(-30)
//
//                ZStack{
//                    Rectangle()
//                        .fill(Color.white) // Sets the interior color to white
//                        .frame(width: 300, height: 450) // Specify the size of the rectangle
//
//                        .overlay(
//                            Rectangle()
//                                .stroke(Color.gray, lineWidth: 4)
//                                .cornerRadius(5)
//                        )
//
//                    Image(uiImage: viewModel.selectedImage ?? UIImage(named: "defaultImage")!)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: 200)
//                }
//                .padding()
//                Spacer()
//                Text("")
//                    .foregroundColor(.gray)
//                    .padding()
//
//                HStack{
//                    Button(action: {
//                        viewModel.reset()
//                        presentationMode.wrappedValue.dismiss()
//                        navigateToUploadedView = false
//                    }) {
//                        Text("Retake Image")
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.red)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//
//                    Button(action: {
//                        viewModel.uploadImage()
//                    }) {
//                        Text("Upload Image")
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                }
//                .frame(maxWidth: .infinity)
//                Spacer()
//            }
//
//            .padding()
//            .onChange(of: viewModel.productName) { _ in
//                if viewModel.productName != nil {
//                    navigateToUploadedView = true
//                }
//            }
//            .navigationDestination(isPresented: $navigateToUploadedView) {
//                ImageUploadedView(viewModel: viewModel)
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//}
//
//// Preview
//struct ImageConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageConfirmationView(viewModel: ImageUploadViewModel())
//    }
//}

