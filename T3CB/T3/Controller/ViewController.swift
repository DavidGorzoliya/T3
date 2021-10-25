//
//  ViewController.swift
//  T3
//
//  Created by Давид Горзолия on 10/25/21.
//

import UIKit

final class ViewController: UIViewController {

    private let maximumDollarBoundLabel: UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: v.font.pointSize)
        v.sizeToFit()
        v.backgroundColor = .systemPink
        v.textAlignment = .center
        v.textColor = .black
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = true
        return v
    }()

    private var records: [Record] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.compareMaximumBoundDollarWithCurrent()
            }
        }
    }

    private var maximumDollarBound: Double = 0 {
        didSet {
            maximumDollarBoundLabel.text = "\(maximumDollarBound)"
            maximumDollarBoundLabel.sizeToFit()
            maximumDollarBoundLabel.bounds.size.width += 12
            maximumDollarBoundLabel.bounds.size.height = 40
        }
    }

    private lazy var setMaximumDollarBoundButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "pencil"),
        style: .plain,
        target: self,
        action: #selector(onSetDollarMaxBound)
    )

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.titleView = maximumDollarBoundLabel
        configureNavBar()
        configureSubviews()
        configureTableView()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    @objc private func onSetDollarMaxBound() {
        let alertController = UIAlertController(title: "Set maximum dollar bounds value", message: nil, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        alertController.addTextField {
            $0.keyboardType = .numberPad
            $0.placeholder = "$ value"
        }

        let addToPriceObjective = UIAlertAction(title: "Set", style: .default) { _ in

            guard let text = alertController.textFields?.first?.text,
                  let value = Double(text) else {
                return
            }

            self.maximumDollarBound = value
            UserDefaults.standard.set(value, forKey: UserDefaultsKeys.maxDollarBound)
            DispatchQueue.main.async {
                self.compareMaximumBoundDollarWithCurrent()
            }
        }

        alertController.addAction(addToPriceObjective)
        present(alertController, animated: true)
    }

    private func configureNavBar() {
        if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.maxDollarBound),
           let valueDouble = value as? Double {
            maximumDollarBound = valueDouble
        }
        navigationItem.rightBarButtonItem = setMaximumDollarBoundButtonItem
    }

    private func compareMaximumBoundDollarWithCurrent() {
        guard let value = records.first?.value.toDouble else {
            return
        }
        maximumDollarBoundLabel.backgroundColor = value >= maximumDollarBound ? .red : .SMGreen
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    private func configureTableView() {
        tableView.register(DollarTableViewCell.self, forCellReuseIdentifier: DollarTableViewCell.indentifier)
        tableView.dataSource = self
        tableView.rowHeight = 60
    }

    private func configureSubviews() {
        view.addSubview(tableView)
    }

    private func fetchData() {
        CBRService.shared.getAllDollarData { result in
            switch result {
            case .success(let data):
                self.records = data.reversed()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DollarTableViewCell.indentifier, for: indexPath) as? DollarTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(date: records[indexPath.row].date, value: records[indexPath.row].value)
        return cell
    }
}
