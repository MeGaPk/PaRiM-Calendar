//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import UIKit

class WeekdayPicker: NSObject {
    typealias CompletionHandler = (Weekday) -> ()

    private static var weekdayPicker: WeekdayPicker? // hack to avoid deinit

    // CGRect need to fix error in logs: https://stackoverflow.com/questions/58530406/unable-to-simultaneously-satisfy-constraints-when-uitoolbarcontentview-is-presen
    private let toolBar = Configure(UIToolbar(frame:CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))) {
        $0.barStyle = UIBarStyle.default
        $0.isTranslucent = true
        $0.tintColor = .black
        $0.sizeToFit()
        $0.isUserInteractionEnabled = true
     }
    private let picker = UIPickerView()
    // fake keyboard for show picker
    private let dummy = UITextField(frame: .zero)

    private var selectedIndex: Int = 0

    private lazy var weekDays: [Weekday] = {
        var weekDays = Weekday.allCases
        weekDays.remove(at: 0)
        weekDays.append(.sunday)
        // for fix order on WeekDay for UIPickerView
        return weekDays
    }()

    private var completion: ((Weekday) -> ())?

    override init() {
        super.init()

        picker.dataSource = self
        picker.delegate = self

//        TODO: fix dark theme
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        dummy.delegate = self
        dummy.inputAccessoryView = toolBar
        dummy.inputView = picker
    }

    static func show(on view: UIView, selected: Weekday, completion: @escaping (Weekday) -> ()) {
        let picker = WeekdayPicker()
        picker.selectRow(selected)
        picker.completion = completion

        view.addSubview(picker.dummy)
        picker.dummy.becomeFirstResponder()
        WeekdayPicker.weekdayPicker = picker
    }

    @objc func doneTapped() {
        let weekday = weekDays[selectedIndex]
        completion?(weekday)
        close()
    }

    @objc func cancelTapped() {
        close()
    }

    private func selectRow(_ weekday: Weekday) {
        if let index = weekDays.firstIndex(of: weekday) {
            picker.selectRow(index, inComponent: 0, animated: false)
        }
    }

    private func close() {
        WeekdayPicker.weekdayPicker = nil
        completion = nil
        dummy.resignFirstResponder()
    }

    deinit {
        print("WeekdayPicker: deinit")
    }
}

extension WeekdayPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        weekDays.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        weekDays[row].toString()
    }
}

extension WeekdayPicker: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        close() // to get external events and avoid a memory leak
    }
}
