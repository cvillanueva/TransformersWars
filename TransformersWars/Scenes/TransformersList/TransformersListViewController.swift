//
//  TransformersListViewController.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// swiftlint:disable force_cast

class TransformersListViewController: UIViewController {

    // MARK: - Widgets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fightButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var transformersTableView: UITableView!
    @IBOutlet weak var safeZoneView: UIView!

    // MARK: - Class variables
    var viewModel: TransformersListViewModel
    let disposeBag = DisposeBag()
    var color = AppConstants.Color.getRandomColor()

    init(
        viewModel: TransformersListViewModel = TransformersListViewModel()
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        self.setupBinding()

        self.viewModel.checkApiToken()
//        self.viewModel.fillTableWithMockData()
    }

    // MARK: - UI

    func setupUI() {
        self.title = AppConstants.TransformersListViewController.title

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.optimus(size: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = color
        self.bottomStackView.backgroundColor = color
        self.safeZoneView.backgroundColor = color

        self.addButton.titleLabel?.font = .optimus(size: 24)
        self.fightButton.titleLabel?.font = .optimus(size: 24)

        let backItem = UIBarButtonItem()
        backItem.title = AppConstants.TransformersListViewController.backButtonTitle
        backItem.tintColor = .white
        backItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.optimus(size: 20)],
            for: .normal
        )
        self.navigationItem.backBarButtonItem = backItem
    }

    func showApiTokenRequestErrorAlert(message: String) {
        print("[TransformersListViewController] showApiTokenRequestErrorAlert()")
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
                    self.viewModel.getAPiToken()
                }
            )
        )

        present(refreshAlert, animated: true, completion: nil)
    }

    func showTransformersListRequestErrorAlert(message: String) {
        print("[TransformersListViewController] showTransformersListRequestErrorAlert()")
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
                    self.viewModel.getTransformersList()
                }
            )
        )

        present(refreshAlert, animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        self.pushTransformerEditor(operation: .create)
    }

    func pushTransformerEditor(
        operation: TransformerEditorOperation,
        model: Transformer? = AppConstants.emptyTransformer
    ) {
        let transformerEditorViewController = TransformerEditorViewController(
            parentController: self,
            operation: operation,
            model: model
        )
        self.navigationController?.pushViewController(transformerEditorViewController, animated: true)
    }
}

extension TransformersListViewController {
    // MARK: - Rx functions

    /// To set table view properties
    func setupTableView() {
        transformersTableView.rx.setDelegate(self).disposed(by: disposeBag)

        transformersTableView.register(
            UINib(nibName: AppConstants.TransformersListViewController.autobotCellName, bundle: nil),
            forCellReuseIdentifier: AppConstants.TransformersListViewController.autobotCellName
        )

        transformersTableView.register(
            UINib(nibName: AppConstants.TransformersListViewController.decepticonCellName, bundle: nil),
            forCellReuseIdentifier: AppConstants.TransformersListViewController.decepticonCellName
        )
    }

    /// To listen changes in the viewmodel
    func setupBinding() {
        self.viewModel.output.transformersItems
            .drive(transformersTableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)

        self.transformersTableView.rx.modelSelected(TransformerItem.self)
            .subscribe(
                onNext: { [weak self] model in
                    switch model {
                    case .autobotItem(model: let model):
                        print("[TransformersListViewController] setupBinding() modelSelected:\(model)")
                        if let self = self {
                            self.pushTransformerEditor(operation: .update, model: model)
                        }
                    case .decepticonItem(model: let model):
                        print("[TransformersListViewController] setupBinding() modelSelected:\(model)")
                        if let self = self {
                            self.pushTransformerEditor(operation: .update, model: model)
                        }
                    }
                }
            ).disposed(by: disposeBag)

        self.viewModel.output.gotRequestError
            .drive(
                onNext: { [weak self] errorType in
                    switch errorType {
                    case .apiTokenNetworkIsNotReachable:
                        self?.showApiTokenRequestErrorAlert(message: errorType.rawValue)
                    case .apiTokenServerError:
                        self?.showApiTokenRequestErrorAlert(message: errorType.rawValue)
                    case .transformersListNetworkIsNotReachable:
                        self?.showTransformersListRequestErrorAlert(message: errorType.rawValue)
                    case .transformersListServerError:
                        self?.showTransformersListRequestErrorAlert(message: errorType.rawValue)
                    case .transformersListParsingError:
                        self?.showTransformersListRequestErrorAlert(message: errorType.rawValue)
                    }
                }
            ).disposed(by: disposeBag)
    }

    func dataSource() -> RxTableViewSectionedReloadDataSource<TransformersListSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<TransformersListSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ -> UITableViewCell in
                switch dataSource[indexPath] {
                case .autobotItem(model: let model):
//                    self.loadingAlert.dismiss(animated: true)
//                    self.fetchingData = false

                    let cell: AutobotTableViewCell = tableView.dequeueReusableCell(
                        withIdentifier: AppConstants.TransformersListViewController.autobotCellName,
                        for: indexPath
                    ) as! AutobotTableViewCell

                    cell.setup(model: model)

                    return cell
                case .decepticonItem(model: let model):
//                    self.loadingAlert.dismiss(animated: true)
//                    self.fetchingData = false

                    let cell: DecepticonTableViewCell = tableView.dequeueReusableCell(
                        withIdentifier: AppConstants.TransformersListViewController.decepticonCellName,
                        for: indexPath
                    ) as! DecepticonTableViewCell

                    cell.setup(model: model)

                    return cell
                }
            }
        )
        return dataSource
    }
}

extension TransformersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.TransformersListViewController.transformerCellHeight
    }
}
