//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import UIKit

class CalendarCellFactory {
    static func calendarCell(_ tableView: UITableView, event: CalendarHolidayDay?, for indexPath: IndexPath) -> UITableViewCell? {
        if let event = event, let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCellView.identifier, for: indexPath) as? CalendarCellView {
            cell.setText(text: event.name)
            cell.setTextColor(event.textColor())
            cell.setContainerBackgroundColor(event.backgroundColor())
            cell.backgroundColor = .appBackgroundColor
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEmptyCellView.identifier, for: indexPath) as? CalendarEmptyCellView {
            cell.backgroundColor = .appBackgroundColor
            return cell
        }
        return nil
    }

    static func calendarHeader(_ tableView: UITableView, date: Date) -> UITableViewHeaderFooterView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarTableHeaderView.identifier) as? CalendarTableHeaderView {
            cell.titleLabel.text = date.toSectionString()
            cell.tintColor = .appBackgroundColor
            cell.contentView.backgroundColor = .appBackgroundColor // for ios 12
            return cell
        }
        return nil
    }
}

private extension CalendarHolidayDay {
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