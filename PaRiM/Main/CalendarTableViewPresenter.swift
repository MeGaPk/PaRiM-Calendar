//
// Created by Ivan Gaydamakin on 09.05.2021.
//

import UIKit
import DiffableDataSources

class CalendarTableViewPresenter: NSObject {

    public var tableView: UITableView? {
        didSet {
            dataSource.defaultRowAnimation = .fade

            tableView?.delegate = self
            tableView?.estimatedRowHeight = 20

            tableView?.register(CalendarCellView.self, forCellReuseIdentifier: CalendarCellView.identifier)
            tableView?.register(CalendarEmptyCellView.self, forCellReuseIdentifier: CalendarEmptyCellView.identifier)
            tableView?.register(CalendarTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CalendarTableHeaderView.identifier)
        }
    }

    private lazy var dataSource = TableViewDiffableDataSource<Date, CalendarHolidayDay?>(tableView: tableView!) { tableView, indexPath, holiday in
        CalendarCellFactory.calendarCell(tableView, event: holiday, for: indexPath)
    }

    private let modal = CalendarModal(provider: AmazonAPI())

    override init() {
        super.init()
        modal.delegate = self
    }

    func present(dates: [Date]) {
        modal.load(dates: dates)
    }
}

extension CalendarTableViewPresenter: CalendarModalDelegate {
    func loaded(dates: [Date], holidays: [String: [CalendarHolidayDay]]) {
        makeAndApplySnapshot(dates: dates, holidays: holidays)
    }

    func updated(dates: [Date], holidays: [String: [CalendarHolidayDay]]) {
        makeAndApplySnapshot(dates: dates, holidays: holidays)
    }
}

// Render section view and for height cell and section view
extension CalendarTableViewPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = dataSource.itemIdentifier(for: indexPath)
        return event != nil ? UITableView.automaticDimension : 20 // event == nil, mean will be show "No events" cell, so size is 20 for it.
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = dataSource.snapshot().sectionIdentifiers[section]
        return CalendarCellFactory.calendarHeader(tableView, date: date)
    }
}

private extension CalendarTableViewPresenter {
    func makeAndApplySnapshot(dates: [Date], holidays: [String: [CalendarHolidayDay]], animation: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = DiffableDataSourceSnapshot<Date, CalendarHolidayDay?>()
        snapshot.appendSections(dates)
        for date in dates {
            let calendarHolidays = holidays[date.toRequestString()]
            let vs: [CalendarHolidayDay?] = [nil]
            snapshot.appendItems(calendarHolidays ?? vs, toSection: date)
        }
        dataSource.apply(snapshot, animatingDifferences: animation) {
            completion?()
        }
    }
}