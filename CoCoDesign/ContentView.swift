//
//  ContentView.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

struct ContentView: View {
//    let data = ["Img_2", "pic_1", "Img_2", "ic_place", "pic_4", "pic_3", "pic_2", "pic_5", "Img_2", "pic_1", "pic_2", "pic_5"]
    var body: some View {
//        GeometryReader { geometry in
//            ScrollView {
//                HStack(alignment: .top, spacing: nil, content: {
//                    VStack {
//                        ForEach(0 ..< data.count, id: \.self) { element in
//                            if element % 2 == 0 {
//                                Image(data[element])
//                                    .resizable()
//                                    .frame(width: geometry.size.width / 2 , height: 25 * CGFloat(element))
//                            }
//                        }
//                    }
//                    VStack {
//                        ForEach(0 ..< data.count, id: \.self) { element in
//                            if element % 2 != 0 {
//                                Image(data[element])
//                                    .resizable()
//                                    .frame(width: geometry.size.width / 2 , height: 100)
//                            }
//                        }
//                    }
//                })
//            }
//        }
        PhoneInputView(viewModel: PhoneInputViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
