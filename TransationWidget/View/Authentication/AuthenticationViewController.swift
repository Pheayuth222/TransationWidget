//
//  AuthenticationViewController.swift
//  TransationWidget
//
//  Created by YuthFight's MacBook Pro  on 13/2/25.
//

import UIKit
import WidgetKit

class AuthenticationViewController: UIViewController {
  // MARK: - Properties
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 12
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowOpacity = 0.1
    view.layer.shadowRadius = 4
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let segmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: ["Login", "Register"])
    control.selectedSegmentIndex = 0
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()
  
  private let emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Email"
    textField.borderStyle = .roundedRect
    textField.keyboardType = .emailAddress
    textField.autocapitalizationType = .none
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.borderStyle = .roundedRect
    textField.isSecureTextEntry = true
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupActions()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(containerView)
    containerView.addSubview(segmentedControl)
    containerView.addSubview(emailTextField)
    containerView.addSubview(passwordTextField)
    containerView.addSubview(actionButton)
    
    NSLayoutConstraint.activate([
      containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
      
      segmentedControl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
      segmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      segmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      
      emailTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
      emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      emailTextField.heightAnchor.constraint(equalToConstant: 44),
      
      passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
      passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      passwordTextField.heightAnchor.constraint(equalToConstant: 44),
      
      actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
      actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      actionButton.heightAnchor.constraint(equalToConstant: 44),
      actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
    ])
  }
  
  // MARK: - Actions
  private func setupActions() {
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
  }
  
  @objc private func segmentedControlValueChanged() {
    let title = segmentedControl.selectedSegmentIndex == 0 ? "Login" : "Register"
    actionButton.setTitle(title, for: .normal)
  }
  
  @objc private func actionButtonTapped() {
    guard let email = emailTextField.text, !email.isEmpty,
          let password = passwordTextField.text, !password.isEmpty else {
      // Show alert for empty fields
      let alert = UIAlertController(title: "Error",
                                    message: "Please fill in all fields",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
      return
    }
    
    if segmentedControl.selectedSegmentIndex == 0 {
      // Handle login
      handleLogin(email: email, password: password)
    } else {
      // Handle registration
      handleRegistration(email: email, password: password)
    }
  }
  
  // MARK: - Authentication Methods
  private func handleLogin(email: String, password: String) {
    // Implement your login logic here
    print("Login with email: \(email)")
    
    DispatchQueue.main.async {
        // Update UserDefaults
        if #available(iOS 14.0, *) {
            // WidgetCenter.shared.reloadTimelines(ofKind: "group.com.TransationWidget")
            // Read the value after a slight delay to ensure the update is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              UserDefaultsManager.shared.setBOOLValue(true, forKey: "isLoggedIn")
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "MyCustomWidget")
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    let viewController = ViewController()
    viewController.modalTransitionStyle = .crossDissolve
    viewController.modalPresentationStyle = .fullScreen
    self.present(viewController, animated: true)
  }
  
  private func handleRegistration(email: String, password: String) {
    // Implement your registration logic here
    print("Register with email: \(email)")
    DispatchQueue.main.async {
        // Update UserDefaults
        if #available(iOS 14.0, *) {
            // WidgetCenter.shared.reloadTimelines(ofKind: "group.com.TransationWidget")
            // Read the value after a slight delay to ensure the update is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              UserDefaultsManager.shared.setBOOLValue(true, forKey: "isLoggedIn")
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "MyCustomWidget")
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    let viewController = ViewController()
    viewController.modalTransitionStyle = .crossDissolve
    viewController.modalPresentationStyle = .fullScreen
    self.present(viewController, animated: true)
  }
}
