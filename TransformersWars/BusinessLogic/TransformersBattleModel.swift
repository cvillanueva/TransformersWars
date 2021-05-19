//
//  TransformersBattleModel.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 19-05-21.
//

import Foundation

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable type_body_length
// swiftlint:disable file_length

/// Business Logic
class TransformersBattleModel {

    var transformersList: [Transformer]

    init(transformersList: [Transformer]) {
        self.transformersList = transformersList
    }

    /// Performs the business logic
    /// - Returns: A list of objects with the battle results and the general result
    func execBattle() -> ([BattleModel], GeneralResultModel) {
        var generalResult = AppConstants.emptyGeneralResult

        var autobotsList: [Transformer] = []
        var decepticonsList: [Transformer] = []

        for transformer in transformersList {
            if transformer.team == AppConstants.BusinessLogic.autobotTeam {
                autobotsList.append(transformer)
            } else {
                decepticonsList.append(transformer)
            }
        }

        // Sorting by rank major to minor
        autobotsList.sort { $0.rank > $1.rank }
        decepticonsList.sort { $0.rank > $1.rank }

        printTransformersList(transformersList)
        printTransformersList(autobotsList)
        printTransformersList(decepticonsList)

        var longerCount = autobotsList.count
        if decepticonsList.count > autobotsList.count { longerCount = decepticonsList.count }

        var battleList: [BattleModel] = []

        if !checkGameResultAllDestroyed(autobotsList: autobotsList, decepticonsList: decepticonsList) {

            var numberOfBattles = 0

            for index in 0...longerCount - 1 {
                let autobot = getTransformerFromList(transformersList: autobotsList, index: index)
                let decepticon = getTransformerFromList(transformersList: decepticonsList, index: index)

                let battleModel = getBattle(
                    autobot: autobot,
                    decepticon: decepticon
                )

                if battleModel.autobotName == battleModel.decepticonName ||
                    (
                        battleModel.autobotName == AppConstants.BusinessLogic.autobotBoss &&
                            battleModel.decepticonName == AppConstants.BusinessLogic.decepticonBoss
                    ) {
                    generalResult = AppConstants.allDestroyedGeneralResult
                }

                if generalResult.winningTeam != .allDestroyed {

                    if battleModel.battleResultModel.winningTransformerType == .autobotWon &&
                        battleModel.decepticonName != AppConstants.empty {
                        generalResult.autobotsVictories += 1
                        generalResult.decepticonsDefeats += 1
                        generalResult.autobotsSurvivors += 1
                        numberOfBattles += 1

                    } else if battleModel.battleResultModel.winningTransformerType == .decepticonWon &&
                                battleModel.autobotName != AppConstants.empty {
                        generalResult.decepticonsVictories += 1
                        generalResult.autobotsDefeats += 1
                        generalResult.decepticonsSurvivors += 1
                        numberOfBattles += 1

                    } else if battleModel.battleResultModel.winningTransformerType == .tie {
                        generalResult.autobotsTies += 1
                        generalResult.decepticonsTies += 1
                        numberOfBattles += 1

                    } else if battleModel.decepticonName == AppConstants.empty {
                        generalResult.autobotsSurvivors += 1

                    } else if battleModel.autobotName == AppConstants.empty {
                        generalResult.decepticonsSurvivors += 1
                    }
                }
                battleList.append(battleModel)
            }

            generalResult.numberOfBattles = numberOfBattles

        } else {
            generalResult.winningTeam = .allDestroyed
            generalResult.numberOfBattles = 0
        }

        if generalResult.winningTeam != .allDestroyed {
            if generalResult.autobotsVictories > generalResult.decepticonsVictories {
                generalResult.winningTeam = .autobotWon
            } else if generalResult.decepticonsVictories > generalResult.autobotsVictories {
                generalResult.winningTeam = .decepticonWon
            } else if generalResult.decepticonsVictories == generalResult.autobotsVictories {
                generalResult.winningTeam = .tie
            }
        }

        return (battleList, generalResult)
    }

    /// Returns a valid or empty transformer if the index is out of range
    /// - Parameters:
    ///   - transformersList: The list to loop
    ///   - index: The index
    /// - Returns: A transformer
    func getTransformerFromList(transformersList: [Transformer], index: Int) -> Transformer {
        if index < transformersList.count {
            return transformersList[index]
        } else {
            return AppConstants.emptyTransformer
        }
    }

