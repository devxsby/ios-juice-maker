//
//  JuiceMaker - StoreViewController.swift
//
//  Created by J.E on 2023/01/06.
//

import UIKit

protocol StoreDelegate: AnyObject {
    func syncFruitStocks()
}

final class StoreViewController: UIViewController, StoreDelegate {
    private let fruitStore = FruitStore.shared
    weak var delegate: StoreDelegate?
    
    @IBOutlet var fruitImageLabels: [UILabel]!
    @IBOutlet private var fruitStockLabels: [UILabel]!
    @IBOutlet private var fruitStockSteppers: [UIStepper]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncFruitStocks()
        fruitStore.storeDelegate = self
    }
    
    @IBAction private func stockStepperDidTap(_ sender: UIImageView) {
        guard let stepper = fruitStockSteppers[safe: sender.tag] else { return }
        guard let fruit = Fruits.allCases[safe: stepper.tag] else { return }
        fruitStore.changeStock(of: fruit, count: Int(stepper.value))
    }
    
    @IBAction private func fruitImageDidTap(_ sender: UIStepper) {
        guard let fruit = Fruits.allCases[safe: sender.tag] else { return }
        presentAlertAsking(bulkOf: fruit)
    }
    
    @IBAction private func confirmChangedStockButtonDidTap(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func syncFruitStocks() {
        Fruits.allCases.enumerated().forEach {
            let stock = fruitStore.count(of: $0.1)
            guard let label = fruitStockLabels[safe: $0.0] else { return }
            guard let stepper = fruitStockSteppers[safe: $0.0] else { return }
            label.text = String(stock)
            stepper.value = Double(stock)
        }
    }
    
    private func presentAlertAsking(bulkOf fruit: Fruits) {
        let alert = UIAlertController(title: "대량입고",
                                      message: "추가할 수량을 입력해 주세요.",
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.keyboardType = .numberPad
            field.returnKeyType = .done
        }
        let confirm = UIAlertAction(title: "예", style: .default, handler: { _ in
            guard let field = alert.textFields?[0] else { return }
            let amount = Int(field.text ?? "0") ?? 0
            self.fruitStore.increase(of: fruit, amount: amount)
        })
        let close = UIAlertAction(title: "아니요", style: .destructive)
        
        alert.addAction(confirm)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
}
