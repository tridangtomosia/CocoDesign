//
//  ImageView.swift
//  CoCoDesign
//
//  Created by apple on 2/28/21.
//

import SwiftUI
import URLImage

struct ImageView: View {
    init(withURL url: String) {
        self.url = url
    }
    var url: String

    var body: some View {
//        LoadingView(isShowing: $isShowLoading) {
//            VStack {
//                Image(uiImage: image)
//                    .resizable()
//                    .frame(width: 200, height: 200, alignment: .leading)
//                    .scaledToFill()
//                    .aspectRatio(contentMode: .fill)
//            }
//            .onAppear(perform: {
//                if let url = URL(string: "https://i.ibb.co/68BbdVm/Screenshot-2021-02-03-at-16-00-05.png"),
//                    let imageData = try? Data(contentsOf: url),
//                    let uiImage = UIImage(data: imageData) {
//                    image = uiImage
//                    isShowLoading = false
//                }
//            })
//        }
//        "https://i.ibb.co/68BbdVm/Screenshot-2021-02-03-at-16-00-05.png"
        URLImage(url: URL(string: url)!) {
            Text("nothing here")
        } inProgress: { progress -> Text in
            if let progress = progress {
                return Text("\(progress/100)+ % Loading...")
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
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(withURL: "")
    }
}
