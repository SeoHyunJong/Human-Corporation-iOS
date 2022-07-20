//
//  ImagePicker.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/20.
//
//SwiftUI에서 정식으로 지원하는 Image picker인 PhotosPicker는 iOS 16부터 사용가능하기 때문에
//일단 UIKit의 UIImagePickerController를 이용해서 처리한다.
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @EnvironmentObject var viewModel: ViewModel

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true //modified
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                parent.viewModel.uploadImg(image: possibleImage)
            } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.viewModel.uploadImg(image: possibleImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
