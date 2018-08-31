import RealmSwift

class Thought: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create(_ title: String? = "") -> Thought {
        let temp = Thought()
        temp.id = UUID().uuidString
        temp.title = title!
        return temp
    }
}
