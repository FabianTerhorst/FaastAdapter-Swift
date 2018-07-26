//
//  Item.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

open class Item {
    
    public weak var fastAdapter: FastAdapter<Item>?
    
    open func getType() -> String {
        return String(describing: type(of: self))
    }
    
    open func getCell() -> AnyClass {
        return UICollectionViewCell.self
    }
    
    open func getNib() -> UINib? {
        return nil
    }
    
    open func onBind(indexPath: IndexPath, cell: inout ListViewCell) {
    }
    
    open func onBind(indexPath: IndexPath, view: inout (UIView & ListViewReusableView)) {
    }
    
    /**
     Return is only used to determinate if item is measurable. Unmeasureable items will be ignored.
    **/
    open func onMeasure(width: CGFloat?, height: CGFloat?) -> Bool {
        return false
    }
    
    //TODO: mabye also support nil return for also unmeasureable layouts, or return size in onMeasure and handle the getSize internally
    open func getSize() -> CGSize {
        return .zero
    }
    
    public init() {
        
    }
}
