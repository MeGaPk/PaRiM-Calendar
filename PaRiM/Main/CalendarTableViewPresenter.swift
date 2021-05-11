//
// Created by Ivan Gaydamakin on 09.05.2021.
//

import UIKit
import DiffableDataSources

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
        CalendarCellFactory.calendarCell(tableView, event: event, for: indexPath)
    }

    let modal = CalendarModal(provider: AmazonAPI())

    override init() {
        super.init()
        modal.delegate = self
    }

    func present(dates: [Date]) {
        modal.load(dates: dates)
    }
}

extension CalendarTableViewPresenter: CalendarModalDelegate {
    func loaded(dates: [Date], events: [String: [CalendarEvent]]) {
        makeAndApplySnapshot(dates: dates, holidays: events)
    }

    func updated(dates: [Date], events: [String: [CalendarEvent]]) {
        makeAndApplySnapshot(dates: dates, holidays: events)
    }
}

extension CalendarTableViewPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = dataSource.itemIdentifier(for: indexPath)
        return event != nil ? UITableView.automaticDimension : 20 // not event, mean will be show "No events" cell, so size is 20 for it.
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarTableHeaderView.identifier) as? CalendarTableHeaderView {
            let date = dataSource.snapshot().sectionIdentifiers[section]
            view.titleLabel.text = date.toSectionString()
            return view
        }
        return nil
    }
}

private extension CalendarTableViewPresenter {
    func makeAndApplySnapshot(dates: [Date], holidays: [String: [CalendarEvent]], animation: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = DiffableDataSourceSnapshot<Date, CalendarEvent?>()
        snapshot.appendSections(dates)
        for date in dates {
            let calendarEvents = holidays[date.toRequestString()]
            let vs: [CalendarEvent?] = [nil]
            snapshot.appendItems(calendarEvents ?? vs, toSection: date)
        }
        dataSource.apply(snapshot, animatingDifferences: animation) {
            completion?()
        }
    }
}