//
//  LinkOnString.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct LinkedView: UIViewRepresentable {
    @EnvironmentObject var policy: PolicyObseverble
    var font: UIFont = .appFont(interFont: .regular, size: 13)
    var color: UIColor = UIColor(Color.AppColor.blackColor)

    func makeCoordinator() -> CordinatorLinkedView {
        return CordinatorLinkedView(self)
    }

    func makeUIView(context: Context) -> some UITextView {
        let textView = UITextView(frame: .zero)
        let attributedString = NSMutableAttributedString(string: Strings.PhoneInputView.textPolicy)
        let url = URL(string: Strings.PhoneInputView.linkOpenPolicy)!
        // Set the 'click here' substring to be the link

        attributedString.setAttributes([.link: url],
                                       range: NSRange(location: 43,
                                                      length: 22))
        attributedString.addAttributes([.font: font,
                                        .foregroundColor: color],
                                       range: NSRange(location: 65,
                                                      length: Strings.PhoneInputView.textPolicy.length - 65))
        attributedString.addAttributes([.foregroundColor: color,
                                        .font: font],
                                       range: NSRange(location: 0,
                                                      length: 43))
        textView.attributedText = attributedString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.delegate = context.coordinator

        // Set how links should appear: blue and underlined
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        return textView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}

    class CordinatorLinkedView: NSObject, UITextViewDelegate {
        var textView: LinkedView

        init(_ textView: LinkedView) {
            self.textView = textView
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            self.textView.policy.isShowPolicy = true
            self.textView.policy.links = URL
            return false
        }
    }
}
