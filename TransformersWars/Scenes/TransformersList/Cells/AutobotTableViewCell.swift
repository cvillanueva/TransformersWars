//
//  AutobotTableViewCell.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import UIKit

class AutobotTableViewCell: UITableViewCell {

    // MARK: - Widgets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var strengthProgressView: UIProgressView!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var intelligenceProgressView: UIProgressView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedProgressView: UIProgressView!
    @IBOutlet weak var enduranceLabel: UILabel!
    @IBOutlet weak var enduranceProgressView: UIProgressView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView!
    @IBOutlet weak var courageLabel: UILabel!
    @IBOutlet weak var courageProgressView: UIProgressView!
    @IBOutlet weak var firepowerLabel: UILabel!
    @IBOutlet weak var firepowerProgressView: UIProgressView!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillProgressView: UIProgressView!

    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI() {
        self.leftViewWidthConstraint.constant = UIScreen.main.bounds.width / 2
        self.nameLabel.font = .optimus(size: 22)
    }

    func setup(model: AutobotTableViewCellModel) {
        self.nameLabel.text = model.name
        self.strengthProgressView.setProgress(Float(model.strength) * 0.1, animated: false)
        self.intelligenceProgressView.setProgress(Float(model.intelligence) * 0.1, animated: false)
        self.speedProgressView.setProgress(Float(model.speed) * 0.1, animated: false)
        self.enduranceProgressView.setProgress(Float(model.endurance) * 0.1, animated: false)
        self.rankProgressView.setProgress(Float(model.rank) * 0.1, animated: false)
        self.courageProgressView.setProgress(Float(model.courage) * 0.1, animated: false)
        self.firepowerProgressView.setProgress(Float(model.firepower) * 0.1, animated: false)
        self.skillProgressView.setProgress(Float(model.skill) * 0.1, animated: false)

        if model.oddCell {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
    }
}

public struct AutobotTableViewCellModel {
    let name: String
    let strength: Int
    let intelligence: Int
    let speed: Int
    let endurance: Int
    let rank: Int
    let courage: Int
    let firepower: Int
    let skill: Int
    let team: String
    let oddCell: Bool
}
