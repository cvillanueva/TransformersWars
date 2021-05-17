//
//  NewTransformerViewModel.swift
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

class NewTransformerViewModel {

    // MARK: - I/O
    struct Input {}

    struct Output {
        let gotRequestError: Driver<AppConstants.ApiRequestError>
    }

    let input: Input
    let output: Output

    // MARK: - Subjects
    let _gotRequestError = PublishSubject<AppConstants.ApiRequestError>()

    // MARK: - Class variables

    private let disposeBag = DisposeBag()

    init() {
        print("[NewTransformerViewModel] init()")
        input = Input()
        output = Output(
            gotRequestError: _gotRequestError.asDriver(onErrorJustReturn: .transformersListNetworkIsNotReachable)
        )
    }

    func strengthSliderChanged(value: Int) {
        print("[NewTransformerViewModel] strengthSliderChanged() value:\(value)")
    }

    func intelligenceSliderChanged(value: Int) {
        print("[NewTransformerViewModel] intelligenceSliderChanged() value:\(value)")
    }

    func speedSliderChanged(value: Int) {
        print("[NewTransformerViewModel] speedSliderChanged() value:\(value)")
    }

    func enduranceSliderChanged(value: Int) {
        print("[NewTransformerViewModel] enduranceSliderChanged() value:\(value)")
    }

    func rankSliderChanged(value: Int) {
        print("[NewTransformerViewModel] rankSliderChanged() value:\(value)")
    }

    func courageSliderChanged(value: Int) {
        print("[NewTransformerViewModel] courageSliderChanged() value:\(value)")
    }

    func firepowerSliderChanged(value: Int) {
        print("[NewTransformerViewModel] firepowerSliderChanged() value:\(value)")
    }

    func skillSliderChanged(value: Int) {
        print("[NewTransformerViewModel] skillSliderChanged() value:\(value)")
    }

    func transformerTypeSegmentedControlChanged(value: Int) {
        print("[NewTransformerViewModel] transformerTypeSegmentedControlChanged() value:\(value)")
    }

    func createButtonTapped() {
        print("[NewTransformerViewModel] createButtonTapped()")
    }
}
