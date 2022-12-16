//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import UIKit

class TabBarViewController: UITabBarController, StickyViewController {
    
    var collapsedHeight: CGFloat = 50.0
    var animationDuration: TimeInterval = 0.5
    var childViewController: Expandable?
    
    private var collapsableViewControllerFlow: ExpandableViewController?
    
    func configureCollapseableChild(_ childViewController: Expandable, isFullscreenOnFirstAppearance: Bool) {
        
        guard collapsableViewControllerFlow == nil else { return }
        
        childViewController.loadViewIfNeeded()
        childViewController.container = self
        self.childViewController = childViewController
        collapsableViewControllerFlow = ExpandableViewController(withChild: childViewController, collapsedHeight: collapsedHeight, animationDuration: animationDuration)
        
        collapsableViewControllerFlow!.tabController = self
        view.addSubview(collapsableViewControllerFlow!.view)
        addChild(collapsableViewControllerFlow!)
        
        collapsableViewControllerFlow!.view.backgroundColor = .black.withAlphaComponent(0.8)
        
        collapsableViewControllerFlow!.view.translatesAutoresizingMaskIntoConstraints = false
        collapsableViewControllerFlow!.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collapsableViewControllerFlow!.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collapsableViewControllerFlow!.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        
        let heightConstraint = collapsableViewControllerFlow!.view.heightAnchor.constraint(equalToConstant: collapsedHeight)
        heightConstraint.isActive = true
        collapsableViewControllerFlow!.heightConstraint = heightConstraint
        
        collapsableViewControllerFlow!.didMove(toParent: self)
        
        if isFullscreenOnFirstAppearance {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.collapsableViewControllerFlow!.expand()
            }
        }
    }
    
    func removeCollapsableChild(animated: Bool) {
        guard let collapsableViewControllerFlow = collapsableViewControllerFlow else { return }
        
        if animated {
            UIView.animate(withDuration: animationDuration,
                           animations: {
                collapsableViewControllerFlow.heightConstraint.constant = 0.0
                collapsableViewControllerFlow.view.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    self.removeStickyViewController()
                }
            }
        } else {
            removeStickyViewController()
        }
    }
    
    final func collapseChild() {
        guard let collapsableViewControllerFlow = collapsableViewControllerFlow
        else { return }
        collapsableViewControllerFlow.collapse()
    }
    
    final func expandChild() {
        guard let collapsableViewControllerFlow = collapsableViewControllerFlow
        else { return }
        collapsableViewControllerFlow.expand()
    }
    
    private func removeStickyViewController() {
        guard let collapsableViewControllerFlow = collapsableViewControllerFlow
        else { return }

        collapsableViewControllerFlow.view.removeFromSuperview()
        collapsableViewControllerFlow.removeFromParent()
        
        self.collapsableViewControllerFlow = nil
        self.childViewController = nil
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .clear
        tabBar.barStyle = UIBarStyle.black
        tabBar.tintColor = .white
        
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = LibraryViewController()
        
        vc1.title = "Browse"
        vc2.title = "Search"
        vc3.title = "Library"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.navigationBar.tintColor = .white
        nav2.navigationBar.tintColor = .white
        nav3.navigationBar.tintColor = .white
        
        nav1.navigationBar.barStyle = .black
        nav2.navigationBar.barStyle = .black
        nav3.navigationBar.barStyle = .black
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 3)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3], animated: false)
        
    }
    

}
