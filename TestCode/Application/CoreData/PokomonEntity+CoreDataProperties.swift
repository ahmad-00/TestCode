//
//  PokomonEntity+CoreDataProperties.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/9/21.
//
//

import Foundation
import CoreData


extension PokomonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokomonEntity> {
        return NSFetchRequest<PokomonEntity>(entityName: "PokomonEntity")
    }

    @NSManaged public var ability: String
    @NSManaged public var id: Int32
    @NSManaged public var image: String
    @NSManaged public var name: String

}

extension PokomonEntity : Identifiable {

}
