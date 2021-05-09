//
//  ViewController.swift
//  PaRiM
//
//  Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class MainViewController: UIViewController {

    private var layoutInstalled = false

    let presenter = CalenderPresenter()
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view?.backgroundColor = .white
        presenter.tableView = mainView.tableView
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !layoutInstalled {
            layoutInstalled = true
            mainView.pin(on: view!) {
                [
                    $0.topAnchor.constraint(equalTo: $1.topAnchor),
                    $0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                    $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                    $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                ]
            }
        }
    }
}

