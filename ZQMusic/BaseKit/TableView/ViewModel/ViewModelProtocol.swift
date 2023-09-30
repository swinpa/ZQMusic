//
//  ViewModelProtocol.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import Foundation

protocol TableRowViewModelProtocol {
    func bind(cell:UIView)->Void
    var identifier:String { get set }
    static var identifier:String { get set }
    static func cellClass() -> AnyClass
}
extension TableRowViewModelProtocol {
    var identifier:String {
        get{
            Self.identifier
        }
        set {}
    }
    static var identifier:String {
        get{
            NSStringFromClass(Self.cellClass())
        }
        set{}
    }
}
