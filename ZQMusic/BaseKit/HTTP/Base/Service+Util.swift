//
//  Service+Util.swift
//  FZChat
//
//  Created by wp on 2023/1/27.
//

import Foundation
import Moya

extension Service {
    
    public typealias SuccessBlock = (_ json: Any) -> Void
    public typealias FailureBlock = (_ error: Swift.Error) -> Void

    
    struct Util {
        
        @discardableResult
        static func request(_ target: FZTargetType,
                                 base: MoyaProvider<MultiTarget>,
                                 queue: DispatchQueue?,
                                 success:@escaping SuccessBlock,
                                 failure:@escaping FailureBlock,
                                 progress: ProgressBlock? = nil) -> Cancellable {
            let mTarget = MultiTarget.target(target)
            
            return base.request(mTarget, callbackQueue: queue, progress: progress, completion: { result in
                Self.handleResult(result, success: success, failure: failure)
            })
        }
    }
}

// MARK: - private methods

extension Service.Util {
    fileprivate static func handleResult(_ result: Result<Moya.Response, MoyaError>,
                                         success:@escaping Service.SuccessBlock,
                                         failure:@escaping Service.FailureBlock)
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

