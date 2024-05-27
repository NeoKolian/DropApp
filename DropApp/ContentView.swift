//
//  ContentView.swift
//  DropApp
//
//  Created by Nikolay Pochekuev on 27.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGSize = .zero

    let innerColor = Color("Gradient1")
    let outerColor = Color("Gradient2")
    
    private let diam = 150.0
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
    
    private var initialX: Double {
        deviceWidth / 2.0
    }
    private var initialY: Double {
        deviceHeight / 2.0
    }
    
    var body: some View {
        Rectangle()
            .fill(theGradient)
            .mask {
                Canvas { context, size in
                    let circle0 = context.resolveSymbol(id: 0)!
                    let circle1 = context.resolveSymbol(id: 1)!
                    
                    context.addFilter(.alphaThreshold(min: 0.7, color: Color.yellow))
                    context.addFilter(.blur(radius: 25))
                    
                    context.drawLayer { ct in
                        ct.draw(circle0, at: CGPoint(x: initialX, y: initialY))
                        ct.draw(circle1, at: CGPoint(x: initialX, y: initialY))
                    }
                } symbols: {
                    ZStack {
                        
                    }
                    Circle()
                        .frame(width: diam, height: diam)
                        .offset(x: offset.width, y: offset.height)
                        .tag(0)
                    Circle()
                        .frame(width: diam, height: diam)
                        .tag(1)
                }
            }
            .overlay {
                Image(systemName: "cloud.sun.rain.fill")
                    .font(.largeTitle)
                    .offset(x: offset.width, y: offset.height)
                    .foregroundStyle(.white)
            }
            .gesture (
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.bouncy) {
                            offset = .zero
                        }
                    }
            )
            .preferredColorScheme(.dark)
            .ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var theGradient: RadialGradient {
        .init(gradient: .init(colors: [innerColor, outerColor]),
              center: .center,
              startRadius: diam / 2,
              endRadius: diam)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
