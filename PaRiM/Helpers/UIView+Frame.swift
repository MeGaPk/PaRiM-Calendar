//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import UIKit


extension CGRect {
    mutating func update(insets: UIEdgeInsets, by frame: CGRect) {
        var f = frame
        f.origin.x = insets.left
        f.origin.y = insets.top
        f.size.width -= insets.left + insets.right
        f.size.height -= insets.top + insets.bottom
        self = f
    }
}
