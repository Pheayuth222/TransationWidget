//
//  AddNewQR.swift
//  TransationWidget
//
//  Created by YuthFight's MacBook Pro  on 14/2/25.
//

import SwiftUI

struct AddNewQR: View {
  
  @State var isLoggedIn: Bool?
  
  var body: some View {
    ZStack {
      if let qrCode = GenerateQR.share.generateQRCode(from: "https://gemini.google.com/app/4a54677b6b72a613") {
        Image(uiImage: qrCode)
          .interpolation(.none)
          .resizable()
          .scaledToFit()
        
          .frame(width: 150, height: 150,alignment: .center)
          .padding()
          .blur(radius: isLoggedIn ?? false ? 0 : 10)
          .overlay(
            // Colored overlay that only shows when blurred
            !(isLoggedIn ?? false) ? Color.white.opacity(0.5) : Color.clear
          )
          .animation(.easeInOut, value: isLoggedIn)
        
        
        // Add QR Code button that only shows when QR is blurred
        if !(isLoggedIn ?? false) {
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

#Preview {
    AddNewQR()
}
