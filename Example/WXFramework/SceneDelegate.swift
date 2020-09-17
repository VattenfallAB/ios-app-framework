//
//  SceneDelegate.swift
//  App framework
//
//  Created by Artur Gurgul on 31/08/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//

import UIKit
import SwiftUI

import WXFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        PP()
//                let contentView = VStack {
//                    
//                    NavigationView {
//                        Text("ok").navigationBarTitle("hej")
//                    }
//                    Color.red.frame( minHeight: 100, idealHeight: 100, maxHeight: 100, alignment: .bottom)
//                }
        
        let contentView = BottomNavigationView(v1: {V1()}, v2: {V2()}, v3: {V3()}, v4: {V4()}, v5: {V5()})

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

