//
//  BlockingCardView.swift
//  App framework
//
//  Created by Artur Gurgul on 08/09/2020.
//  Copyright © 2020 Artur Gurgul. All rights reserved.
//

import SwiftUI

struct BlockingCardView: View {
    let contentView: AnyView
    @State private var offset = CGSize.zero
    @State private var point = CGPoint.zero
    
    var body: some View {
        ZStack {
            Color(white: 0, opacity: 0.4).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    contentView
                        .padding(.bottom, 0)
                        .offset(x: 0, y: self.point.y)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55)
                        .background(Color.white.offset(x: 0, y: self.point.y).edgesIgnoringSafeArea(.all))
//                        .gesture(
//                            DragGesture()
//                                .onChanged { gesture in
//                                    self.offset = gesture.translation
//
//                                    self.point = gesture.startLocation
//                                    self.point.y += gesture.translation.height
//                                }
//
//                                .onEnded { _ in
//                                        print ("ended")
//                                }
//                        )
                }
                //.frame(minWidth: .infinity, maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            }
            
            
        }
    }
}
