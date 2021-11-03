//
//  ChooseNonprofitFlow.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation
import UIKit

public enum BKChooseNonprofitViewType {
    case fullScreen
    case widget
}

class BKChooseNonprofitFlow {
    
    var context: BKChooseNonprofitContext {
        return BeamKitContext.shared.chooseContext
    }
    var chooseVC: BKChooseNonprofitVC?
    
    func showChooseNonprofitVC(from presentingVC: UIViewController) {
        guard let trans = context.currentTransaction else {
            //todo something here
            return
        }
        chooseVC = BKChooseNonprofitVC(with: trans)
        guard let vc = chooseVC else { return } // todo add error
       // vc.modalPresentationStyle = .fullScreen
        presentingVC.present(vc, animated: true)
    }
    
    func navigateBack(from vc: UIViewController, completion: (() -> Void)? = nil) {
        vc.dismiss(animated: true, completion: completion)
    }
    
    func redeem(_ transaction: BKTransaction,
                nonprofit: BKNonprofit,
                from vc: UIViewController,
                completion: (() -> Void)? = nil) {
        transaction.chosenNonprofit = nonprofit
        context.currentTransaction = transaction
        DispatchQueue.main.async {
            self.navigateBack(from: vc, completion: completion)
        }
    }
    
    func complete(_ transaction: BKTransaction, _ completion: ((Int?, BeamError) -> Void)? = nil) {
        context.redeem(transaction: transaction) { returnedTrans, error in
          //  guard let `self` = self else { return }

            completion?(returnedTrans.id, error)
        }
    }
    
    func register(with userID: String? = nil, _ completion: ((BeamError) -> Void)? = nil) {

        context.register(with: userID, completion)
    }
    
    func favorite(nonprofit: BKNonprofit, from vc: UIViewController, completion: (() -> Void)? = nil) {
        context.favorite(nonprofit: nonprofit) { _ in
            DispatchQueue.main.async {
                self.navigateBack(from: vc, completion: completion)
            }
        }
    }
    
    func viewFavorite(_ completion: ((BK_INSFavoriteCopy?, BeamError) -> Void)? = nil) {
        context.viewFavorite(completion)
    }

}
