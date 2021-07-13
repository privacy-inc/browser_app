import Foundation

protocol CollectionItemInfo: Hashable {
    associatedtype Id : Equatable
    
    var id: Id { get }
}
