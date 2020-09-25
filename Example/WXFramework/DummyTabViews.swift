//
//  DummyTabViews.swift
//  App framework
//
//  Created by Artur Gurgul on 08/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI
import Combine

import WXFramework

class MapViewModel: ObservableObject {
    var chargingStationReceiver: Cancellable?
    let tabBarItem: TabBarItem
    
    init(tabBarItem: TabBarItem) {
        //NotificationCenter.default.post(name: .chargingStation, object: nil)
        //_localTabType = cardType
        self.tabBarItem = tabBarItem
        
        chargingStationReceiver = NotificationCenter
            .default.publisher(for: .chargingStation)
            .sink(receiveValue: recived)
        
    }
    
    func recived(notification: Notification) {
        print(notification.object)
        
        
        //tabBarItem.tabState.cardType = .list
        
        tabBarItem.tabState.cardType = .error(title: "sadfd")
        
        //localTabType <> localTabType = .list
//        mainTabBarState.cardType = .list
//        mainTabBarState.objectWillChange.send()
//        print(localTabBarState)
    }
}

struct V1: View {
    static var tabName = "Map"
    
    var viewModel: MapViewModel
    
    //@Environment(\.self) var environment
    
    init(_ tabBarItem: TabBarItem) {
        viewModel = MapViewModel(tabBarItem: tabBarItem)
    }
    
     func recived(notification: Notification) {
        print(notification.object)
        
//        environment[TabBarStateEnvironmentKey].cardType = .list
//        environment[TabBarStateEnvironmentKey].objectWillChange.send()
    }
    
    @State var c = true
    
    var body: some View {
        ZStack {
            
            
            
            MapView()
                .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                //Text("HHHHHHAAA!!").background( viewModel.example ? Color.red : Color.green)
                Button(action: {
                    
//                                                        self.mainCardState.cardType = .error(title:"sdc")
//                                                        self.v1CardState.cardType = .none
                    //globalCard.projectedValue = .list
                   // v1CardState.globalCardType = .list
                    
   //                 tabBarState.cardType = .list
                    
                }, label: {Text("Show error card")})
                
                Button(action: {
//                                                        self.mainCardState.cardType = .list
                    //mainCardState.cardType = .list
                   // viewModel.example = true
                   // c = true
                }, label: {Text("Show list")})
                
                Button(action: {
//                                                        self.v1CardState.cardType = .list
//                                                        self.mainCardState.cardType = .none
                    
                    //mainCardState.cardType = .error(title: "re")
                   // viewModel.example = false
                 //   c = false//
                }, label: {Text("Show list inside map view")})
            }
        }
    }
}

class ViewModel {
    
}


struct V2: View {
    @Environment(\.bottomNavigationState) var bottomNavigationState
    
    let tabBarItem: TabBarItem
    
    init(_ tabBarItem: TabBarItem) {
        self.tabBarItem = tabBarItem
        tabBarItem.tabState.tabName = "Map"
    }
    
    static var tabName = "View 2"
    var body: some View {
        VStack {
            NavigationView {
                Button(action: {
                    
                    
                  //  tabBarItem.tabState.cardType = card(title: "title").cardType()
                    //bottomNavigationState.cardType = .any(view: AnyView(Text("asjdfnv adsjkif vnsdkaf vjnsbd lfvij ")))
                    
                    //tabBarItem.tabState.cardType = .error(title: "sadfd")
                    //bottomNavigationState.cardType = .error(title: "sadfd")
                    
                }, label: {
                    Text("Show any view")
                    
                })//.navigationTitle("NAVIGATION TITLE")
            }
            Color.red.frame( minHeight: 100, idealHeight: 100, maxHeight: 100, alignment: .bottom)
        }
    }
    
    func card(title: String) -> some View {
        VStack {
            Text("Very custom tab : \(title)").font(.headline).padding(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 0))
            Text("Nulla ut risus eu tortor semper efficitur. Ut convallis justo libero, eu lobortis augue convallis nec. Praesent condimentum at nibh vel pretium. Vivamus aliquam faucibus mauris, ac viverra quam volutpat sed. Ut fermentum velit eget lacus vulputate fermentum. Donec aliquam sem eget sapien hendrerit porta. Nunc maximus posuere nunc, non dictum tellus iaculis et. Donec fermentum, sapien suscipit rhoncus vehicula, diam quam dapibus lectus, vel ultrices leo lorem ac erat. Sed quis convallis ligula. Curabitur tristique dui mauris, eget hendrerit nisl ultricies vel. Fusce maximus ut libero vitae bibendum. Pellentesque nec accumsan dolor.")
            Text("Maecenas fringilla libero nec nisl accumsan, quis accumsan libero efficitur. In sollicitudin eleifend lacus vitae tempor. Praesent a nisl quam. Nulla sit amet orci mi. Nullam aliquam rutrum magna sit amet ultricies. Ut malesuada urna et ligula posuere imperdiet. Ut tincidunt, augue in porta porttitor, ligula ipsum interdum quam, eget elementum augue eros a nunc. Sed maximus enim a neque pulvinar fermentum. Suspendisse vitae urna tincidunt, rutrum ipsum eleifend, accumsan magna. Morbi eget odio commodo, gravida magna a, ornare felis. Duis molestie, urna a laoreet porta, neque turpis molestie enim, convallis faucibus sem libero in massa. Quisque quis sem quis nibh egestas feugiat et quis sem. Nullam in sollicitudin neque, vitae placerat velit.")
        }
    }
}
struct V3: View {
    
    let tabBarItem: TabBarItem
    
    init(_ tabBarItem: TabBarItem) {
        self.tabBarItem = tabBarItem
    }
    
    static var tabName = "Hejo 3"
    var body: some View {
        Text("V3")
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
struct V4: View {
    @Environment(\.bottomNavigationState) var bottomNavigationState
    
    let tabBarItem: TabBarItem
    
    init(_ tabBarItem: TabBarItem) {
        self.tabBarItem = tabBarItem
    }
    
    static var tabName = "Hsvsvejo"
    var body: some View {
        Button(action: {
           // bottomNavigationState.selected = .t1
            NotificationCenter.default.post(name: .chargingStation, object: "test")
        }, label: {
            Text("V4")
            
        })
        .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}


let ns = NotificationCenter()
extension NotificationCenter {
    static var inCharge: NotificationCenter {
        return ns
    }
}

class InChargeNotificationCenter: NotificationCenter {
    
}

extension NSNotification.Name {
    static let chargingStation = Self("NSNotification.Name")
}

struct V5: View {
    static var tabName = "fff"
    
    let tabBarItem: TabBarItem
    
    init(_ tabBarItem: TabBarItem) {
        self.tabBarItem = tabBarItem
    }
    
    
    var body: some View {
        Text("V5")
            .frame(minWidth: 0,maxWidth: .infinity, minHeight: 55,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
