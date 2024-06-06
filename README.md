This project demonstrates coredata custom migrations

```
- Tag 1.0: 1st version of the schema with Student and Course Entities
          Through the UI, the user can add Students, Courses and assign Courses to Students
- Tag 2.0: 2nd version of the schema with Student, Course and Enrollment Entities
          The database is mmigrated from Ver1 to Ver2 where the Course Entity is migrated using a Mapping Model, The Student and Enrollment Entities are migrated using Custom Migration Policy
- Tag 3.0: 3rd version of the schema with new Description attribute in Enrollment Entity
          The databasse is migrated using Mapping model
          Included core data iterative migration support (Eg:- Ver1 -> Ver2 -> Ver3)
```
