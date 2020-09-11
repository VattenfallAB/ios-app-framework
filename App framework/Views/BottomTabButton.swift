//
//  BottomTabButton.swift
//  App framework
//
//  Created by Artur Gurgul on 08/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI


struct BottomTabButton: View {
    let title: String
    let iconName: String
    let action: ()->Void
    
    @State private var color: Color = Style.vfBlack
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 0) {
                Image(iconName)
                Text(title)
            }
        }
        .accentColor(color)
        .font(Font.system(size: 12, weight: .medium))
        .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: 55)
    }
}
