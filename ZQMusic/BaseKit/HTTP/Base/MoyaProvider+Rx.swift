//
//  MoyaProvider+RxSwift.swift
//  FZChat
//
//  Created by wp on 2023/1/27.
//

@_exported import RxSwift
import Moya


public extension Reactive where Base: MoyaProvider<MultiTarget> {
    
    typealias SuccessBlock = (_ json: Any) -> Void
    typealias FailureBlock = (_ error: Swift.Error) -> Void

    
    /// Designated request-making method.
    /// - Parameters:
    ///   - api: Request body
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Observable sequence JSON object. May be thrown twice.
    func request<T:Codable>(target: FZTargetType, callbackQueue: DispatchQueue? = nil) -> RxSwift.Observable<T> {
        var single: RxSwift.Observable<T> = RxSwift.Observable<T>.create { (observer) in
            // And then process network data
            let token = self.request(target, base: base, queue: callbackQueue) { json in
                
                Logger.debug(.HTTP, message: "++++++++++++++++++++++response++++++++++++++++++++++++")
                Logger.debug(.HTTP, message: "url:\(target.baseURL.absoluteString + target.path)")
                Logger.debug(.HTTP, message: "content:\n\(json)")
                Logger.debug(.HTTP, message: "++++++++++++++++++++++end++++++++++++++++++++++++")
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(T.self, from: jsonData)
                    observer.onNext(model)
                } catch let parseError {
                    Logger.error(.HTTP, message: "\(parseError)")
                    let error = NSError.init(domain: "", code: -1,userInfo: [
                        NSLocalizedDescriptionKey : "\(parseError)",
                        NSLocalizedFailureErrorKey : "\(parseError)",
                        NSLocalizedFailureReasonErrorKey : "\(parseError)"
                    ])
                    observer.onError(error)
                }
                
                observer.onCompleted()
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create {
                token.cancel()
            }
        }
        if target.retry > 0 {
            single = single.retry(target.retry) // Number of retries after failed.
        }
        return single.share(replay: 1, scope: .forever)
    }
    
    
    @discardableResult
    func request(_ target: FZTargetType,
                             base: MoyaProvider<MultiTarget>,
                             queue: DispatchQueue?,
                             success:@escaping SuccessBlock,
                             failure:@escaping FailureBlock,
                             progress: ProgressBlock? = nil) -> Cancellable {
        let mTarget = MultiTarget.target(target)
        
        return base.request(mTarget, callbackQueue: queue, progress: progress, completion: { result in
            self.handleResult(result, success: success, failure: failure)
        })
    }
    
    func handleResult(_ result: Result<Moya.Response, MoyaError>,
                                         success:@escaping SuccessBlock,
                                         failure:@escaping FailureBlock)
    {
        switch result {
        case let .success(response):
            do {
                let response = try response.filterSuccessfulStatusCodes()
                let json = try response.mapJSON()
                // 主线程回调
                DispatchQueue.main.async {
                    success(json)
                }
                
            } catch MoyaError.statusCode(let response) {
                // 主线程回调
                DispatchQueue.main.async {
                    failure(MoyaError.statusCode(response))
                }
                
            } catch MoyaError.jsonMapping(let response) {
                // 主线程回调
                DispatchQueue.main.async {
                    failure(MoyaError.jsonMapping(response))
                }
            } catch {
                // 主线程回调
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        case let .failure(error):
            // 主线程回调
            DispatchQueue.main.async {
                failure(error)
            }
            
        }
    }
}
