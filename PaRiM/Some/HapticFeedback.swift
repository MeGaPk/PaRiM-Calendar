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

    private var medium = UIImpactFeedbackGenerator(style: .medium)
    private var selected = UISelectionFeedbackGenerator()

    init() {
        medium.prepare()
        selected.prepare()
    }

    static func button(_ type: ButtonType) {
        switch type {
        case .next:
            shared.medium.impactOccurred()
        case .previous:
            shared.medium.impactOccurred()
        case .selected:
            shared.selected.selectionChanged()
        }
    }
}
