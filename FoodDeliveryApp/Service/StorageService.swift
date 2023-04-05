//
//  File.swift
//  FoodDeliveryApp
//
//  Created by Alexandr Rassokhin on 05.04.2023.
//

import Foundation
import CoreData

class StorageService {
   
    static private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static private let sharedViewContext: NSManagedObjectContext = persistentContainer.viewContext
    
    private let viewContext = StorageService.sharedViewContext
    
    func getBanners(completion: (([BannerCellModel]) -> Void)? = nil) {
        viewContext.perform {
            let bannerEnities = self.getAll(BannerEntity.self, self.viewContext)
            let bannerModels = bannerEnities.map(BannerCellModel.init)
            
            completion?(bannerModels)
        }
    }
    
    func saveBanners(_ banners: [BannerCellModel], completion: (() -> Void)? = nil) {
        viewContext.perform {
            self.saveWithOverride(models: banners, entitySaveType: BannerEntity.self, context: self.viewContext, completion: completion)
        }
    }

    func getProducts(completion: (([ProductCellModel]) -> Void)? = nil) {
        viewContext.perform {
            let productEnities = self.getAll(ProductEntity.self, self.viewContext)
            let productModels = productEnities.map(ProductCellModel.init)
            
            completion?(productModels)
        }
    }
    
    func saveProducts(_ products: [ProductCellModel], completion: (() -> Void)? = nil) {
        viewContext.perform {
            self.saveWithOverride(models: products, entitySaveType: ProductEntity.self, context: self.viewContext, completion: completion)
        }
    }
    
    func getCategories(completion: (([CategoryCellModel]) -> Void)? = nil) {
        viewContext.perform {
            let categoryEnities = self.getAll(CategoryEntity.self, self.viewContext)
            let categoryModels = categoryEnities.map(CategoryCellModel.init)
            
            completion?(categoryModels)
        }
    }
    
    func saveCategories(_ categories: [CategoryCellModel], completion: (() -> Void)? = nil) {
        viewContext.perform {
            self.saveWithOverride(models: categories, entitySaveType: CategoryEntity.self, context: self.viewContext, completion: completion)
        }
    }
    
    private func getAll<T: NSManagedObject>(_ entityType: T.Type, _ context: NSManagedObjectContext) -> [T] {

        let request = T.fetchRequest() as! NSFetchRequest<T>
        
        do {
            let objects = try context.fetch(request)
            
            return objects
            
        } catch {
            return []
        }
    }
    
    private func saveWithOverride<T1, T2, T3>(models: T2, entitySaveType: T3.Type, context: NSManagedObjectContext, completion: (() -> Void)?) where T2: Collection, T3: NSManagedObject, T3: CreatableEntity, T1 == T2.Element, T1 == T3.Item {
        
        for model in models {
            _ = T3.create(model, context: context)
        }
        
        do {
            if context.hasChanges {
                try self.deleteObjects(of: T3.self, context: context)
                try self.viewContext.save()
            }
        } catch {
            print(error)
        }
    }
    
    private func deleteObjects<T: NSManagedObject>(of type: T.Type, context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: T.entity().name!)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        deleteRequest.resultType = .resultTypeObjectIDs

        let batchDelete = try context.execute(deleteRequest)
            as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }
    
}
