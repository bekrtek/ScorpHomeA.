//
//  PersonTableViewCell.swift
//  ScorpHomeA.
//
//  Created by BEKIR TEK on 4.04.2023.
//

import UIKit

final class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with person: Person) {
        nameLabel.text = "\(person.fullName) (\(person.id))"
    }
}
