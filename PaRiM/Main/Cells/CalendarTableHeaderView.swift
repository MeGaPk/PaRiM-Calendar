//
// Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class CalendarTableHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CalendarHeaderFooterView"

    let titleLabel = Configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.text = "Section"
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
