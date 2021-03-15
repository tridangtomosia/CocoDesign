//
//  ContentView.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct ContentView: View {
    @State var name = ""
    var body: some View {
        NavigationView {
            PhoneInputView(viewModel: PhoneInputViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