    /// Returns the result of a battle between an autobot and a decepticon
    /// - Parameters:
    ///   - autobot: The autobot
    ///   - decepticon: The decepticon
    /// - Returns: A battle model object
    func getBattle(autobot: Transformer, decepticon: Transformer) -> BattleModel {

        let autobotOverall = autobot.courage + autobot.strength + autobot.skill + autobot.speed +
            autobot.endurance + autobot.firepower + autobot.intelligence + autobot.rank

        let decepticonOverall = decepticon.courage + decepticon.strength + decepticon.skill + decepticon.speed +
            decepticon.endurance + decepticon.firepower + decepticon.intelligence + decepticon.rank

        var battleResult = AppConstants.BusinessLogic.tiedBattleResult

        let battleResultByName = getBattleResultByName(autobot: autobot, decepticon: decepticon)

        let battleResultByCourageAndStrength = getBattleResultByCourageAndStrength(
            autobot: autobot,
            decepticon: decepticon
        )

        let battleResultBySkill = getBattleResultBySkill(autobot: autobot, decepticon: decepticon)

        let battleResultByOverall = getBattleResultByOverall(
            autobot: autobot,
            decepticon: decepticon,
            autobotOverall: autobotOverall,
            decepticonOverall: decepticonOverall
        )

        if battleResultByName.winningTransformerType != .battlesContinue {
            battleResult = battleResultByName

        } else if battleResultByCourageAndStrength.winningTransformerType != .battlesContinue {
            battleResult = battleResultByCourageAndStrength

        } else if battleResultBySkill.winningTransformerType != .battlesContinue {
            battleResult = battleResultBySkill

        } else {
            battleResult = battleResultByOverall
        }

        return BattleModel(
            autobotName: autobot.name,
            decepticonName: decepticon.name,
            autobotCourage: autobot.courage,
            autobotStrength: autobot.strength,
            autobotSkill: autobot.skill,
            autobotSpeed: autobot.speed,
            autobotEndurance: autobot.endurance,
            autobotFirepower: autobot.firepower,
            autobotIntelligence: autobot.intelligence,
            autobotRank: autobot.rank,
            autobotOverall: autobotOverall,
            decepticonCourage: decepticon.courage,
            decepticonStrength: decepticon.strength,
            decepticonSkill: decepticon.skill,
            decepticonSpeed: decepticon.speed,
            decepticonEndurance: decepticon.endurance,
            decepticonFirepower: decepticon.firepower,
            decepticonIntelligence: decepticon.intelligence,
            decepticonRank: decepticon.rank,
            decepticonOverall: decepticonOverall,
            battleResultModel: battleResult,
            oddCell: false
        )
    }

    /// Checks the special rule about boss names
    /// - Parameters:
    ///   - autobot: The autobot
    ///   - decepticon: The decepticon
    /// - Returns: The result, that can be autobot or decepticon victory, all destroyed or the battle continues
    func checkTransformersName(
        autobot: Transformer,
        decepticon: Transformer
    ) -> AppConstants.BattleResult {

        if autobot.name == decepticon.name {
            return AppConstants.BattleResult.allDestroyed

        } else if autobot.name == AppConstants.BusinessLogic.autobotBoss &&
                  decepticon.name == AppConstants.BusinessLogic.decepticonBoss {
            return AppConstants.BattleResult.allDestroyed

        } else if autobot.name == AppConstants.BusinessLogic.autobotBoss {
            return AppConstants.BattleResult.autobotWon

        } else if decepticon.name == AppConstants.BusinessLogic.decepticonBoss {
            return AppConstants.BattleResult.decepticonWon

        } else {
            return AppConstants.BattleResult.battlesContinue
        }
    }

