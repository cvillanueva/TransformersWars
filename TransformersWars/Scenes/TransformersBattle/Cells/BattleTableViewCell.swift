//
//  BattleTableViewCell.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 18-05-21.
//

import UIKit

// swiftlint:disable function_body_length

class BattleTableViewCell: UITableViewCell {

    // MARK: - Widgets
    @IBOutlet weak var autobotNameLabel: UILabel!
    @IBOutlet weak var decepticonNameLabel: UILabel!

    @IBOutlet weak var autobotCourageProgressView: UIProgressView!
    @IBOutlet weak var autobotStrengthProgressView: UIProgressView!
    @IBOutlet weak var autobotSkillProgressView: UIProgressView!
    @IBOutlet weak var autobotSpeedProgressView: UIProgressView!
    @IBOutlet weak var autobotEnduranceProgressView: UIProgressView!
    @IBOutlet weak var autobotFirepowerProgressView: UIProgressView!
    @IBOutlet weak var autobotIntelligenceProgressView: UIProgressView!
    @IBOutlet weak var autobotRankProgressView: UIProgressView!
    @IBOutlet weak var autobotOverallProgressView: UIProgressView!

    @IBOutlet weak var decepticonCourageProgressView: UIProgressView!
    @IBOutlet weak var decepticonStrengthProgressView: UIProgressView!
    @IBOutlet weak var decepticonSkillProgressView: UIProgressView!
    @IBOutlet weak var decepticonSpeedProgressView: UIProgressView!
    @IBOutlet weak var decepticonEnduranceProgressView: UIProgressView!
    @IBOutlet weak var decepticonFirepowerProgressView: UIProgressView!
    @IBOutlet weak var decepticonIntelligenceProgressView: UIProgressView!
    @IBOutlet weak var decepticonRankProgressView: UIProgressView!
    @IBOutlet weak var decepticonOverallProgressView: UIProgressView!

    @IBOutlet weak var autobotCourageLabel: UILabel!
    @IBOutlet weak var autobotStrengthLabel: UILabel!
    @IBOutlet weak var autobotSkillLabel: UILabel!
    @IBOutlet weak var autobotSpeedLabel: UILabel!
    @IBOutlet weak var autobotEnduranceLabel: UILabel!
    @IBOutlet weak var autobotFirepowerLabel: UILabel!
    @IBOutlet weak var autobotIntelligenceLabel: UILabel!
    @IBOutlet weak var autobotRankLabel: UILabel!
    @IBOutlet weak var autobotOverallLabel: UILabel!

    @IBOutlet weak var decepticonCourageLabel: UILabel!
    @IBOutlet weak var decepticonStrengthLabel: UILabel!
    @IBOutlet weak var decepticonSkillLabel: UILabel!
    @IBOutlet weak var decepticonSpeedLabel: UILabel!
    @IBOutlet weak var decepticonEnduranceLabel: UILabel!
    @IBOutlet weak var decepticonFirepowerLabel: UILabel!
    @IBOutlet weak var decepticonIntelligenceLabel: UILabel!
    @IBOutlet weak var decepticonRankLabel: UILabel!
    @IBOutlet weak var decepticonOverallLabel: UILabel!

    @IBOutlet weak var autobotFinalStatusLabel: UILabel!
    @IBOutlet weak var decepticonFinalStatusLabel: UILabel!

    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!

