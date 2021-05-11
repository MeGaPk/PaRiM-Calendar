//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import UIKit

final class HapticFeedback {
    enum ButtonType {
        case next
        case previous
        case selected
    }

    private static let shared = HapticFeedback()

    private var light = UIImpactFeedbackGenerator(style: .light)
    private var selected = UISelectionFeedbackGenerator()

    init() {
        light.prepare()
        selected.prepare()
    }

    static func button(_ type: ButtonType) {
        switch type {
        case .next:
            shared.light.impactOccurred()
        case .previous:
            shared.light.impactOccurred()
        case .selected:
            shared.selected.selectionChanged()
        }
    }
}
