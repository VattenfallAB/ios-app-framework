//
//  RootViewController.swift
//  eMobility
//
//  Created by Artur Gurgul on 02/11/2018.
//  Copyright © 2018 Nuon. All rights reserved.
//

import UIKit
/*
extension BaseTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BaseScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       return false
       //return true
    }
}

extension UIView {
    func calculatedHeight() -> CGFloat {
        return systemLayoutSizeFitting(CGSize(width: frame.size.width, height: 40)).height
    }
}

class BaseTableView: UITableView {
    var manager: CardScrollManager!
    override func awakeFromNib() {
        manager = CardScrollManager(scrollView: self, needAlfa: false, thereshold: 56.0, allowedStates: Set([.middle, .opened]))
        super.awakeFromNib()
        backgroundColor = .clear
        let panGestureRecognition = UIPanGestureRecognizer(target: self, action: #selector(objcPanGestureHandler))
        addGestureRecognizer(panGestureRecognition)
    }
    var firstPointTouch = CGPoint.zero
    var savedContentOffset = CGPoint.zero
    @objc func objcPanGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        manager.panGestureHandler(gestureRecognizer: gestureRecognizer)
    }
    
    func resetView() {
        manager.resetView()
    }
    
    func hide() {
        manager.hide()
    }
}

class BaseScrollView: UIScrollView {
    var manager: CardScrollManager!
    var panGestureRecognition: UIPanGestureRecognizer!
    init(cardManagerViewController: CardManagerViewController) {
        
        super.init(frame: CGRect.zero)
        let cardViewController = cardManagerViewController.cardViewController
        
        alwaysBounceVertical = true
        //manager = CardScrollManager(scrollView: self, needAlfa: true, thereshold: 208, cardManagerViewController: cardManagerViewController)
        
        let cardMiddleHeight = cardViewController.onlyHalfOpen ? cardViewController.view.calculatedHeight() : 224
        
        var allowedCardStates: Set<CardScrollManager.ViewState> = Set([.opened, .middle, .closed])
        
        if cardViewController.onlyHalfOpen {
            allowedCardStates.remove(.opened)
        }
        
        manager = CardScrollManager(scrollView: self, needAlfa: true, thereshold: cardMiddleHeight, cardManagerViewController: cardManagerViewController, allowedStates: allowedCardStates)
        backgroundColor = .clear
        panGestureRecognition = UIPanGestureRecognizer(target: self, action: #selector(objcPanGestureHandler))
        addGestureRecognizer(panGestureRecognition)
        
        panGestureRecognition.cancelsTouchesInView = false
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func objcPanGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        manager.panGestureHandler(gestureRecognizer: gestureRecognizer)
    }
    
    func resetView() {
        manager.resetView()
    }
    
    func hide() {
        manager.hide()
    }
}


class CardScrollManager {
    let scrollView: UIScrollView
    let allowedStates: Set<ViewState>
    var firstPointTouch = CGPoint.zero
    var savedContentOffset = CGPoint.zero
    let needAlfa: Bool
    let thereshold: CGFloat
    weak var cardManagerViewController: CardManagerViewController?
    
    enum ViewState {case opened, middle, closed}
    var viewState = ViewState.closed
    
    init(scrollView: UIScrollView, needAlfa: Bool = false, thereshold: CGFloat, cardManagerViewController: CardManagerViewController? = nil, allowedStates: Set<ViewState>) {
        self.allowedStates = allowedStates
        self.scrollView = scrollView
        self.needAlfa = needAlfa
        self.thereshold = thereshold
        self.cardManagerViewController = cardManagerViewController
        
        scrollView.layer.masksToBounds = false
    }
    
    func panGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = scrollView.superview else {return}
        guard let parentview = superview.superview else {return}
        
        switch gestureRecognizer.state {
        case .began:
            firstPointTouch = gestureRecognizer.location(in: scrollView)
            savedContentOffset = scrollView.contentOffset
        case .cancelled, .ended:
            // if there is posibility to scroll up that implays the view can not change frames
            if scrollView.contentOffset.y > 0 && superview.frame.origin.y < 0.5 {
                break
            }
            let v = gestureRecognizer.velocity(in: parentview)
            
            let currentLevel: CGFloat
            switch viewState {
            case .opened:
                currentLevel = 0
            case .middle:
                currentLevel = superview.frame.size.height - thereshold - safeAreaWindowInsets().bottom
            case .closed:
                currentLevel = superview.frame.size.height
            }
            
            let nextViewState: ViewState
            
            if abs(v.y) < 450 {
                let offset = currentLevel - superview.frame.origin.y
                if abs(offset) >= 80 {
                    switch viewState {
                    case .opened:
                        nextViewState = offset < 0 ? .middle  : .opened
                    case .middle:
                        nextViewState = offset < 0 ? .closed  : .opened
                    case .closed:
                        nextViewState = .closed
                    }
                } else {
                    nextViewState = viewState
                }
                
            } else {
                switch viewState {
                case .opened:
                    nextViewState = v.y < 0 ? .opened : .middle
                case .middle:
                    nextViewState = v.y < 0 ? .opened : .closed
                case .closed:
                    nextViewState = .closed
                }
                
            }
            
            let nextAllowedState: ViewState
            if allowedStates.contains(nextViewState) {
                nextAllowedState = nextViewState
            } else {
                nextAllowedState = viewState
            }
            
            switch nextAllowedState {
            case .opened:
                var f = superview.frame
                f.origin.y = 0
                UIView.animate(withDuration: 0.18, animations: {
                    superview.frame = f
                    self.scrollView.alpha = 1
                    superview.layer.cornerRadius = 0
                    self.cardManagerViewController?.cardViewController.adjustCorners(value: 0)
                }, completion:{ completed in
                    if completed {
                        self.scrollView.isScrollEnabled = true
                    }
                })
                viewState = .opened
            case .middle:
                
                
                scrollView.isScrollEnabled = true
                
                var f = superview.frame
                f.origin.y = superview.frame.size.height - thereshold - safeAreaWindowInsets().bottom
                
                
                
                UIView.animate(withDuration: 0.18, animations: {
                    self.scrollView.setContentOffset(CGPoint.zero, animated: false)
                    superview.frame = f
                    if self.needAlfa == false {
                        self.scrollView.alpha = 0.015
                    }
                    superview.layer.cornerRadius = 12
                    
                }, completion:{ completed in })
                viewState = .middle
            case .closed:
                
                cardManagerViewController?.cardViewController.willCloseByGesture()
                
                var f = superview.frame
                f.origin.y = superview.frame.size.height
                UIView.animate(withDuration: 0.18, animations: {
                    superview.frame = f
                }) { [weak self] _ in
                    guard let self = self else {return}
                    self.cardManagerViewController?.viewNeedToBeClosed()
                }
                viewState = .closed
            }
            
            
        case .changed:
            let nextPointTouch = gestureRecognizer.location(in: parentview)
            var f = parentview.frame
            var finalY = nextPointTouch.y - firstPointTouch.y
            
            if allowedStates.contains(.opened) == false {
                
                if finalY <= superview.frame.size.height - thereshold - safeAreaWindowInsets().bottom + 0.5 {
                    finalY = superview.frame.size.height - thereshold - safeAreaWindowInsets().bottom
                    savedContentOffset = scrollView.contentOffset
                } else {
                    savedContentOffset = CGPoint.zero
                }
                
                
                
            } else if finalY <= 0.5 {
                finalY = 0
                savedContentOffset = scrollView.contentOffset
            } else {
                savedContentOffset = CGPoint.zero
            }
            
            scrollView.setContentOffset(savedContentOffset, animated: false)
            
            f.origin.y = finalY
            superview.frame = f
            
            let visibleHeight = parentview.frame.size.height - finalY
            
            
            if needAlfa {
                scrollView.alpha = 1
            } else {
                let newAlpha = (visibleHeight - 95.0) / 35.5
                if newAlpha > 1 {
                    scrollView.alpha = 1
                } else if newAlpha <= 0 {
                    scrollView.alpha = 0.015
                } else {
                    scrollView.alpha = newAlpha
                }
            }
            
            var cornerRadius = 12 * finalY / 35.0
            if cornerRadius > 12 {
                cornerRadius = 12
            }
            
            superview.layer.cornerRadius = cornerRadius
            cardManagerViewController?.cardViewController.adjustCorners(value: cornerRadius)
            
        default:
            break
        }
    }
    
    
    func resetView() {
        if needAlfa {
            scrollView.alpha = 1
        } else {
            scrollView.alpha = 0.015
        }
        
        guard let superview = scrollView.superview else {return}
        var f = superview.frame
        f.origin.y = superview.frame.size.height - thereshold - safeAreaWindowInsets().bottom
        
        superview.frame = f
        superview.layer.cornerRadius = 12
        viewState = .middle
    }
    
    func hide() {
        guard let superview = scrollView.superview else {return}
        var f = superview.frame
        f.origin.y = superview.frame.size.height
        superview.frame = f
        viewState = .closed
    }
    
}

protocol CardViewController: BaseViewController {
    func open(rootViewController: RootCardViewController?, animated: Bool)
    
    func close(animated: Bool)
    
    var onlyHalfOpen: Bool {get}
    var disableOthers: Bool {get}
    
    //var blockScrolling: Bool {get set}
    var enableScrolling: ((Bool)->Void)? {get set}
    
    func willCloseByGesture()
    func adjustCorners(value: CGFloat)
}



extension CardViewController {
    
    func willCloseByGesture() {
        
    }
    
    func adjustCorners(value: CGFloat){
        
    }
    
    var enableScrolling: ((Bool)->Void)? {
        set {}
        get {nil}
    }
    
    func open(rootViewController: RootCardViewController? = nil, animated: Bool = true) {
        let rootViewController = rootViewController ?? Injector.resolve(RootCardViewController.self)
        rootViewController.open(cardViewController: self, animated: animated)
    }
    
    func close(animated: Bool) {
        let rootViewController = getCardRootViewController()
        rootViewController.close(cardViewController: self, animated: animated)
    }
    
    func getCardRootViewController() -> RootCardViewController{
        var parentViewController: UIViewController? = self
        while parentViewController != nil{
            parentViewController = parentViewController?.parent
            if let rootViewController = parentViewController as? RootCardViewController {
                return rootViewController
            }
        }
        fatalError()
    }
}

private extension CALayer {
    func adjustCorners(with offset: CGFloat) {
        if offset < 60 {
            let radius = floor(offset/60 * 12.0)
            if cornerRadius != radius {
                cornerRadius = radius
            }
        }
    }
}

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
