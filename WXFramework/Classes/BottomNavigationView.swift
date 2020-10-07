//
//  ContentView.swift
//  App framework
//
//  Created by Artur Gurgul on 31/08/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import SwiftUI
import Combine

public enum TabItem { case t1, t2, t3, t4, t5}

struct Style {
    static var vfBlack = Color(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0)
    static var vfBlue = Color(red: 32.0 / 255.0, green: 113.0 / 255.0, blue: 181.0 / 255.0)
    static var vfGray = Color(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0)
}

public class CardStatePassthroughSubject {
    public var height = PassthroughSubject<CGFloat, Never>()
    public var contentOffset = PassthroughSubject<CGFloat, Never>()
}

public class BottomNavigationState: ObservableObject {
    @Published public var cardType: CardType = .none
    let cardState = CardStatePassthroughSubject()
    @Published public var selected: TabItem = .t1
}

public class TabState: ObservableObject {
    @Published public var cardType: CardType = .none
    let cardState = CardStatePassthroughSubject()
    @Published public var isSelected = false
    @Published public var icon: Image?
    @Published public var tabName: String = ""
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

public struct BottomNavigationView<T1, T2, T3, T4, T5>: View where T1: View, T2: View, T3: View, T4: View, T5: View {
    
    let v1: T1
    let v2: T2
    let v3: T3
    let v4: T4
    let v5: T5
    
    public init(
        @ViewBuilder v1: (TabBarItem) -> T1,
        @ViewBuilder v2: (TabBarItem) -> T2,
        @ViewBuilder v3: (TabBarItem) -> T3,
        @ViewBuilder v4: (TabBarItem) -> T4,
        @ViewBuilder v5: (TabBarItem) -> T5) {
        
        
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
        
        CardView(cardType: $bottomNavigationState.cardType, cardState: bottomNavigationState.cardState) {
                VStack {
                    ZStack {
                        Group {
                            
                            if self.bottomNavigationState.selected == .t1 {
                                CardView(cardType: self.$v1TabState.cardType, cardState: self.v1TabState.cardState) {
                                    self.v1.environment(\.tabState, self.v1TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t2 {
                                CardView(cardType: self.$v2TabState.cardType, cardState: self.v2TabState.cardState) {
                                    self.v2.environment(\.tabState, self.v2TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t3 {
                                CardView(cardType: self.$v3TabState.cardType, cardState: self.v3TabState.cardState) {
                                    self.v3.environment(\.tabState, self.v3TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t4 {
                                CardView(cardType: self.$v4TabState.cardType, cardState: self.v4TabState.cardState) {
                                    self.v4.environment(\.tabState, self.v4TabState)
                                }
                            } else if self.bottomNavigationState.selected == .t5 {
                                CardView(cardType: self.$v5TabState.cardType, cardState: self.v5TabState.cardState) {
                                    self.v5.environment(\.tabState, self.v5TabState)
                                }
                            }
                        }
                    }
                    .environment(\.bottomNavigationState, self.bottomNavigationState)

                    Spacer(minLength: 0)
                    VStack(alignment: .center, spacing: 0) {
                        Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                            
                        HStack {
                            BottomTabButton(title: self.v1TabState.tabName, selected: self.bottomNavigationState.selected == .t1, iconName: "ic_map_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t1
                            })
                            BottomTabButton(title: self.v2TabState.tabName, selected: self.bottomNavigationState.selected == .t2, iconName: "ic_sessions_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t2
                            })
                            ZStack {
                                Image("ic_circle_bottom_navigation").offset(x: 0, y: -7)
                                BottomTabButton(title: self.v3TabState.tabName, selected: self.bottomNavigationState.selected == .t3, iconName: "ic_charging_slow", action: {
                                    self.bottomNavigationState.selected = .t3
                                })
                            }
                            
                            BottomTabButton(title: self.v4TabState.tabName, selected: self.bottomNavigationState.selected == .t4, iconName: "ic_star", action: {
                                self.bottomNavigationState.selected = .t4
                            })
                            BottomTabButton(title: self.v5TabState.tabName, selected: self.bottomNavigationState.selected == .t5, iconName: "ic_more_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t5
                            })
                        }
                        
                        Color.white.frame(height: UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
                    }
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
}
