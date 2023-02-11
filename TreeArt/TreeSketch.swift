//
//  TreeSketch.swift
//  TreeArt
//
//  Created by Yuki Kuwashima on 2023/02/11.
//

import SwiftyCreatives
import CoreGraphics
import AppKit

final class TreeSketch: Sketch {
    
    var tipBoxColor: f3 = f3(1.0, 0.2, 0.7)
    var tipBoxScale: Float = 0.15
    var lineWidth: Float = 0.1
    var branchTipColor: f3 = f3(1.0, 0.3, 1.0)
    var lineColor: f3 = f3(1.0, 1.0, 1.0)
    var zPlus: Float = 0.3
    var zMinus: Float = -0.3
    var yPlus: Float = 0.15
    var yMinus: Float = -0.15
    var growGene: String = "FyF+[+FyF-yPA]-[-yF+YPA]"
    
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
            box(0, 0, 0, 0.3, 0.3, 0.3)
            popMatrix()
            
            pushMatrix()
            rotateY(currentRotation[i])
            for _ in 0..<10 {
                rotateY(-speeds[i] * 20)
                pushMatrix()
                translate(Float(i + 2) * 2, 0, 0)
                box(0, 0, 0, 0.15, 0.15, 0.15)
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
            color(tipBoxColor.x, tipBoxColor.y, tipBoxColor.z, 1.0)
            box(0, 0, 0, tipBoxScale, tipBoxScale, tipBoxScale)
        case "P":
            color(branchTipColor.x, branchTipColor.y, branchTipColor.z, 1.0)
            boldline(0, 0, 0, 0, 1, 0, width: lineWidth)
            translate(0, 1, 0)
        case "F":
            color(lineColor.x, lineColor.y, lineColor.z, 0.8)
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
