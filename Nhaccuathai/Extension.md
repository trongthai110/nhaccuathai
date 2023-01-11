import Foundation
import CoreData
import UIKit

extension NSManagedObject {
    class var context: NSManagedObjectContext! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    class var request: NSFetchRequest<NSManagedObject> {
        return NSFetchRequest(entityName: String(describing: self))
    }

    func save(success: (() -> Void)?, fail: ((Error) -> Void)?) {
        guard let context = self.managedObjectContext else {
            fail?(NSError(domain: "", code: 1, userInfo: nil))
            return
        }
        if context.hasChanges {
            do {
                try context.save()
                success?()
            } catch {
                fail?(error)
            }
        } else {
            let error = NSError(domain: "Data not change", code: 0, userInfo: nil)
            fail?(error)
        }
    }

    func delete(completed: ((Error?) -> Void)?) {
        self.managedObjectContext?.delete(self)
        self.save(success: {
            completed?(nil)
        }) { (error) in
            completed?(error)
        }
    }

    class func all(predicate: NSPredicate?, success: (([NSManagedObject]) -> Void)?, fail: ((Error) -> Void)?) {
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            success?(result)
        } catch {
            fail?(error)
        }
    }

    class func findByObjectId(objectId: NSManagedObjectID) -> NSManagedObject? {
        do {
            return try self.context.existingObject(with: objectId)
        } catch {
            return nil
        }
    }

    class func findBy(predicate: NSPredicate?, success: ((NSManagedObject?) -> Void)?, fail: ((Error) -> Void)?) {
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            success?(result.first)
        } catch {
            fail?(error)
        }
    }
}
