//
//  View+Background.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


import SwiftUI

extension View {
    func background(backgroundColor: Color, overlayColor: Color, corners: [PopupAlignment: CGFloat]) -> some View {
        background(backgroundColor)
            .overlay(overlayColor)
            .mask(RoundedCorner(corners: corners))
    }
}

// MARK: Background Shape
fileprivate struct RoundedCorner: Shape {
    var corners: [PopupAlignment: CGFloat]
    
    var animatableData: CGFloat {
        get { corners.values.max() ?? 0 }
        set { corners.keys.forEach { corners[$0] = newValue } }
    }
    
    func path(in rect: CGRect) -> Path {
        let maxRadius = corners.values.max() ?? 0
        return createContinuousPath(rect, maxRadius)
    }
}

private extension RoundedCorner {
    func createContinuousPath(_ rect: CGRect, _ radius: CGFloat) -> Path {
        var path = Path()
        
        let topLeft = corners[.top] ?? 0
        let topRight = corners[.top] ?? 0
        let bottomRight = corners[.bottom] ?? 0
        let bottomLeft = corners[.bottom] ?? 0
        
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        
        // Top Left
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.minY + topLeft),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bottomLeft))
        
        // Bottom Left
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        
        path.addLine(to: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY))
        
        // Bottom Right
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + topRight))
        
        // Top Right
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - topRight, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        
        path.closeSubpath()
        return path
    }
}
