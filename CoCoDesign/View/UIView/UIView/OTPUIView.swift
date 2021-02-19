//
//  OTPUIView.swift
//  CoCoDesign
//
//  Created by apple on 2/15/21.
//

import SwiftUI
import UIKit
class OTPUIView: UIView {
    @IBOutlet var inputOTPTextFiels: [UITextField]!

    override func awakeFromNib() {
        super.awakeFromNib()
        inputOTPTextFiels.forEach { textField in
            textField.delegate = self
            textField.textAlignment = .center
            textField.placeholder = "0"
            textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }

    @objc func textFieldDidChange(textField: UITextField) {
        
    }
}

extension OTPUIView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if textField.tag > 10 {
                (viewWithTag(textField.tag - 1) as? UITextField)?.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }

        if textField.text?.isEmpty == false {
            if textField.tag == 15 {
                textField.text = string
            } else {
                textField.text = string
                nextCursorTextField(textField: textField)
            }
            return false
        } else {
            textField.text = string
            nextCursorTextField(textField: textField)
            return false
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
    }

    func nextCursorTextField(textField: UITextField) {
        switch textField.tag {
        case 10:
            inputOTPTextFiels[1].becomeFirstResponder()
        case 11:
            inputOTPTextFiels[2].becomeFirstResponder()
        case 12:
            inputOTPTextFiels[3].becomeFirstResponder()
        case 13:
            inputOTPTextFiels[4].becomeFirstResponder()
        case 14:
            inputOTPTextFiels[5].becomeFirstResponder()
        default:
            break
        }
    }
}

struct OTP2UIView: UIViewRepresentable {
    @Binding var text: String
    func makeUIView(context: Context) -> some OTPUIView {
        let view = Bundle.main.loadNibNamed("OTPUIView", owner: nil, options: nil)?[0] as! OTPUIView
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    func makeCoordinator() -> OPTCoordinator {
        return OPTCoordinator(self)
    }

    class OPTCoordinator: NSObject, UITextFieldDelegate {
        var view: OTP2UIView
        init(_ view: OTP2UIView) {
            self.view = view
        }
    }
}
