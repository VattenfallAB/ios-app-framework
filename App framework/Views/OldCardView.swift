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
    var content: Content
    var contentHolder: UIKitCardView<Content>
    
    init(dismissed:@escaping ()->Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        contentHolder = UIKitCardView(dismissed: dismissed, content: self.content)
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
    var dismissed: ()->Void
    
    let content: UIView
    
    init(dismissed: @escaping ()->Void, content: Content) {
        self.content = UIHostingController(rootView: content).view
        self.dismissed = dismissed
        
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
        
        self.content.backgroundColor = .red
        
        alwaysBounceVertical = true
        backgroundColor = .clear
        clipsToBounds = false
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var firstLayout = true
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLayout {
            moveToBottom()
            firstLayout = false
        }
        content.roundCorners(corners: [.topLeft, .topRight], radius: 12.0)
    }
    
    private func moveToBottom() {
        let contentheight = content.calculatedHeight()
        if let sView = superview {
            var f = frame
            f.size.height = contentheight
            f.origin.y = sView.frame.size.height - contentheight
            frame = f
        }
    }

    
    private func outOfOffset() -> Bool {
        let contentheight = content.calculatedHeight()
        if let sView = superview {
            var f = frame
            f.size.height = contentheight
            let shouldBeY = sView.frame.size.height - contentheight
            let itIsY = frame.origin.y
            
            if itIsY - shouldBeY > 70 {
                return true
            }
        }
        
        return false
    }
    
    
    var isViewDragging = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentheight = self.content.calculatedHeight()
        
        if isViewDragging == false {
            return
        }
        if contentOffset.y < 0  || (frame.origin.y > (superview?.frame.size.height ?? 0) - contentheight) {
            print(contentOffset.y)
            var f = frame
            f.origin.y -= contentOffset.y
            frame = f
            
            
        }
    }
    //@State var isClosed = false
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //print("v: \(velocity)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isViewDragging = false
        
        
        if outOfOffset() {
            //self.isClosed = true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                let contentheight = self.content.calculatedHeight()
                if let sView = self.superview {
                    var f = self.frame
                    f.size.height = contentheight
                    f.origin.y = sView.frame.size.height + (self.superview?.superview?.safeAreaInsets.bottom ?? 0)
                    self.frame = f
                }
            }, completion: { finished in
                //if self.isClosed {
                    self.dismissed()
                //}
            })
            
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.moveToBottom()
            })
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isViewDragging = true
    }
}
