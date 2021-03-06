//
//  TypeInstanceCache.swift
//  FastAdapter
//
//  Created by Fabian Terhorst on 12.07.18.
//  Copyright © 2018 everHome. All rights reserved.
//

public class TypeInstanceCache<Itm: Item> {
    weak var fastAdapter: FastAdapter<Itm>?
    
    var typeInstances = [String: Itm]()
    
    var supplementaryViewTypeInstances = [String: [String: Itm]]()
    
    public init() {
    }
    
    public func register(items: [Itm]) -> Bool {
        var allRegistered = true
        for item in items {
            if !register(item: item) {
                allRegistered = false
            }
        }
        return allRegistered
    }
    
    public func register(item: Itm) -> Bool {
        let typeId = item.getType()
        if typeInstances.index(forKey: typeId) == nil {
            typeInstances[typeId] = item
            _register(typeId: typeId, item: item)
            return true
        }
        return false
    }
    
    public func register(item: Itm, forSupplementaryViewOfKind: String) -> Bool {
        let typeId = item.getType()
        let typeInstances = supplementaryViewTypeInstances[forSupplementaryViewOfKind]
        if typeInstances == nil {
            supplementaryViewTypeInstances[forSupplementaryViewOfKind] = [String: Itm]()
        }
        if typeInstances?.index(forKey: typeId) == nil {
            supplementaryViewTypeInstances[forSupplementaryViewOfKind]?[typeId] = item
            _register(typeId: typeId, item: item, forSupplementaryViewOfKind: forSupplementaryViewOfKind)
            return true
        }
        return false
    }
    
    private func _register(typeId: String, item: Itm) {
        if let listView = fastAdapter?.listView {
            if let nib = item.getNib() {
                listView.registerCell(nib, forCellWithReuseIdentifier: typeId)
            } else {
                listView.registerCell(item.getViewClass(), forCellWithReuseIdentifier: typeId)
            }
        }
    }
    
    private func _register(typeId: String, item: Itm, forSupplementaryViewOfKind: String) {
        if let listView = fastAdapter?.listView {
            if let nib = item.getNib() {
                listView.registerCell(nib, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: typeId)
            } else {
                listView.registerCell(item.getViewClass(), forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: typeId)
            }
        }
    }
    
    public subscript(typeId: String) -> Item? {
        return typeInstances[typeId]
    }
    
    func clear() {
        typeInstances.removeAll()
        supplementaryViewTypeInstances.removeAll()
    }
    
    func renew() {
        var registeredCells = fastAdapter?.listView?.registeredCells
        for (typeId, item) in typeInstances {
            if registeredCells == nil || registeredCells?.contains(typeId) == false {
                if registeredCells == nil {
                    registeredCells = Set<String>()
                }
                registeredCells?.insert(typeId)
                _register(typeId: typeId, item: item)
            }
        }
        fastAdapter?.listView?.registeredCells = registeredCells
        for (kind, typeInstances) in supplementaryViewTypeInstances {
            for (typeId, item) in typeInstances {
                _register(typeId: typeId, item: item, forSupplementaryViewOfKind: kind)
            }
        }
    }
}
