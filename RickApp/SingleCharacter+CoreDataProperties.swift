//
//  SingleCharacter+CoreDataProperties.swift
//  lab04hw
//
//  Created by Никита Зорин on 07.07.2023.
//
//

import Foundation
import CoreData


extension SingleCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleCharacter> {
        return NSFetchRequest<SingleCharacter>(entityName: "SingleCharacter")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var gender: String?
    @NSManaged public var location: String?

}

extension SingleCharacter : Identifiable {

}
