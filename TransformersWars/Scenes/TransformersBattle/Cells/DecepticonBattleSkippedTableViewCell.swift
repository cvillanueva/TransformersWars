//
//  DecepticonBattleSkippedTableViewCell.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 19-05-21.
//

import UIKit

class DecepticonBattleSkippedTableViewCell: UITableViewCell {

    // MARK: - Widgets

    @IBOutlet weak var decepticonNameLabel: UILabel!

    // MARK: - Cell Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Setup the cell with the given data
    /// - Parameter model: A battle model object
    func setup(model: BattleModel) {
        self.decepticonNameLabel.text = "\(model.decepticonName) survives"

        if model.oddCell {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
    }
}
