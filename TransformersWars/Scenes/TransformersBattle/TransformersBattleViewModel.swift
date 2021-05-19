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
            battleResultModel: BattleResultModel(
                autobotStatus: "Victory", decepticonStatus: "Defeated", result: "Potatobot Won",
                resultColor: AppConstants.Color.redAutobot,
                winningTransformerType: AppConstants.BattleResult.autobotWon,
                victoryCriteria: .victoryByName
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
            battleResultModel: BattleResultModel(
                autobotStatus: "Defeated", decepticonStatus: "Victory", result: "Flaitetron Won",
                resultColor: AppConstants.Color.purpleDecepticon,
                winningTransformerType: AppConstants.BattleResult.decepticonWon,
                victoryCriteria: .victoryByOverall
            ),
            oddCell: false
        )

        let battleList: [BattleModel] = [battle1, battle2]
        showList(battleList: battleList, generalResultParam: AppConstants.emptyGeneralResult)
    }

    func showList(battleList: [BattleModel], generalResultParam: GeneralResultModel) {
        print("[BattlesListViewModel] showList()")
        var generalResult = generalResultParam

        var section: BattlesListSectionModel = .battleListSection(title: AppConstants.empty, items: [])
        var currentBattlesItems: [BattleItem] = []
        var oddCounter = 0

        for battle in battleList {
            var model = battle
            print("[BattlesListViewModel] showList() \(model.autobotName) VS \(model.decepticonName)")
            model.oddCell = oddCounter % 2 == 0

            if model.decepticonName == AppConstants.empty {
                currentBattlesItems.append(.autobotSkippedBattleItem(model: model))

            } else if model.autobotName == AppConstants.empty {
                currentBattlesItems.append(.decepticonSkippedBattleItem(model: model))

            } else {
                currentBattlesItems.append(.battleItem(model: model))
            }

            oddCounter += 1
        }

        generalResult.oddCell = oddCounter % 2 == 0
        let generalResultItem: BattleItem = .generalResult(model: generalResult)
        currentBattlesItems.append(generalResultItem)

        section = .battleListSection(
            title: AppConstants.empty,
            items: currentBattlesItems
        )

        battleItems[0] = section
    }

    func startBattle() {
        let transformersBattleModel = TransformersBattleModel(transformersList: transformersList)
        let (battleList, generalResult) = transformersBattleModel.execBattle()
        showList(battleList: battleList, generalResultParam: generalResult)
    }
}

// MARK: - Section Models
enum BattlesListSectionModel {
    case battleListSection(title: String, items: [BattleItem])
}

enum BattleItem {
    case battleItem(model: BattleModel)
    case autobotSkippedBattleItem(model: BattleModel)
    case decepticonSkippedBattleItem(model: BattleModel)
    case generalResult(model: GeneralResultModel)
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
