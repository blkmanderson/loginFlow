//
//  FindCommunityView.swift
//  Community
//
//  Created by Blake Anderson on 12/16/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct FindCommunityView: View {
    
    @State var dataExample = (0 ..< 30).map { $0 }
    
    var body: some View {
        ASCollectionView(data: dataExample, dataID: \.self) { item, _ in
            CGCard()
            
        }
        .layout {
            .grid(layoutMode: .adaptive(withMinItemSize: 104),
                  itemSpacing: 15,
                  lineSpacing: 10,
                  itemSize: .absolute(104))
        }
    }
}

struct FindCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        FindCommunityView()
    }
}

