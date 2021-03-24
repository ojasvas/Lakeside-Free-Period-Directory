//
//  Extensions.swift
//  Free Period Directory
//
//  Created by Student on 3/24/21.
//

import Foundation

struct Extensions {
    extension UITextField {
        func disableAutoFill() {
            if #available(iOS 12, *) {
                textContentType = .oneTimeCode
            } else {
                textContentType = .init(rawValue: "")
            }
        }
    }
}
