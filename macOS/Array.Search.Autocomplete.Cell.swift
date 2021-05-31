import Foundation

extension Array where Element == Search.Autocomplete.Cell {
    var up: String? {
        guard !isEmpty else { return nil }
        let highlighted = self.highlighted
        let next = highlighted
            .map {
                $0 - 1
            }
            .map {
                $0 >= 0
                    ? $0
                    : count - 1
            }
        ?? count - 1
        highlighted
            .map {
                self[$0].highlighted = false
            }
        self[next].highlighted = true
        return self[next].filtered.url
    }
    
    var down: String? {
        guard !isEmpty else { return nil }
        let highlighted = self.highlighted
        let next = highlighted
            .map {
                $0 + 1
            }
            .map {
                $0 < count
                    ? $0
                    : 0
            }
        ?? 0
        highlighted
            .map {
                self[$0].highlighted = false
            }
        self[next].highlighted = true
        return self[next].filtered.url
    }
    
    private var highlighted: Int? {
        firstIndex {
            $0.highlighted
        }
    }
}
