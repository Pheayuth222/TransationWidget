//
//  QRCodeGenerator.swift
//  TransationWidget
//
//  Created by YuthFight's MacBook Pro  on 5/2/25.
//

import UIKit
import CoreImage

class QRCodeGenerator {
    
    enum QRCodeError: Error {
        case generateFailed
        case invalidInput
    }
    
    // Basic QR Code generation
    static func generateQRCode(from string: String,
                             size: CGSize = CGSize(width: 200, height: 200),
                             foregroundColor: UIColor = .black,
                             backgroundColor: UIColor = .white) throws -> UIImage {
        
        // Input validation
        guard !string.isEmpty else {
            throw QRCodeError.invalidInput
        }
        
        // Create QR Code filter
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            throw QRCodeError.generateFailed
        }
        
        // Convert string to data
        let data = string.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        // Set error correction level
        filter.setValue("H", forKey: "inputCorrectionLevel") // H = High (30%)
        
        // Get generated image
        guard let ciImage = filter.outputImage else {
            throw QRCodeError.generateFailed
        }
        
        // Scale the image
        let scale = min(size.width, size.height) / ciImage.extent.width
        let transformedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        // Create colored QR code
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setValue(transformedImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
        
        guard let outputImage = colorFilter?.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            throw QRCodeError.generateFailed
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    // Generate QR Code with logo
    static func generateQRCodeWithLogo(from string: String,
                                     logo: UIImage,
                                     size: CGSize = CGSize(width: 200, height: 200),
                                     foregroundColor: UIColor = .black,
                                     backgroundColor: UIColor = .white) throws -> UIImage {
        
        // Generate basic QR Code first
        let qrCode = try generateQRCode(from: string,
                                      size: size,
                                      foregroundColor: foregroundColor,
                                      backgroundColor: backgroundColor)
        
        // Begin graphics context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // Draw QR code
        qrCode.draw(in: CGRect(origin: .zero, size: size))
        
        // Calculate logo size (usually 20% of QR code size)
        let logoSize = CGSize(width: size.width * 0.2, height: size.height * 0.2)
        let logoFrame = CGRect(x: (size.width - logoSize.width) / 2,
                             y: (size.height - logoSize.height) / 2,
                             width: logoSize.width,
                             height: logoSize.height)
        
        // Draw logo
        logo.draw(in: logoFrame)
        
        // Get final image
        guard let finalImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            throw QRCodeError.generateFailed
        }
        
        UIGraphicsEndImageContext()
        return finalImage
    }
}
