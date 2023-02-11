//
//  Color+.swift
//  TreeArt
//
//  Created by Yuki Kuwashima on 2023/02/11.
//

import CoreGraphics
import SwiftUI
import SwiftyCreatives

extension Color {
    func tof3() -> f3 {
        guard let color = self.cgColor else {
            return f3.zero
        }
        guard let components = color.components else {
            return f3.zero
        }
        switch components.count {
        case 2:
            return f3(Float(components[0]), Float(components[0]), Float(components[0]))
        case 4:
            return f3(Float(components[0]), Float(components[1]), Float(components[2]))
        default:
            return f3.zero
        }
    }
}
