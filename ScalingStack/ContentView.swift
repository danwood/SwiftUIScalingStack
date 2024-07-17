//
//  ContentView.swift
//  ScalingStack
//
//  Created by Dan Wood on 7/10/24.
//

import SwiftUI

struct ContentView: View {
	@State private var alignment: Alignment = .center

	var body: some View {
		//ScrollView(.vertical) {
			VStack {
				PotatomojiCrazy()
					.padding()
				PotatomojiSimple()
					.padding()
				
				AlignmentPicker(selectedAlignment: $alignment)

				ScalingStack(alignment: alignment, smallSize: CGSize(width: 128, height: 128), bigSize: CGSize(width: 256, height: 256)) {

					Color.brown
						.sizing(.fraction(UnitPoint(x: 0.8, y: 0.2)))
						.offset(.fraction(UnitPoint(x:0.25, y: 0.25)))

					Color.purple
						.sizing(.slopeIntercept(m: 0.5, b: 20))

					Color.gray
						.sizing(.fraction(UnitPoint(x: 0.5, y: 0.5)))		// slightly smaller than purple, so above it
						.frame(maxWidth: 100)		// Use standard frame directive to cap the size to a constant value

					Color.white
						.sizing(.custom({ containerSize in			// Crazy function
							containerSize.width > 200
							? CGSize(width: max(10, 400 - containerSize.width), height: max(10, 400 - containerSize.height))
							: CGSize(width: containerSize.width * 0.1, height: containerSize.height * 0.1)
						}))

					Color.cyan
						.sizing(.references(small: CGSize(width: 10, height: 10),	// when outerSize is 10, this is size of this item
											big: CGSize(width: 100, height: 100)))	// when outerSize is 100, this is size of this item
						.padding(10)	// padding is still a great way to move something away from the edge


					// Inverse
					Color.black
						.sizing(.references(small: CGSize(width: 100, height: 100),	// when outerSize is 100, this is size of this item
											big: CGSize(width: 10, height: 10)))	// when outerSize is 10, this is size of this item

					Color.orange
						.sizing(.size(CGSize(width: 30, height: 50)))
						.offset(CGSize(width: 20, height: 40))	// ↘️ relative to current alignment anchor
					Color.red
						.sizing(.size(CGSize(width: 20, height: 20)))
						.position(x: 20, y: 20)	// TODO: figure out how to replicate ZStack's behavior of ignoring alignment and placing relative to top-left always

					//COMPARE TO SIMPLE ZSTACK PLACEMENT:
//					Color.orange
//						.frame(width: 30, height: 50)
//						.offset(CGSize(width: 20, height: 40))	// ↘️ relative to current alignment anchor
//					Color.red
//						.frame(width: 20, height: 20)
//						.position(x: 20, y: 20)	// ↘️ absolute from top left regardless of alignment. ZStack ignores alignment completely!



					Color.brown
						.frame(width: 10, height: 10)
						.offset(.fraction(UnitPoint(x: 0.25, y: 0.25)))

					Color.purple
						.frame(width: 10, height: 10)
						.offset(.size(CGSize(width: 100, height: 100)))

					Color.gray
						.frame(width: 10, height: 10)
						.offset(.custom({ containerSize in			// Crazy function
							containerSize.width > 200
							? CGSize(width: max(10, 400 - containerSize.width), height: max(10, 400 - containerSize.height))
							: CGSize(width: containerSize.width * 0.1, height: containerSize.height * 0.1)
						}))

					Color.white
						.frame(width: 10, height: 10)
						.offset(.slopeIntercept(m: 0.5, b: 40))


					Color.orange
						.frame(width: 10, height: 10)
						.offset(CGSize(width: 20, height: 140))	// ↘️ relative to current alignment anchor
					Color.red
						.frame(width: 10, height: 10)
						.position(x: 20, y: 140)	// TODO: figure out how to replicate ZStack's behavior of ignoring alignment and placing relative to top-left always


					Image(systemName: "figure.skiing.crosscountry")
						.resizable()
						.aspectRatio(1, contentMode: .fit)
						.foregroundStyle(.yellow)
						.sizing(.references(small: CGSize(width: 20, height: 10),	// when outerSize is 20, this is size of this item
											big: CGSize(width: 40, height: 40)))	// when outerSize is 40, this is size of this item

					Text("Hello, world!")
						.foregroundStyle(.white)
						.lineLimit(1)
						.minimumScaleFactor(0.0001)
						.font(.system(size: 80))
				}
				.frame(minWidth: 20, minHeight: 20)
			}
			// .environment(\.layoutDirection, .rightToLeft)	// Useful to vary this just to make sure it's working as expected
		//}
	}
}

#Preview {
    ContentView()
}
