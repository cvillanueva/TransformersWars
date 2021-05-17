//
//  NewTransformerViewController.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 16-05-21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class NewTransformerViewController: UIViewController {

    // MARK: - Widgets

    @IBOutlet weak var strengthSlider: UISlider!
    @IBOutlet weak var intelligenceSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var enduranceSlider: UISlider!
    @IBOutlet weak var rankSlider: UISlider!
    @IBOutlet weak var courageSlider: UISlider!
    @IBOutlet weak var firepowerSlider: UISlider!
    @IBOutlet weak var skillSlider: UISlider!

    @IBOutlet weak var strengthValueLabel: UILabel!
    @IBOutlet weak var intelligenceValueLabel: UILabel!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var enduranceValueLabel: UILabel!
    @IBOutlet weak var rankValueLabel: UILabel!
    @IBOutlet weak var courageValueLabel: UILabel!
    @IBOutlet weak var firepowerValueLabel: UILabel!
    @IBOutlet weak var skillValueLabel: UILabel!

    @IBOutlet weak var transformerTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var createButton: UIButton!

    // MARK: - Class variables
    var viewModel: NewTransformerViewModel
    let disposeBag = DisposeBag()

    // MARK: - ViewController Life Cycle

    init(viewModel: NewTransformerViewModel = NewTransformerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.setupBinding()
    }

    // MARK: - UI

    func setupUI() {
        self.createButton.layer.cornerRadius = 10
        self.createButton.titleLabel?.font = .optimus(size: 20)
    }
}

extension NewTransformerViewController {
    // MARK: - Rx functions

    /// Bind widgets to the viewmodel
    func setupBinding() {

        self.strengthSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.strengthSlider.value))
                    self.strengthValueLabel.text = String(value)
                    self.viewModel.strengthSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.intelligenceSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.intelligenceSlider.value))
                    self.intelligenceValueLabel.text = String(value)
                    self.viewModel.intelligenceSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.speedSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.speedSlider.value))
                    self.speedValueLabel.text = String(value)
                    self.viewModel.speedSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.enduranceSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.enduranceSlider.value))
                    self.enduranceValueLabel.text = String(value)
                    self.viewModel.enduranceSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.rankSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.rankSlider.value))
                    self.rankValueLabel.text = String(value)
                    self.viewModel.rankSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.courageSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.courageSlider.value))
                    self.courageValueLabel.text = String(value)
                    self.viewModel.courageSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.firepowerSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.firepowerSlider.value))
                    self.firepowerValueLabel.text = String(value)
                    self.viewModel.firepowerSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.skillSlider.rx.value
            .subscribe(
                onNext: { _ in
                    let value = Int(round(self.skillSlider.value))
                    self.skillValueLabel.text = String(value)
                    self.viewModel.skillSliderChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.transformerTypeSegmentedControl.rx.value
            .subscribe(
                onNext: { _ in
                    let value = self.transformerTypeSegmentedControl.selectedSegmentIndex
                    self.viewModel.transformerTypeSegmentedControlChanged(
                        value: value
                    )
                }
            )
            .disposed(by: disposeBag)

        self.createButton.rx.tap
            .subscribe(
                onNext: { _ in
                    self.viewModel.createButtonTapped()
                }
            )
            .disposed(by: disposeBag)
    }
}
