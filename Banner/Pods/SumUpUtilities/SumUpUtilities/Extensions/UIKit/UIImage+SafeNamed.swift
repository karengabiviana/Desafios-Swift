//
//  UIImage+SafeNamed.swift
//  SumUpUtilities
//
//  Created by Hagi on 25.01.19.
//  Copyright © 2019 SumUp. All rights reserved.
//

import UIKit

extension UIImage {

    /// Attempts to load the image with the given name - otherwise
    /// returns any empty instance.
    public static func safeNamed(_ name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            print("warning: image named '\(name)' not found.")
            return UIImage()
        }

        return image
    }

}
