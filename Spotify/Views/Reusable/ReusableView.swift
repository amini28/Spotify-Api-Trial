//
//  ReusableView.swift
//  Spotify
//
//  Created by Amini on 09/11/22.
//

import Foundation
import UIKit

public extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)

        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
}
