//
// Created by Иван Гайдамакин on 10.05.2021.
//

import UIKit

class CalendarEmptyCellView: UITableViewCell {
    static let identifier = "EmptyCalendarCellView"

    private let titleLabel = Configure(UILabel()) {
        $0.font = UIFont.italicSystemFont(ofSize: 20)
        $0.textColor = .black
        $0.text = "No events"
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let offset = CGFloat(8)
        var f = contentView.frame
        f.origin.x += offset
        f.size.width -= offset * 2
        titleLabel.frame = f
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
