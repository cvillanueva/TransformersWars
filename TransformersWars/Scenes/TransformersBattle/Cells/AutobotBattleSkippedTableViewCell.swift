//
//  AutobotBattleSkippedTableViewCell.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 19-05-21.
//

import UIKit

class AutobotBattleSkippedTableViewCell: UITableViewCell {

    // MARK: - Widgets

    @IBOutlet weak var autobotNameLabel: UILabel!

    // MARK: - Cell Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Setup the cell with the given data
    /// - Parameter model: A battle model object
    func setup(model: BattleModel) {
        self.autobotNameLabel.text = "\(model.autobotName) survives"
        if model.oddCell {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
    }
}
