//
//  TransformersBattleModelTests.swift
//  TransformersWarsTests
//
//  Created by Claudio Emilio Villanueva Albornoz on 19-05-21.
//

import XCTest
@testable import TransformersWars

class TransformersBattleModelTests: XCTestCase {

    var transformersList: [Transformer]?
    var transformersBattleModel: TransformersBattleModel?

    let optimusPrime = Transformer(
        identifier: AppConstants.noID,
        name: AppConstants.BusinessLogic.autobotBoss,
        strength: 5,
        intelligence: 5,
        speed: 5,
        endurance: 5,
        rank: 5,
        courage: 5,
        firepower: 5,
        skill: 5,
        team: AppConstants.BusinessLogic.autobotTeam,
        teamIcon: AppConstants.empty
    )

    let predaking = Transformer(
        identifier: AppConstants.noID,
        name: AppConstants.BusinessLogic.decepticonBoss,
        strength: 5,
        intelligence: 5,
        speed: 5,
        endurance: 5,
        rank: 5,
        courage: 5,
        firepower: 5,
        skill: 5,
        team: AppConstants.BusinessLogic.decepticonTeam,
        teamIcon: AppConstants.empty
    )

    let jazz = Transformer(
        identifier: AppConstants.noID,
        name: "Jazz",
        strength: 5,
        intelligence: 5,
        speed: 5,
        endurance: 5,
        rank: 5,
        courage: 5,
        firepower: 5,
        skill: 8,
        team: AppConstants.BusinessLogic.autobotTeam,
        teamIcon: AppConstants.empty
    )

    let starscream = Transformer(
        identifier: AppConstants.noID,
        name: "Starscream",
        strength: 9,
        intelligence: 5,
        speed: 5,
        endurance: 5,
        rank: 5,
        courage: 9,
        firepower: 5,
        skill: 8,
        team: AppConstants.BusinessLogic.decepticonTeam,
        teamIcon: AppConstants.empty
    )

    let soundWave = Transformer(
        identifier: AppConstants.noID,
        name: "Sound Wave",
        strength: 5,
        intelligence: 5,
        speed: 5,
        endurance: 5,
        rank: 5,
        courage: 9,
        firepower: 5,
        skill: 4,
        team: AppConstants.BusinessLogic.decepticonTeam,
        teamIcon: AppConstants.empty
    )

    let prowl = Transformer(
        identifier: AppConstants.noID,
        name: "Prowl",
        strength: 5,
        intelligence: 5,
        speed: 5,
        endurance: 5,
        rank: 5,
        courage: 9,
        firepower: 5,
        skill: 6,
        team: AppConstants.BusinessLogic.autobotTeam,
        teamIcon: AppConstants.empty
    )

    override func setUp() {

        transformersList = []
        transformersList?.append(optimusPrime)
        transformersList?.append(starscream)

        transformersBattleModel = TransformersBattleModel(transformersList: transformersList ?? [])
    }

    override func tearDown() {
        transformersList = nil
        transformersBattleModel = nil
    }

    func testCheckTransformersNameBattleContinues() {
        let check = transformersBattleModel?.checkTransformersName(
            autobot: jazz,
            decepticon: starscream
        )

        if check == .battlesContinue {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testBattleResultByNameBossWin() {
        let battleResult = transformersBattleModel?.getBattleResultByName(
            autobot: optimusPrime,
            decepticon: starscream
        )

        if battleResult?.victoryCriteria == .victoryByName {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testBattleResultByNameBossAllDestroyed() {
        let battleResult = transformersBattleModel?.getBattleResultByName(
            autobot: optimusPrime,
            decepticon: predaking
        )

        if battleResult?.victoryCriteria == .victoryByName &&
            battleResult?.result == AppConstants.TransformersBattleViewController.allDestroyed {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testNotBattleResultByName() {
        let battleResult = transformersBattleModel?.getBattleResultByName(
            autobot: jazz,
            decepticon: starscream
        )

        if battleResult?.victoryCriteria != .victoryByName {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testBattleResultByCourageAndStrength() {
        let battleResult = transformersBattleModel?.getBattleResultByCourageAndStrength(
            autobot: jazz,
            decepticon: starscream
        )

        if battleResult?.victoryCriteria == .victoryByCourageAndStrength &&
            battleResult?.winningTransformerType == .decepticonWon {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testBattleResultBySkill() {
        let battleResult = transformersBattleModel?.getBattleResultBySkill(
            autobot: jazz,
            decepticon: soundWave
        )

        if battleResult?.victoryCriteria == .victoryBySkill &&
            battleResult?.winningTransformerType == .autobotWon {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

    func testBattleResultByOverall() {
        let autobotOverall = prowl.courage + prowl.strength + prowl.skill + prowl.speed +
            prowl.endurance + prowl.firepower + prowl.intelligence + prowl.rank

        let decepticonOverall = soundWave.courage + soundWave.strength + soundWave.skill + soundWave.speed +
            soundWave.endurance + soundWave.firepower + soundWave.intelligence + soundWave.rank

        let battleResult = transformersBattleModel?.getBattleResultByOverall(
            autobot: prowl,
            decepticon: soundWave,
            autobotOverall: autobotOverall,
            decepticonOverall: decepticonOverall
        )

        if battleResult?.victoryCriteria == .victoryByOverall &&
            battleResult?.winningTransformerType == .autobotWon {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
}
