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
    
    func sendPhone(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if error != nil { return }
            self.verificationID = verificationID ?? ""
            self.timeRemaining = 90
        }
    }
}


