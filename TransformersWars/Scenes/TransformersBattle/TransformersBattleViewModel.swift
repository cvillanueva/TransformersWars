//
//  TransformersBattleViewModel.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 18-05-21.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

// swiftlint:disable identifier_name

class TransformersBattleViewModel {

    // MARK: - I/O
    struct Input {}
    struct Output {
        let battleItems: Driver<[BattlesListSectionModel]>
    }

    let input: Input
    let output: Output

    // MARK: - Subjects
    let _battleItems = BehaviorRelay<[BattlesListSectionModel]>(value: [])

    // MARK: - Sections

    var battleItems: [BattlesListSectionModel] {
        get {
            _battleItems.value
        }
        set {
            _battleItems.accept(newValue)
        }
    }

    // MARK: - Class variables
    let disposeBag = DisposeBag()
    var transformersList: [Transformer] = []
    var battleList: [BattleModel] = []

    init(transformersList: [Transformer]) {
        print("[BattleListViewModel] init()")
        self.transformersList = transformersList
        input = Input()
        output = Output(
            battleItems: _battleItems.asDriver()
        )
        battleItems = [.battleListSection(title: AppConstants.empty, items: [])]
    }

    func fillTableWithMockData() {
        let battle1 = BattleModel(
            autobotName: "Potatobot", decepticonName: "Plastatron",
            autobotCourage: 10, autobotStrength: 10, autobotSkill: 10, autobotSpeed: 10,
            autobotEndurance: 10, autobotFirepower: 10, autobotIntelligence: 10, autobotRank: 10,
            autobotOverall: 80,
            decepticonCourage: 9, decepticonStrength: 9, decepticonSkill: 9, decepticonSpeed: 9,
            decepticonEndurance: 9, decepticonFirepower: 9, decepticonIntelligence: 9, decepticonRank: 9,
            decepticonOverall: 72,
            battleResult: BattleResultModel(
                autobotStatus: "Victory", decepticonStatus: "Defeated", result: "Potatobot Won",
                resultColor: AppConstants.Color.redAutobot,
                winningTeam: AppConstants.BusinessLogic.BattleResult.autobotWon
            ),
            oddCell: false
        )

        let battle2 = BattleModel(
            autobotName: "Cumabot", decepticonName: "Flaitetron",
            autobotCourage: 7, autobotStrength: 7, autobotSkill: 7, autobotSpeed: 7,
            autobotEndurance: 7, autobotFirepower: 7, autobotIntelligence: 7, autobotRank: 7,
            autobotOverall: 56,
            decepticonCourage: 9, decepticonStrength: 9, decepticonSkill: 9, decepticonSpeed: 9,
            decepticonEndurance: 9, decepticonFirepower: 9, decepticonIntelligence: 9, decepticonRank: 9,
            decepticonOverall: 64,
            battleResult: BattleResultModel(
                autobotStatus: "Defeated", decepticonStatus: "Victory", result: "Flaitetron Won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTeam: AppConstants.BusinessLogic.BattleResult.decepticonWon
            ),
            oddCell: false
        )

        let battleList: [BattleModel] = [battle1, battle2]
        showList(battleList: battleList)
    }

    func showList(battleList: [BattleModel]) {
        print("[BattlesListViewModel] showList()")
        var section: BattlesListSectionModel = .battleListSection(title: AppConstants.empty, items: [])
        var currentBattlesItems: [BattleItem] = []
        var oddCounter = 0

        for battle in battleList {
            var model = battle
            print("[BattlesListViewModel] showList() \(model.autobotName) VS \(model.decepticonName)")
            model.oddCell = oddCounter % 2 == 0
            currentBattlesItems.append(.battleItem(model: model))
            oddCounter += 1
        }

        section = .battleListSection(
            title: AppConstants.empty,
            items: currentBattlesItems
        )

        battleItems[0] = section
    }
}

extension TransformersBattleViewModel {

    // MARK: - Business logic

    func startBattle() {
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

        for i in 0...longerCount-1 {
            let battleModel = getBattle(
                autobot: autobotsList[i],
                decepticon: decepticonsList[i]
            )
            battleList.append(battleModel)
        }

        showList(battleList: battleList)
    }

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

