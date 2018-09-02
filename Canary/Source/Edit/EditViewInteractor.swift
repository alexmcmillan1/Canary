import Foundation
import RealmSwift

protocol EditViewInteractorProtocol: class {
    func executeLogicChange(_ thought: Thought, save: Bool, delete: Bool)
}

class EditViewInteractor: EditViewInteractorProtocol {
    
    weak var viewController: EditViewController?
    private lazy var realm = try? Realm()
    
    func executeLogicChange(_ thought: Thought, save: Bool, delete: Bool) {
        guard let realm = realm else {
            return
        }
        
        try! realm.write {
            if save {
                realm.add(thought)
            } else if delete {
                realm.delete(thought)
            }
        }

        viewController?.finishedProcessing(success: true) // fix
    }
}
