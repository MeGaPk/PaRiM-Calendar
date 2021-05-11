//
// Created by Ivan Gaydamakin on 09.05.2021.
//

import UIKit
import DiffableDataSources

extension CalendarEvent: Hashable {
    var hashValue: Int {
        name.hashValue
    }

    static func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type
    }
}

class CalendarTableViewPresenter: NSObject {

    public var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.estimatedRowHeight = 20

            tableView?.register(CalendarCellView.self, forCellReuseIdentifier: CalendarCellView.identifier)
            tableView?.register(CalendarEmptyCellView.self, forCellReuseIdentifier: CalendarEmptyCellView.identifier)
            tableView?.register(CalendarTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CalendarTableHeaderView.identifier)
        }
    }

    lazy var dataSource = TableViewDiffableDataSource<Date, CalendarEvent?>(tableView: tableView!) { tableView, indexPath, event in
        guard let event = event else {
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
        return nil
    }

    var modal: CalendarModal?

    override init() {
        super.init()
    }

    func present(dates: [Date]) {
        self.makeAndApplySnapshot(dates: dates, holidays: [:]) {
            self.modal?.load(dates: dates) {
                let events = self.modal!.getEvents()
                print(dates, events)
                self.makeAndApplySnapshot(dates: dates, holidays: events) {
                }
            }
        }
    }

    func makeAndApplySnapshot(dates: [Date], holidays: [String: [CalendarEvent]], animation: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = DiffableDataSourceSnapshot<Date, CalendarEvent?>()
        snapshot.appendSections(dates)
        for date in dates {
            let calendarEvents = holidays[date.toRequestString()]
            let vs: [CalendarEvent?] = [nil]
            snapshot.appendItems(calendarEvents ?? vs, toSection: date)
        }
        self.dataSource.apply(snapshot, animatingDifferences: animation) {
            completion?()
        }
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