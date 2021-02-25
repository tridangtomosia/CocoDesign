//
//  Model.swift
//  CoCoDesign
//
//  Created by apple on 2/4/21.
//

import SwiftUI
import Combine

class PolicyObseverble: ObservableObject {
    @Published var isShowPolicy: Bool = false
    @Published var links: URL?
}
