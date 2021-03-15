//
//  UITextField.swift
//  CoCoDesign
//
//  Created by apple on 3/10/21.
//

import SwiftUI
import UIKit
import Combine

struct SearchTextField: UIViewRepresentable {
    @Binding var text: String
    var placeHolder: String
    var font: UIFont = .appFont(interFont: .bold, size: 13)
    var color: UIColor = .black
    var didReturn: (String) -> Void
    
    func makeUIView(context: Context) -> some UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = .alphabet
        textField.returnKeyType = .search
        textField.placeholder = placeHolder
        textField.font = font
        textField.textColor = color
        return textField
    }

    func updateUIView(_ textField: UIViewType, context: Context) {
        if textField.text != self.text {
            textField.text = self.text
        }
    }

    func makeCoordinator() -> OPTCoordinator {
        return OPTCoordinator(self)
    }

    class OPTCoordinator: NSObject, UITextFieldDelegate {
        var view: SearchTextField
        init(_ view: SearchTextField) {
            self.view = view
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            view.text = textField.text ?? ""
            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            view.didReturn(textField.text ?? "")
            return true
        }
    }
}
