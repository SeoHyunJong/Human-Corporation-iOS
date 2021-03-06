//
//  Triangle.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct Triangle: View {
    var color = Color.blue
    var body: some View {
        GeometryReader { geo in
            let width = min(geo.size.width, geo.size.height)
            Path { path in
                path.move(to: CGPoint(x: 0, y: width*0.5))
                path.addLine(to: CGPoint(x: width, y: width*0.1))
                path.addLine(to: CGPoint(x: width, y: width*0.9))
            }
            .fill(color)
        }.aspectRatio(1, contentMode: .fit)
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
    }
}
