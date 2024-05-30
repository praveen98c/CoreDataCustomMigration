//
//  AppLocalization.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-06-04.
//

import Foundation

class AppLocalization {
    
    private static let tableName = "AppLocalization"
    
    static var students: String {
        String(localized: "students", table: AppLocalization.tableName)
    }
    
    static var unknown: String {
        String(localized: "unknown", table: AppLocalization.tableName)
    }
    
    static var details: String {
        String(localized: "details", table: AppLocalization.tableName)
    }
    
    static var studentId: String {
        String(localized: "studentId", table: AppLocalization.tableName)
    }
    
    static var enterName: String {
        String(localized: "enterName", table: AppLocalization.tableName)
    }
    
    static var enterAge: String {
        String(localized: "enterAge", table: AppLocalization.tableName)
    }
    
    static var enterEmail: String {
        String(localized: "enterEmail", table: AppLocalization.tableName)
    }
    
    static var enterDOB: String {
        String(localized: "enterDOB", table: AppLocalization.tableName)
    }
    
    static var submit: String {
        String(localized: "submit", table: AppLocalization.tableName)
    }
    
    static var update: String {
        String(localized: "update", table: AppLocalization.tableName)
    }
    
    static var courses: String {
        String(localized: "courses", table: AppLocalization.tableName)
    }
    
    static var enterCourseName: String {
        String(localized: "enterCourseName", table: AppLocalization.tableName)
    }
    
    static var enrollments: String {
        String(localized: "enrollments", table: AppLocalization.tableName)
    }
    
    static var addEnrollment: String {
        String(localized: "addEnrollment", table: AppLocalization.tableName)
    }
    
    static var enterGrade: String {
        String(localized: "enterGrade", table: AppLocalization.tableName)
    }
    
    static var enterEnrollmentDate: String {
        String(localized: "enterEnrollmentDate", table: AppLocalization.tableName)
    }
    
    static var enterDescription: String {
        String(localized: "enterDescription", table: AppLocalization.tableName)
    }
}
