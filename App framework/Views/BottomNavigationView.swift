//
//  ContentView.swift
//  App framework
//
//  Created by Artur Gurgul on 31/08/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI


struct Style {
    static var vfBlack = Color(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0)
    static var vfBlue = Color(red: 32.0 / 255.0, green: 113.0 / 255.0, blue: 181.0 / 255.0)
    static var vfGray = Color(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0)
}

struct BottomNavigationView<T1, T2, T3, T4, T5>: View where T1: View, T2: View, T3: View, T4: View, T5: View {
    
    enum TabItem { case map, sessions, charge, favourities, more }
    
    @State var selectedTab: TabItem = .map

    let v1: T1
    let v2: T2
    let v3: T3
    let v4: T4
    let v5: T5
    
    init(@ViewBuilder v1: () -> T1, @ViewBuilder v2: () -> T2, @ViewBuilder v3: () -> T3, @ViewBuilder v4: () -> T4, @ViewBuilder v5: () -> T5) {
        self.v1 = v1()
        self.v2 = v2()
        self.v3 = v3()
        self.v4 = v4()
        self.v5 = v5()
    }
    
    @State private var blockingCardView: CardView<AnyView>?
    
    @State var cardType: CardType = .none
    
    var body: some View {
        
        CardView(cardType: cardType) {
                VStack {
                    
                    ZStack {
                        
                        Group {
                            
                            if selectedTab == .map {
                                
                                
                                                                ZStack {
                                //                                    CardView(dismissed: dismissed) {
                                v1
                                //                                    }
                                
                                                                    Button(action: {
                                                                        self.cardType = .error(title:"sdc")
                                                                        
                                                                    }, label: {Text("Show errorcard")})
                                                                }
                            } else if selectedTab == .sessions {
                                v2
                            } else if selectedTab == .charge {
                                v3
                            } else if selectedTab == .favourities {
                                v4
                            } else if selectedTab == .more {
                                v5
                            }
                        }
                    }

                    Spacer(minLength: 0)
                    VStack(alignment: .center, spacing: 0) {
                        Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                            
                        HStack {
                            BottomTabButton(title: "Map", selected: self.selectedTab == .map, iconName: "ic_map_bottom_navigation", action: {
                                self.selectedTab = .map
                                
                            })
                            BottomTabButton(title: "Sessions", selected: self.selectedTab == .sessions, iconName: "ic_sessions_bottom_navigation", action: {
                                self.selectedTab = .sessions
                            })
                            ZStack {
                                Image("ic_circle_bottom_navigation").offset(x: 0, y: -7)
                                BottomTabButton(title: "Charge", selected: self.selectedTab == .charge, iconName: "ic_charging_slow", action: {
                                    self.selectedTab = .charge
                                })
                            }
                            
                            BottomTabButton(title: "Favourites", selected: self.selectedTab == .favourities, iconName: "ic_star", action: {
                                self.selectedTab = .favourities
                            })
                            BottomTabButton(title: "More", selected: self.selectedTab == .more, iconName: "ic_more_bottom_navigation", action: {
                                self.selectedTab = .more
                            })
                                
                        }
                    }
                    
                }
                
//                Group {
//    //            Rectangle().background(Color.black).opacity(0.2).disabled(true)
//                    //
//                    if cardType == .some {
//
//
//                        //Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
//
//
//                        /*.clipShape(Circle()).contentShape(HitTestingShape())*/
//                        //.opacity(0.5)
//                    }
//
//                    //if cardType == .none {
//
//                    //} else {
//                     //   Text("")
//                    //}
//                    //Rectangle().allowsHitTesting(true)
//                }//.contentShape(HitTestingShape())
                
           // }.edgesIgnoringSafeArea(.top)
        }.edgesIgnoringSafeArea(.top)
    }

//    func dismissed() {
//        cardType = .none
//    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView(v1: {V1()}, v2: {V2()}, v3: {V3()}, v4: {V4()}, v5: {V5()})
    }
}


//struct CardViews: View {
//    var body: some View {
//       Group {
//           switch containedView {
//              case .home: HomeView()
//              case .categories: CategoriesView()
//              ...
//           }
//       }
//    }
//}
