//
//  WebViewStateModel.swift
//  CoCoDesign
//
//  Created by apple on 2/4/21.
//

import SwiftUI
import WebKit

class WebViewStateModel: ObservableObject {
    @Published var pageTitle: String = "Web View"
    @Published var loading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var goBack: Bool = false
}

enum NavigationAction {
    case decidePolicy(WKNavigationAction, (WKNavigationActionPolicy) -> Void) // mendetory
    case didRecieveAuthChallange(URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) // mendetory
    case didStartProvisionalNavigation(WKNavigation)
    case didReceiveServerRedirectForProvisionalNavigation(WKNavigation)
    case didCommit(WKNavigation)
    case didFinish(WKNavigation)
    case didFailProvisionalNavigation(WKNavigation, Error)
    case didFail(WKNavigation, Error)
}
