//
//  CardView.swift
//  App framework
//
//  Created by Artur Gurgul on 08/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI

struct CardView<Content>: View where Content : View {
    @GestureState var offsa = CGSize(width: 0, height: 0)
    
    @State var offs = CGSize.zero
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        return ZStack {
            ZStack {
                Spacer()
                
                GeometryReader { outsideProxy in
                    
                    ScrollView {
                        
                        
                        
                        self.content.background(Color.white)
                        
                        
                        GeometryReader { insideProxy in
                        Text("\(outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY), \(insideProxy.frame(in: .global).minY)")
                            .font(.title)
                            .frame(maxWidth: .infinity) // Just to center the text

                            //self.offs.height += 1
                        }.accessibilityScrollAction { e in
                            print("sdfc")
                        }
                        
                    }
                    .frame(alignment: .bottom)
                    .offset(self.offs)
                }
            }.frame(alignment: .bottom).background(Color.clear)
            //.animation(.spring())
            //.animation(.easeInOut)
             //   .animation(Animation.spring(response: <#T##Double#>, dampingFraction: <#T##Double#>, blendDuration: <#T##Double#>))
  /*          .offset(y:  offs.height-30)
            
            
                .simultaneousGesture(DragGesture(minimumDistance: 0).updating($offsa, body: { (val, state, transaction) in
                    state = val.translation
                })/*.onChanged{gesture in
            
                    print(gesture.translation)
                    
                    
                    
            self.offs = CGSize(width: gesture.location.x, height: gesture.location.y)
            if self.offs.height - 30 < 0 {
                self.offs.height = 30
            }
            //self.dragAmount = gesture.translation
        }*/, including: .all)
 */
        }
                  .background(Color.clear)
    //.gesture(DragGesture(minimumDistance: 0))
    //.highPriorityGesture(DragGesture(minimumDistance: 0))
    
        /*
        .highPriorityGesture(DragGesture(minimumDistance: 0)
//                    .updating($offs, body: { (drag, state, transaction) in
//                        print(drag.translation)
//
//                        state = drag.translation
//                    })
                    .onChanged{gesture in
                        print(gesture.translation)
                        self.offs = CGSize(width: gesture.location.x, height: gesture.location.y)
                        if self.offs.height - 30 < 0 {
                            self.offs.height = 0
                        }
                        //self.dragAmount = gesture.translation
                    }
                    
            )
        */
           // .frame(maxHeight: offs.height/*, alignment: .bottom*/)
            //.offset(offs)
        }
   
    
}
