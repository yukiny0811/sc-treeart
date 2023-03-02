//
//  TreeSketch.swift
//  TreeArt
//
//  Created by Yuki Kuwashima on 2023/02/11.
//

import SwiftyCreatives
import CoreGraphics
import AppKit
import Combine
import SwiftUI

final class TreeSketch: Sketch, ObservableObject {
    
    @Published var tipBoxColor: Color = Color(cgColor: CGColor(red: 1.0, green: 0.2, blue: 0.7, alpha: 1.0))
    @Published var tipBoxScale: Float = 0.15
    @Published var lineWidth: Float = 0.1
    @Published var branchTipColor: Color = Color(cgColor: CGColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
    @Published var lineColor: Color = Color(cgColor: CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    @Published var zPlus: Float = 0.3
    @Published var zMinus: Float = -0.3
    @Published var yPlus: Float = 0.15
    @Published var yMinus: Float = -0.15
    @Published var growGene: String = "FyF+[+FyF-yPA]-[-yF+YPA]"
    
    var tipBoxColorf3: f3 { tipBoxColor.tof3() }
    var branchTipColorf3: f3 { branchTipColor.tof3() }
    var lineColorf3: f3 { lineColor.tof3() }
    
    private var tree = "F"
    private var speeds: [Float] = [0.01, -0.015, 0.004, 0.008, -0.02]
    private var currentRotation: [Float] = [0, 0, 0, 0, 0]
    
    override init() {
        super.init()
        for _ in 0..<4 {
            grow()
        }
    }
    
    override func setupCamera(camera: some MainCameraBase) {
        camera.setTranslate(0, -20, -40)
    }
    
    override func update(camera: some MainCameraBase) {
        camera.rotateAroundY(0.01)
    }
    
    override func draw(encoder: SCEncoder) {
        pushMatrix()
        for i in 0..<speeds.count {
            pushMatrix()
            currentRotation[i] += speeds[i]
            rotateY(currentRotation[i])
            translate(Float(i + 2) * 2, 0, 0)
            color(1.0, 0.8, 1.0, 1.0)
            box(0.3, 0.3, 0.3)
            popMatrix()
            
            pushMatrix()
            rotateY(currentRotation[i])
            for _ in 0..<10 {
                rotateY(-speeds[i] * 20)
                pushMatrix()
                translate(Float(i + 2) * 2, 0, 0)
                box(0.15, 0.15, 0.15)
                popMatrix()
            }
            popMatrix()
        }
        popMatrix()
        for t in tree {
            compile(char: t)
        }
    }
    
    func reset() {
        tree = "F"
        for _ in 0..<4 {
            grow()
        }
    }
    
    func grow() {
        var currentTree = ""
        for t in tree {
            if t == "F" {
                currentTree += growGene
            } else {
                currentTree += String(t)
            }
        }
        tree = currentTree
    }
    
    func compile(char: Character) {
        switch char {
        case "A":
            color(tipBoxColorf3, alpha: 1.0)
            box(tipBoxScale, tipBoxScale, tipBoxScale)
        case "P":
            color(branchTipColorf3, alpha: 1.0)
            boldline(0, 0, 0, 0, 1, 0, width: lineWidth)
            translate(0, 1, 0)
        case "F":
            color(lineColorf3, alpha: 0.8)
            boldline(0, 0, 0, 0, 1, 0, width: lineWidth)
            translate(0, 1, 0)
        case "+":
            rotateZ(zPlus)
        case "-":
            rotateZ(zMinus)
        case "[":
            pushMatrix()
        case "]":
            popMatrix()
        case "y":
            rotateY(yPlus)
        case "Y":
            rotateY(yMinus)
        default:
            break
        }
    }
}
