//
//  TransformerEditorViewController.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 16-05-21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// swiftlint:disable function_body_length

enum TransformerEditorOperation {
    case create
    case update
    case delete
}

class TransformerEditorViewController: UIViewController {

    // MARK: - Widgets

    @IBOutlet weak var nameTextField: UITextField!

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
    @IBOutlet weak var actionButton: UIButton!

    // MARK: - Class variables
    var viewModel: TransformerEditorViewModel
    let disposeBag = DisposeBag()
    let parentController: TransformersListViewController
    let operation: TransformerEditorOperation
    let model: Transformer

    // MARK: - ViewController Life Cycle

    init(
        parentController: TransformersListViewController,
        operation: TransformerEditorOperation,
        model: Transformer? = nil
    ) {
        self.parentController = parentController
        self.operation = operation
        self.model = model ?? AppConstants.emptyTransformer
        self.viewModel = TransformerEditorViewModel(operation: operation, transformer: model)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.setupUI()
        self.setupBinding()
    }

    // MARK: - UI

    func setupUI() {
        self.actionButton.layer.cornerRadius = 10
        self.actionButton.titleLabel?.font = .optimus(size: 20)

        if self.operation == .update {
            self.actionButton.setTitle(
                AppConstants.TransformerEditorViewController.actionButtonTitleUpdate,
                for: .normal
            )

            self.setFields()

            let deleteItem = UIBarButtonItem(
                barButtonSystemItem: .trash,
                target: self,
                action: #selector(deleteButtonTapped)
            )
            deleteItem.title = "Delete"
            deleteItem.tintColor = .white
            self.navigationItem.rightBarButtonItem = deleteItem

        } else {
            if parentController.color == AppConstants.Color.redAutobot {
                self.transformerTypeSegmentedControl.selectedSegmentIndex = 0
                setAppColor(color: AppConstants.Color.redAutobot)
            } else {
                self.transformerTypeSegmentedControl.selectedSegmentIndex = 1
                setAppColor(color: AppConstants.Color.purpleDecepticon)
            }
        }
    }

    func setFields() {
        self.nameTextField.text = self.model.name

        self.strengthSlider.value = Float(self.model.strength)
        self.intelligenceSlider.value = Float(self.model.intelligence)
        self.speedSlider.value = Float(self.model.speed)
        self.enduranceSlider.value = Float(self.model.endurance)
        self.rankSlider.value = Float(self.model.rank)
        self.courageSlider.value = Float(self.model.courage)
        self.firepowerSlider.value = Float(self.model.firepower)
        self.skillSlider.value = Float(self.model.skill)

        if self.model.team == AppConstants.BusinessLogic.autobotTeam {
            self.transformerTypeSegmentedControl.selectedSegmentIndex = 0
            setAppColor(color: AppConstants.Color.redAutobot)
        } else {
            self.transformerTypeSegmentedControl.selectedSegmentIndex = 1
            setAppColor(color: AppConstants.Color.purpleDecepticon)
        }
    }

    func setSlidersTintColor(color: UIColor) {
        self.strengthSlider.tintColor = color
        self.intelligenceSlider.tintColor = color
        self.speedSlider.tintColor = color
        self.enduranceSlider.tintColor = color
        self.rankSlider.tintColor = color
        self.courageSlider.tintColor = color
        self.firepowerSlider.tintColor = color
        self.skillSlider.tintColor = color
    }

    @IBAction func transformerTypeChanged(_ sender: Any) {
        if self.transformerTypeSegmentedControl.selectedSegmentIndex == 0 {
            setAppColor(color: AppConstants.Color.redAutobot)
        } else {
            setAppColor(color: AppConstants.Color.purpleDecepticon)
        }
    }

    func setAppColor(color: UIColor) {
        self.setSlidersTintColor(color: color)
        self.setActionButtonColor(color: color)
        self.parentController.color = color
        self.parentController.setupUI()
    }

    func setActionButtonColor(color: UIColor) {
        if self.nameTextField.text?.count ?? 0 > 0 {
            self.actionButton.isEnabled = true
            self.actionButton.backgroundColor = color
        } else {
            self.actionButton.isEnabled = false
            self.actionButton.backgroundColor = UIColor.lightGray
        }
    }

    func showTransformerCreationErrorAlert(message: String) {
        print("[TransformersListViewController] showTransformerCreationErrorAlert()")
        let refreshAlert = UIAlertController(
            title: AppConstants.TransformersListViewController.apiTokenFailedDialogTitle,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )

        refreshAlert.addAction(
            UIAlertAction(
                title: AppConstants.buttonOk,
                style: .default,
                handler: { (_: UIAlertAction!) in

                }
            )
        )

        present(refreshAlert, animated: true, completion: nil)
    }

    @objc func deleteButtonTapped() {
        print("[TransformersListViewController] deleteButtonTapped()")
        self.viewModel.deleteButtonTapped()
    }
}

extension TransformerEditorViewController {
    // MARK: - Rx functions

    /// Bind widgets to the viewmodel
    func setupBinding() {

        self.nameTextField.rx.value
            .subscribe(
                onNext: { _ in
                    let value = self.nameTextField.text
                    self.viewModel.nameTextFieldChanged(value: value ?? AppConstants.empty)
                }
            )
            .disposed(by: disposeBag)

        self.strengthSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.strengthSlider.value))
                    self.strengthValueLabel.text = String(value)
                    self.viewModel.strengthSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.intelligenceSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.intelligenceSlider.value))
                    self.intelligenceValueLabel.text = String(value)
                    self.viewModel.intelligenceSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.speedSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.speedSlider.value))
                    self.speedValueLabel.text = String(value)
                    self.viewModel.speedSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.enduranceSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.enduranceSlider.value))
                    self.enduranceValueLabel.text = String(value)
                    self.viewModel.enduranceSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.rankSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.rankSlider.value))
                    self.rankValueLabel.text = String(value)
                    self.viewModel.rankSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.courageSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.courageSlider.value))
                    self.courageValueLabel.text = String(value)
                    self.viewModel.courageSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.firepowerSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.firepowerSlider.value))
                    self.firepowerValueLabel.text = String(value)
                    self.viewModel.firepowerSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.skillSlider.rx.value
            .subscribe(
                onNext: { _ in
                    self.view.endEditing(true)
                    let value = Int(round(self.skillSlider.value))
                    self.skillValueLabel.text = String(value)
                    self.viewModel.skillSliderChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.transformerTypeSegmentedControl.rx.value
            .subscribe(
                onNext: { _ in
                    let value = self.transformerTypeSegmentedControl.selectedSegmentIndex
                    self.viewModel.transformerTypeSegmentedControlChanged(value: value)
                }
            )
            .disposed(by: disposeBag)

        self.actionButton.rx.tap
            .subscribe(
                onNext: { _ in
                    self.viewModel.createButtonTapped()
                }
            )
            .disposed(by: disposeBag)

        self.viewModel.output.gotRequestSuccess
            .drive(
                onNext: { [weak self] _ in
                    self?.parentController.viewModel.getTransformersList()
                    self?.navigationController?.popViewController(animated: true)
                }
            ).disposed(by: disposeBag)

        self.viewModel.output.gotRequestError
            .drive(
                onNext: { [weak self] errorType in
                    self?.showTransformerCreationErrorAlert(message: errorType.rawValue)
                }
            ).disposed(by: disposeBag)
    }
}

extension TransformerEditorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        setActionButtonColor(color: parentController.color)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
