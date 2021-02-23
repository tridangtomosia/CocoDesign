//
//  LinkOnString.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//

import SwiftUI

private let linkDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

struct LinkColoredText: View {
    enum Component {
        case text(String)
        case link(String, URL)
    }

    let text: String
    let components: [Component]
    let linkName: String
    let font: Font

    init(text: String, links: [NSTextCheckingResult], linkName: String, font: Font) {
        self.text = text
        let nsText = text as NSString

        var components: [Component] = []
        var index = 0
        for result in links {
            if result.range.location > index {
                components.append(.text(nsText.substring(with: NSRange(location: index, length: result.range.location - index))))
            }
            components.append(.link(nsText.substring(with: result.range), result.url!))
            index = result.range.location + result.range.length
        }

        if index < nsText.length {
            components.append(.text(nsText.substring(from: index)))
        }

        self.components = components
        self.linkName = linkName
        self.font = font
    }

    var body: some View {
        components.map { component in
            switch component {
            case let .text(text):
                return Text(verbatim: text)
                    .font(font)
                    .foregroundColor(Color.AppColor.grayTextColor)
            case .link:
                return Text(verbatim: linkName)
                    .font(font)
                    .underline()
                    .foregroundColor(.accentColor)
            }
        }.reduce(Text(""), +)
    }
}

struct LinkedText: View {
    @EnvironmentObject var policy: PolicyModel
    let text: String
    let links: [NSTextCheckingResult]
    let linkName: String
    let font: Font

    init(_ text: String, linkName: String, font: Font) {
        self.linkName = linkName
        self.text = text
        let nsText = text as NSString
        self.font = font

        // find the ranges of the string that have URLs
        let wholeString = NSRange(location: 0, length: nsText.length)
        links = linkDetector.matches(in: text, options: [], range: wholeString)
    }

    var body: some View {
        LinkColoredText(text: text, links: links, linkName: linkName, font: font)
            .font(.body) // enforce here because the link tapping won't be right if it's different
            .overlay(LinkTapOverlay(text: text, links: links))
    }
}

private struct LinkTapOverlay: UIViewRepresentable {
    @EnvironmentObject var policy: PolicyModel
    let text: String
    let links: [NSTextCheckingResult]

    func makeUIView(context: Context) -> LinkTapOverlayView {
        let view = LinkTapOverlayView()
        view.textContainer = context.coordinator.textContainer

        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.didTapLabel(_:)))
        tapGesture.delegate = context.coordinator
        view.addGestureRecognizer(tapGesture)

        return view
    }

    func updateUIView(_ uiView: LinkTapOverlayView, context: Context) {
        let attributedString = NSAttributedString(string: text, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        context.coordinator.textStorage = NSTextStorage(attributedString: attributedString)
        context.coordinator.textStorage!.addLayoutManager(context.coordinator.layoutManager)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var overlay: LinkTapOverlay

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        var textStorage: NSTextStorage?

        init(_ overlay: LinkTapOverlay) {
            self.overlay = overlay

            textContainer.lineFragmentPadding = 0
            textContainer.lineBreakMode = .byWordWrapping
            textContainer.maximumNumberOfLines = 0
            layoutManager.addTextContainer(textContainer)
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            let location = touch.location(in: gestureRecognizer.view!)
            let result = link(at: location)
            return result != nil
        }

        @objc func didTapLabel(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: gesture.view!)
            guard let result = link(at: location) else {
                return
            }

            guard let url = result.url else {
                return
            }
            
            overlay.policy.isShowPolicy = true
            overlay.policy.links = url
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        private func link(at point: CGPoint) -> NSTextCheckingResult? {
            guard !overlay.links.isEmpty else {
                return nil
            }

            let indexOfCharacter = layoutManager.characterIndex(
                for: point,
                in: textContainer,
                fractionOfDistanceBetweenInsertionPoints: nil
            )

            return overlay.links.first { $0.range.contains(indexOfCharacter) }
        }
    }
}

private class LinkTapOverlayView: UIView {
    var textContainer: NSTextContainer!

    override func layoutSubviews() {
        super.layoutSubviews()

        var newSize = bounds.size
        newSize.height += 20 // need some extra space here to actually get the last line
        textContainer.size = newSize
    }
}
