//
//  NSObjectExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/22.
//

import Foundation
@_exported import RxSwift
@_exported import RxCocoa

fileprivate let AssociatedKeyDisposeBag = UnsafeRawPointer(bitPattern: "AssociatedKey.rxDisposeBag".hash)!

extension NSObject {
    
    /// NSObject默认创建的`dispose bag`
    public var disposeBag: DisposeBag {
        get{
            if let disposeBag = objc_getAssociatedObject(self, AssociatedKeyDisposeBag) as? DisposeBag {
                return disposeBag
            } else {
                let disposeBag = DisposeBag()
                objc_setAssociatedObject(self,
                                         AssociatedKeyDisposeBag,
                                         disposeBag,
                                        .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeBag
            }
        }
        set {
            objc_setAssociatedObject(self,
                                     AssociatedKeyDisposeBag,
                                     newValue,
                                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
}
