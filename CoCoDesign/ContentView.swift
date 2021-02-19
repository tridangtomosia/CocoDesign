//
//  ContentView.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var policy: PolicyModel
    @Environment(.policy) var policyModel: PolicyModel
    @State var name = ""
    
    var body: some View {
        NavigationView {
            VStack {
                PhoneInput()
                NavigationLink(destination: PolicyView(webViewStateModel: WebViewStateModel()), isActive: $policy.isShowPolicy) {}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
