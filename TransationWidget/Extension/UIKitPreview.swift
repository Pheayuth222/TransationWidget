//
//  UIKitPreview.swift
//  TransationWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

import SwiftUI

struct PreviewContainer<T: UIViewController>: UIViewControllerRepresentable {
    
    let viewControllerBuider : T
    
    init(_ viewControllerBuilder: @escaping () -> T) {
        
        self.viewControllerBuider = viewControllerBuilder()
    }
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> T {
        return viewControllerBuider
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {
        
    }
    
}
