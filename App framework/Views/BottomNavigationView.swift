//
//  ContentView.swift
//  App framework
//
//  Created by Artur Gurgul on 31/08/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI


                //
                //.background(Color.red)
                


struct Style {
    static var vfBlack = Color(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0)
    static var vfBlue = Color(red: 32.0 / 255.0, green: 113.0 / 255.0, blue: 181.0 / 255.0)
    static var vfGray = Color(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0)
}


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

struct ContentView: View {
    var body: some View {
        Text("sdf")
    }
}


struct V1: View {
    var body: some View {
        MapView()
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
struct V2: View {
    var body: some View {
        Text("V2")
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
struct V3: View {
    var body: some View {
        Text("V3")
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
struct V4: View {
    var body: some View {
        Text("V4")
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
struct V5: View {
    var body: some View {
        Text("V5")
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct BlockingCard: View {
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


struct CardView<Content> : View where Content : View {
    //@GestureState var offs = CGSize(width: 1000, height: 1000)
    
    @State var offs = CGSize.zero
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        //return Text("sdf")
        
        return ZStack {
            //Group {
                //
            ZStack {
                ScrollView {
                    content
                }
                
                    //                            .introspectScrollView { scrollView in
                    //                            scrollView.isScrollEnabled = shouldScroll
                    //                        }
                    
                    //}
                   // .offset(offs)
                    
                
                //.offset()
                
                
                //}.frame(minWidth: 300, minHeight: 300)
                //                        .onTap { o in
                //                            print(o)
                
                
                //                    }
                //}
            //}
            }.offset(y:  offs.height-30)
            
        }
        .simultaneousGesture(DragGesture(minimumDistance: 0).onChanged{gesture in
            print(gesture.translation)
            self.offs = CGSize(width: gesture.location.x, height: gesture.location.y)
            if self.offs.height - 30 < 0 {
                self.offs.height = 30
            }
            //self.dragAmount = gesture.translation
        }, including: .all)
        
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


struct BottomNavigationView: View {
    
    
    init() {
        contentView = AnyView(V1())
    }
    
    
    
    //let tabs:[View.Type] = [V1.self, V2.self, V3.self, V4.self, V5.self]
    
    @State private var cardView: AnyView?
    @State private var contentView: AnyView?
    @State private var c: GestureState<Any>?
    
    //@Binding var shouldScroll: Bool

    
    //@Binding var shouldScroll: Bool
    
    //@State private var
    
    @GestureState var dragAmount = CGSize.zero
    
    var body: some View {
        
        
        ZStack {
            VStack {
                
                ZStack {
                    contentView
                    
                    
                    
               /*     //ScrollView {
                        List {
                            ForEach(1...100, id:\.self) { i  in
                                Text("element \(i)")
                            }//.gesture(DragGesture())
                            
                        }
                        //.moveDisabled(true)
                        .offset()
                        .highPriorityGesture(
                            DragGesture(minimumDistance: 100)
                                .onChanged { gesture in
                                    print(gesture.translation)
                                }

                                .onEnded { _ in
                                        print ("ended")
                                }
                        
                    )
                    */
                    
                    
                    // {
                    
                    
                    CardView {
                        Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
                    }
                }
//            .simultaneousGesture(<#T##gesture: Gesture##Gesture#>, including: <#T##GestureMask#>)
//                .simultaneousGesture(
//                    DragGesture(minimumDistance: 0).updating($dragAmount) { value, state, transaction in
//                        print("changed \(value)")
////                        var frame = value.translation
////                        frame.width = 0
////                        state = frame
//                        
//                    }
//                )
            

                Spacer(minLength: 0)
                VStack(alignment: .center, spacing: 0) {
                    Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                        
                    HStack {
                        BottomTabButton(title: "Map", iconName: "ic_map_bottom_navigation", action: {
                            self.contentView = AnyView(V1())
                            
                            //self.show(view: AnyView(Text("OK")))
                        })
                        BottomTabButton(title: "Sessions", iconName: "ic_sessions_bottom_navigation", action: {
                            self.contentView = AnyView(V2())
                        })
                        ZStack {
                            Image("ic_circle_bottom_navigation")
                            .offset(x: 0, y: -7)
                            BottomTabButton(title: "Charge", iconName: "ic_charging_slow", action: {
                                self.contentView = AnyView(V3())
                            })
                        }
                        
                        
                        BottomTabButton(title: "Favourites", iconName: "ic_star", action: {
                            self.contentView = AnyView(V4())
                        })
                        BottomTabButton(title: "More", iconName: "ic_more_bottom_navigation", action: {
                            self.contentView = AnyView(V5())
                        })
                            
                    }
                }
            }
            cardView
        }
    }
    
    func show(view: AnyView) {
        cardView = AnyView(BlockingCard(contentView: view))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView()
    }
}
