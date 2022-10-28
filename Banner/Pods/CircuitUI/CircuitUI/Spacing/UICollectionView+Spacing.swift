//
//  UICollectionView+Spacing.swift
//  CircuitUI
//
//  Created by Marcel Voß on 06.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public extension NSCollectionLayoutSpacing {
    class func fixed(_ spacing: Spacing) -> Self {
        .fixed(spacing.rawValue)
    }

    class func flexible(_ spacing: Spacing) -> Self {
        .flexible(spacing.rawValue)
    }
}

@available(iOS 13.0, *)
public extension NSCollectionLayoutSection {
    func setIntergroupSpacing(_ spacing: Spacing) {
        interGroupSpacing = spacing.rawValue
    }
}

public extension UICollectionViewFlowLayout {
    func setMinimumLineSpacing(_ spacing: Spacing) {
        minimumLineSpacing = spacing.rawValue
    }

    func setMinimumInteritemSpacing(_ spacing: Spacing) {
        minimumInteritemSpacing = spacing.rawValue
    }
}