    // MARK: - Cell Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Setup cell data
    /// - Parameter model: Data model with the info
    func setup(model: BattleModel) {
        self.autobotNameLabel.text = model.autobotName
        self.decepticonNameLabel.text = model.decepticonName

        self.autobotCourageProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotStrengthProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotSkillProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotSpeedProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotEnduranceProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotFirepowerProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotIntelligenceProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotRankProgressView.semanticContentAttribute = .forceRightToLeft
        self.autobotOverallProgressView.semanticContentAttribute = .forceRightToLeft

        self.autobotCourageProgressView.setProgress(Float(model.autobotCourage) * 0.1, animated: false)
        self.autobotStrengthProgressView.setProgress(Float(model.autobotStrength) * 0.1, animated: false)
        self.autobotSkillProgressView.setProgress(Float(model.autobotSkill) * 0.1, animated: false)
        self.autobotSpeedProgressView.setProgress(Float(model.autobotSpeed) * 0.1, animated: false)
        self.autobotEnduranceProgressView.setProgress(Float(model.autobotEndurance) * 0.1, animated: false)
        self.autobotFirepowerProgressView.setProgress(Float(model.autobotFirepower) * 0.1, animated: false)
        self.autobotIntelligenceProgressView.setProgress(Float(model.autobotIntelligence) * 0.1, animated: false)
        self.autobotRankProgressView.setProgress(Float(model.autobotRank) * 0.1, animated: false)
        self.autobotOverallProgressView.setProgress(Float(model.autobotOverall/10) * 0.1, animated: false)

        self.decepticonCourageProgressView.setProgress(Float(model.decepticonCourage) * 0.1, animated: false)
        self.decepticonStrengthProgressView.setProgress(Float(model.decepticonStrength) * 0.1, animated: false)
        self.decepticonSkillProgressView.setProgress(Float(model.decepticonSkill) * 0.1, animated: false)
        self.decepticonSpeedProgressView.setProgress(Float(model.decepticonSpeed) * 0.1, animated: false)
        self.decepticonEnduranceProgressView.setProgress(Float(model.decepticonEndurance) * 0.1, animated: false)
        self.decepticonFirepowerProgressView.setProgress(Float(model.decepticonFirepower) * 0.1, animated: false)
        self.decepticonIntelligenceProgressView.setProgress(Float(model.decepticonIntelligence) * 0.1, animated: false)
        self.decepticonRankProgressView.setProgress(Float(model.decepticonRank) * 0.1, animated: false)
        self.decepticonOverallProgressView.setProgress(Float(model.decepticonOverall/10) * 0.1, animated: false)

        self.autobotCourageLabel.text = String(model.autobotCourage)
        self.autobotStrengthLabel.text = String(model.autobotStrength)
        self.autobotSkillLabel.text = String(model.autobotSkill)
        self.autobotSpeedLabel.text = String(model.autobotSpeed)
        self.autobotEnduranceLabel.text = String(model.autobotEndurance)
        self.autobotFirepowerLabel.text = String(model.autobotFirepower)
        self.autobotIntelligenceLabel.text = String(model.autobotIntelligence)
        self.autobotRankLabel.text = String(model.autobotRank)
        self.autobotOverallLabel.text = String(model.autobotOverall)

        self.decepticonCourageLabel.text = String(model.decepticonCourage)
        self.decepticonStrengthLabel.text = String(model.decepticonStrength)
        self.decepticonSkillLabel.text = String(model.decepticonSkill)
        self.decepticonSpeedLabel.text = String(model.decepticonSpeed)
        self.decepticonEnduranceLabel.text = String(model.decepticonEndurance)
        self.decepticonFirepowerLabel.text = String(model.decepticonFirepower)
        self.decepticonIntelligenceLabel.text = String(model.decepticonIntelligence)
        self.decepticonRankLabel.text = String(model.decepticonRank)
        self.decepticonOverallLabel.text = String(model.decepticonOverall)

        self.autobotFinalStatusLabel.text = model.battleResult.autobotStatus
        self.decepticonFinalStatusLabel.text = model.battleResult.decepticonStatus

        self.resultView.backgroundColor = model.battleResult.resultColor
        self.resultLabel.text = model.battleResult.result

        if model.oddCell {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
    }
}

struct BattleModel {
    let autobotName: String
    let decepticonName: String
    let autobotCourage: Int
    let autobotStrength: Int
    let autobotSkill: Int
    let autobotSpeed: Int
    let autobotEndurance: Int
    let autobotFirepower: Int
    let autobotIntelligence: Int
    let autobotRank: Int
    let autobotOverall: Int
    let decepticonCourage: Int
    let decepticonStrength: Int
    let decepticonSkill: Int
    let decepticonSpeed: Int
    let decepticonEndurance: Int
    let decepticonFirepower: Int
    let decepticonIntelligence: Int
    let decepticonRank: Int
    let decepticonOverall: Int
    let battleResult: BattleResultModel
    var oddCell: Bool
}

struct BattleResultModel {
    let autobotStatus: String
    let decepticonStatus: String
    let result: String
    let resultColor: UIColor
    let winningTeam: AppConstants.BusinessLogic.BattleResult
}
