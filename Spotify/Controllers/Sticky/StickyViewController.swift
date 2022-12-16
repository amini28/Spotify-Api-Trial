//
//  StickyViewController.swift
//  Spotify
//
//  Created by Amini on 06/12/22.
//

import UIKit

public protocol StickyViewController: UITabBarController {
    var collapsedHeight: CGFloat { get set }
    var animationDuration: TimeInterval { get set }
    var childViewController: Expandable? { get }
    
    func configureCollapseableChild(_ childViewController: Expandable, isFullscreenOnFirstAppearance: Bool)
    func removeCollapsableChild(animated: Bool)
    func collapseChild()
    func expandChild()
}
