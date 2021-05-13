//
// Created by Ivan Gaydamakin on 09.05.2021.
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
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel.frame.update(insets: insets, by: contentView.frame)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
