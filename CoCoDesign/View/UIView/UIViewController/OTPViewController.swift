//
//  OTPView.swift
//  CoCoDesign
//
//  Created by apple on 2/14/21.
//

import UIKit
import SwiftUI

class OTPViewController: UIViewController {
    @IBOutlet var inputOTPTextFiels: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputOTPTextFiels.forEach { (textField) in
            textField.delegate = self
            textField.placeholder = "0"
            textField.textAlignment = .center
            textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){

        let text = textField.text

        if (text?.utf16.count)! >= 1{
            switch textField.tag {
            case 0:
                inputOTPTextFiels[1].becomeFirstResponder()
            case 1:
                inputOTPTextFiels[2].becomeFirstResponder()
            case 2:
                inputOTPTextFiels[3].becomeFirstResponder()
            case 3:
                inputOTPTextFiels[4].becomeFirstResponder()
            case 4:
                inputOTPTextFiels[5].becomeFirstResponder()
            default:
                break
            }
        }else{

        }
    }
}

extension OTPViewController: UITextFieldDelegate {
    
}

struct OTPTextView: UIViewControllerRepresentable {
    func makeCoordinator() -> OPTCoordinator {
        return OPTCoordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return OTPViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
    
    @Binding var text: String

    class OPTCoordinator: NSObject, UITextFieldDelegate {
        var view : OTPTextView
        init(_ view: OTPTextView) {
            self.view = view
        }
    }
}
