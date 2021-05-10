//
// Created by Иван Гайдамакин on 10.05.2021.
//

import UIKit

class CalendarCellView: UITableViewCell {
    static let identifier = "CalendarCellView"

    let titleLabel = Configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .black
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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
