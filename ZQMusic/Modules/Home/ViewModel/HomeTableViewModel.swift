//
//  HomeTableViewModel.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import Foundation
import RxDataSources

struct RowViewModel: TableRowViewModelProtocol{
    var data: ItemModel
    
    func bind(cell: UIView) {
        
    }
    static func cellClass() -> AnyClass {
        return HomeMusicCell.self
    }
    init(data:ItemModel) {
        self.data = data
    }
}

struct SectionViewModel {
  var header: String
  var items: [Item]
}

extension SectionViewModel: SectionModelType {
  typealias Item = RowViewModel

   init(original: SectionViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
