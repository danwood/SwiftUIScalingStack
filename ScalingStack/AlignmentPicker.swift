//
//  AlignmentPicker.swift
//  ScalingStack
//
//  Created by Dan Wood on 7/10/24.
//

import SwiftUI

struct AlignmentPicker: View {
	@Binding var selectedAlignment: Alignment

	var body: some View {
		Picker("Select Alignment", selection: $selectedAlignment) {
			ForEach(Alignment.allCases, id: \.self) { alignment in
				Text(alignment.description)
					.tag(alignment)
			}
		}
		.pickerStyle(MenuPickerStyle())
		.padding()
	}
}

extension Alignment: @retroactive Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.horizontal.key)
		hasher.combine(self.vertical.key)
	}
}

extension Alignment: @retroactive CaseIterable {
	public static var allCases: [Alignment] {
		return [
			.topLeading, .top, .topTrailing,
			.leading, .center, .trailing,
			.bottomLeading, .bottom, .bottomTrailing
		]
	}
}

extension Alignment: @retroactive CustomStringConvertible {
	public var description: String {
		switch self {
		case .topLeading: return "Top Leading"
		case .top: return "Top"
		case .topTrailing: return "Top Trailing"
		case .leading: return "Leading"
		case .center: return "Center"
		case .trailing: return "Trailing"
		case .bottomLeading: return "Bottom Leading"
		case .bottom: return "Bottom"
		case .bottomTrailing: return "Bottom Trailing"
		default: return "Center"
		}
	}
}
