//
//  OldCardView.swift
//  App framework
//
//  Created by Artur Gurgul on 11/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//


import UIKit
import SwiftUI


extension CardView {
    func errorView(title:String) -> some View {
        VStack {
            Text("Title : \(title)").font(.headline).padding(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 0))
            Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
            Text("Your content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\nYour content herasd vasiv aoif vhaoi fvha fvh aifpv haioud vfahdfadhfadf adf asdfe\n")
        }
    }
    
    func list() -> some View {
        //List {
          //  ForEach(1..<100) {_ in
                Text("Example very long list")
            //}
        //}.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


enum CardType {
    case error(title: String)
    case list
    case any(view: AnyView)
    case none
    /*
    func create()-> some View {
        switch self {
        case .none:
            return EmptyView()
        default:
            return Text("")
        }
    }*/
}

class CardState: ObservableObject {
    @Published var cardType: CardType = .none
}

struct CardView<Content: View>: UIViewControllerRepresentable {
    
    @Binding var cardType: CardType
    
    var content: () -> Content
    
    
    init(cardType: Binding<CardType>, @ViewBuilder content: @escaping () -> Content) {
        self._cardType = cardType
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> CardHolderViewController<Content> {
        return CardHolderViewController(cardType: $cardType,rootView: content())
    }
    
    func updateUIViewController(_ viewController: CardHolderViewController<Content>, context: Context) {
        viewController.rootView = self.content()
        
        
        switch cardType {
        case .error(let title):
            viewController.show(view: errorView(title: title), full: false)
        case .list:
            viewController.show(view:list() ,full: true)
        case .none, .any:
            break
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
    
    func addView(view: UIView) {
        addSubview(view)
        
        
        let views: [String: UIView] = ["contentView": view]
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var allConstraints = [NSLayoutConstraint]()
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[contentView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += vertical
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[contentView]-(0)-|", options: [], metrics: nil, views: views)
        allConstraints += horizontal
        NSLayoutConstraint.activate(allConstraints)
    }
}

extension UIView {
    func calculatedHeight() -> CGFloat {
        return systemLayoutSizeFitting(CGSize(width: frame.size.width, height: 40)).height
    }
}

class CardHolderViewController<Content>: UIViewController where Content: View {
    
    @Binding var cardType: CardType
    
    private let hostingViewController: UIHostingController<Content>
    private var scrollView: UIScrollView?
    init(cardType: Binding<CardType>, rootView: Content) {
        hostingViewController = UIHostingController(rootView: rootView)
        scrollView = nil
        self.rootView = rootView
        self._cardType = cardType
        
        super.init(nibName: nil, bundle: nil)
        
        addChildViewController(hostingViewController)
        view.addView(view: hostingViewController.view)
        hostingViewController.didMove(toParent: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rootView: Content {
        didSet {
            hostingViewController.rootView = rootView
        }
    }
    
    func show<V>(view: V, full: Bool) where V: View {
        scrollView?.removeFromSuperview()
        if full {
            scrollView = UIKitFullScreenCardView(cardType: $cardType, content: view, openedHeight: 100)
            
        } else {
            scrollView = UIKitCardView(cardType: $cardType, content: view)
        }
        self.view.addView(view: scrollView!)
    }
}

class UIKitCardView<Content>: UIScrollView, UIScrollViewDelegate where Content : View {
    //var dismissed: ()->Void
    func middleHeight() -> CGFloat { content.calculatedHeight() }
    
    @Binding var cardType: CardType
    
    let content: UIView
    
    init(cardType: Binding<CardType>, content: Content) {
        self.content = UIHostingController(rootView: content).view
        //self.dismissed = dismissed
        self._cardType = cardType
        
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
        
        alwaysBounceVertical = true
        backgroundColor = .clear
        clipsToBounds = false
        delegate = self
        
        bottomLayer.backgroundColor = self.content.backgroundColor?.cgColor
        layer.addSublayer(bottomLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var firstLayout = true
    
    let bottomLayer = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLayout {
            moveToClosed()
            
            firstLayout = false
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.moveToBottom()
            })
            
        }
        content.roundCorners(corners: [.topLeft, .topRight], radius: 12.0)
        bottomLayer.frame = CGRect(x: 0, y: content.frame.size.height, width: content.frame.size.width, height: 1000)
        
    }

    private func moveToClosed() {
        let contentheight = middleHeight()
        if let sView = superview {
            var f = frame
            f.size.height = contentheight
            f.origin.y = sView.frame.size.height
            frame = f
        }
    }
    
    private func moveToBottom() {
        let contentheight = middleHeight()
        if let sView = superview {
            var f = frame
            f.size.height = contentheight
            f.origin.y = sView.frame.size.height - contentheight
            frame = f
        }
    }

    
    private func outOfOffset() -> Bool {
        let contentheight = middleHeight()
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
    
    var offsetReads: [(date: Date, offset:CGFloat)] = []
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isViewDragging == false {
            return
        }
        cardDidScroll()
    }
    
    func cardDidScroll() {
        let contentheight = self.middleHeight()
        if contentOffset.y < 0  || (frame.origin.y > (superview?.frame.size.height ?? 0) - contentheight) {
            var f = frame
            f.origin.y -= contentOffset.y
            frame = f
            
            offsetReads.append((date: Date(), offset: frame.origin.y))
            
            if offsetReads.count > 40 {
                offsetReads.removeFirst()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isViewDragging = false
        
        let currentDate = Date()
        let revelentTimestamps = offsetReads.filter{abs($0.date.timeIntervalSince1970 - currentDate.timeIntervalSince1970)<0.1}
        
        let speed: CGFloat
        if let firstTimestamp = revelentTimestamps.first, let lastTimestamp = revelentTimestamps.last, firstTimestamp != lastTimestamp {
            let t = abs(firstTimestamp.date.timeIntervalSince1970 - lastTimestamp.date.timeIntervalSince1970)
            let s = abs(firstTimestamp.offset - lastTimestamp.offset)
            speed = s/CGFloat(t)
        } else {
            speed = 0
        }
        
        cardDidEndDragging(with: speed)
    }
    func cardDidEndDragging(with speed: CGFloat) {
        if outOfOffset() || speed > 800 {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                let contentheight = self.middleHeight()
                if let sView = self.superview {
                    var f = self.frame
                    f.size.height = contentheight
                    f.origin.y = sView.frame.size.height + (self.superview?.superview?.safeAreaInsets.bottom ?? 0)
                    self.frame = f
                }
            }, completion: { finished in
                    //self.dismissed()
                self.cardType = .none
                self.removeFromSuperview()
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


class UIKitFullScreenCardView<Content>: UIKitCardView<Content> where Content: View {
    let openedHeight: CGFloat
    
    override func middleHeight() -> CGFloat {
        openedHeight
        
    }
    
    private func exceedThereshold() -> Bool {
        let contentheight = middleHeight()
        if let sView = superview {
            let shouldBeY = sView.frame.size.height - openedHeight
            let itIsY = frame.origin.y
            
            if itIsY - shouldBeY > 70 {
                return true
            }
        }
        
        return false
    }
    
    init(cardType: Binding<CardType>, content: Content, openedHeight: CGFloat) {
        self.openedHeight = openedHeight
        super.init(cardType: cardType, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    override func cardDidEndDragging(with speed: CGFloat) {
        
        // where is closer to
        if exceedThereshold() || speed > 800 {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                let contentheight = self.content.calculatedHeight()
                if let sView = self.superview {
                    var f = self.frame
                    f.size.height = contentheight
                    f.origin.y = sView.frame.size.height + (self.superview?.superview?.safeAreaInsets.bottom ?? 0)
                    self.frame = f
                }
            }, completion: { finished in
                    //self.dismissed()
                self.cardType = .none
                self.removeFromSuperview()
            })
            
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.moveToBottom()
            })
        }
    } */
    
    override func cardDidScroll() {
        let contentheight = self.content.calculatedHeight()
        if contentOffset.y < 0  || frame.origin.y > 0  {
            var f = frame
            f.origin.y -= contentOffset.y
            frame = f

            offsetReads.append((date: Date(), offset: frame.origin.y))

            if offsetReads.count > 40 {
                offsetReads.removeFirst()
            }
        }
    }
}
