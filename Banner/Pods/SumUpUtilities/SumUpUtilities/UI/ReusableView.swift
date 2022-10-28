//
//  ReusableView.swift
//  SumUpUtilities
//
//  Created by Florian Schliep on 17.09.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

import UIKit

/// A kind of view that can reused in a table or collection view.
/// Intended for registering and dequeuing views using the methods below.
public protocol ReusableView { }

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        String(describing: self)
    }

    static var nibName: String {
        reuseIdentifier
    }
}

// MARK: - UITableView

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }

public extension UITableView {
    func registerNib<T: UITableViewCell>(_: T.Type, inBundle bundle: Bundle? = nil, forIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    func registerClass<T: UITableViewCell>(_: T.Type, forIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }

    func registerNib<T: UITableViewHeaderFooterView>(_: T.Type, forHeaderFooterViewReuseIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    func registerClass<T: UITableViewHeaderFooterView>(_: T.Type, forHeaderFooterViewReuseIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return T()
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            assertionFailure("Could not dequeue header footer view with identifier: \(T.reuseIdentifier)")
            return T()
        }
        return view
    }
}

// MARK: - UICollectionView

extension UICollectionReusableView: ReusableView { }

public extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_: T.Type, forIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func registerClass<T: UICollectionViewCell>(_: T.Type, forIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return T()
        }
        return cell
    }
}
