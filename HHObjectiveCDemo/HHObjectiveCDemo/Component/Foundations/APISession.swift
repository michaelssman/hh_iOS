//
//  APISession.swift
//  HHSwift
//
//  Created by Michael on 2022/12/27.
//

import Foundation
import Alamofire
import RxSwift

enum APISessionError: Error {
    case networkError(error: Error, statusCode: Int)
    case invalidJSON
    case noData
}

protocol APISession {
    associatedtype ReponseType: Codable
    func post(_ path: String, headers: HTTPHeaders, parameters: Parameters?) -> Observable<ReponseType>
    func request()
}

extension APISession {
    var defaultHeaders: HTTPHeaders {
        let headers: HTTPHeaders = [
            "x-app-platform": "iOS",
            "x-app-version": "5.1.1",
            "x-os-version": UIDevice.current.systemVersion,
            "AsId": "100133941",
            "User-Agent": "HHiOSUser-Agent",
            "Authorization": "Bearer F3btLVz0GAtKm4qB80lHz0LdKf3TqfCdsRy78g_dKJTzkS46mW6XLCDhO2QkLddMLCjmhy-wGRCrtidJ6Pg3GFyU9CE1N3ij0Tc0XVVKaNVf7wzjx8vP-vh-azxveIyekS3F3KomMRgkFWvVcv5Maep9e6vaNX9Wm-nwjImoaTZd5-1AJmO5-UUXgWormFOd8a-4iP7i1xhoEEGijLJexgVOVZ2h4BPglvoaL2yErngrSfJ9yrdaArQDnDyiJAFV2G9GIw9N0dzQuQeKyVHaBGvgXAuFQvJl08pz77sZ597UzgzVevU5IxoKlJ5iODycaHN7PAsHwMwvc94E9ZK_kMgh87-_cZRM7swGaw4a8vg0-uJl9n8oBjEjW_740uKPNcUOUCDTaLD2DJQ3oA8X7oLtbX2amMY6IQCBsIe2RdnxDTBjK4oMfV26LtytiuFDve1_VNh0wm1afvig1vDmUNCgtIn1Z-d4eeJuBtqI3c-D_jqecqU1VhkPDXJ3tnw0",
            "Content-Type": "application/json",
        ]
        return headers
    }
    
    var baseUrl: URL {
        return URL(string: "https://www.nmy.com/hh")!
    }
    
    func post(_ path: String, headers: HTTPHeaders = [:], parameters: Parameters? = nil) -> Observable<ReponseType> {
        return request(path, method: .post, headers: headers, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func delete(_ path: String, headers: HTTPHeaders = [:], parameters: Parameters? = nil) -> Observable<ReponseType> {
        return request(path, method: .delete, headers: headers, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func request() {
        //AF命名空间，链式调用
        AF.request("http://59.110.112.58:9093/jxc_api/Product/GetById/100000020", method: .get, parameters: nil, encoding: URLEncoding.default, headers: defaultHeaders).response { response in
            debugPrint(response)
        }
    }
    
}

private extension APISession {
    func request(_ path: String, method: HTTPMethod, headers: HTTPHeaders, parameters: Parameters?, encoding: ParameterEncoding) -> Observable<ReponseType> {
        let url = baseUrl.appendingPathComponent(path)
        let allHeaders = HTTPHeaders(defaultHeaders.dictionary.merging(headers.dictionary) { $1 })
        
        return Observable.create { observer -> Disposable in
            let queue = DispatchQueue(label: "hh.app.api", qos: .background, attributes: .concurrent)
            let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: allHeaders, interceptor: nil)
                .validate()//.validate()：状态码是否在默认的可接受范围内200…299
                .responseJSON(queue: queue) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if let data = response.data, !data.isEmpty {
                            // 响应数据非空，进行序列化和处理
                            do {
                                let model = try JSONDecoder().decode(ReponseType.self, from: data)
                                observer.onNext(model)
                                observer.onCompleted()
                            } catch {
                                observer.onError(error)
                            }
                        } else {
                            // 响应数据为空或长度为零，进行错误处理
                            print("Response data is empty.")
                            observer.onError(response.error ?? APISessionError.noData)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            observer.onError(APISessionError.networkError(error: error, statusCode: statusCode))
                        } else {
                            observer.onError(error)
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
