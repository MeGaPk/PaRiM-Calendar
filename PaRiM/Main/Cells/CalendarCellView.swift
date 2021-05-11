//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import UIKit

class CalendarCellView: UITableViewCell {
    static let identifier = "CalendarCellView"

    private let titleLabel = Configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    private let cornerBackgroundLayer = Configure(CALayer()) {
        // Huge change in performance by explicitly setting the below (even though default is supposedly NO)
        $0.masksToBounds = false
        // Performance improvement here depends on the size of your view
        $0.shouldRasterize = true
        $0.rasterizationScale = UIScreen.main.scale;
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.addSublayer(cornerBackgroundLayer)
        let offset: CGFloat = 16 + 8
        titleLabel.pin(on: contentView) {
            [
                $0.topAnchor.constraint(equalTo: $1.topAnchor, constant: offset),
                $0.leftAnchor.constraint(equalTo: $1.leftAnchor, constant: offset),
                $0.rightAnchor.constraint(equalTo: $1.rightAnchor, constant: -offset),
                $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor, constant: -offset),
            ]
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        cornerBackgroundLayer.frame.update(insets: insets, by: contentView.frame)

        let cornerRadius = CGSize(width: 16.0, height: 16.0)
        let pathWithRadius = UIBezierPath(roundedRect: cornerBackgroundLayer.bounds, byRoundingCorners:[.allCorners], cornerRadii: cornerRadius)
        let mask = CAShapeLayer()
        mask.path = pathWithRadius.cgPath
        cornerBackgroundLayer.mask = mask
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarCellView {
    func setContainerBackgroundColor(_ color: UIColor?) {
        cornerBackgroundLayer.backgroundColor = color?.cgColor
    }

    func setTextColor(_ color: UIColor?) {
        titleLabel.textColor = color
    }

    func setText(text: String?) {
        titleLabel.text = text
    }
}
