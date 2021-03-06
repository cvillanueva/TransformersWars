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
// swiftlint: function_body_length

class TransformersListViewModel {

    // MARK: - I/O
    struct Input {}

    struct Output {
        let transformersItems: Driver<[TransformersListSectionModel]>
        let gotRequestError: Driver<AppConstants.ApiRequestError>
        let dissmissFetchingAlert: Driver<Bool>
    }

    let input: Input
    let output: Output

    // MARK: - Subjects
    let _transformersItems = BehaviorRelay<[TransformersListSectionModel]>(value: [])
    let _gotRequestError = PublishSubject<AppConstants.ApiRequestError>()
    let _dissmissFetchingAlert = PublishSubject<Bool>()

    // MARK: - Sections

    var transformersItems: [TransformersListSectionModel] {
        get {
            _transformersItems.value
        }
        set {
            _transformersItems.accept(newValue)
        }
    }

    // MARK: - Class variables
    let disposeBag = DisposeBag()
    var gotRequestError = false
    var transformersList: [Transformer] = []

    init() {
        print("[TransformersListViewModel] init()")
        input = Input()
        output = Output(
            transformersItems: _transformersItems.asDriver(),
            gotRequestError: _gotRequestError.asDriver(onErrorJustReturn: .apiTokenNetworkIsNotReachable),
            dissmissFetchingAlert: _dissmissFetchingAlert.asDriver(onErrorJustReturn: false)
        )
        transformersItems = [.transformersListSection(title: AppConstants.empty, items: [])]
    }

    func fillTableWithMockData() {
        let autobot = Transformer(
            identifier: AppConstants.noID,
            name: "Inferno",
            strength: 5,
            intelligence: 6,
            speed: 7,
            endurance: 8,
            rank: 9,
            courage: 10,
            firepower: 9,
            skill: 8,
            team: AppConstants.BusinessLogic.autobotTeam,
            teamIcon: "no_icon"
        )

        let decepticon = Transformer(
            identifier: AppConstants.noID,
            name: "Starscream",
            strength: 5,
            intelligence: 6,
            speed: 7,
            endurance: 8,
            rank: 9,
            courage: 10,
            firepower: 9,
            skill: 8,
            team: AppConstants.BusinessLogic.decepticonTeam,
            teamIcon: "no_icon"
        )

        let transformersList: [Transformer] = [autobot, decepticon, autobot, autobot, decepticon, decepticon]
        showList(transformersList: transformersList)
    }

    func showList(transformersList: [Transformer]) {
        print("[TransformersListViewModel] showList()")
        var section: TransformersListSectionModel = .transformersListSection(title: AppConstants.empty, items: [])
        var currentTransformersItems: [TransformerItem] = []
        var oddCounter = 0

        for transformer in transformersList {
            var model = transformer
            print("[TransformersListViewModel] showList() model.identifier:\(model.identifier)")
            model.oddCell = oddCounter % 2 == 0

            if transformer.team == AppConstants.BusinessLogic.autobotTeam {
                currentTransformersItems.append(.autobotItem(model: model))
            } else {
                currentTransformersItems.append(.decepticonItem(model: model))
            }
            oddCounter += 1
        }

        section = .transformersListSection(
            title: AppConstants.empty,
            items: currentTransformersItems
        )

        transformersItems[0] = section
    }
}

// MARK: - Section Models
enum TransformersListSectionModel {
    case transformersListSection(title: String, items: [TransformerItem])
}

enum TransformerItem {
    case autobotItem(model: Transformer)
    case decepticonItem(model: Transformer)
}

extension TransformersListSectionModel: SectionModelType {
    typealias Item = TransformerItem

    var items: [Item] {
        switch self {
        case .transformersListSection(title: _, items: let items):
            return items
        }
    }

    init(original: TransformersListSectionModel, items: [Item]) {
        switch original {
        case let .transformersListSection(title: title, items: _):
            self = .transformersListSection(title: title, items: items)
        }
    }
}

extension TransformersListViewModel: RequestApiTokenProtocol {

    // MARK: API token requesting logic

    func checkApiToken() {
        let apiToken = AppStorage.getApiToken()
        if apiToken != AppConstants.empty {
            print("[TransformersListViewModel] checkApiToken() apiToken:\(apiToken)")
            self.getTransformersList(apiToken)
        } else {
            self.getAPiToken()
        }

    }

    func getAPiToken() {
        _ = RequestApiToken(delegate: self)
    }

    func receivedToken(token: String) {
        AppStorage.storeApiToken(token: token)
        print("[TransformersListViewModel] receivedToken() calling transformers list")
        self.checkApiToken()
    }

    func serverErrorHappened(errorType: AppConstants.ApiRequestError) {
        print("[TransformersListViewModel] serverErrorHappened()")
        self._gotRequestError.onNext(errorType)
    }
}

extension TransformersListViewModel: RequestTransformersListProtocol {

    func getTransformersList(_ apiToken: String = AppStorage.getApiToken()) {
        _ = RequestTransformersList(delegate: self, apiToken: apiToken)
    }

    func receivedData(transformersList: [Transformer]) {
        self._dissmissFetchingAlert.onNext(true)
        self.transformersList = transformersList
        showList(transformersList: transformersList)
    }
}
