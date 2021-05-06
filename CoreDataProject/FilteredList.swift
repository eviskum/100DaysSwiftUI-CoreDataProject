//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Esben Viskum on 06/05/2021.
//

import SwiftUI
import CoreData

enum PredicateType {
    case beginsWidth
    case contains
    var predicate: String {
        switch self {
        case .beginsWidth:
            return "%K BEGINSWITH %@"
        case .contains:
            return "%K CONTAINS %@"
        }
    }
}

/*
struct FilteredList: View {
    var fetchRequest: FetchRequest<Singer>
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }
}
*/

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }
    
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }
    
    init(filterKey: String, filterValue: String, predicate: PredicateType, sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: predicate.predicate, filterKey, filterValue))
        self.content = content
    }
}
