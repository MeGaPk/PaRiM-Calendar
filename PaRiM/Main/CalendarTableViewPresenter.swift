//
// Created by Ivan Gaydamakin on 09.05.2021.
//

import UIKit

class CalendarTableViewPresenter: NSObject {

    public var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.estimatedRowHeight = 20

            tableView?.register(CalendarCellView.self, forCellReuseIdentifier: CalendarCellView.identifier)
            tableView?.register(CalendarEmptyCellView.self, forCellReuseIdentifier: CalendarEmptyCellView.identifier)
            tableView?.register(CalendarTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CalendarTableHeaderView.identifier)
        }
    }

    var modal: CalendarModal?

    func load(dates: [Date]) {
        modal?.load(dates: dates) {
            self.tableView?.reloadData()
        }
    }

}

extension CalendarTableViewPresenter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        modal?.getDates()?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modal?.getEvents(by: section)?.count ?? 1 // 1 need to show "No events" cell
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = modal?.getEvent(by: indexPath) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEmptyCellView.identifier, for: indexPath) as! CalendarEmptyCellView
            cell.contentView.backgroundColor = .appBackgroundColor
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCellView.identifier, for: indexPath) as? CalendarCellView {
            cell.contentView.backgroundColor = .appBackgroundColor
            cell.setText(text: event.name)
            cell.setTextColor(event.textColor())
            cell.setContainerBackgroundColor(event.backgroundColor())
            return cell
        }
        fatalError("Cannot load any cell. Maybe you forgot to register it?")
    }
}


extension CalendarTableViewPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = modal?.getEvent(by: indexPath)
        return event != nil ? UITableView.automaticDimension : 20
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarTableHeaderView.identifier) as? CalendarTableHeaderView {
            view.contentView.backgroundColor = .appBackgroundColor
            view.titleLabel.text = modal?.getDate(by: section)?.toSectionString()
            return view
        }
        return nil
    }
}

private extension CalendarEvent {
    func textColor() -> UIColor {
        switch type {
        case .folk:
            return .appFolkTitleColor
        case .common:
            return .appCommonTitleColor
        }
    }

    func backgroundColor() -> UIColor {
        switch type {
        case .folk:
            return .appFolkBackgroundColor
        case .common:
            return .appCommonBackgroundColor
        }
    }
}