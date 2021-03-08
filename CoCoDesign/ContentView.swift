//
//  ContentView.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var policy: PolicyObseverble
    @State var name = ""

    var body: some View {
        NavigationView {
            VStack {
                PhoneInputView(viewModel: PhoneInputViewModel())
                NavigationLink(destination: PolicyView(webViewStateModel: WebViewStateModel()),
                               isActive: $policy.isShowPolicy) {}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PolicyObseverble())
    }
}
