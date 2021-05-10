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

    private(set) var events: [String: [CalendarEvent]]?

    public var provider: CalendarProvider?

    var dates = ["2019-02-01"]

    public func load() {
        provider?.getEvents(from: "2019-02-01", to: "2019-02-28") { [weak self]result in
            switch result {
            case .success(let holidays):
                print(holidays)
                self?.events = holidays;
                self?.tableView?.reloadData()
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

extension CalenderPresenter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
//        0//
        self.dates.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        0
        self.events?[self.dates[section]]?.count ?? 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = events?[dates[indexPath.section]]?[indexPath.row] else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCalendarCellView.identifier, for: indexPath) as? EmptyCalendarCellView
            return cell!
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCellView.identifier, for: indexPath) as? CalendarCellView {
            cell.titleLabel.text = "Cell \(event.name)"
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
            view.titleLabel.text = "Section: \(section)"
            view.contentView.backgroundColor = .yellow
            return view
        }
        return nil
    }
}