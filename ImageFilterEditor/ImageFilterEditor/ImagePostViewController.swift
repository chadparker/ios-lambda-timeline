//
//  ImagePostViewController.swift
//  ImageFilterEditor
//
//  Created by Chad Parker on 7/8/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class ImagePostViewController: UIViewController {

    @IBOutlet weak var selectImageButtonContainer: UIView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var originalImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        selectImageButton.layer.cornerRadius = 16
    }

    @IBAction func selectImage(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available.")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
