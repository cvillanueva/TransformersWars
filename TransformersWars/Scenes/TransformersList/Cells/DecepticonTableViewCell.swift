//
//  DecepticonTableViewCell.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 16-05-21.
//

import UIKit

class DecepticonTableViewCell: UITableViewCell {

    // MARK: - Widgets

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
        self.strengthProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.intelligenceProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.speedProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.enduranceProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.rankProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.courageProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.firepowerProgressView.tintColor = AppConstants.Color.purpleDecepticon
        self.skillProgressView.tintColor = AppConstants.Color.purpleDecepticon
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
