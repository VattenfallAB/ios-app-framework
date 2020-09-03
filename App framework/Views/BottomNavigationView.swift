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

protocol CardView: View {
    
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
                        //.offset(y: 150)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                    self.point = gesture.location
                                    
                                }

                                .onEnded { _ in
                                        print ("ended")
                                }
                        )
                }
                //.frame(minWidth: .infinity, maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            }
            
            
        }
    }
}

struct BottomNavigationView: View {
    
    
    init() {
        contentView = AnyView(V1())
    }
    
    
    
    //let tabs:[View.Type] = [V1.self, V2.self, V3.self, V4.self, V5.self]
    
    @State private var cardView: AnyView?
    @State private var contentView: AnyView?
    
    var body: some View {
        ZStack {
            VStack {
                
                    contentView

                Spacer(minLength: 0)
                VStack(alignment: .center, spacing: 0) {
                    Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                        
                    HStack {
                        BottomTabButton(title: "Map", iconName: "ic_map_bottom_navigation", action: {
                            self.contentView = AnyView(V1())
                            
                            self.show(view: AnyView(Text("OK")))
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
