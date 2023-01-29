import FloxBxAuth
import FloxBxNetworking
import FloxBxUtilities
import Foundation
import Sublimation

extension ApplicationObject {
  #if DEBUG
    private static func fetchBaseURL() async throws -> URL {
      do {
        guard let url = try await KVdb.url(
          withKey: Configuration.Sublimation.key,
          atBucket: Configuration.Sublimation.bucketName
        ) else {
          throw DeveloperServerError.noServer
        }
        return url
      } catch {
        throw DeveloperServerError.sublimationError(error)
      }
    }

    internal func developerService(fallbackURL: URL) async -> CredentialsService {
      let baseURL: URL
      do {
        baseURL = try await Self.fetchBaseURL()
        Self.logger.debug("Found service url: \(baseURL)")
      } catch {
        onError(error)
        baseURL = fallbackURL
      }
      return ServiceImpl<JSONCoder, URLSession, URLRequestBuilder, KeychainContainer>(
        baseURL: baseURL,
        accessGroup: Configuration.accessGroup,
        serviceName: Configuration.serviceName
      )
    }
  #endif
}
