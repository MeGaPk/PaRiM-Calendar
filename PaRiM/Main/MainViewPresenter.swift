//
// Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class CalenderPresenter: NSObject {

    public var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self

            tableView?.register(CalendarCellView.self, forCellReuseIdentifier: CalendarCellView.identifier)
            tableView?.register(EmptyCalendarCellView.self, forCellReuseIdentifier: EmptyCalendarCellView.identifier)
            tableView?.register(CalendarHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CalendarHeaderFooterView.identifier)
        }
    }

    var modal: CalendarModal?

    func load() {
        modal?.load(completion: {
            self.tableView?.reloadData()
        })
    }

}

extension CalenderPresenter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        modal?.dates.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = modal?.dates[section] ?? ""
        return modal?.events[date]?.count ?? 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = modal?.dates[indexPath.section] ?? ""
        guard let event = modal?.events[date]?[indexPath.row] else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCalendarCellView.identifier, for: indexPath) as? EmptyCalendarCellView
            return cell!
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCellView.identifier, for: indexPath) as? CalendarCellView {
            cell.titleLabel.text = event.name
            return cell
        }
        fatalError("Unknown cell")
    }
}


extension CalenderPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarHeaderFooterView.identifier) as? CalendarHeaderFooterView {
            view.titleLabel.text = modal?.dates[section]
            view.contentView.backgroundColor = .yellow
            return view
        }
        return nil
    }
}