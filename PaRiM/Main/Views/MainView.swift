//
// Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class MainView: UIView {

    private var installed = false

    let headerView = MainHeaderView()
    let tableView = Configure(UITableView()) {
        $0.backgroundColor = .lightGray
    }

    convenience init() {
        self.init(frame: .zero)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if (!installed) {
            installed = true
            headerView.pin(on: self) {
                [
                    $0.topAnchor.constraint(equalTo: $1.topAnchor),
                    $0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                    $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                ]
            }
            tableView.pin(on: self) {
                [
                    $0.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                    $0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                    $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                    $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                ]
            }
        }
    }
}