//
//  ViewController.swift
//  VideoPostPrototype
//
//  Created by Chad Parker on 7/16/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        requestVideoPermission()
    }

    private func requestPermissionAndShowCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestVideoPermission()
        case .restricted:
            preconditionFailure("Video is disabled. Please review device restrictions.")
        case .denied:
            preconditionFailure("Tell user to change settings > privacy > video.")
        case .authorized:
            showCamera()
        @unknown default:
            preconditionFailure("New status code to handle")
        }
    }

    private func requestVideoPermission() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            guard isGranted else {
                preconditionFailure("UI: Tell the user to enable permissions for video/camera")
            }

            DispatchQueue.main.async {
                self.showCamera()
            }
        }
    }

}
