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
    static var vfGray = Color(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0)
}

public class CardEvents {
    public let topSpace = PassthroughSubject<CGFloat, Never>()
    public let contentOffset = PassthroughSubject<CGFloat, Never>()
    public let cardDidClosed = PassthroughSubject<Void, Never>()
    
    // INTERNAL:
    var showCardViewAction = PassthroughSubject<(view: AnyView, isBlocking: Bool, isFullScreen: Bool, openingHeight: CGFloat), Never>()
    var closeCardAction = PassthroughSubject<Void, Never>()
}

public class BottomNavigationState: ObservableObject {
    public let cards = Cards()
    
    @Published public var selected: TabItem = .t1
}

public class Card {
    @Published var cardView: AnyView?
    public let events = CardEvents()
    public func show<Content: View>(isBlocking: Bool = false, isFullScreen: Bool = false, openingHeight: CGFloat = 100, @ViewBuilder content: @escaping () -> Content)  {
        events.showCardViewAction.send((view: AnyView(content()), isBlocking: isBlocking, isFullScreen: isFullScreen, openingHeight: openingHeight))
    }
    
    public func close() {
        events.closeCardAction.send()
    }
}

public class Cards {
    public var blockingCard = Card()
    public var notClosableCard = Card()
    public var normalCard = Card()
}

public class TabState: ObservableObject {
    public let cards = Cards()
    
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
    let accentColor: Color
    
    public init(
        @ViewBuilder v1: (TabBarItem) -> T1,
        @ViewBuilder v2: (TabBarItem) -> T2,
        @ViewBuilder v3: (TabBarItem) -> T3,
        @ViewBuilder v4: (TabBarItem) -> T4,
        @ViewBuilder v5: (TabBarItem) -> T5,
        accentColor: Color) {
        
        
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
        self.accentColor = accentColor

    }
    
    @ObservedObject var bottomNavigationState: BottomNavigationState
    
    @ObservedObject var v1TabState: TabState
    @ObservedObject var v2TabState: TabState
    @ObservedObject var v3TabState: TabState
    @ObservedObject var v4TabState: TabState
    @ObservedObject var v5TabState: TabState
    
    
    public var body: some View {
        
        CardView(cards: bottomNavigationState.cards) {
                VStack {
                    ZStack {
                        //Group {
                            
                            CardView(cards: self.v1TabState.cards) {
                                self.v1.environment(\.tabState, self.v1TabState)
                            }.zIndex(self.bottomNavigationState.selected == .t1 ? 1 : 0.5)
                            
                            CardView(cards: self.v2TabState.cards) {
                                self.v2.environment(\.tabState, self.v2TabState)
                            }.zIndex(self.bottomNavigationState.selected == .t2 ? 1 : 0.5)
                        
                            CardView(cards: self.v3TabState.cards) {
                                self.v3.environment(\.tabState, self.v3TabState)
                            }.zIndex(self.bottomNavigationState.selected == .t3 ? 1 : 0.5)
                        
                            CardView(cards: self.v4TabState.cards) {
                                self.v4.environment(\.tabState, self.v4TabState)
                            }.zIndex(self.bottomNavigationState.selected == .t4 ? 1 : 0.5)
                        
                            CardView(cards: self.v5TabState.cards) {
                                self.v5.environment(\.tabState, self.v5TabState)
                            }.zIndex(self.bottomNavigationState.selected == .t5 ? 1 : 0.5)
                        //}
                    }
                    .environment(\.bottomNavigationState, self.bottomNavigationState)

                    Spacer(minLength: 0)
                    VStack(alignment: .center, spacing: 0) {
                        Style.vfGray.frame(minHeight: 0.5, idealHeight: 0.5, maxHeight: 0.5)
                        
                        HStack {
                            BottomTabButton(title: self.v1TabState.tabName, selected: self.bottomNavigationState.selected == .t1, iconName: "ic_map_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t1
                            }, accentColor: accentColor).accessibility(identifier: "layoutItemMap")
                            BottomTabButton(title: self.v2TabState.tabName, selected: self.bottomNavigationState.selected == .t2, iconName: "ic_sessions_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t2
                            }, accentColor: accentColor).accessibility(identifier: "layoutItemSessions")
                            ZStack {
                                Image("ic_circle_bottom_navigation").offset(x: 0, y: -7)
                                BottomTabButton(title: self.v3TabState.tabName, selected: self.bottomNavigationState.selected == .t3, iconName: "ic_charging_slow", action: {
                                    self.bottomNavigationState.selected = .t3
                                }, accentColor: accentColor)
                            }
                            BottomTabButton(title: self.v4TabState.tabName, selected: self.bottomNavigationState.selected == .t4, iconName: "ic_star", action: {
                                self.bottomNavigationState.selected = .t4
                            }, accentColor: accentColor).accessibility(identifier: "layoutItemFavorite")
                            BottomTabButton(title: self.v5TabState.tabName, selected: self.bottomNavigationState.selected == .t5, iconName: "ic_more_bottom_navigation", action: {
                                self.bottomNavigationState.selected = .t5
                            }, accentColor: accentColor).accessibility(identifier: "layoutItemMore")
                        }
                        
                        Color.white.frame(height: UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
                    }
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
}
