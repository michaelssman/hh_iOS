//
//  CoreDataHelper.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/19.
//

import Foundation
import CoreData

class CoreDataHelper: NSObject {
    enum TableName: String {
        case Teacher
        case Student
    }
    
    // 单例模式
    @objc static let shared = CoreDataHelper()
    
    private override init() {}
    
    // 获取持久化容器
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // 获取上下文
    //给数据管理器赋值
    //不需要重新初始化我们的数据管理器,一个项目中不可能存在2个数据库.
    @objc lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private func parseEntities(container: NSPersistentContainer) {
        let entities = container.managedObjectModel.entities
        print("Entities count = \(entities.count)\n")
        
        for entity in entities {
            print("Entity: \(entity.name!)")
            
            for property in entity.properties {
                print("Property: \(property.name)")
            }
            
            print("")
        }
    }
    
    
    // MARK: 插入数据
    @objc func insertData(name: String, address: String) -> Teacher {
        
        //第一种创建插入对象的方法
        let teacher: Teacher = NSEntityDescription.insertNewObject(forEntityName: TableName.Teacher.rawValue, into: context) as! Teacher
        teacher.name = name
        teacher.address = address
        
        for i in 0..<50 {
            //第二种创建插入对象方法
            let description: NSEntityDescription = NSEntityDescription.entity(forEntityName: TableName.Student.rawValue, in: context)!
            let student: Student = Student(entity: description, insertInto: context)
            
            student.name = "\(String(describing: teacher.name))老师的\(i)号学生"
            student.relationship = teacher
        }
        
        do {
            try context.save()
            return teacher
        } catch {
            print("Insert failed: \(error.localizedDescription)")
            return Teacher()
        }
    }
    
    //    // 更新数据
    //    func updateData(person: Person, name: String, age: Int16) {
    //        person.name = name
    //        person.age = age
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Update failed: \(error.localizedDescription)")
    //        }
    //    }
    
    // 查询数据 返回数组
    @objc func fetchTeachers() -> [Teacher] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Teacher>(entityName: TableName.Teacher.rawValue)
        
        //检索条件
        /*
         //如果需要  添加更多的检索条件需要用and 或者or 进行拼接.
         let name: String = "艾佛森"
         let age: Int = 18
         let predicate: NSPredicate = NSPredicate(format: "name == \(name) and age == \(age)")
         fetchRequest.predicate = predicate
         //排序
         fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
         //请求分页
         fetchRequest.fetchOffset = 30
         fetchRequest.fetchLimit = 20
         */
        
        do {
            let teachers = try context.fetch(fetchRequest)
            for person in teachers {
                print(person.name as Any)
            }
            return teachers
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
            return []
        }
    }
    
    // 删除数据
    @objc func deleteData(teacher: Teacher) {
        //删除老师下的学生
        if let students = teacher.relationship {
            for student in students {
                context.delete(student as! NSManagedObject)
            }
        }
        //删除老师
        context.delete(teacher)
        do {
            try context.save()
        } catch {
            print("Delete failed: \(error.localizedDescription)")
        }
    }
}
