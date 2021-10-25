//
//  DollarTableViewCell.swift
//  T3
//
//  Created by Давид Горзолия on 10/25/21.
//

import UIKit

final class DollarTableViewCell: UITableViewCell {

    static let indentifier = "DollarTableViewCell"

    private let dateLabel = UILabel()
    private let valueLabel = UILabel()


    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(dateLabel)
        dateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 6).isActive = true

        contentView.addSubview(valueLabel)
        valueLabel.font = .systemFont(ofSize: 20, weight: .medium)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6).isActive = true
    }

    func configure(date: String, value: String) {
        dateLabel.text = date
        valueLabel.text = value
    }
}
