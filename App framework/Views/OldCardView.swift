//
//  OldCardView.swift
//  App framework
//
//  Created by Artur Gurgul on 11/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//


import UIKit
import SwiftUI

struct OldCardView<Content>: UIViewRepresentable where Content: View {
    var param: Int = 30
    var content: Content
    var contentHolder: UIKitCardView<Content>
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        contentHolder = UIKitCardView(content: self.content)
    }
    
    func makeUIView(context: Context) -> UIKitCardView<Content> {
        return contentHolder
    }

    func updateUIView(_ view: UIKitCardView<Content>, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: OldCardView

        init(_ parent: OldCardView) {
            self.parent = parent
        }
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

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func calculatedHeight() -> CGFloat {
        return systemLayoutSizeFitting(CGSize(width: frame.size.width, height: 40)).height
    }
}

class UIKitCardView<Content>: UIScrollView, UIScrollViewDelegate where Content : View {
    
    let content: UIView
    
    init(content: Content, needAlfa: Bool = false, thereshold: CGFloat = 208, allowedStates: Set<ViewState> = Set()) {
        self.allowedStates = allowedStates
        self.needAlfa = needAlfa
        self.thereshold = thereshold
        self.content = UIHostingController(rootView: content).view
        
        super.init(frame: .zero)
        
        self.content.translatesAutoresizingMaskIntoConstraints = false

        addSubview(self.content)
        let views: [String: UIView] = ["contentView": self.content, "superview": self]
        
        var allConstraints = [NSLayoutConstraint]()
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[contentView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += vertical
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[contentView(==superview)]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += horizontal
        NSLayoutConstraint.activate(allConstraints)
        
        self.content.backgroundColor = UIColor.red
        
        
        self.backgroundColor = UIColor.green
        
        
        
        alwaysBounceVertical = true
        
        
        let cardMiddleHeight = onlyHalfOpen ? calculatedHeight() : 224
        
        var allowedCardStates: Set<ViewState> = Set([.opened, .middle, .closed])
        
        if onlyHalfOpen {
            allowedCardStates.remove(.opened)
        }
        

        backgroundColor = .clear
        clipsToBounds = false
        delegate = self
        
        //self.content.layer.cornerRadius = 12
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let onlyHalfOpen = true
    
    
    
    let allowedStates: Set<ViewState>
    var firstPointTouch = CGPoint.zero
    var savedContentOffset = CGPoint.zero
    let needAlfa: Bool
    let thereshold: CGFloat
    
    enum ViewState {case opened, middle, closed}
    var viewState = ViewState.closed
    
    var firstLayout = true
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("did layout subviews \(frame)")
        
        if firstLayout {
            
            var f = frame
            f.size.height = content.calculatedHeight()
            frame = f
            firstLayout = false
            
            
            let heightV = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: content.calculatedHeight()))
            
        }
        
        content.roundCorners(corners: [.topLeft, .topRight], radius: 12.0)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentOffset.y < 0 {
            var f = frame
            f.origin.y -= contentOffset.y
            frame = f
        }
    }
    
    /*
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       return true
    }
    
    @objc func panGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = superview else {return}
        guard let parentview = superview.superview else {return}
        
        switch gestureRecognizer.state {
        case .began:
            firstPointTouch = gestureRecognizer.location(in: self)
            savedContentOffset = contentOffset
        case .cancelled, .ended:
            // if there is posibility to scroll up that implays the view can not change frames
            if contentOffset.y > 0 && superview.frame.origin.y < 0.5 {
                break
            }
            let v = gestureRecognizer.velocity(in: parentview)
            
            let currentLevel: CGFloat
            switch viewState {
            case .opened:
                currentLevel = 0
            case .middle:
                currentLevel = superview.frame.size.height - thereshold /*- safeAreaWindowInsets().bottom*/
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
                    self.alpha = 1
                    superview.layer.cornerRadius = 0
                    //self.cardManagerViewController?.cardViewController.adjustCorners(value: 0)
                }, completion:{ completed in
                    if completed {
                        self.isScrollEnabled = true
                    }
                })
                viewState = .opened
            case .middle:
                
                
                isScrollEnabled = true
                
                var f = superview.frame
                f.origin.y = superview.frame.size.height - thereshold /*- safeAreaWindowInsets().bottom */
                
                
                
                UIView.animate(withDuration: 0.18, animations: {
                    self.setContentOffset(CGPoint.zero, animated: false)
                    superview.frame = f
                    if self.needAlfa == false {
                        self.alpha = 0.015
                    }
                    superview.layer.cornerRadius = 12
                    
                }, completion:{ completed in })
                viewState = .middle
            case .closed:
                
                //cardManagerViewController?.cardViewController.willCloseByGesture()
                
                var f = superview.frame
                f.origin.y = superview.frame.size.height
                UIView.animate(withDuration: 0.18, animations: {
                    superview.frame = f
                }) { [weak self] _ in
                    guard let self = self else {return}
                    //self.cardManagerViewController?.viewNeedToBeClosed()
                }
                viewState = .closed
            }
            
            
        case .changed:
            let nextPointTouch = gestureRecognizer.location(in: parentview)
            var f = parentview.frame
            var finalY = nextPointTouch.y - firstPointTouch.y
            
            if allowedStates.contains(.opened) == false {
                
                if finalY <= superview.frame.size.height - thereshold /*- safeAreaWindowInsets().bottom*/ + 0.5 {
                    finalY = superview.frame.size.height - thereshold /*- safeAreaWindowInsets().bottom*/
                    savedContentOffset = contentOffset
                } else {
                    savedContentOffset = CGPoint.zero
                }
                
                
                
            } else if finalY <= 0.5 {
                finalY = 0
                savedContentOffset = contentOffset
            } else {
                savedContentOffset = CGPoint.zero
            }
            
            setContentOffset(savedContentOffset, animated: false)
            
            f.origin.y = finalY
            superview.frame = f
            
            let visibleHeight = parentview.frame.size.height - finalY
            
            
            if needAlfa {
                alpha = 1
            } else {
                let newAlpha = (visibleHeight - 95.0) / 35.5
                if newAlpha > 1 {
                    alpha = 1
                } else if newAlpha <= 0 {
                    alpha = 0.015
                } else {
                    alpha = newAlpha
                }
            }
            
            var cornerRadius = 12 * finalY / 35.0
            if cornerRadius > 12 {
                cornerRadius = 12
            }
            
            superview.layer.cornerRadius = cornerRadius
            //cardManagerViewController?.cardViewController.adjustCorners(value: cornerRadius)
            
        default:
            break
        }

    }
    */
    /*
    func resetView() {
        if needAlfa {
            alpha = 1
        } else {
            alpha = 0.015
        }
        
        guard let superview = superview else {return}
        var f = superview.frame
        f.origin.y = superview.frame.size.height - thereshold /*- safeAreaWindowInsets().bottom*/
        
        superview.frame = f
        superview.layer.cornerRadius = 12
        viewState = .middle
    }
    
    func hide() {
        guard let superview = superview else {return}
        var f = superview.frame
        f.origin.y = superview.frame.size.height
        superview.frame = f
        viewState = .closed
    } */
}
