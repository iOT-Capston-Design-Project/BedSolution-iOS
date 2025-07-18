import Foundation
import Alamofire

public enum NetworkError: Error {
    case invalidResponse
    case server(message: String)
    case underlying(Error)
}

public protocol NetworkRequestable {
    func request(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    )
}

public final class NetworkManager: NetworkRequestable {
    private let session: Session
    private let queue = DispatchQueue(label: "com.bedsolution.network", qos: .utility)

    public init(session: Session = .default) {
        self.session = session
    }

    public func request(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        queue.async {
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(.underlying(error)))
                }
            }
        }
    }
}