        if battleResultByName.winningTeam != .battlesContinue {
            battleResult = battleResultByName

        } else if battleResultByCourageAndStrength.winningTeam != .battlesContinue {
            battleResult = battleResultByCourageAndStrength

        } else if battleResultBySkill.winningTeam != .battlesContinue {
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
            battleResult: battleResult,
            oddCell: false
        )
    }

    func checkTransformersName(
        autobot: Transformer,
        decepticon: Transformer
    ) -> AppConstants.BusinessLogic.BattleResult {

        if autobot.name == decepticon.name {
            return AppConstants.BusinessLogic.BattleResult.allDestroyed

        } else if autobot.name == AppConstants.BusinessLogic.autobotBoss &&
                  decepticon.name == AppConstants.BusinessLogic.decepticonBoss {
            return AppConstants.BusinessLogic.BattleResult.allDestroyed

        } else if autobot.name == AppConstants.BusinessLogic.autobotBoss {
            return AppConstants.BusinessLogic.BattleResult.autobotWon

        } else if decepticon.name == AppConstants.BusinessLogic.decepticonBoss {
            return AppConstants.BusinessLogic.BattleResult.decepticonWon

        } else {
            return AppConstants.BusinessLogic.BattleResult.battlesContinue
        }
    }

    func getBattleResultByName(autobot: Transformer, decepticon: Transformer) -> BattleResultModel {
        let resultByName = checkTransformersName(autobot: autobot, decepticon: decepticon)

        if resultByName == .autobotWon {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTeam: AppConstants.BusinessLogic.BattleResult.autobotWon
            )

        } else if resultByName == .decepticonWon {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTeam: AppConstants.BusinessLogic.BattleResult.decepticonWon
            )

        } else {
            return AppConstants.BusinessLogic.tiedBattleResult
        }
    }

    func getBattleResultByCourageAndStrength(autobot: Transformer, decepticon: Transformer) -> BattleResultModel {
        let autobotCourageDifference = autobot.courage - decepticon.courage
        let autobotStrengthDifference = autobot.strength - decepticon.strength

        let decepticonCourageDifference = decepticon.courage - autobot.courage
        let decepticonStrengthDifference = decepticon.strength - autobot.strength

        if autobotCourageDifference >= 4 && autobotStrengthDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTeam: AppConstants.BusinessLogic.BattleResult.autobotWon
            )

        } else if decepticonCourageDifference >= 4 && decepticonStrengthDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTeam: AppConstants.BusinessLogic.BattleResult.decepticonWon
            )

        } else {
            return AppConstants.BusinessLogic.tiedBattleResult
        }
    }

    func getBattleResultBySkill(autobot: Transformer, decepticon: Transformer) -> BattleResultModel {
        let autobotSkillDifference = autobot.skill - decepticon.skill
        let decepticonSkillDifference = decepticon.skill - autobot.skill

        if autobotSkillDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTeam: AppConstants.BusinessLogic.BattleResult.autobotWon
            )

        } else if decepticonSkillDifference >= 3 {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTeam: AppConstants.BusinessLogic.BattleResult.decepticonWon
            )

        } else {
            return AppConstants.BusinessLogic.tiedBattleResult
        }
    }

    func getBattleResultByOverall(
        autobot: Transformer,
        decepticon: Transformer,
        autobotOverall: Int,
        decepticonOverall: Int
    ) -> BattleResultModel {
        if autobotOverall > decepticonOverall {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                result: "\(autobot.name) won",
                resultColor: AppConstants.Color.redAutobot,
                winningTeam: AppConstants.BusinessLogic.BattleResult.autobotWon
            )
        } else {
            return BattleResultModel(
                autobotStatus: AppConstants.BusinessLogic.TransformerBattleStatus.defeated.rawValue,
                decepticonStatus: AppConstants.BusinessLogic.TransformerBattleStatus.victory.rawValue,
                result: "\(decepticon.name) won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTeam: AppConstants.BusinessLogic.BattleResult.decepticonWon
            )
        }
    }

    func printTransformersList(_ transformersList: [Transformer]) {
        print("===================================")
        for transformer in transformersList {
            print("team: \(transformer.team) name:\(transformer.name) rank:\(transformer.rank)")
        }
    }
}

// MARK: - Section Models
enum BattlesListSectionModel {
    case battleListSection(title: String, items: [BattleItem])
}

enum BattleItem {
    case battleItem(model: BattleModel)
}

extension BattlesListSectionModel: SectionModelType {
    typealias Item = BattleItem

    var items: [Item] {
        switch self {
        case .battleListSection(title: _, items: let items):
            return items
        }
    }

    init(original: BattlesListSectionModel, items: [Item]) {
        switch original {
        case let .battleListSection(title: title, items: _):
            self = .battleListSection(title: title, items: items)
        }
    }
}
