//
//  Toggle.swift
//  CircuitUI
//
//  Created by Andrii Kravchenko on 10.05.22.
//  Copyright © 2022 SumUp. All rights reserved.
//

import UIKit
#if canImport(CircuitUI_Private)

import CircuitUI_Private

final class Toggle: UISwitch {

    var onChangeHandler: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    @objc
    private func onChange(_ control: UISwitch) {
        onChangeHandler?(control.isOn)
    }

    private func commonInit() {
        onTintColor = SemanticColor.tint
        addTarget(self, action: #selector(onChange(_:)), for: .valueChanged)
    }
}

#endif
