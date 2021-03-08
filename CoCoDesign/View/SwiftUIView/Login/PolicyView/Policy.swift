//
//  Policy.swift
//  CoCoDesign
//
//  Created by apple on 2/4/21.
//

import SwiftUI

struct PolicyView: View {
    @ObservedObject var webViewStateModel: WebViewStateModel
    @EnvironmentObject var policy: PolicyModel
    
    var body: some View {
        LoadingView(isShowing: .constant(webViewStateModel.loading)) {
            // Add onNavigationAction if callback needed
            WebView(url: policy.links!, webViewStateModel: self.webViewStateModel) // add
        }
        .navigationBarTitle(Text(webViewStateModel.pageTitle), displayMode: .inline)
        .navigationBarItems(trailing:
            Button("Last Page") {
                self.webViewStateModel.goBack.toggle()
            }.disabled(!webViewStateModel.canGoBack)
        )
    }
}
