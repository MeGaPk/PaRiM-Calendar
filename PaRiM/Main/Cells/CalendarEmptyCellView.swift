//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import UIKit

class CalendarEmptyCellView: UITableViewCell {
    static let identifier = "EmptyCalendarCellView"

    private let titleLabel = Configure(UILabel()) {
        $0.font = UIFont.italicSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = "No events"
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .appBackgroundColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel.frame.update(insets: insets, by: contentView.frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
