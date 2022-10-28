//
//  CUIViewController.swift
//  CircuitUI
//
//  Created by Illia Lukisha on 18/05/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

import UIKit

/// This class is required by Merchant app. We need to handle orientation support in each controller instead of
/// making this setting app wide.
@objc(CUIViewController)
open class ViewController: UIViewController {

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        traitCollection.userInterfaceIdiom == .pad ? .all : .portrait
    }

    public private(set) var isVisible = false

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }

    override open func viewWillDisappear(_ animated: Bool) {
        isVisible = false
        super.viewWillDisappear(animated)
    }
}

/// This class is required by Merchant app. We need to handle orientation support in each controller instead of
/// making this setting app wide.
@objc(CUITableViewController)
open class TableViewController: UITableViewController {

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        traitCollection.userInterfaceIdiom == .pad ? .all : .portrait
    }
}

/// This class is required by Merchant app. We need to handle orientation support in each controller instead of
/// making this setting app wide.
@objc(CUICollectionViewController)
open class CollectionViewController: UICollectionViewController {

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        traitCollection.userInterfaceIdiom == .pad ? .all : .portrait
    }
}
