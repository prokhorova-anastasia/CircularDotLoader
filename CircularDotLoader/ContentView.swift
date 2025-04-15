//
//  ContentView.swift
//  CircularDotLoader
//
//  Created by Anastasiia Prokhorova on 15.04.25.
//

import SwiftUI

struct ContentView: View {
    private let dotCount = 6
    private let dotCounrDouble: Double = 6
    private let dotSize: CGFloat = 8
    private let radius: CGFloat = 50
    private let cycleDuration: Double = 4.0
    
    private let ascendEnd: Double   = 0.4
    private let downStart: Double   = 0.6
    private let queueSpread: Double = 0.15
    
    @State private var startDate = Date()
    
    var body: some View {
        let ascendSpacing  = ascendEnd / dotCounrDouble
        let descentSpacing = (1 - downStart) / dotCounrDouble
        let plateauEnd     = 0.5 + queueSpread/2
        let plateauSpacing = queueSpread / (dotCounrDouble - 1)
        
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let t = (elapsed.truncatingRemainder(dividingBy: cycleDuration)) / cycleDuration
            
            ZStack {
                ForEach(0..<dotCount, id: \.self) { i in
                    let ascendStart  = Double(i) * ascendSpacing
                    let ascendEnd_i  = ascendStart + ascendSpacing
                    let descentStart = downStart + Double(i) * descentSpacing
                    let descentEnd   = descentStart + descentSpacing
                    let plateauPos   = plateauEnd - plateauSpacing * Double(i)
                    
                    let (pos, opacity): (Double, Double) = {
                        switch t {
                        case ascendStart..<ascendEnd_i:
                            let local = (t - ascendStart) / ascendSpacing
                            let eased = 1 - pow(1 - local, 2)
                            return (eased * plateauPos, 1)
                        case ascendEnd_i..<descentStart:
                            return (plateauPos, 1)
                        case descentStart..<descentEnd:
                            let local = (t - descentStart) / descentSpacing
                            let eased = pow(local, 2)
                            return (plateauPos + eased * (1 - plateauPos), 1)
                        default:
                            return (0, 0)
                        }
                    }()
                    
                    let angle = Angle(radians: .pi/2 + pos * 2 * .pi)
                    let x = cos(angle.radians) * radius
                    let y = sin(angle.radians) * radius
                    
                    Circle()
                        .frame(width: dotSize, height: dotSize)
                        .offset(x: x, y: y)
                        .opacity(opacity)
                }
            }
            .frame(width: radius*2 + dotSize,
                   height: radius*2 + dotSize)
            .onAppear { startDate = Date() }
        }
    }
}

#Preview {
    ContentView()
}
