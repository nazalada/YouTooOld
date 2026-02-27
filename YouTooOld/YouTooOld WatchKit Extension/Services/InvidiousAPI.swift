//
//  InvidiousAPI.swift
//  YouTooOld WatchKit Extension
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodeError
    case serverError(Int)
}

final class InvidiousAPI {

    static let shared = InvidiousAPI()

    private let session: URLSession
    private let decoder = JSONDecoder()

    private init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = Constants.apiTimeout
        config.httpAdditionalHeaders = ["User-Agent": Constants.userAgent]
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: config)
    }

    private func get<T: Decodable>(path: String, query: [String: String]? = nil) async throws -> T {
        let base = InstanceManager.shared.baseURL
        guard var comp = URLComponents(string: base + path) else { throw APIError.invalidURL }
        comp.queryItems = query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = comp.url else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, response) = try await session.data(for: request)
        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            InstanceManager.shared.markFailed(baseURL: base)
            InstanceManager.shared.switchToNext()
            throw APIError.serverError(http.statusCode)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodeError
        }
    }

    func video(id: String, completion: @escaping (Result<VideoModel, Error>) -> Void) {
        Task {
            do {
                let v: VideoModel = try await get(path: "/api/v1/videos/\(id)")
                DispatchQueue.main.async { completion(.success(v)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func search(q: String, page: Int = 0, completion: @escaping (Result<[VideoModel], Error>) -> Void) {
        let query = ["q": q]
        Task {
            do {
                let raw: [SearchResponseItem] = try await get(path: "/api/v1/search", query: query)
                let list = raw.compactMap { VideoModel(searchItem: $0) }
                DispatchQueue.main.async { completion(.success(list)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func trending(completion: @escaping (Result<[VideoModel], Error>) -> Void) {
        fetchList(path: "/api/v1/trending", completion: completion)
    }

    func popular(completion: @escaping (Result<[VideoModel], Error>) -> Void) {
        fetchList(path: "/api/v1/popular", completion: completion)
    }

    private func fetchList(path: String, completion: @escaping (Result<[VideoModel], Error>) -> Void) {
        Task {
            do {
                let raw: [SearchResponseItem] = try await get(path: path)
                let list = raw.compactMap { VideoModel(searchItem: $0) }
                DispatchQueue.main.async { completion(.success(list)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func fetchList(context: VideoListContext, page: Int, completion: @escaping (Result<[VideoModel], Error>) -> Void) {
        switch context.mode {
        case .trending:
            trending(completion: completion)
        case .popular:
            popular(completion: completion)
        case .search:
            guard let q = context.query else { completion(.failure(APIError.invalidURL)); return }
            search(q: q, page: page, completion: completion)
        }
    }
}
