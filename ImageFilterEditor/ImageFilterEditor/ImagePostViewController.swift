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

    // MARK: - Outlets

    @IBOutlet weak var selectImageButtonContainer: UIView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurButton: UIButton!


    // MARK: - Properties

    var originalImage: UIImage?
    var currentFilter: CIFilter?


    // MARK: - UI State

    enum UIState {
        case noPhoto
        case photoPicked(UIImage)
        case selectFilter(CIFilter)
    }

    var state: UIState = .noPhoto {
        didSet {
            updateUI()
        }
    }


    // MARK: - UI Updates

    override func viewDidLoad() {
        super.viewDidLoad()

        selectImageButton.layer.cornerRadius = 16
        blurButton.layer.cornerRadius = 8
        blurButton.layer.borderWidth = 0.5
    }

    private func updateUI() {
        switch state {
        case .noPhoto:
            selectImageButtonContainer.isHidden = false
        case .photoPicked(let image):
            originalImage = image
            imageView.image = image
            selectImageButtonContainer.isHidden = true
        case .selectFilter(let filter):
            print(filter)
        }
    }


    // MARK: - Actions

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

    @IBAction func blur(_ sender: Any) {

    }
}


// MARK: - Image Picker Delegate

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.editedImage] as? UIImage {
            state = .photoPicked(image)
        } else if let image = info[.originalImage] as? UIImage {
            state = .photoPicked(image)
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
