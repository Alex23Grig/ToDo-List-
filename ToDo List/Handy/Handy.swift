//
//  Handy.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 20.11.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        // Gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // Allow other touches to pass through
        
        view.addGestureRecognizer(tapGesture)
        
        if let navView = self.navigationController?.view {
            navView.addGestureRecognizer(tapGesture)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

