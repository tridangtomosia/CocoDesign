//
//  ItemCategorie.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import SwiftUI
import Combine

struct ItemCategorie: View {
    
    var categorise: Categorie = Categorie(id: 0, name: "", order: 0, status: "", imgUrl: "")
    
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            VStack {
                Text("")
            }
        })
    }
}

struct ItemCategorie_Previews: PreviewProvider {
    static var previews: some View {
        ItemCategorie()
    }
}
