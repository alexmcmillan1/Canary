import RealmSwift

class Thought: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var content = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create(id: String, content: String) -> Thought {
        let temp = Thought()
        temp.id = id
        temp.content = content
        return temp
    }
}
