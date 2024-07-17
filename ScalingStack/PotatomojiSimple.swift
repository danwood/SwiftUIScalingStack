//
//  PotatomojiSimple.swift
//  ScalingStack
//
//  Created by Dan Wood on 7/10/24.
//

import SwiftUI

// Face where the components scale exactly to match the container view.

struct PotatomojiSimple: View {
    var body: some View {
		ScalingStack(alignment: .center, smallSize: CGSize(width: 80, height: 80), bigSize: CGSize(width: 160, height: 160)) {
			Circle()
				.fill(.yellow)
				.sizing(.fraction(UnitPoint(x: 0.92, y: 0.92)))
			"👃"
				.toImage()
				.resizable()
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
			"👁️"
				.toImage()
				.resizable()
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: -0.16, y: -0.14)))
			"👁️"
				.toImage()
				.resizable()
				.scaleEffect(x: -1, y: 1)  // flip horizontally
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: 0.16, y: -0.14)))
			"👓"
				.toImage()
				.resizable()
				.blendMode(.plusDarker)
				.sizing(.fraction(UnitPoint(x: 0.8, y: 0.8)))
				.offset(.fraction(UnitPoint(x: 0, y: -0.14)))
			"👄"
				.toImage()
				.resizable()
				.sizing(.fraction(UnitPoint(x: 0.4, y: 0.4)))
				.offset(.fraction(UnitPoint(x: 0, y: 0.26)))
			"👂"
				.toImage()
				.resizable()
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: 0.45, y: 0)))
			"👂"
				.toImage()
				.resizable()
				.scaleEffect(x: -1, y: 1)  // flip horizontally
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: -0.45, y: 0)))

			"🎀"
				.toImage()
				.resizable()
				.rotation3DEffect(.degrees(-20), axis: (x: 0, y: 0, z: 1))
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: -0.25, y: -0.35)))
		}

		.aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PotatomojiSimple()
}
