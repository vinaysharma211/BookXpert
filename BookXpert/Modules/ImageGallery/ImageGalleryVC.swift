import UIKit
import AVFoundation
import Photos

class ImageGalleryVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imageView = UIImageView()
    let captureButton = UIButton(type: .system)
    let galleryButton = UIButton(type: .system)
    let buttonStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Photos"
        setupUI()
        
        if let savedImageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let savedImage = UIImage(data: savedImageData) {
            imageView.image = savedImage
        }
    }

    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        view.addSubview(imageView)

        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        styleButton(captureButton, title: "Camera", systemImage: "camera.fill")
        styleButton(galleryButton, title: "Gallery", systemImage: "photo.on.rectangle.angled")

        captureButton.addTarget(self, action: #selector(requestCameraPermission), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(requestGalleryPermission), for: .touchUpInside)

        buttonStack.addArrangedSubview(captureButton)
        buttonStack.addArrangedSubview(galleryButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            buttonStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func styleButton(_ button: UIButton, title: String, systemImage: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: systemImage)
        config.imagePadding = 8
        config.baseBackgroundColor = .systemGray
        config.cornerStyle = .large
        button.configuration = config
    }

    // MARK: - Permissions

    @objc func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.openCamera()
                } else {
                    self.showAlert(title: "Camera Access Denied", message: "Please allow camera access in settings.")
                }
            }
        }
    }

    @objc func requestGalleryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    self.openGallery()
                } else {
                    self.showAlert(title: "Gallery Access Denied", message: "Please allow photo access in settings.")
                }
            }
        }
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Unavailable", message: "This device has no camera.")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage

            // Convert image to Data (PNG format)
            if let imageData = selectedImage.pngData() {
                UserDefaults.standard.set(imageData, forKey: "userProfileImage")
            }
        }
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
