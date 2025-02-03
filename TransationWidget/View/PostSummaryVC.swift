//
//  PostSummaryVC.swift
//  TransationWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

import UIKit
import SwiftUI
import WidgetKit

class PostSummaryVC: UIViewController, UITextFieldDelegate {
    
    var postTitle: String?
    var totalAmount: Double?
    
    @State private var someValue: String = ""
    let now = Date()
    
    var formattedDate: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let timeString = timeFormatter.string(from: now)
        let dateString = dateFormatter.string(from: now)
        
        return "\(timeString) | \(dateString)"
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yuth"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter amount"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .black
        return tf
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(updateValue), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        amountTF.delegate = self
        
        // Load initial value from UserDefaults
        someValue = UserDefaultsManager.shared.stringValue(forKey: "totalAmount") ?? ""
        
        amountTF.text = "\(totalAmount ?? 0.0)"
        titleLabel.text = postTitle
        setUpConstraint()
    }
    
    private func setUpConstraint() {
        view.addSubview(titleLabel)
        view.addSubview(submitButton)
        view.addSubview(amountTF)
        NSLayoutConstraint.activate([
            
            amountTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            amountTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: amountTF.bottomAnchor, constant: 30),
            submitButton.widthAnchor.constraint(equalToConstant: 100),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
    
    @objc func updateValue(_ sender: UIButton) {
        // Create and configure SwiftUI view
        DispatchQueue.main.async {
            // Update UserDefaults
            if #available(iOS 14.0, *) {
                // WidgetCenter.shared.reloadTimelines(ofKind: "group.com.TransationWidget")
                // Read the value after a slight delay to ensure the update is complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UserDefaultsManager.shared.doubleValue(self.totalAmount ?? 0.0, forKey: "totalAmount")
                    UserDefaultsManager.shared.setStringValue(self.formattedDate, forKey: "syncDate")
                }
                WidgetCenter.shared.reloadTimelines(ofKind: "MyCustomWidget")
                WidgetCenter.shared.reloadAllTimelines()
            } else {
                // Fallback on earlier versions
            }
            
        }
        dismiss(animated: true, completion: {
            
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("BeginEditing \(textField.text)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("EndEditing: \(textField.text)")
        self.totalAmount = Double(textField.text ?? "")
        
    }
    
}

