//
//  ScalingStack.swift
//  ScalingStack
//
//  Created by Dan Wood on 7/10/24.
//

import SwiftUI

public enum Sizing {
	case unspecified			// default, uses full size for sizing, or no offset for offset declaration
	case fraction(UnitPoint)	// fraction in X and Y dimension, between 0 and 1
	case references(small: CGSize, big: CGSize)	// calculate for you based on two reference sizes, relative to ScalingStack's reference sizes
	case slopeIntercept(m: CGFloat, b: CGFloat)	// calculate width&height (or x&y) from container size * m + b. Minimum 1pt for dimensions.
	case size(CGSize)	// Fixed size in points, ignoring container size
	case custom((_ containerSize: CGSize) -> CGSize) // closure for arbitrary calculations
}

public struct ScalingStack: Layout {
	public init(alignment: Alignment = .center, smallSize: CGSize = .zero, bigSize: CGSize = .zero) {
		self.alignment = alignment
		self.smallSize = smallSize
		self.bigSize = bigSize
	}

	let alignment: Alignment
	let smallSize: CGSize
	let bigSize: CGSize

	public func sizeThatFits(
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout Void
	) -> CGSize {
		proposal.replacingUnspecifiedDimensions()	// Take whatever space is offered.
	}

	public func placeSubviews(
		in bounds: CGRect,
		proposal: ProposedViewSize,
		subviews: Subviews,
		cache: inout Void
	) {
		let containerSize = proposal.replacingUnspecifiedDimensions()
		let unitPoint = alignment.unitPoint
		let alignmentPoint = bounds.alignmentPoint(alignment: alignment)

		for (_, subview) in subviews.enumerated() {
			let sizing = subview[SizingKey.self]
			let offset = subview[OffsetKey.self]
			let calculatedSize: CGSize = calculateSize(sizing: sizing, containerSize: containerSize, forOffset: false)
			let calculatedOffset: CGSize = calculateSize(sizing: offset, containerSize: containerSize, forOffset: true)
			let relativePoint = CGPoint(x: alignmentPoint.x + calculatedOffset.width,
										y: alignmentPoint.y + calculatedOffset.height)

			subview.place(at: relativePoint, anchor: unitPoint, proposal: ProposedViewSize(calculatedSize))
		}
	}
}

private extension ScalingStack {
	func calculateSize(sizing: Sizing, containerSize: CGSize, forOffset: Bool) -> CGSize {
		switch sizing {

		case .unspecified:
			forOffset ? .zero : containerSize
		case .fraction(let fraction):
			CGSize(width: fraction.x * containerSize.width, height: fraction.y * containerSize.height)
		case .references(small: let small, big: let big):
			interpolate(containerSize, small: small, big: big, containerSmall: smallSize, containerBig: bigSize, forOffset: forOffset)
		case .slopeIntercept(let m, let b):
			forOffset
			? CGSize(		// Allow it to go negative
				width: m * containerSize.width + b,
				height: m * containerSize.height + b)
			: CGSize(		// For dimensions, make sure at least one point
				width: max(1, m * containerSize.width + b),
				height: max(1, m * containerSize.height + b))
		case .size(let size):
			size
		case .custom(let closure):
			closure(containerSize)
		}
	}

	func interpolate(_ containerSize: CGSize, small: CGSize, big: CGSize, containerSmall: CGSize, containerBig: CGSize, forOffset: Bool) -> CGSize {

		// Calculate the interpolation factor for width and height
		let widthFactor: CGFloat
		let heightFactor: CGFloat

		if containerSmall.width != containerBig.width {
			widthFactor = (containerSize.width - containerSmall.width) / (containerBig.width - containerSmall.width)
		} else {
			widthFactor = 0
		}

		if containerSmall.height != containerBig.height {
			heightFactor = (containerSize.height - containerSmall.height) / (containerBig.height - containerSmall.height)
		} else {
			heightFactor = 0
		}

		// Interpolate the width and height
		let interpolatedWidth = small.width + widthFactor * (big.width - small.width)
		let interpolatedHeight = small.height + heightFactor * (big.height - small.height)
		if forOffset {
			return CGSize(width:interpolatedWidth, height: interpolatedHeight)
		} else {
			return CGSize(width: max(1, interpolatedWidth), height: max(1, interpolatedHeight))	// give it a minimum size
		}
	}
}

private struct SizingKey: LayoutValueKey {
	static let defaultValue: Sizing = .unspecified
}
private struct OffsetKey: LayoutValueKey {
	static let defaultValue: Sizing = .unspecified
}

public extension View {
	/// Sets the rank layout value on a view.
	func sizing(_ sizing: Sizing) -> some View {
		layoutValue(key: SizingKey.self, value: sizing)
	}

	// Overload offset directive but with our relative sizing values
	func offset(_ sizing: Sizing) -> some View {
		layoutValue(key: OffsetKey.self, value: sizing)
	}
}

private extension Alignment {
	var unitPoint: UnitPoint {
		switch self {
		case .topLeading:		.topLeading
		case .top:				.top
		case .topTrailing:		.topTrailing
		case .leading:			.leading
		case .center:			.center
		case .trailing:			.trailing
		case .bottomLeading:	.bottomLeading
		case .bottom:			.bottom
		case .bottomTrailing:	.bottomTrailing
		default:				.center
		}
	}
}

private extension CGRect {
	func alignmentPoint(alignment: Alignment) -> CGPoint {
		switch alignment {
		case .topLeading:		return CGPoint(x: minX, y: minY)
		case .top:				return CGPoint(x: midX, y: minY)
		case .topTrailing:		return CGPoint(x: maxX, y: minY)
		case .leading:			return CGPoint(x: minX, y: midY)
		case .center:			return CGPoint(x: midX, y: midY)
		case .trailing:			return CGPoint(x: maxX, y: midY)
		case .bottomLeading:	return CGPoint(x: minX, y: maxY)
		case .bottom:			return CGPoint(x: midX, y: maxY)
		case .bottomTrailing:	return CGPoint(x: maxX, y: maxY)
		default:				return CGPoint(x: midX, y: midY)
		}
	}
}
