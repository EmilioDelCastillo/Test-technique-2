//
//  Assisting Extensions.swift
//  Test technique
//
//  Created by Emilio Del Castillo on 12/03/2021.
//

import Foundation

extension Optional where Wrapped == String {
    /**
     Returns "unknown" if self is nil
     */
    var safelyUnwrappedValue: String {
        if self == nil {
            return "unknown"
        }
        return self!
    }
}
