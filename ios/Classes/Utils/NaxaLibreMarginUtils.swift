//
//  NaxaLibreMarginUtils.swift
//  naxalibre
//
//  Created by Amit on 26/09/2025.
//

import Foundation
import UIKit

/// Utility class for handling margin calculations and validation
class NaxaLibreMarginUtils {
    
    /// Validates and calculates margin offsets for UI elements
    /// - Parameters:
    ///   - left: Left margin value
    ///   - top: Top margin value  
    ///   - right: Right margin value
    ///   - bottom: Bottom margin value
    /// - Returns: A CGPoint representing the offset from default position
    /// - Throws: NSError if both horizontal or both vertical margins are set
    static func getMargins(left: Double, top: Double, right: Double, bottom: Double) throws -> CGPoint {
        // Validate that both horizontal or both vertical margins are not set
        if left != 0 && right != 0 {
            throw NSError(domain: "Cannot set both left and right margins", code: 0, userInfo: nil)
        }
        if top != 0 && bottom != 0 {
            throw NSError(domain: "Cannot set both top and bottom margins", code: 0, userInfo: nil)
        }
        
        // Calculate offset based on which margins are set
        // Horizontal: left = positive X, right = negative X
        // Vertical: top = positive Y, bottom = negative Y
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        if left != 0 {
            xOffset = CGFloat(left)
        } else if right != 0 {
            xOffset = CGFloat(right)
        }
        
        if top != 0 {
            yOffset = CGFloat(top)
        } else if bottom != 0 {
            yOffset = CGFloat(bottom)
        }
        
        return CGPoint(x: xOffset, y: yOffset)
    }
}
