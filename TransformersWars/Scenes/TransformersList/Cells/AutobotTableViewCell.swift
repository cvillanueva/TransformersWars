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
    @IBOutlet weak var strengthProgressView: UIProgressView!
    @IBOutlet weak var intelligenceProgressView: UIProgressView!
    @IBOutlet weak var speedProgressView: UIProgressView!
    @IBOutlet weak var enduranceProgressView: UIProgressView!
    @IBOutlet weak var rankProgressView: UIProgressView!
    @IBOutlet weak var courageProgressView: UIProgressView!
    @IBOutlet weak var firepowerProgressView: UIProgressView!
    @IBOutlet weak var skillProgressView: UIProgressView!
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Cell Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Setup widgets style
    func setupUI() {
        self.leftViewWidthConstraint.constant = UIScreen.main.bounds.width / 2
        self.nameLabel.font = .optimus(size: 22)
        self.strengthProgressView.tintColor = AppConstants.Color.redAutobot
        self.intelligenceProgressView.tintColor = AppConstants.Color.redAutobot
        self.speedProgressView.tintColor = AppConstants.Color.redAutobot
        self.enduranceProgressView.tintColor = AppConstants.Color.redAutobot
        self.rankProgressView.tintColor = AppConstants.Color.redAutobot
        self.courageProgressView.tintColor = AppConstants.Color.redAutobot
        self.firepowerProgressView.tintColor = AppConstants.Color.redAutobot
        self.skillProgressView.tintColor = AppConstants.Color.redAutobot
        self.selectionStyle = .none
    }

    /// Setup cell data
    /// - Parameter model: Data model with the info
    func setup(model: Transformer) {
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
