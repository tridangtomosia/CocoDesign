//
//  AreaInputCode.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct AreaInputCode: View {
//    @ObservedObject var inputCode: CodeInputObserver
    @State var timeRemaining = 90
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var text = ""

    var body: some View {
        VStack {
            OTP2UIView(text: $text)
                .frame(height: 50)
            HStack {
                Text("Thoi gian het han OTP: ")
                    .font(.system(size: 11))
                    .foregroundColor(.black)
                Text(timeFormater(second: timeRemaining))
                    .foregroundColor(.red)
                    .font(.system(size: 11))
                    .onReceive(timer) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        }
                    }
            }
        }
    }

    func timeFormater(second: Int) -> String {
        let sec = second % 60
        let minute = second / 60
        return "\(minute): \(sec)"
    }
}

struct AreaInputCode_Previews: PreviewProvider {
    static var previews: some View {
        AreaInputCode()
    }
}
