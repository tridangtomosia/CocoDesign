//
//  VerificodeViewModel.swift
//  CoCoDesign
//
//  Created by apple on 2/23/21.
//

import Firebase
import FirebaseAuth
import SwiftUI
import UIKit

struct VerificodeViewModel {
    @Binding var verificationID : String
    @Binding var timeRemaining : Int
    @State var phoneNumber = ""
    @Binding var isShowProgress: Bool
    
    func sendPhone() {
        isShowProgress = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if error != nil {
                self.isShowProgress = false
                return
            }
            self.verificationID = verificationID ?? ""
            self.timeRemaining = 90
            self.isShowProgress = false
        }
    }
}