    /// The result of a battle depending on the special rule about boss names
    /// - Parameters:
    ///   - autobot: The autobot
    ///   - decepticon: The decepticon
    /// - Returns: A battle result model object
    func getBattleResultByName(autobot: Transformer, decepticon: Transformer) -> BattleResultModel {
        let resultByName = checkTransformersName(autobot: autobot, decepticon: decepticon)

        if resultByName == .autobotWon {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTransformerType: AppConstants.BattleResult.autobotWon,
                victoryCriteria: .victoryByName
            )

        } else if resultByName == .decepticonWon {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTransformerType: AppConstants.BattleResult.decepticonWon,
                victoryCriteria: .victoryByName
            )

        } else if resultByName == .allDestroyed {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                result: AppConstants.TransformersBattleViewController.allDestroyed,
                resultColor: AppConstants.Color.alldestroyedBlue,
                winningTransformerType: AppConstants.BattleResult.allDestroyed,
                victoryCriteria: .victoryByName
            )

        } else {
            return AppConstants.BusinessLogic.tiedBattleResult
        }
    }

    /// The result of a battle depending on the courage and strength criteria
    /// - Parameters:
    ///   - autobot: The autobot
    ///   - decepticon: The decepticon
    /// - Returns: A battle result model object
    func getBattleResultByCourageAndStrength(autobot: Transformer, decepticon: Transformer) -> BattleResultModel {
        let autobotCourageDifference = autobot.courage - decepticon.courage
        let autobotStrengthDifference = autobot.strength - decepticon.strength

        let decepticonCourageDifference = decepticon.courage - autobot.courage
        let decepticonStrengthDifference = decepticon.strength - autobot.strength

        if autobotCourageDifference >= 4 && autobotStrengthDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTransformerType: AppConstants.BattleResult.autobotWon,
                victoryCriteria: .victoryByCourageAndStrength
            )

        } else if decepticonCourageDifference >= 4 && decepticonStrengthDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTransformerType: AppConstants.BattleResult.decepticonWon,
                victoryCriteria: .victoryByCourageAndStrength
            )

        } else {
            return AppConstants.BusinessLogic.tiedBattleResult
        }
    }

    /// The result of a battle depending on the skill criteria
    /// - Parameters:
    ///   - autobot: The autobot
    ///   - decepticon: The decepticon
    /// - Returns: A battle result model object
    func getBattleResultBySkill(autobot: Transformer, decepticon: Transformer) -> BattleResultModel {
        let autobotSkillDifference = autobot.skill - decepticon.skill
        let decepticonSkillDifference = decepticon.skill - autobot.skill

        if autobotSkillDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTransformerType: AppConstants.BattleResult.autobotWon,
                victoryCriteria: .victoryBySkill
            )

        } else if decepticonSkillDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTransformerType: AppConstants.BattleResult.decepticonWon,
                victoryCriteria: .victoryBySkill
            )

        } else {
            return AppConstants.BusinessLogic.tiedBattleResult
        }
    }

    /// The result of a battle depending on the overall criteria
    /// - Parameters:
    ///   - autobot: The autobot
    ///   - decepticon: The decepticon
    /// - Returns: A battle result model object
    func getBattleResultByOverall(
        autobot: Transformer,
        decepticon: Transformer,
        autobotOverall: Int,
        decepticonOverall: Int
    ) -> BattleResultModel {
        if autobotOverall > decepticonOverall {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTransformerType: AppConstants.BattleResult.autobotWon,
                victoryCriteria: .victoryByOverall
            )
        } else if decepticonOverall > autobotOverall {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTransformerType: AppConstants.BattleResult.decepticonWon,
                victoryCriteria: .victoryByOverall
            )
        } else {
            return BattleResultModel(
                autobotStatus: AppConstants.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.TransformerBattleStatus.victory.rawValue,
                result: "TIE",
                resultColor: AppConstants.Color.yellowTie,
                winningTransformerType: AppConstants.BattleResult.tie,
                victoryCriteria: .tie
            )
        }
    }

    /// Checks in a preliminary way if all the transformers will result destroyed
    /// - Parameters:
    ///   - autobotsList: The autobots list
    ///   - decepticonsList: The decepticons list
    /// - Returns: A boolean indicating if there is mass destruction
    func checkGameResultAllDestroyed(autobotsList: [Transformer], decepticonsList: [Transformer]) -> Bool {
        var longerCount = autobotsList.count
        if decepticonsList.count > autobotsList.count { longerCount = decepticonsList.count }

        for index in 0...longerCount - 1 {
            let autobot = getTransformerFromList(transformersList: autobotsList, index: index)
            let decepticon = getTransformerFromList(transformersList: decepticonsList, index: index)

            if autobot.name == AppConstants.BusinessLogic.autobotBoss &&
                decepticon.name == AppConstants.BusinessLogic.decepticonBoss {
                return true
            } else if autobot.name == decepticon.name {
                return true
            }
        }
        return false
    }

    /// Prints a list of transformers to the console
    /// - Parameter transformersList: <#transformersList description#>
    func printTransformersList(_ transformersList: [Transformer]) {
        print("===================================")
        for transformer in transformersList {
            print("team: \(transformer.team) name:\(transformer.name) rank:\(transformer.rank)")
        }
    }
}
