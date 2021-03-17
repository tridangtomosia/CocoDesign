//
//  LoadingView.swift
//  CoCoDesign
//
//  Created by apple on 2/25/21.
//

import Combine
import SwiftUI

struct LoadingIndicatorView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    let backgroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottom)
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ActivityIndicatorLoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                CircleLoader()
                    .frame(width: geometry.size.width / 2,
                           height: geometry.size.height / 5)
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

struct CircleLoader: View {
    // MARK: - variables

    let circleTrackGradient = LinearGradient(gradient: .init(colors: [Color.AppColor.appColor, Color.blue]), startPoint: .leading, endPoint: .bottomLeading)
    let circleRoundGradient = LinearGradient(gradient: .init(colors: [Color.red, Color.AppColor.appColor]), startPoint: .topLeading, endPoint: .trailing)

    let trackerRotation: Double = 1
    let animationDuration: Double = 0.75

    @State var isAnimating: Bool = false
    @State var circleStart: CGFloat = 0.17
    @State var circleEnd: CGFloat = 0.325

    @State var rotationDegree: Angle = Angle.degrees(0)

    // MARK: - views

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20))
                .fill(circleTrackGradient)
            Circle()
                .trim(from: circleStart, to: circleEnd)
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .fill(circleRoundGradient)
                .rotationEffect(self.rotationDegree)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: self.trackerRotation * self.animationDuration + self.animationDuration, repeats: true) { _ in
                self.animateLoader()
            }
        }
    }

    // MARK: - functions

    func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation) + .degrees(120)
    }

    func animateLoader() {
        withAnimation(Animation.spring(response: animationDuration * 2)) {
            self.rotationDegree = .degrees(-57.5)
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.trackerRotation * self.animationDuration)) {
                self.rotationDegree += self.getRotationAngle()
            }
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: (self.trackerRotation * self.animationDuration) / 2.25)) {
                self.circleEnd = 0.925
            }
        }

        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            self.rotationDegree = .degrees(47.5)
            withAnimation(Animation.easeOut(duration: self.animationDuration)) {
                self.circleEnd = 0.325
            }
        }
    }
}
