//
//  ContentView.swift
//  PixelPerfectDesignChallenge
//
//  Created by cm0620 on 2022/6/16.
//

import SwiftUI

struct ContentView: View {
    
    var totalWidth: CGFloat {
        return UIScreen.main.bounds.size.width - 20.0
    }
    var pixelWidth: CGFloat {
        return ( totalWidth - spacing ) / CGFloat(pixelCountForSide) - spacing
    }
    
    let pixelCountForSide: Int = 16
    
    @State var allColor: [Color] = Array(repeating: .white, count: 16*16)
    @State var drawingButtonTitle = "Drawing"
    @State var isDrawing = true
    var spacingButtonTitle = "Show/Hide Spacing"
    @State var spacing: CGFloat = 1
    @State var bgColor = Color(.sRGB, red: 0.0, green: 0.0, blue: 0.0)
    
    var columes: [GridItem] {
        return Array(repeating: GridItem(spacing: spacing), count: pixelCountForSide)
    }
    
    var body: some View {
        VStack{
            Text("Challenge: Pixel perfect design 16 x 16")
            HStack{
                Button(drawingButtonTitle, action: {
                    isDrawing = !isDrawing
                    drawingButtonTitle = isDrawing ? "Drawing" : "Erasing"
                })
                ColorPicker("", selection: $bgColor).labelsHidden()
                Spacer()
                Button(spacingButtonTitle, action: {
                    spacing = spacing == 1 ? 0 : 1
                }).foregroundColor(.green)
                Button("CleanAll", action: {
                    allColor = Array(repeating: .white, count: 16*16)
                }).foregroundColor(.red)
            }.padding()
            VStack{
                LazyVGrid(columns: columes, spacing: spacing){
                    ForEach(0...pixelCountForSide*pixelCountForSide-1, id: \.self) { i in
                        Rectangle()
                            .fill(allColor[i])
                            .frame(width: pixelWidth, height: pixelWidth, alignment: .center)
                    }
                }
                .background(Color.gray)
                .frame(width: totalWidth, height: totalWidth, alignment: .center)
                .gesture(drag)
            }.padding(5.0)
            .background(Color.gray)
        }
    }
    
    /// 拖拉手勢
    var drag: some Gesture {
        DragGesture(minimumDistance: 0.1)
            .onChanged { value in
                if let drawIndex = locationToIndex(location: value.location),
                    self.allColor.indices.contains(drawIndex){
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.allColor[drawIndex] = isDrawing ? bgColor : .white
                    }
                }
            }
            .onEnded { _ in }
    }
    
    /// 取得Index
    func locationToIndex(location: CGPoint) -> Int?{
        guard location.x >= 0, location.y >= 0,
            location.x < totalWidth, location.y < totalWidth else { return nil }
        let indexX = Int(location.x / (pixelWidth+spacing))
        let indexY = Int(location.y / (pixelWidth+spacing))
        return indexY * pixelCountForSide + indexX
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
