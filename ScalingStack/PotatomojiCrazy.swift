//
//  PotatomojiCrazy.swift
//  ScalingStack
//
//  Created by Dan Wood on 7/10/24.
//

import SwiftUI
import Foundation

// "Crazy" face where the position and sizes of the components depend on the face's size.
// Weird stuff happens depending on how the sizing and positioning is specified

struct PotatomojiCrazy: View {
	var body: some View {
		ScalingStack(alignment: .center, smallSize: CGSize(width: 80, height: 80), bigSize: CGSize(width: 160, height: 160)) {
			Circle()
				.fill(.yellow)
				.sizing(.fraction(UnitPoint(x: 0.92, y: 0.92)))

			// The bigger the face, the bigger the nose.
			// Use reference sizing. When ScalingStack is 'small' size (80x80), nose is 16x16.
			// When ScalingStack is 'big' size (160 x 160), nose is 60 x 60.
			"👃"
				.toImage()
				.resizable()
				.sizing(.references(small: CGSize(width: 16, height: 26), big: CGSize(width: 60, height: 60)))

			// Simple scaling, but combine with frame to have a minimum size
			"👁️"
				.toImage()
				.resizable()
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: -0.16, y: -0.14)))
				.frame(minWidth: 40, minHeight: 40)
			"👁️"
				.toImage()
				.resizable()
				.scaleEffect(x: -1, y: 1)  // flip horizontally
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(.fraction(UnitPoint(x: 0.16, y: -0.14)))
				.frame(minWidth: 50, minHeight: 50)

			// Glasses size is a fraction face size, but glasses position depends on size
			"👓"
				.toImage()
				.resizable()
				.blendMode(.plusDarker)
				.sizing(.fraction(UnitPoint(x: 0.8, y: 0.8)))
				.offset(.references(small: CGSize(width: 0, height: -10), big: CGSize(width: 0, height: -30)))

			// scale and position as a fraction of size
			"👄"
				.toImage()
				.resizable()
				.sizing(.fraction(UnitPoint(x: 0.4, y: 0.4)))
				.offset(.fraction(UnitPoint(x: 0, y: 0.26)))


			// The bigger the face, the smaller the ears (down to 1 point size)
			"👂"
				.toImage()
				.resizable()
				.sizing(.slopeIntercept(m: -0.2, b: 80))
				.offset(.fraction(UnitPoint(x: 0.45, y: 0)))
			"👂"
				.toImage()
				.resizable()
				.scaleEffect(x: -1, y: 1)  // flip horizontally
				.sizing(.slopeIntercept(m: -0.2, b: 80))
				.offset(.fraction(UnitPoint(x: -0.45, y: 0)))

			// shrink and grow, a sine wave, as face gets bigger
			"🎀"
				.toImage()
				.resizable()
				.rotation3DEffect(.degrees(-20), axis: (x: 0, y: 0, z: 1))
				.sizing(.fraction(UnitPoint(x: 0.25, y: 0.25)))
				.offset(Sizing.custom({ containerSize in
					let sine = sin(Double(containerSize.width / 30))
					let adjusted = sine * containerSize.width / 3
					return CGSize(width: adjusted, height: adjusted)
				}))
		}

		.aspectRatio(1, contentMode: .fit)
	}
}

#Preview {
    PotatomojiCrazy()
}
