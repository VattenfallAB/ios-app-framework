//
//  RootViewController.swift
//  eMobility
//
//  Created by Artur Gurgul on 02/11/2018.
//  Copyright © 2018 Nuon. All rights reserved.
//

import UIKit
/*




class RootViewController: BaseViewController {
    
    func open(viewController: UIViewController, animated: Bool) {
        let viewControllersToRemove = children.filter{$0 != viewController}
        presentChildViewController(childController: viewController)
        
        for viewControllerToRemove in viewControllersToRemove {
            removeChildViewController(childViewController: viewControllerToRemove)
        }
    }
}

class CardManagerViewController: BaseViewController {
    let cardViewController: CardViewController
    var scrollView: BaseScrollView!
    let openWithAnimation: Bool
    var closeWithAnimation = true
    init(cardViewController: CardViewController, openWithAnimation: Bool) {
        self.openWithAnimation = openWithAnimation
        self.cardViewController = cardViewController
        super.init(nibName: nil, bundle: nil)
        scrollView = BaseScrollView(cardManagerViewController: self)
        
        cardViewController.enableScrolling = enableScrolling
    }
    
    func enableScrolling(enabled: Bool) {
        scrollView.panGestureRecognition.isEnabled = enabled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        let views: [String: UIView] = ["scrollView": scrollView, "contentView": cardViewController.view]
        presentChildViewController(childController: cardViewController, onView: scrollView)
        
        scrollView.bounces = true
        scrollView.isHidden = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        cardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        var allConstraints = [NSLayoutConstraint]()
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[contentView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += vertical
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[contentView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += horizontal
        
        let verticalScrollView = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[scrollView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += verticalScrollView
        let horizontalScrollView = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[scrollView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += horizontalScrollView
        
        
        NSLayoutConstraint.activate(allConstraints)
        
        scrollView.addConstraint(NSLayoutConstraint(item: cardViewController.view as Any, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1.0, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: cardViewController.view as Any, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0.0))
        
        view.backgroundColor = cardViewController.view.backgroundColor
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.hide()
        scrollView.isHidden = false
        
        if openWithAnimation {
            UIView.animate(withDuration: 0.18, animations: {
                self.scrollView.resetView()
            })
        } else {
            scrollView.resetView()
        }
    }
    

    
    func viewNeedToBeClosed() {
        if let parent = parent as? RootCardViewController {
            parent.unblockIfNeeded()
        }
        
        
        guard let rootCardViewController = cardViewController.parent?.parent as? RootCardViewController else {
            return
        }
        
        rootCardViewController.close(cardViewController: cardViewController, withGesture: true, animated: true)
    }
}

class RootCardViewController: RootViewController {
    private(set) var cardManagerViewControllers = [CardManagerViewController]()
    private var activeCardManagerViewController: CardManagerViewController?
    
    func didClose(cardViewController: CardViewController, withGesture: Bool = false) {}
    func closeAllCards(excpet: LocationDetailsViewController? = nil, animated: Bool) {
        let cardViewControllers = cardManagerViewControllers.map{$0.cardViewController}
        for cardViewController in cardViewControllers where cardViewController != excpet {
            cardViewController.close(animated: animated)
        }
    }
    
    func close(cardViewController: CardViewController, withGesture: Bool = false, animated: Bool) {
        unblockIfNeeded()
        let cardViewControllers = cardManagerViewControllers.map{$0.cardViewController}
        guard let index = cardViewControllers.firstIndex(where: {$0 == cardViewController}) else {
            // view has been already closed, probably by from outside logic
            return
        }
        cardManagerViewControllers.remove(at: index)
        activeCardManagerViewController = cardManagerViewControllers.last
        
        guard let cardManagerViewController = cardViewController.parent as? CardManagerViewController else {
            fatalError("card view was not opened correctly so it is impossible to close ")
        }
        
        if cardManagerViewController.closeWithAnimation {
            UIView.animate(withDuration: 0.18, animations: {
                var f = cardManagerViewController.view.frame
                f.origin.y = cardManagerViewController.view.frame.size.height
                cardManagerViewController.view.frame = f
            }, completion: { completed in
                self.removeChildViewController(childViewController: cardManagerViewController)
                self.didClose(cardViewController: cardManagerViewController.cardViewController, withGesture: withGesture)
            })
        } else {
            var f = cardManagerViewController.view.frame
            f.origin.y = cardManagerViewController.view.frame.size.height
            cardManagerViewController.view.frame = f
            removeChildViewController(childViewController: cardManagerViewController)
            didClose(cardViewController: cardManagerViewController.cardViewController, withGesture: withGesture)
        }
    }
    
    func open(cardViewController: CardViewController, animated: Bool) {
        if cardViewController.disableOthers {
            addBlockView()
        }
        
        var openWithAnimation = true
        if let prevCardManagerViewController = cardManagerViewControllers.last, prevCardManagerViewController.cardViewController is LocationDetailsViewController && cardViewController is LocationDetailsViewController {
            openWithAnimation = false
            prevCardManagerViewController.closeWithAnimation = false
        }
        let cardManagerViewController = viewControllerFactory.createCardManagerViewController(cardViewController: cardViewController, openWithAnimation: openWithAnimation)
        cardManagerViewControllers.append(cardManagerViewController)
        activeCardManagerViewController = cardManagerViewController
        presentChildViewController(childController: cardManagerViewController)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blockView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        blockNavView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        blockOutsideSafeAreaView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    let blockView = UIView()
    let blockNavView = UIView()
    let blockOutsideSafeAreaView = UIView()
    
    func addBlockView() {
        blockNavigation()
        blockController()
        blockOutsideSafeArea()
    }
    
    func blockOutsideSafeArea() {
        guard let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets else {
            return
        }
        
        view.window?.addSubview(blockOutsideSafeAreaView)
        
        let views: [String: UIView] = ["blockView": blockOutsideSafeAreaView]
        blockOutsideSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        
        var allConstraints = [NSLayoutConstraint]()
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[blockView(\(safeArea.top))]", options: [], metrics: nil, views: views)
        allConstraints += vertical
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[blockView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += horizontal
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func blockNavigation() {
        if let navigationViewController = parent as? BaseNavigationController {
            navigationViewController.navigationBar.addSubview(blockNavView)
            let views: [String: UIView] = ["blockView": blockNavView]
            blockNavView.translatesAutoresizingMaskIntoConstraints = false
            
            var allConstraints = [NSLayoutConstraint]()
            
            let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[blockView]-(0)-|", options: [], metrics: nil, views: views)
            allConstraints += vertical
            let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[blockView]-(0)-|", options: [], metrics: nil, views: views)
            allConstraints += horizontal
            
            NSLayoutConstraint.activate(allConstraints)
        }
    }
    
    func blockController() {
        let views: [String: UIView] = ["blockView": blockView]
        blockView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blockView)
        var allConstraints = [NSLayoutConstraint]()
        
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[blockView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += vertical
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[blockView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += horizontal
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func unblockIfNeeded() {
        blockView.removeFromSuperview()
        blockNavView.removeFromSuperview()
        blockOutsideSafeAreaView.removeFromSuperview()
    }
}
*/
