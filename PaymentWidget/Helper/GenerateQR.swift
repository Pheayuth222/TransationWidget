//
//  GenerateQR.swift
//  PaymentWidgetExtension
//
//  Created by Pheayuit.Yen    on 4/2/25.
//

import Foundation
import CoreImage
import UIKit

class GenerateQR {
    
    static let share = GenerateQR()
    
    private init() {
        
    }
    
    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
}
