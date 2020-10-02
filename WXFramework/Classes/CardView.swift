//
//  OldCardView.swift
//  App framework
//
//  Created by Artur Gurgul on 11/09/2020.
//  Copyright © 2020 Winux-ORG. All rights reserved.
//


import UIKit
import SwiftUI


private let thereshold = CGFloat(30)
private let closingSpeed = CGFloat(400)

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
        ScrollView {
         VStack {
            ForEach(1..<100) {_ in
                    Text("Example very long list")
            }
        }
        }.edgesIgnoringSafeArea(.leading)
            //}
        //}.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


public enum CardType {
    case error(title: String)
    case list
    case any(view: AnyView?, openedHeight: CGFloat)
    case blocking(view: AnyView?)
    case none
}

struct CardView<Content: View>: UIViewControllerRepresentable {
    
    @Binding var cardType: CardType
    
    var content: () -> Content
    
    init(cardType: Binding<CardType>, @ViewBuilder content: @escaping () -> Content) {
        self._cardType = cardType
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> CardHolderViewController<Content> {
        let holerViewController = CardHolderViewController(cardType: $cardType,rootView: content())
        holerViewController.view.clipsToBounds = true
        return holerViewController
    }
    
    func updateUIViewController(_ viewController: CardHolderViewController<Content>, context: Context) {
        viewController.rootView = self.content()
        
        switch cardType {
        case .error(let title):
            viewController.show(view: errorView(title: title), full: false)
        case .list:
            viewController.show(view:list() ,full: true)
        case .any(let view, let openedHeight):
            viewController.show(view:view ,full: true, openedHeight: openedHeight)
        case .blocking(let view):
            viewController.show(view:view ,full: false)
        case .none:
            break
//        default:
//            break
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
        return systemLayoutSizeFitting(CGSize(width: frame.size.width /* 375 */, height: 40)).height
    }
}


public extension View {
    func cardType(isFixedHeight: Bool = true, isBlocking: Bool = false, isFullScreen: Bool = false, openedHeight: CGFloat = 100) -> CardType {
        if isFullScreen {
            return .any(view: AnyView(self), openedHeight: openedHeight)
        }
        return .blocking(view: AnyView(self))
    }
}


class CardHolderViewController<Content>: UIViewController where Content: View {
    
    @Binding var cardType: CardType
    
    private let hostingViewController: UIHostingController<Content>
    private var scrollView: CardScrollView?
    init(cardType: Binding<CardType>, rootView: Content) {
        hostingViewController = UIHostingController(rootView: rootView)
        scrollView = nil
        self.rootView = rootView
        self._cardType = cardType
        
        super.init(nibName: nil, bundle: nil)
        
        addChild(hostingViewController)
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
    
    func show<V>(view: V, full: Bool, openedHeight: CGFloat = 100) where V: View {
        scrollView?.removeFromSuperview()
        if full {
            scrollView = UIKitFullScreenCardView(cardType: $cardType, content: view, openedHeight: openedHeight)
            
        } else {
            scrollView = UIKitCardView(cardType: $cardType, content: view)
        }
        
        self.view.addSubview(scrollView!)
        
        scrollView?.contentSize = CGSize(width: 1000, height: 1000)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.scrollView?.open()

        
    }
//
//    var didAppear = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if didAppear == false {
//
//            didAppear = true
//        }
       // print ("view did loaded")
    }
}

protocol CardScrollView: UIScrollView {
    func open()
}

class UIKitCardView<Content>: UIScrollView, CardScrollView, UIScrollViewDelegate where Content : View {
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
    
    let bottomLayer = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newFrame = CGRect(x: 0, y: content.frame.size.height, width: content.frame.size.width, height: 1000)
        
        
        if newFrame != bottomLayer.frame {
            content.roundCorners(corners: [.topLeft, .topRight], radius: 12.0)
            bottomLayer.frame = newFrame
        }
        
        //print("layouted")
    }
    
    func open() {
       // print("opened")
        moveToClosed()
        
//        setNeedsLayout()
//        layoutIfNeeded()
        
        
//
//
//        print(content.frame.size.width)
//        print(frame.size.width)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.moveToBottom()
        })
    }

    private func moveToClosed() {
        let contentheight = middleHeight()
        
        if let sView = superview {
            var f = frame
            f.size.height = contentheight
            f.size.width = sView.frame.size.width
            f.origin.y = sView.frame.size.height
            frame = f
        }
    }
    
    private func moveToBottom() {
        if let sView = superview {
            // First execution forces layout or something, without this line middleHeight returns worng height
            content.systemLayoutSizeFitting(CGSize(width: frame.size.width, height: 40)).height
            let contentheight = middleHeight()
            
            var f = frame
            f.size.height = contentheight
            f.size.width = sView.frame.size.width
            
            f.origin.y = sView.frame.size.height - contentheight  - (self.superview?.superview?.safeAreaInsets.bottom ?? 0)
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
            
        }
        
        let date = Date()
        offsetReads.append((date: date, offset: frame.origin.y))
        //print(date)
        
        if offsetReads.count > 40 {
            offsetReads.removeFirst()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isViewDragging = false
        let currentDate = Date()
        //print(currentDate)
        let revelentTimestamps = offsetReads.filter{abs($0.date.timeIntervalSince1970 - currentDate.timeIntervalSince1970)<0.1}
        
        
        offsetReads = []
        
        let speed: CGFloat
        if let firstTimestamp = revelentTimestamps.first {
            let t = abs(firstTimestamp.date.timeIntervalSince1970 - currentDate.timeIntervalSince1970)
            let s = frame.origin.y - firstTimestamp.offset
            speed = s/CGFloat(t)
        } else {
            speed = 0
        }
        
        //print("Ended with speed: \(speed)")
        cardWillEndDragging(with: speed, targetContentOffset: targetContentOffset)
    }
    
    func cardWillEndDragging(with speed: CGFloat, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if outOfOffset() || abs(speed) > closingSpeed {
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
        
        let date = Date()
        offsetReads.append((date: date, offset: frame.origin.y))
    }
}


class UIKitFullScreenCardView<Content>: UIKitCardView<Content> where Content: View {
    let openedHeight: CGFloat
    private var viewState = ViewState.middle
    override func middleHeight() -> CGFloat { openedHeight }
    enum ViewState {case willClose, fullScreen, middle}
    
    private enum ViewNextState{case same, up, down}
    
    private func nextThereshold() -> ViewState {
        if let sView = superview {
            let shouldBeY: CGFloat
            switch viewState {
            case .fullScreen:
                shouldBeY = topSpace()
            case .middle:
                shouldBeY = sView.frame.size.height - openedHeight
            default:
                shouldBeY = sView.frame.size.height
            }
            
            let itIsY = frame.origin.y
            
            let next: ViewNextState
            
            
            if  shouldBeY - itIsY > thereshold {
                next = .up
            } else if shouldBeY - itIsY < -1 * thereshold {
                next = .down
            } else {
                next = .same
            }
            
            switch viewState {
            case .fullScreen:
                if next == .down {
                    return .middle
                }
            case .middle:
                if next == .down {
                    return .willClose
                } else if next == .up {
                    return .fullScreen
                }
            default:
                break
            }
        }

        return viewState
    }
    
    init(cardType: Binding<CardType>, content: Content, openedHeight: CGFloat) {
        self.openedHeight = openedHeight
        super.init(cardType: cardType, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cardWillEndDragging(with speed: CGFloat, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let nextViewState = nextThereshold()
        
        if nextViewState == .fullScreen || ((viewState == .middle) && (speed < -closingSpeed)) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                if let sView = self.superview {
                    var f = self.frame
                    f.size.height = sView.frame.size.height - self.topSpace()
                    f.origin.y = self.topSpace()
                    self.frame = f
                }
            })
        } else if nextViewState == .willClose || ((viewState == .middle) && (speed > closingSpeed)) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                if let sView = self.superview {
                    var f = self.frame
                    f.origin.y = sView.frame.size.height + (self.superview?.superview?.safeAreaInsets.bottom ?? 0)
                    self.frame = f
                }
            }, completion: { finished in
                self.cardType = .none
                self.removeFromSuperview()
            })
        } else if nextViewState == .middle || ((viewState == .fullScreen) && speed > closingSpeed) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                if let sView = self.superview {
                    var f = self.frame
                    f.origin.y = sView.frame.size.height - self.openedHeight
                    f.size.height = sView.frame.size.height
                    self.frame = f
                }
            })
        }
        
        
        if viewState != .fullScreen {
            targetContentOffset.pointee = CGPoint(x: 0, y: 0)
        }
        
        viewState = nextViewState
        
        if viewState != .fullScreen {
            showsVerticalScrollIndicator = false
        } else {
            showsVerticalScrollIndicator = true
        }
    }
    
    override func cardDidScroll() {
        let contentheight = middleHeight()
        if (contentOffset.y < 0  || frame.origin.y > topSpace()) {
            var f = frame
            f.origin.y -= contentOffset.y
            frame = f

            contentOffset.y = 0
            
        }
        
        offsetReads.append((date: Date(), offset: frame.origin.y))

        if offsetReads.count > 40 {
            offsetReads.removeFirst()
        }
    }
    
    func topSpace() -> CGFloat {
        return 50
    }
}
