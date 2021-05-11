//
// Created by Иван Гайдамакин on 11.05.2021.
//

import UIKit

class CalendarCellFactory {
    static func calendarCell(_ tableView: UITableView, event: CalendarEvent?, for indexPath: IndexPath) -> UITableViewCell? {
        if let event = event, let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCellView.identifier, for: indexPath) as? CalendarCellView {
            cell.setText(text: event.name)
            cell.setTextColor(event.textColor())
            cell.setContainerBackgroundColor(event.backgroundColor())
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEmptyCellView.identifier, for: indexPath) as? CalendarEmptyCellView {
            return cell
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