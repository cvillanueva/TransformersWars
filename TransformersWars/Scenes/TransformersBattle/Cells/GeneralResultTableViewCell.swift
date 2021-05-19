//
//  GeneralResultTableViewCell.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 19-05-21.
//

import UIKit

class GeneralResultTableViewCell: UITableViewCell {

    // MARK: - Widgets

    @IBOutlet weak var teamResultLabel: UILabel!

    @IBOutlet weak var autobotsVictoriesLabel: UILabel!
    @IBOutlet weak var autobotsDefeatsLabel: UILabel!
    @IBOutlet weak var autobotsTiesLabel: UILabel!
    @IBOutlet weak var autobotsSurvivorsLabel: UILabel!

    @IBOutlet weak var decepticonsVictoriesLabel: UILabel!
    @IBOutlet weak var decepticonsDefeatsLabel: UILabel!
    @IBOutlet weak var decepticonsTiesLabel: UILabel!
    @IBOutlet weak var decepticonsSurvivorsLabel: UILabel!

    // MARK: - Cell Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Setup cell data
    /// - Parameter model: A general result model object
    func setup(model: GeneralResultModel) {

        self.teamResultLabel.text = "Number of battles: \(model.numberOfBattles)"

        self.autobotsVictoriesLabel.text = String(model.autobotsVictories)
        self.autobotsDefeatsLabel.text = String(model.autobotsDefeats)
        self.autobotsTiesLabel.text = String(model.autobotsTies)
        self.autobotsSurvivorsLabel.text = String(model.autobotsSurvivors)

        self.decepticonsVictoriesLabel.text = String(model.decepticonsVictories)
        self.decepticonsDefeatsLabel.text = String(model.decepticonsDefeats)
        self.decepticonsTiesLabel.text = String(model.decepticonsTies)
        self.decepticonsSurvivorsLabel.text = String(model.decepticonsSurvivors)

        if model.winningTeam == .autobotWon {
            self.teamResultLabel.text = "Autobots won"
            self.teamResultLabel.backgroundColor = AppConstants.Color.redAutobot

        } else if model.winningTeam == .decepticonWon {
            self.teamResultLabel.text = "Decepticons won"
            self.teamResultLabel.backgroundColor = AppConstants.Color.purpleDecepticon

        } else if model.winningTeam == .allDestroyed {
            self.teamResultLabel.text = "All destroyed"
            self.teamResultLabel.backgroundColor = AppConstants.Color.alldestroyedBlue

        } else {
            self.teamResultLabel.text = "TIE"
            self.teamResultLabel.backgroundColor = AppConstants.Color.yellowTie
        }

        if model.oddCell {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
    }
}

/// Struct to handle the general result data
struct GeneralResultModel {
    var numberOfBattles: Int
    var autobotsVictories: Int
    var autobotsDefeats: Int
    var autobotsTies: Int
    var autobotsSurvivors: Int
    var decepticonsVictories: Int
    var decepticonsDefeats: Int
    var decepticonsTies: Int
    var decepticonsSurvivors: Int
    var winningTeam: AppConstants.BattleResult
    var oddCell: Bool
}
