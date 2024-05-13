//
//  CoursesScreen.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-16.
//

import Foundation
import SwiftUI

struct CoursesScreen: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var courses: FetchedResults<Course>
    
    var body: some View {
        NavigationStack {
            VStack {
                List(courses) { course in
                    NavigationLink(destination: CourseAddScreen(course: course)) {
                        Text(course.name ?? AppLocalization.unknown)
                    }
                }
                .navigationBarItems(trailing:
                                        NavigationLink(value: "1", label: {
                    Image(systemName: "plus")
                })
                )
            }.navigationDestination(for: String.self) { value in
                CourseAddScreen()
            }
            .navigationBarTitle(AppLocalization.courses, displayMode: .inline)
        }
    }
}

struct CourseAddScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    
    @State private var name = ""
    private var course: Course?
    
    init(course: Course) {
        self.course = course
        _name = State(initialValue: course.name ?? "")
    }
    
    init(){}
    
    var body: some View {
        VStack(alignment: .leading) {
            InputView(label: AppLocalization.enterCourseName, value: $name)
            Button(course == nil ? AppLocalization.submit : AppLocalization.update) {
                updateCourse()
                self.presentationMode.wrappedValue.dismiss()
            }
            .submitBtnStyle()
            Spacer()
        }
        .padding()
    }
    
    private func updateCourse() {
        let course = course ?? Course(context: moc)
        course.name = name
    }
}
