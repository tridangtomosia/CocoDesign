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
    var codeInputCompleted: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        inputOTPTextFiels.forEach { textField in
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = textField.bounds.height / 10
            textField.clipsToBounds = true
            textField.layer.borderColor = Color.AppColor.grayBorderColor.cgColor
            textField.delegate = self
            textField.textAlignment = .center
            textField.placeholder = "0"
            textField.font = .appFont(interFont: .bold, size: 16)
        }
    }
}

extension OTPUIView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if textField.tag > 10 {
                (viewWithTag(textField.tag - 1) as? UITextField)?.becomeFirstResponder()
                (viewWithTag(textField.tag - 1) as? UITextField)?.layer.borderColor = Color.AppColor.appColor.cgColor
            }
            textField.text = ""
            textField.layer.borderColor = Color.AppColor.grayBorderColor.cgColor
            checkStateCompleted()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = Color.AppColor.appColor.cgColor
        return true
    }

    func nextCursorTextField(textField: UITextField) {
        textField.layer.borderColor = Color.AppColor.grayBorderColor.cgColor
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
            textField.layer.borderColor = Color.AppColor.appColor.cgColor
            break
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkStateCompleted()
    }

    func checkStateCompleted() {
        var codeInput = ""
        for i in 10 ... 15 {
            if let character = (viewWithTag(i) as? UITextField)?.text {
                codeInput.append(character)
            }
        }
        codeInputCompleted?(codeInput)
        if codeInput.count == 6 {
            endEditing(true)
        }
    }
}

struct OTPView: UIViewRepresentable {
    @Binding var verifiCode: String
    func makeUIView(context: Context) -> some OTPUIView {
        let view = Bundle.main.loadNibNamed("OTPUIView", owner: nil, options: nil)?[0] as! OTPUIView
        view.codeInputCompleted = { code in
            verifiCode = code
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    func makeCoordinator() -> OPTCoordinator {
        return OPTCoordinator(self)
    }

    class OPTCoordinator: NSObject, UITextFieldDelegate {
        var view: OTPView
        init(_ view: OTPView) {
            self.view = view
        }
    }
}
