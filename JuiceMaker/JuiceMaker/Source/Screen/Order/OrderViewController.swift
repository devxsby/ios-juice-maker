//
//  JuiceMaker - OrderViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

protocol OrderDelegate: AnyObject {
    func syncFruitStocks()
}

final class OrderViewController: UIViewController, OrderDelegate {
    private let fruitStore = FruitStore.shared
    private let juiceMaker = JuiceMaker()
    weak var delegate: OrderDelegate?
    
    @IBOutlet private var fruitCountLabels: [UILabel]!
    @IBOutlet private var juiceOrderButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncFruitStocks()
        fruitStore.orderDelegate = self
    }
    
    @IBAction private func orderButtonDidTap(_ sender: UIButton) {
        let juice = Juice.allCases[safe: sender.tag]
        let menu = String(sender.titleLabel?.text?.dropLast(5) ?? "")
        guard let juice,
              juiceMaker.isMakable(menu: juice) else {
            presentFailAlert()
            return
        }
        juiceMaker.startBlending(of: juice)
        presentSuccessAlert(menu: menu)
    }
    
    @IBAction private func editStockButtonDidTap(_ sender: Any) {
        presentStockViewController()
    }
    
    func syncFruitStocks() {
        Fruits.allCases.enumerated().forEach {
            guard let label = fruitCountLabels[safe: $0.0] else { return }
            label.text = String(fruitStore.count(of: $0.1))
        }
        Juice.allCases.enumerated().forEach {
            guard let button = juiceOrderButtons[safe: $0.0] else { return }
            if !juiceMaker.isMakable(menu: $0.1) {
                button.backgroundColor = .lightGray
            }
        }
    }
    
    private func presentSuccessAlert(menu: String) {
        let alert = UIAlertController(title: "\(menu)쥬스 나왔습니다!",
                                      message: "맛있게 드세요!",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentFailAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "재료가 모자라요.\n재고를 수정할까요?",
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "예", style: .default, handler: { _ in
            self.presentStockViewController()
        })
        let close = UIAlertAction(title: "아니요", style: .destructive)
        
        alert.addAction(confirm)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentStockViewController() {
        guard let storeVC = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier:"StoreViewController") as? StoreViewController else { return }
        let storeNav = UINavigationController(rootViewController: storeVC)
        self.present(storeNav, animated: true)
    }
}
