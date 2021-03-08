//
//  ItemCategorie.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import SwiftUI
import Combine

struct ItemCategory: View {
    var category: Category = Category(id: 0, name: "", order: 0, status: "", imgUrl: "")
    
    var body: some View {
        VStack(alignment: .center, spacing: 5, content: {
            VStack {
                ImageView(withURL: category.imgUrl)
                    .padding(.all, 16)
            }
            .frame(width: 78, height: 78, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.AppColor.shadowColor, radius: 9, x: 1, y: 3)
            Text(category.name)
                .font(.appFont(interFont: .regular, size: 12))
                .foregroundColor(Color.AppColor.blackColor)
                .background(Color.clear)
        })
    }
}

struct ItemCategorie_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategory()
    }
}
