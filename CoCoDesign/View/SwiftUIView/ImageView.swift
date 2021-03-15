//
//  ImageView.swift
//  CoCoDesign
//
//  Created by apple on 2/28/21.
//

import SwiftUI
import URLImage

struct ImageView: View {
    init(withURL url: String, isPresentFullScreen: Bool = false) {
        self.url = url
        self.isPresentFullScreen = isPresentFullScreen
    }
    var url: String
    var isPresentFullScreen: Bool

    var body: some View {
        URLImage(url: URL(string: url)!) {
            Text("nothing here")
        } inProgress: { progress -> Text in
            if let progress = progress {
                return Text("\(progress/100) %")
            } else {
                return Text("Loading...")
            }
        } failure: { error, retry in // Display error and retry button
            VStack {
                Text(error.localizedDescription)
                Button("Reload", action: retry)
            }
        } content: { image in // Content view
            image
                .resizable()
                .aspectRatio(contentMode: isPresentFullScreen ? .fit : .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .padding(.all, 0)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(withURL: "")
    }
}
