//
//  ExpandableViewController.swift
//  Spotify
//
//  Created by Amini on 06/12/22.
//

import UIKit

public protocol Expandable: UIViewController {
    var minimisedView: UIView { get }
    var container: StickyViewController? { get set }
}

public extension Expandable {
    weak var container: StickyViewController? {
        get { tabBarController as? StickyViewController }
        
        set {}
    }
}

class ExpandableViewController: UIViewController {
    
    var heightConstraint: NSLayoutConstraint!
    var isEnlarged = false
    
    weak var tabController: StickyViewController?
    
    let deviceHeight: CGFloat = UIScreen.main.bounds.height
    
    var collapsedHeight: CGFloat
    var animationDuration: TimeInterval
    
    private var minimisedView: UIView
    private let childViewController: Expandable
    
    lazy var isBeginningUpWards = !isEnlarged
    var runningAnimation: UIViewPropertyAnimator?
    var animationProgressWhenInterrupted: CGFloat = 0
    
    init(withChild childViewController: Expandable, collapsedHeight: CGFloat, animationDuration: TimeInterval) {
        self.childViewController = childViewController
        self.collapsedHeight = collapsedHeight
        self.animationDuration = animationDuration
        self.minimisedView = childViewController.minimisedView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enlargedWithTap))
        minimisedView.addGestureRecognizer(gestureRecognizer)
        
        let panGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        view.clipsToBounds = true
        configureChildViewController()
    }
    
    private func configureChildViewController() {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.didMove(toParent: self)
    }
    
    func expand() {
        animateTransitionIfNeeded(isEnlarging: true, duration: animationDuration)
    }
    
    func collapse() {
        animateTransitionIfNeeded(isEnlarging: false, duration: animationDuration)
    }
    
    @objc private func enlargedWithTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(isEnlarging: !isEnlarged, duration: animationDuration)
        default:
            break
        }
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let velocity = recognizer.velocity(in: childViewController.view)
            isBeginningUpWards = isDirectionUpwards(for: velocity)
            startInteractivateTransition(isEnlarging: !isEnlarged, duration: animationDuration)
            
        case .changed:
            let velocity = recognizer.velocity(in: childViewController.view)
            isBeginningUpWards = isDirectionUpwards(for: velocity)
            
            let translation = recognizer.translation(in: childViewController.view)
            var fractionComplete = translation.y / deviceHeight
            fractionComplete = isEnlarged ? fractionComplete : -fractionComplete
            
            if runningAnimation?.isReversed ?? false {
                fractionComplete = -fractionComplete
            }
            
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
        case .ended:
            continueInteractiveTransition(isReversed: shouldReverseAnimation())
            
        default: break
        }
    }
    
    private func shouldReverseAnimation() -> Bool {
        if isEnlarged && isBeginningUpWards {
            return true
        } else if !isEnlarged && isBeginningUpWards {
            return true
        }
        return false
    }
    
    private func isDirectionUpwards(for velocity: CGPoint) -> Bool {
        return velocity.y > 0
    }
    
    private func animateTransitionIfNeeded(isEnlarging: Bool, duration: TimeInterval) {
        guard runningAnimation == nil,
              let tabController = tabController,
              self.isEnlarged != isEnlarging
        else { return }
        
        runningAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            if isEnlarging {
                self.heightConstraint.constant = self.deviceHeight - tabController.tabBar.frame.height
                self.minimisedView.alpha = 0.0
                tabController.hidesBottomBarWhenPushed = true
            } else {
                self.heightConstraint.constant = self.collapsedHeight
                self.minimisedView.alpha = 1.0
            }
            
            self.view.setNeedsLayout()
            tabController.view.setNeedsLayout()
            
            self.view.layoutIfNeeded()
            tabController.view.layoutIfNeeded()
        }
        
        runningAnimation?.addCompletion { (position) in
            switch position {
            case .end:
                self.isEnlarged = !self.isEnlarged
            default:
                ()
            }
            self.runningAnimation = nil
        }
        
        runningAnimation?.startAnimation()
    }
    
    private func startInteractivateTransition(isEnlarging: Bool, duration: TimeInterval) {
        animateTransitionIfNeeded(isEnlarging: isEnlarging, duration: duration)
        runningAnimation?.pauseAnimation()
        animationProgressWhenInterrupted = runningAnimation?.fractionComplete ?? 0.0
    }
    
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        runningAnimation?.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
    }
    
    private func continueInteractiveTransition(isReversed: Bool) {
        runningAnimation?.isReversed = isReversed
        runningAnimation?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
}
