enum Command: Equatable {
    case get(String)
    case set(String, String)
    case delete(String)
    case count(String)
    case begin
    case commit
    case rollback
}
