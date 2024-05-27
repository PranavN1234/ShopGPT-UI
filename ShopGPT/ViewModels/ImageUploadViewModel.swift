import SwiftUI

class ImageUploadViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var isCamera = false
    @Published var productName: String?
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var navigationDestination: NavigationDestination?

    func uploadImage() {
        guard let selectedImage = selectedImage else { return }

        ImageUploadService.shared.uploadImage(selectedImage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productName):
                    self?.productName = productName
                case .failure(let error):
                    print("Failed to upload image: \(error)")
                }
            }
        }
    }

    func fetchProducts(completion: @escaping () -> Void) {
        guard let productName = productName else { return }

        isLoading = true
        ProductService.shared.fetchProducts(for: productName) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.navigationDestination = .products
                    completion()
                case .failure(let error):
                    print("Failed to fetch products: \(error)")
                }
            }
        }
    }

    func navigateToLoadingAndFetchProducts(completion: @escaping () -> Void) {
        navigationDestination = .loading
        fetchProducts {
            self.navigationDestination = .products
            completion()
        }
    }

    func resetNavigation() {
        navigationDestination = nil
    }
    
    func reset() {
            selectedImage = nil
            productName = nil
            products = []
            isShowingImagePicker = false
            isCamera = false
            isLoading = false
            navigationDestination = nil
        }
}
