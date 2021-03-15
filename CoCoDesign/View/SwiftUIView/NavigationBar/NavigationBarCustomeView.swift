//
//  NavigationBarCustomeView.swift
//  CoCoDesign
//
//  Created by apple on 3/11/21.
//

import SwiftUI

struct NavigationBarCustomeView<T: View>: View {
    var isLeftHidden: Bool = true
    var isRightHidden: Bool = true
    var isLineBottomHidden: Bool = true
    var leftAction: () -> Void = {}
    var rightAction: () -> Void = {}
    var barView: T

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    // custome here left button if Using
                    if !isLeftHidden {
                        Button {
                            leftAction()
                        } label: {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 10, height: 16, alignment: .center)
                        }
                        .frame(width: 15, alignment: .center)
                        .padding(.leading, 16)
                    }

                    Spacer()

                    barView
                        .frame(width: geometry.size.width * 313 / 375, height: geometry.size.height * 30 / 45, alignment: .center)

                    Spacer()

                    // custome here right button if Using
                    if !isRightHidden {
                        Button {
                            rightAction()
                        } label: {
                            Text(Strings.Action.skip)
                        }
                    }
                }
                .frame(alignment: .center)
                
                Spacer()
                
                if !isLineBottomHidden {
                    Rectangle()
                        .foregroundColor(Color.AppColor.grayBoldColor)
                        .frame(height: 1, alignment: .bottom)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 45, alignment: .center)
    }
}
