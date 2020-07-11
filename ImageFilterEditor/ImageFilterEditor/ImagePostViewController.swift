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

    // MARK: - Enums

    private enum Filter {
        case none, blur
    }

    private enum State {
        case noPhoto
        case photoPicked(UIImage)
        case selectFilter(Filter)
    }

    // MARK: - Outlets

    @IBOutlet private var stackSelectImage: UIView!
    @IBOutlet private var stackImageFilter: UIStackView!

    @IBOutlet private var selectImageButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var blurButton: UIButton!
    @IBOutlet private var blurSlider: UISlider!
    

    // MARK: - Properties

    private var originalImage: UIImage?
    private var scaledImage: CIImage?
    private let context = CIContext()

    private let blurFilter = CIFilter.gaussianBlur()

    private var state: State = .noPhoto {
        didSet {
            stateChanged()
        }
    }


    // MARK: - View Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        selectImageButton.layer.cornerRadius = 16
        blurButton.layer.cornerRadius = 8
        blurButton.layer.borderWidth = 0.5
        stateChanged()
    }

    // MARK: - State Changes

    private func stateChanged() {
        switch state {

        case .noPhoto:
            originalImage = nil
            scaledImage = nil
            imageView.image = nil

            stackSelectImage.isHidden = false
            stackImageFilter.isHidden = true

        case .photoPicked(let chosenImage):
            originalImage = chosenImage
            scaledImage = CIImage(image: scale(image: chosenImage, to: imageView.bounds.size))
            imageView.image = chosenImage

            stackSelectImage.isHidden = true
            stackImageFilter.isHidden = false

        case .selectFilter(let filter):
            switch filter {
            case .none:
                blurSlider.isHidden = true
            case .blur:
                blurSlider.isHidden = false
                
                let blur = filters[filter]
                
            }
    }

    private func image(byFiltering inputImage: CIImage) -> UIImage? {

//        colorControlsFilter.inputImage = inputImage
//        colorControlsFilter.saturation = saturationSlider.value
//        colorControlsFilter.brightness = brightnessSlider.value
//        colorControlsFilter.contrast = contrastSlider.value

//        blurFilter.inputImage = colorControlsFilter.outputImage?.clampedToExtent()
        blurFilter.inputImage = inputImage.clampedToExtent()
        blurFilter.radius = blurSlider.value

        // CIImage is a recipe

        guard let outputImage = blurFilter.outputImage else { return nil }
        guard let renderedCGImage = context.createCGImage(outputImage, from: inputImage.extent) else { return nil }
        return UIImage(cgImage: renderedCGImage)
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
