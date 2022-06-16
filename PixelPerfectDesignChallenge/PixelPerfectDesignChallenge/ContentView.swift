//
//  ContentView.swift
//  PixelPerfectDesignChallenge
//
//  Created by cm0620 on 2022/6/16.
//

import SwiftUI

struct ContentView: View {
    
    var spacing: CGFloat = 1
    var pixelCount: Int = 16
    var pixelWidth: CGFloat = 20
    var totalWidth: CGFloat {
        return ( pixelWidth + spacing ) * CGFloat(pixelCount) - spacing
    }
    
    @State var allColor: [Color] = Array(repeating: .white, count: 16*16)
    
    var columes: [GridItem] = Array(repeating: GridItem(spacing: 1), count: 16)
    
    @State var buttonTitle = "Drawing"
    @State var isDrawing = true
    
    var body: some View {
        Button(buttonTitle, action: {
            isDrawing = !isDrawing
            buttonTitle = isDrawing ? "Drawing" : "Eraser"
        })
        LazyVGrid(columns: columes, spacing: 1){
            ForEach(0...pixelCount*pixelCount-1, id: \.self) { i in
                Rectangle()
                    .fill(allColor[i])
                    .frame(width: pixelWidth, height: pixelWidth, alignment: .center)
            }
        }
        .background(Color.gray)
        .frame(width: totalWidth, height: totalWidth, alignment: .center)
        .gesture(drag)
    }
    
    @State var isDragging = false

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.isDragging = true
                print("ccc l \(value.location)")
                if let drawIndex = locationToIndex(location: value.location),
                    self.allColor.indices.contains(drawIndex){
                    self.allColor[drawIndex] = isDrawing ? .black : .white
                }
            }
            .onEnded { _ in
                self.isDragging = false
                print("eee")
            }
    }
    
    func locationToIndex(location: CGPoint) -> Int?{
        guard location.x >= 0, location.y >= 0,
            location.x < totalWidth, location.y < totalWidth else { return nil }
        let indexX = Int(location.x / (pixelWidth+spacing))
        let indexY = Int(location.y / (pixelWidth+spacing))
        return indexY * pixelCount + indexX
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
