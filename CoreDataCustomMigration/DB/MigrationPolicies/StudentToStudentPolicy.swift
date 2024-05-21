//
//  StudentToStudentPolicy.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-22.
//

import Foundation
import CoreData

class StudentToStudentPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sourceInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        guard let userInfo = mapping.userInfo,
              let sourceVersion = userInfo["sourceVersion"] as? String else {
            print("Error no source version")
            try super.createDestinationInstances(forSource: sourceInstance, in: mapping, manager: manager)
            return
        }
        
        // Get the source attribute keys and values
        let sourceAttributeKeys = Array(sourceInstance.entity.attributesByName.keys)
        let sourceAttributeValues = sourceInstance.dictionaryWithValues(forKeys: sourceAttributeKeys)
        
        // Create the destination Student instance
        let destinationInstance = NSEntityDescription.insertNewObject(forEntityName: "Student", into: manager.destinationContext)
        
        // Get the destination attribute keys
        let destinationAttributeKeys = Array(destinationInstance.entity.attributesByName.keys)
        
        // Set all those attributes of the destination instance which are the same as those of the source instance
        for key in destinationAttributeKeys {
            if let value = sourceAttributeValues[key] {
                destinationInstance.setValue(value, forKey: key)
            }
        }
        
        if sourceVersion == "ver1" {
            let sourceRelationshipKeys = Array(sourceInstance.entity.relationshipsByName.keys)
            let sourceRelationshipAttributeValues = sourceInstance.dictionaryWithValues(forKeys: sourceRelationshipKeys)
            let sourceCourses = sourceRelationshipAttributeValues["courses"]
            if let coursesSet = sourceCourses as? Set<NSManagedObject> {
                let studentEnrollments = destinationInstance.mutableSetValue(forKey: "enrollments")
                for course in Array(coursesSet) {
                    if let courseObjectId = course.value(forKey: "objectID") as? NSManagedObjectID {
                        let enrollment = NSEntityDescription.insertNewObject(forEntityName: "Enrollment", into: manager.destinationContext)
                        studentEnrollments.add(enrollment)
                        if let destinationCourse = try? manager.destinationContext.existingObject(with: courseObjectId){
                            enrollment.setValue(destinationCourse, forKey: "course")
                        }
                    }
                }
            }
        }
        
        manager.associate(sourceInstance: sourceInstance, withDestinationInstance: destinationInstance, for: mapping)
    }
}
