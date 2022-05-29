//
//  Adapter.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import CoreData

extension TunesItem {
    
    convenience init(from dbItem: DBITunesItem) {
        self.init(title: dbItem.title!,
                  id: dbItem.trackId!,
                  imageURL: dbItem.imageURI!)
    }
}

extension DBITunesItem {
    
    convenience init(context: NSManagedObjectContext, item: TunesItem) {
        self.init(context: context)
        self.imageURI = item.imageURL
        self.title = item.title
        self.trackId = item.id
    }
}
