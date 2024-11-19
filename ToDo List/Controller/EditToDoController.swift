//
//  EditToDoController.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 19.11.2024.
//

import Foundation
import UIKit

class EditToDoController: UIViewController {
    
    //MARK:  ui vars
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 40)
        textField.textColor = .white
        textField.placeholder = "Задача"
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 20
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray3
        label.text = "19/11/24"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.text = "Подборное описание задачи"
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        return textView
    }()
    
    //MARK:  viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:  setup ui
    private func setupUI() {
        view.backgroundColor = .black
        
        // Add subviews
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        // Auto Layout constraints
        NSLayoutConstraint.activate([
            // Title TextField
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Description TextView
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
}
