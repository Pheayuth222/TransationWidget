//
//  ViewController.swift
//  TransationWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
  
  lazy var qrImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "qr")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var cameraButton: UIButton = {
    let button = UIButton()
    button.setTitle("Camera", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
    return button
  }()
  
  lazy var logOutButton: UIButton = {
    let button = UIButton()
    button.setTitle("Log Out", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    return button
  }()
  
  var getQRString: String? {
    didSet {
      qrImageView.image = nil
      // Generate a QR code with custom colors and size
      do {
          let qrCode = try QRCodeGenerator.generateQRCode(
            from: getQRString ?? "",
              size: CGSize(width: 300, height: 300),
            foregroundColor: .black,
              backgroundColor: .white
          )
        qrImageView.image = qrCode
      } catch {
          print("Error generating QR code: \(error)")
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setUpConstraint()
  }
  
  private func setUpConstraint() {
    view.addSubview(qrImageView)
    view.addSubview(cameraButton)
    view.addSubview(logOutButton)
    
    NSLayoutConstraint.activate([
      
      qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      qrImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      cameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
      
      logOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc private func logoutButtonTapped() {
    // Perform logout logic
    DispatchQueue.main.async {
        // Update UserDefaults
        if #available(iOS 14.0, *) {
            // WidgetCenter.shared.reloadTimelines(ofKind: "group.com.TransationWidget")
            // Read the value after a slight delay to ensure the update is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              UserDefaultsManager.shared.setBOOLValue(false, forKey: "isLoggedIn")
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "MyCustomWidget")
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // Switch back to login
    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
      sceneDelegate.setToRootViewController(AuthenticationViewController())
    }
  }
  
  @objc func didTapCamera() {
    let vc = QRScannerViewController()
    vc.modalPresentationStyle = .fullScreen
//    vc.modalTransitionStyle = .crossDissolve
    vc.delegate = self
    present(vc, animated: true, completion: nil)
  }
  
  
}

extension ViewController: QRScannerViewControllerDelegate {
  
  func qrScannerViewController(_ vc: QRScannerViewController, didScan code: String) {
    // Handle the scanned QR code here
//    print("Scanned QR Code:", code)
    self.getQRString = code
    // You can dismiss the scanner view controller after scanning
    // if you want:
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
      vc.dismiss(animated: true, completion: nil)
    }
  }
  
}

protocol QRScannerViewControllerDelegate: AnyObject {
    func qrScannerViewController(_ vc: QRScannerViewController, didScan code: String)
}
