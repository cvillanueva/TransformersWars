//
//  TransformersListViewModel.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

// swiftlint:disable identifier_name

class TransformersListViewModel {

    // MARK: - I/O
    struct Input {}

    struct Output {
        let newsItems: Driver<[NewsListSectionModel]>
        let gotApiRequestError: Driver<AppConstants.ApiRequestError>
    }

    let input: Input
    let output: Output

    // MARK: - Subjects
    let _newsItems = BehaviorRelay<[NewsListSectionModel]>(value: [])
    let _gotApiRequestError = PublishSubject<AppConstants.ApiRequestError>()

    // MARK: - Sections

    var newsItems: [NewsListSectionModel] {
        get {
            _newsItems.value
        }
        set {
            _newsItems.accept(newValue)
        }
    }

    // MARK: - Class variables
    let disposeBag = DisposeBag()
    var gotRequestError = false
    var newsList: [Transformer] = []

    init() {
        print("[TransformersListViewModel] init()")
        input = Input()
        output = Output(
            newsItems: _newsItems.asDriver(),
            gotApiRequestError: _gotApiRequestError.asDriver(onErrorJustReturn: .networkIsNotReachable)
        )
        newsItems = [.newsListSection(title: AppConstants.empty, items: [])]
    }

    func fillTableWithMockData() {
        print("[TransformersListViewModel] fillTableWithMockData()")
        let transformer = Transformer(
            identifier: "no_id",
            name: "Inferno",
            strength: 5,
            intelligence: 6,
            speed: 7,
            endurance: 8,
            rank: 9,
            courage: 10,
            firepower: 9,
            skill: 8,
            team: "A",
            teamIcon: "no_icon"
        )

        var section: NewsListSectionModel = .newsListSection(title: AppConstants.empty, items: [])
        let transformersList: [Transformer] = [transformer, transformer, transformer, transformer]
        var currentNewsItems: [NewsItem] = []

        var oddCounter = 0
        for transformer in transformersList {
            currentNewsItems.append(
                .newsItem(
                    model: AutobotTableViewCellModel(
                        name: transformer.name,
                        strength: transformer.strength,
                        intelligence: transformer.intelligence,
                        speed: transformer.speed,
                        endurance: transformer.endurance,
                        rank: transformer.rank,
                        courage: transformer.courage,
                        firepower: transformer.firepower,
                        skill: transformer.skill,
                        team: transformer.team,
                        oddCell: oddCounter % 2 == 0
                    )
                )
            )
            oddCounter += 1
        }

        section = .newsListSection(
            title: AppConstants.empty,
            items: currentNewsItems
        )

        newsItems[0] = section
    }
}

// MARK: - Section Models
enum NewsListSectionModel {
    case newsListSection(title: String, items: [NewsItem])
}

enum NewsItem {
    case newsItem(model: AutobotTableViewCellModel)
}

extension NewsListSectionModel: SectionModelType {
    typealias Item = NewsItem

    var items: [Item] {
        switch self {
        case .newsListSection(title: _, items: let items):
            return items
        }
    }

    init(original: NewsListSectionModel, items: [Item]) {
        switch original {
        case let .newsListSection(title: title, items: _):
            self = .newsListSection(title: title, items: items)
        }
    }
}
