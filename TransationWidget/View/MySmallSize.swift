//
//  MySmallSize.swift
//  TransationWidget
//
//  Created by YuthFight's MacBook Pro  on 14/2/25.
//

import SwiftUI

struct QRButtonWidget: View {
  let url: String
  let size: CGFloat
  @State private var isShowingQRCode = false
  
  init(url: String, size: CGFloat = 40) {
    self.url = url
    self.size = size
  }
  
  var body: some View {
    Button(action: {
      isShowingQRCode.toggle()
    }) {
      ZStack {
        if let qrCode = GenerateQR.share.generateQRCode(from: url) {
          Image(uiImage: qrCode)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .padding()
            .blur(radius: isShowingQRCode ? 0 : 20)
            .animation(.easeInOut, value: isShowingQRCode)
          
          // Add QR Code button that only shows when QR is blurred
          if !isShowingQRCode {
            Text("Add QR Code")
              .foregroundColor(.white)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background(Color.blue)
              .cornerRadius(8)
          }
        } else {
          Text("Failed to generate QR code")
            .foregroundColor(.red)
        }
      }
    }
  }
}

// Preview
struct QRButtonWidget_Previews: PreviewProvider {
  static var previews: some View {
    QRButtonWidget(url: "https://gemini.google.com/app/4a54677b6b72a613")
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
