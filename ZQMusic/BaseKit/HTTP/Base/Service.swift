//
//  Service.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation
import RxSwift
import Alamofire
import Moya

enum Service {
    
}

extension TargetType {
    public var baseURL: URL {
        return URL.init(string: "https://itunes.apple.com")!
    }
}


public protocol ZQMTargetType: Moya.TargetType {
    /// Request parameters
    var parameters: [String: Any] { get }
    /// Plugin array
    var plugins: [Moya.PluginType] { get }
    /// Failed retry count, the default is zero
    var retry: Int { get }
    var timeoutForRequest: TimeInterval { get }
}

extension ZQMTargetType {
    public var baseURL: URL {
        return URL.init(string: "FZGlobal.URL.Host.http")!
    }
    public var plugins: [Moya.PluginType] {
        return []
    }
    public var retry: Int {
        return 0
    }
    public var timeoutForRequest: TimeInterval {
        return 60
    }
    public var parameters: [String: Any] {
        return [:]
    }
}

extension ZQMTargetType {
    
    public func request<T:Codable>(callbackQueue: DispatchQueue? = DispatchQueue(label: "zqm.rx.http.queue", qos: .background, attributes: [.concurrent])) -> RxSwift.Observable<T> {
        
        let configuration = URLSessionConfiguration.af.default
        configuration.headers = Alamofire.HTTPHeaders.default
        configuration.timeoutIntervalForRequest = self.timeoutForRequest
        
        let session: Moya.Session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
        let provider = MoyaProvider<MultiTarget>.init(endpointClosure: MoyaProvider.fzEndpointMapping, stubClosure: MoyaProvider.neverStub,callbackQueue: callbackQueue,session: session, plugins: self.plugins)
        return provider.rx.request(target: self, callbackQueue: callbackQueue)
    }
}


enum HTTPService {
    static var commonHeader: [String:String] {
        
        var headers:[String:String] = [:]
        return headers
    }
}



public extension MoyaProvider {
    final class func fzEndpointMapping(for target: Target) -> Endpoint {
        var headers = HTTPService.commonHeader.merging(target.headers ?? [:], uniquingKeysWith: { key, value in
            fatalError("ext key repeat, key name:\(key)")
        })
        
        if let headers = target.headers,  headers["Content-Type"] != nil {
            
        }else{
            headers["Content-Type"] = "application/json"
        }
        
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: headers
        )
    }

    final class func fzRequestMapping(for endpoint: Endpoint, closure: RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }

    final class func fzAlamofireSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default

        return Session(configuration: configuration, startRequestsImmediately: false)
    }
}


/// Subclass of MoyaProvider that returns Observable instances when requests are made. Much better than using completion closures.
public class RxMoyaProvider<Target:TargetType> : MoyaProvider<Target> {
    /// Initializes a reactive provider.
    
    
    /// Initializes a provider.
    public override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.fzEndpointMapping,
                         requestClosure: @escaping RequestClosure = MoyaProvider<Target>.fzRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                session: Session = MoyaProvider<Target>.fzAlamofireSession(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {

        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
}
