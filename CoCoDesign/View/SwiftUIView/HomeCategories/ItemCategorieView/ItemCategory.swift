//
//  ItemCategorie.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

struct ItemCategoryView: View {
    var category: Category = Category()

    var body: some View {
        VStack(alignment: .center, spacing: 5, content: {
            ZStack {
                if let url = category.imgUrl {
                    ImageView(withURL: url)
                        .padding(.all, 16)
                } else {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .gray, radius: 3, x: 0, y: 1)
            )

            Text(category.name ?? "")
                .font(.appFont(interFont: .regular, size: 12))
                .foregroundColor(Color.AppColor.blackColor)
                .background(Color.clear)
                .lineLimit(1)
        })
    }
}

struct ItemCategorieView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategoryView()
    }
}
