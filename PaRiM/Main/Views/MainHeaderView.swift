//
// Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class MainHeaderView: UIView {

    private var installed = false

    let titleLabel = Configure(UILabel()) {
        $0.text = "Tere tulemast"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    let leftArrowButton = Configure(UIButton()) {
        let config = UIImage.SymbolConfiguration(pointSize: 19.0, weight: .semibold, scale: .large)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
    }
    let rightArrowButton = Configure(UIButton()) {
        let config = UIImage.SymbolConfiguration(pointSize: 19.0, weight: .semibold, scale: .large)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
    }

    let firstDayButton = Configure(UIButton()) {
        $0.setTitle("First", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.titleLabel?.textAlignment = .center
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    convenience init() {
        self.init(frame: .zero)
        backgroundColor = UIColor(hex: 0x3B99D9)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if (!installed) {
            installed = true
            titleLabel.pin(on: self) {
                [
                    $0.topAnchor.constraint(equalTo: $1.safeArea.topAnchor, constant: 8),
                    $0.leftAnchor.constraint(equalTo: $1.safeArea.leftAnchor, constant: 8),
                    $0.rightAnchor.constraint(equalTo: $1.safeArea.rightAnchor, constant: -8),
                ]
            }

            firstDayButton.pin(on: self) {
                [
                    $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                    $0.bottomAnchor.constraint(equalTo: $1.safeArea.bottomAnchor, constant: -8),
                    $0.centerXAnchor.constraint(equalTo: $1.centerXAnchor),
                ]
            }

            leftArrowButton.pin(on: self) {
                [
                    $0.topAnchor.constraint(equalTo: firstDayButton.topAnchor),
                    $0.leftAnchor.constraint(equalTo: $1.safeArea.leftAnchor, constant: 8),
                    $0.bottomAnchor.constraint(equalTo: firstDayButton.bottomAnchor),
                ]
            }
            rightArrowButton.pin(on: self) {
                [
                    $0.topAnchor.constraint(equalTo: firstDayButton.topAnchor),
                    $0.rightAnchor.constraint(equalTo: $1.safeArea.rightAnchor, constant: -8),
                    $0.bottomAnchor.constraint(equalTo: firstDayButton.bottomAnchor),
                ]
            }

            firstDayButton.layoutOn {
                [
                    $0.leftAnchor.constraint(greaterThanOrEqualTo: leftArrowButton.rightAnchor, constant: 8),
                    $0.rightAnchor.constraint(lessThanOrEqualTo: rightArrowButton.leftAnchor, constant: -8),
                ]
            }
        }
        firstDayButton.layer.cornerRadius = firstDayButton.frame.size.height / 2
    }

}
