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

struct ContentView: View {
    var body: some View {
        Text("sdf")
    }
}


struct BottomNavigationView: View {
    
    @State var cardType: CardType = .none
    
    enum CardType {
        case none
        case some
        //case error(title: String)
        
        
    }
    
    init() {
        contentView = AnyView(V1())
    }
    
    //@State private var blockingCardView: CardView<AnyView>?
    @State private var contentView: AnyView?
    
    
    @State private var blockingCardView: OldCardView<AnyView>?
    
    var body: some View {
        
        ZStack {
            VStack {
                
                ZStack {
                    contentView
                    //blockingCardView
                    
//                    CardView {
//
//                           }
                }

                Spacer(minLength: 0)
                VStack(alignment: .center, spacing: 0) {
                    Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                        
                    HStack {
                        BottomTabButton(title: "Map", iconName: "ic_map_bottom_navigation", action: {
                            self.contentView = AnyView(V1())
                            
                            //self.show(view: AnyView(Text("OK")))
                            
                            
                            self.cardType = .some
//                            self.showBlockingCard {
//                                HStack {
//                                    Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
//                                    Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
//                                }
//                            }
                            
                        })
                        BottomTabButton(title: "Sessions", iconName: "ic_sessions_bottom_navigation", action: {
                            self.contentView = AnyView(V2())
                        })
                        ZStack {
                            Image("ic_circle_bottom_navigation").offset(x: 0, y: -7)
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
            
            Group {
                if cardType == .some {
                    OldCardView {
                        Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
                    }
                }
                //if cardType == .none {
                    
                //} else {
                 //   Text("")
                //}
            }
            //cardType.cardView()
            
  //          TupleView {
//                switch self.cardType {
//                case .error(let test):
//                    return OldCardView {
//                        HStack {
//                            Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
//                            Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
//                        }
//                    }
//                default:
//                    return Text("")
                    
////                    return OldCardView {
////                        Text("asdf")
////                    }
//                case .none:
                     
                //case .error(let title):
                    //return
//                        AnyView(Text(""))
//                }
    //        }
            
            
            //blockingCardView
        }
    }

    
    func showBlockingCard<V>(@ViewBuilder content: () -> V) where V: View {
        blockingCardView = OldCardView {
            AnyView(content())
        }
    }
}

//struct MakeView: TupleView<BottomNavigationView.CardType> {

//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationView()
    }
}
