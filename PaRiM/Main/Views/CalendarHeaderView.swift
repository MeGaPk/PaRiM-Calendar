//
// Created by Ivan Gaydamakin on 09.05.2021.
//

import UIKit

class CalendarHeaderView: UIView {

    private var installed = false

    let titleLabel = Configure(UILabel()) {
        $0.text = "Tere tulemast"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    let leftArrowButton = Configure(UIButton()) {
        let image = UIImage(named: "backward")  // image I got from PaRiM app
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    let rightArrowButton = Configure(UIButton()) {
        let image = UIImage(named: "forward") // image I got from PaRiM app
        $0.setImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
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
        backgroundColor = .appTitleHeaderColor
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
                    $0.centerYAnchor.constraint(equalTo: firstDayButton.centerYAnchor),
                    $0.leftAnchor.constraint(equalTo: $1.safeArea.leftAnchor, constant: 8),
                    $0.heightAnchor.constraint(equalToConstant: 30),
                    $0.widthAnchor.constraint(equalToConstant: 30),
                ]
            }
            rightArrowButton.pin(on: self) {
                [
                    $0.centerYAnchor.constraint(equalTo: firstDayButton.centerYAnchor),
                    $0.rightAnchor.constraint(equalTo: $1.safeArea.rightAnchor, constant: -8),
                    $0.heightAnchor.constraint(equalToConstant: 30),
                    $0.widthAnchor.constraint(equalToConstant: 30),
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
