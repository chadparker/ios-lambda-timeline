//
//  ImagePostViewController.swift
//  ImageFilterEditor
//
//  Created by Chad Parker on 7/8/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ImagePostViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var stackSelectImage: UIView!
    @IBOutlet weak var stackImageFilter: UIStackView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet private var slider1: UISlider!


    // MARK: - Properties

    var originalImage: UIImage?
    private var scaledImage: UIImage?
    private let context = CIContext()

    enum Filter: String {
        case none
        case blur
    }

    var filters: [Filter: CIFilter] = [
        .blur: .gaussianBlur()
    ]


    // MARK: - UI State

    enum UIState {
        case noPhoto
        case photoPicked(UIImage)
        case selectFilter(Filter)
    }

    var state: UIState = .noPhoto {
        didSet {
            updateUI()
        }
    }


    // MARK: - UI Update

    override func viewDidLoad() {
        super.viewDidLoad()
        selectImageButton.layer.cornerRadius = 16
        blurButton.layer.cornerRadius = 8
        blurButton.layer.borderWidth = 0.5
        updateUI()
    }

    private func updateUI() {
        switch state {

        case .noPhoto:
            originalImage = nil
            scaledImage = nil
            imageView.image = nil

            stackSelectImage.isHidden = false
            stackImageFilter.isHidden = true

        case .photoPicked(let image):
            originalImage = image
            scaledImage = scale(image: image, to: imageView.bounds.size)
            imageView.image = image

            stackSelectImage.isHidden = true
            stackImageFilter.isHidden = false

        case .selectFilter(let filter):
            switch filter {
            case .none:
                slider1.isHidden = true
            case .blur:
                slider1.isHidden = false
                
                let blur = filters[filter]
                
            }
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

    @IBAction func blur(_ sender: UIButton) {
        blurButton.isSelected.toggle()
        if blurButton.isSelected {
            state = .selectFilter(.blur)
            blurButton.backgroundColor = .systemBlue
        } else {
            state = .selectFilter(.none)
            blurButton.backgroundColor = .clear
        }
    }
    
    @IBAction func slider1changed(_ sender: Any) {
        
    }
    
    
    // MARK: - Image Processing
    
    private func scale(image: UIImage, to size: CGSize) -> UIImage {
        let screenScale = UIScreen.main.scale
        let sizeInPixels = CGSize(width: size.width * screenScale, height: size.height * screenScale)
        return image.imageByScaling(toSize: sizeInPixels)
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
