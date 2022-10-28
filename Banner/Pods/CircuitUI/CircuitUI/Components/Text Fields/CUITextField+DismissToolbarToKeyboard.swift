//
//  CUITextField+DismissToolbarToKeyboard.swift
//  CircuitUI
//
//  Created by Gerald.Wood on 8/25/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import Foundation

public extension TextField {
    /// Adds a `inputAccessoryView` containing a system `.done` button, which will dismiss the keyboard for the given `TextField`.
    func addDismissToolbarToKeyboard() {
        let doneToolbar = UIToolbar(frame: .zero)
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))

        let items = [flexSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        keyboardAccessoryView = doneToolbar
    }

    @objc private func doneButtonAction() {
        resignFirstResponder()
    }
}
