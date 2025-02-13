//
//  QRCodeScannerViewController.swift
//  TransationWidget
//
//  Created by YuthFight's MacBook Pro  on 5/2/25.
//

import UIKit
import AVFoundation
import Vision

class QRScannerViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private lazy var previewLayer = AVCaptureVideoPreviewLayer()
    private let videoDataOutput = AVCaptureVideoDataOutput()
  
    weak var delegate: QRScannerViewControllerDelegate? 
    
    // UI Elements
    private lazy var scannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var qrCodeFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(scannerView)
        view.addSubview(qrCodeFrameView)
        
        NSLayoutConstraint.activate([
            scannerView.topAnchor.constraint(equalTo: view.topAnchor),
            scannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupCamera()
                    }
                }
            }
        default:
            showCameraPermissionAlert()
        }
    }
    
    private func setupCamera() {
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(message: "Camera not available")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if captureSession.canAddOutput(videoDataOutput) {
                captureSession.addOutput(videoDataOutput)
            }

            setupPreviewLayer(with: captureSession)
            startScanning()
            
        } catch {
            showAlert(message: "Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    private func setupPreviewLayer(with captureSession: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(previewLayer)
      
      scanImage()
    }
  
  private func scanImage(){
    /// Start ----------
    // Inside setupCamera()
    let holeWidth: CGFloat = 270
    let hollowedView = UIView(frame: view.frame)
    hollowedView.backgroundColor = .clear

    let hollowedLayer = CAShapeLayer()

    let focusRect = CGRect(origin: CGPoint(x: (view.frame.width - holeWidth) / 2, y: (view.frame.height - holeWidth) / 2), size: CGSize(width: holeWidth, height: holeWidth))
    let holePath = UIBezierPath(roundedRect: focusRect, cornerRadius: 12)
    let externalPath = UIBezierPath(rect: hollowedView.frame).reversing()
    holePath.append(externalPath)
    holePath.usesEvenOddFillRule = true

    hollowedLayer.path = holePath.cgPath
    hollowedLayer.fillColor = UIColor.black.cgColor
    hollowedLayer.opacity = 0.5

    hollowedView.layer.addSublayer(hollowedLayer)
    view.addSubview(hollowedView)

    let scannerPlaceholderView = UIImageView(frame: focusRect)
    scannerPlaceholderView.image = UIImage(named: "qr_scan_placeholder")
    scannerPlaceholderView.contentMode = .scaleAspectFill
    scannerPlaceholderView.clipsToBounds = true
    self.view.addSubview(scannerPlaceholderView)
    self.view.bringSubviewToFront(scannerPlaceholderView)
    /// ---- End
  }
    
    // MARK: - Scanning
    private func startScanning() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    private func stopScanning() {
        captureSession?.stopRunning()
    }
    
    // MARK: - QR Code Detection
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
      
        let request = VNDetectBarcodesRequest { [weak self] request, error in
            guard error == nil else {
                self?.showAlert(message: "Error detecting QR code: \(error?.localizedDescription ?? "")")
                return
            }
            
            self?.processQRCodeDetection(request.results as? [VNBarcodeObservation])
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    private func processQRCodeDetection(_ observations: [VNBarcodeObservation]?) {
        guard let observation = observations?.first,
              let payloadString = observation.payloadStringValue else { return }
      
        stopScanning()
        DispatchQueue.main.async { [weak self] in
            self?.handleQRCodeDetection(payloadString, observation: observation)
        }
    }
    
    private func handleQRCodeDetection(_ payloadString: String, observation: VNBarcodeObservation) {
        // Update QR code frame position
        let transform = CGAffineTransform(scaleX: 1, y: -1)
        let translateTransform = CGAffineTransform(translationX: 0, y: scannerView.bounds.height)
        let bounds = observation.boundingBox.applying(transform).applying(translateTransform)
        
        qrCodeFrameView.frame = previewLayer.layerRectConverted(fromMetadataOutputRect: bounds)
        // Handle the QR code data
        print("QR Code detected: \(payloadString)")

        delegate?.qrScannerViewController(self, didScan: payloadString)
        // Add your custom handling logic here
        // For example, you might want to:
        // - Validate the QR code format
        // - Process the data
        // - Show a success message
        // - Navigate to another screen
    }
  
  
    
    // MARK: - Helper Methods
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "Please enable camera access in Settings to scan QR codes",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
