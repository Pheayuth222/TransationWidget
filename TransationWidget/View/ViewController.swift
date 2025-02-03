//
//  ViewController.swift
//  TransationWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = "Yuth"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpConstraint()
    }
    
    private func setUpConstraint() {
        view.addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLable.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
}
