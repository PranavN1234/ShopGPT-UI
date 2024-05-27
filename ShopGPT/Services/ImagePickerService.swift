//
//  ImagePickerService.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/26/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerService: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                selectedImage = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
