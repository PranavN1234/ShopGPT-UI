import SwiftUI

struct ImageUploadView: View {
    @StateObject private var viewModel = ImageUploadViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var isLoading = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()
                    
                    Button(action: {
                        viewModel.reset()
                    }) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()

                    if let productName = viewModel.productName {
                        Text("Product Name: \(productName)")
                            .font(.headline)
                            .padding()

                        Button(action: {
                            isLoading = true
                            viewModel.navigateToLoadingAndFetchProducts {
                                DispatchQueue.main.async {
                                    isLoading = false
                                    navigationPath.append(NavigationDestination.products)
                                }
                            }
                        }) {
                            Text("Shop for Products")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    } else {
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
                } else {
                    Text("No Image Selected")
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
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)  // Adjust size as needed
                                Text("Select from Gallery")
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 140, height: 100) // Specify exact size for the button content
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
                                    .foregroundColor(.green)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)  // Ensure image size is the same as the first button
                                Text("Take a Photo")
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 140, height: 100) // Ensure the frame is identical to the first button
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)

                }
            }
            .padding()
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePickerService(sourceType: viewModel.isCamera ? .camera : .photoLibrary, selectedImage: $viewModel.selectedImage)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .loading:
                    LoadingView()
                case .products:
                    ProductCarouselView(products: viewModel.products)
                        .onAppear {
                            viewModel.resetNavigation()
                        }
                default:
                    EmptyView() // Handle unexpected cases
                }
            }
            .fullScreenCover(isPresented: $isLoading) {
                LoadingView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    ImageUploadView()
}
