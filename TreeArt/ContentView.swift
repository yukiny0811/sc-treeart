//
//  ContentView.swift
//  TreeArt
//
//  Created by Yuki Kuwashima on 2023/02/11.
//

import SwiftUI
import SwiftyCreatives
import Combine

class TreeViewModel: ObservableObject {
    
    let sketch = TreeSketch()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var tipBoxColor: Color = Color(cgColor: CGColor(red: 1.0, green: 0.2, blue: 0.7, alpha: 1.0))
    @Published var tipBoxScale: Float = 0.15
    @Published var lineWidth: Float = 0.1
    @Published var branchTipColor: Color = Color(cgColor: CGColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1.0))
    @Published var lineColor: Color = Color(cgColor: CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    @Published var zPlus: Float = 0.3
    @Published var zMinus: Float = -0.3
    @Published var yPlus: Float = 0.15
    @Published var yMinus: Float = -0.15
    @Published var growGene: String = ""
    
    init() {
        $tipBoxColor.sink { [self] value in
            sketch.tipBoxColor = value.tof3()
        }.store(in: &cancellables)
        
        $tipBoxScale.sink { [self] value in
            sketch.tipBoxScale = value
        }.store(in: &cancellables)
        
        $lineWidth.sink { [self] value in
            sketch.lineWidth = value
        }.store(in: &cancellables)
        
        $branchTipColor.sink { [self] value in
            sketch.branchTipColor = value.tof3()
        }.store(in: &cancellables)
        
        $lineColor.sink { [self] value in
            sketch.lineColor = value.tof3()
        }.store(in: &cancellables)
        
        $zPlus.sink { [self] value in
            sketch.zPlus = value
        }.store(in: &cancellables)
        
        $zMinus.sink { [self] value in
            sketch.zMinus = value
        }.store(in: &cancellables)
        
        $yPlus.sink { [self] value in
            sketch.yPlus = value
        }.store(in: &cancellables)
        
        $yMinus.sink { [self] value in
            sketch.yMinus = value
        }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = TreeViewModel()
    var body: some View {
        HStack {
            SketchView<MainCameraConfig, MainDrawConfig>(viewModel.sketch)
            VStack(alignment: .leading) {
                Group {
                    Text("Tree Designer").font(.largeTitle)
                    ColorPicker("Tip Box Color", selection: $viewModel.tipBoxColor)
                    Slider(value: $viewModel.tipBoxScale, in: 0...1) { Text("Tip Box Scale") }
                    Slider(value: $viewModel.lineWidth, in: 0...1) { Text("Line Width") }
                    ColorPicker("Branch Tip Color", selection: $viewModel.branchTipColor)
                    ColorPicker("Line Color", selection: $viewModel.lineColor)
                    Slider(value: $viewModel.zPlus, in: 0...1) { Text("Z+") }
                    Slider(value: $viewModel.zMinus, in: -1...0) { Text("Z-") }
                    Slider(value: $viewModel.yPlus, in: 0...1) { Text("Y+") }
                    Slider(value: $viewModel.yMinus, in: -1...0) { Text("Y-") }
                }
                HStack {
                    TextField("Gene", text: $viewModel.growGene)
                    Button("Update") {
                        viewModel.sketch.growGene = viewModel.growGene
                        viewModel.sketch.reset()
                    }
                }
            }
            .frame(width: 400)
            .padding(30)
        }
        .background(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
