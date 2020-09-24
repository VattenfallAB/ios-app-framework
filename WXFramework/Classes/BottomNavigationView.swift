//
//  ContentView.swift
//  App framework
//
//  Created by Artur Gurgul on 31/08/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI

public protocol TabRootView: View {
    static var tabName: String {get}
    //public init(tabBarViewState: TabBarViewState)
}

public enum TabItem { case t1, t2, t3, t4, t5}

struct Style {
    static var vfBlack = Color(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0)
    static var vfBlue = Color(red: 32.0 / 255.0, green: 113.0 / 255.0, blue: 181.0 / 255.0)
    static var vfGray = Color(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0)
}

public class BottomNavigationState: ObservableObject {
    @Published public var cardType: CardType = .none
    @Published public var selected: TabItem = .t1
}

public class TabState: ObservableObject {
    @Published public var cardType: CardType = .none
    @Published public var isSelected = false
    @Published public var icon: Image?
}

public class TabBarItem {
    public let bottomNavigationState: BottomNavigationState
    public let tabState: TabState
    fileprivate init (bottomNavigationState: BottomNavigationState, tabState: TabState) {
        self.bottomNavigationState = bottomNavigationState
        self.tabState = tabState
    }
}

public struct TabStateEnvironmentKey: EnvironmentKey {
    public static let defaultValue = TabState()
}

public extension EnvironmentValues {
    var tabState: TabState {
        get { self[TabStateEnvironmentKey.self] }
        set { self[TabStateEnvironmentKey.self] = newValue }
    }
}

public struct BottomNavigationStateEnvironmentKey: EnvironmentKey {
    public static let defaultValue = BottomNavigationState()
}

public extension EnvironmentValues {
    var bottomNavigationState: BottomNavigationState {
        get { self[BottomNavigationStateEnvironmentKey.self] }
        set { self[BottomNavigationStateEnvironmentKey.self] = newValue }
    }
}

public struct BottomNavigationView<T1, T2, T3, T4, T5>: View where T1: TabRootView, T2: TabRootView, T3: TabRootView, T4: TabRootView, T5: TabRootView {
    
    let v1: T1
    let v2: T2
    let v3: T3
    let v4: T4
    let v5: T5
    
    public init(@ViewBuilder v1: (TabBarItem) -> T1, @ViewBuilder v2: (TabBarItem) -> T2, @ViewBuilder v3: (TabBarItem) -> T3, @ViewBuilder v4: (TabBarItem) -> T4, @ViewBuilder v5: (TabBarItem) -> T5) {
        
        
        let v1TabState = TabState()
        let v2TabState = TabState()
        let v3TabState = TabState()
        let v4TabState = TabState()
        let v5TabState = TabState()
        
        self.v1TabState = v1TabState
        self.v2TabState = v2TabState
        self.v3TabState = v3TabState
        self.v4TabState = v4TabState
        self.v5TabState = v5TabState
        
        let bottomNavigationState = BottomNavigationState()
        
        self.bottomNavigationState = bottomNavigationState
        
        self.v1 = v1(TabBarItem(bottomNavigationState: bottomNavigationState, tabState: v1TabState))
        self.v2 = v2(TabBarItem(bottomNavigationState: bottomNavigationState, tabState: v2TabState))
        self.v3 = v3(TabBarItem(bottomNavigationState: bottomNavigationState, tabState: v3TabState))
        self.v4 = v4(TabBarItem(bottomNavigationState: bottomNavigationState, tabState: v4TabState))
        self.v5 = v5(TabBarItem(bottomNavigationState: bottomNavigationState, tabState: v5TabState))
        

    }
    
    @ObservedObject var bottomNavigationState: BottomNavigationState
    
    @ObservedObject var v1TabState: TabState
    @ObservedObject var v2TabState: TabState
    @ObservedObject var v3TabState: TabState
    @ObservedObject var v4TabState: TabState
    @ObservedObject var v5TabState: TabState
    
    public var body: some View {
        
        CardView(cardType: $bottomNavigationState.cardType) {
                VStack {
                    
                    ZStack {
                        
                        Group {
                            
                            if self.bottomNavigationState.selected == .t1 {
                                CardView(cardType: $v1TabState.cardType) {
                                    self.v1.environment(\.tabState, v1TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t2 {
                                CardView(cardType: $v2TabState.cardType) {
                                    self.v2.environment(\.tabState, v2TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t3 {
                                CardView(cardType: $v3TabState.cardType) {
                                    self.v3.environment(\.tabState, v3TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t4 {
                                CardView(cardType: $v4TabState.cardType) {
                                    self.v4.environment(\.tabState, v4TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t5 {
                                CardView(cardType: $v5TabState.cardType) {
                                    self.v5.environment(\.tabState, v5TabState)
                                }
                            }
                        }
                    }.edgesIgnoringSafeArea(.top).environment(\.bottomNavigationState, bottomNavigationState)

                    Spacer(minLength: 0)
                    VStack(alignment: .center, spacing: 0) {
                        Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                            
                        HStack {
                            BottomTabButton(title: T1.tabName, selected: bottomNavigationState.selected == .t1, iconName: "ic_map_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t1
                                
                            })
                            BottomTabButton(title: T2.tabName, selected: bottomNavigationState.selected == .t2, iconName: "ic_sessions_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t2
                            })
                            ZStack {
                                Image("ic_circle_bottom_navigation").offset(x: 0, y: -7)
                                BottomTabButton(title: T3.tabName, selected: bottomNavigationState.selected == .t3, iconName: "ic_charging_slow", action: {
                                    self.bottomNavigationState.selected = .t3
                                })
                            }
                            
                            BottomTabButton(title: T4.tabName, selected: bottomNavigationState.selected == .t4, iconName: "ic_star", action: {
                                self.bottomNavigationState.selected = .t4
                            })
                            BottomTabButton(title: T5.tabName, selected: bottomNavigationState.selected == .t5, iconName: "ic_more_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t5
                            })
                        }
                    }
                    
                }
        }
        .edgesIgnoringSafeArea(.top)
    }
}
