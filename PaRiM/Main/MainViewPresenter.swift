//
// Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class CalenderPresenter: NSObject {

    public var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
}

extension CalenderPresenter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewCell = UITableViewCell()
        viewCell.backgroundColor = .red
        return viewCell
    }
}


extension CalenderPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }
}