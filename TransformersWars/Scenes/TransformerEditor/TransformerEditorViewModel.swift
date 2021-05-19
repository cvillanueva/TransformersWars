//
//  TransformerEditorViewModel.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 16-05-21.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import Action

// swiftlint:disable identifier_name

class TransformerEditorViewModel {

    // MARK: - I/O
    struct Input {}

    struct Output {
        let gotRequestSuccess: Driver<Bool>
        let gotRequestError: Driver<AppConstants.ApiRequestEditionError>
    }

    let input: Input
    let output: Output

    // MARK: - Subjects
    let _gotRequestSuccess = PublishSubject<Bool>()
    let _gotRequestError = PublishSubject<AppConstants.ApiRequestEditionError>()

    // MARK: - Class variables

    private let disposeBag = DisposeBag()
    var transformerModel = AppConstants.emptyTransformer
    var operation: TransformerEditorOperation

    init(operation: TransformerEditorOperation, transformer: Transformer? = nil) {
        print("[TransformerEditorViewModel] init()")
        self.operation = operation

        if let model = transformer {
            self.transformerModel = model
        }

        input = Input()

        output = Output(
            gotRequestSuccess: _gotRequestSuccess.asDriver(onErrorJustReturn: false),
            gotRequestError: _gotRequestError.asDriver(onErrorJustReturn: .transformerCreationError)
        )
    }

    // MARK: - Binding

    func nameTextFieldChanged(value: String) {
        self.transformerModel.name = value
    }

    func strengthSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] strengthSliderChanged() value:\(value)")
        self.transformerModel.strength = value
    }

    func intelligenceSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] intelligenceSliderChanged() value:\(value)")
        self.transformerModel.intelligence = value
    }

    func speedSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] speedSliderChanged() value:\(value)")
        self.transformerModel.speed = value
    }

    func enduranceSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] enduranceSliderChanged() value:\(value)")
        self.transformerModel.endurance = value
    }

    func rankSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] rankSliderChanged() value:\(value)")
        self.transformerModel.rank = value
    }

    func courageSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] courageSliderChanged() value:\(value)")
        self.transformerModel.courage = value
    }

    func firepowerSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] firepowerSliderChanged() value:\(value)")
        self.transformerModel.firepower = value
    }

    func skillSliderChanged(value: Int) {
        print("[TransformerEditorViewModel] skillSliderChanged() value:\(value)")
        self.transformerModel.skill = value
    }

    func transformerTypeSegmentedControlChanged(value: Int) {
        print("[TransformerEditorViewModel] transformerTypeSegmentedControlChanged() value:\(value)")

        if value == 0 {
            print("[TransformerEditorViewModel] transformerTypeSegmentedControlChanged() AUTOBOT")
            self.transformerModel.team = AppConstants.BusinessLogic.autobotTeam
        } else {
            print("[TransformerEditorViewModel] transformerTypeSegmentedControlChanged() DECEPTICON")
            self.transformerModel.team = AppConstants.BusinessLogic.decepticonTeam
        }

    }

    func createButtonTapped() {
        print("[TransformerEditorViewModel] createButtonTapped()")
        if self.operation == .create {
            self.requestTransformerCreation(model: self.transformerModel)
        } else if self.operation == .update {
            self.requestTransformerUpdate(model: self.transformerModel)
        }
    }

    func deleteButtonTapped() {
        print("[TransformerEditorViewModel] deleteButtonTapped()")
        self.requestTransformerDelete(model: self.transformerModel)
    }
}

extension TransformerEditorViewModel: RequestTransformerCreationProtocol {

    // MARK: - RequestTransformerCreationProtocol implementation

    /// Requests the creation of a transformer
    /// - Parameter model: A transformer model object
    func requestTransformerCreation(model: Transformer) {
        _ = RequestTransformerCreation(
            delegate: self,
            apiToken: AppStorage.getApiToken(),
            model: model
        )
    }

    /// Triggered when the call success
    func serverCreatedTransformer() {
        print("[TransformerEditorViewModel] serverCreatedTransformer()")
        self._gotRequestSuccess.onNext(true)
    }

    /// Triggered when the call failes
    /// - Parameter errorType: The error type
    func serverErrorHappened(errorType: AppConstants.ApiRequestEditionError) {
        print("[TransformerEditorViewModel] serverErrorHappened()")
        self._gotRequestError.onNext(errorType)
    }
}

extension TransformerEditorViewModel: RequestTransformerUpdateProtocol {

    // MARK: - RequestTransformerUpdateProtocol implementation

    /// Requests the update of a transformer
    /// - Parameter model: A transformer model object
    func requestTransformerUpdate(model: Transformer) {
        _ = RequestTransformerUpdate(
            delegate: self,
            apiToken: AppStorage.getApiToken(),
            model: model
        )
    }

    /// Triggered when the call success
    func serveUpdatedTransformer() {
        self._gotRequestSuccess.onNext(true)
    }
}

extension TransformerEditorViewModel: RequestTransformerDeleteProtocol {

    // MARK: - RequestTransformerUpdateProtocol implementation

    /// Requests the delete of a transformer
    /// - Parameter model: A transformer model object
    func requestTransformerDelete(model: Transformer) {
        _ = RequestTransformerDelete(
            delegate: self,
            apiToken: AppStorage.getApiToken(),
            model: model
        )
    }

    /// Triggered when the call success
    func serveDeletedTransformer() {
        self._gotRequestSuccess.onNext(true)
    }
}
