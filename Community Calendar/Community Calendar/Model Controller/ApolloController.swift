//
//  ApolloClient.swift
//  Community Calendar
//
//  Created by Michael on 5/5/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import Apollo
import OktaOidc
import Cloudinary

class ApolloController: NSObject, HTTPNetworkTransportDelegate, URLSessionDelegate {

    private static let url = URL(string: "https://apollo.ourcommunitycal.com/")!
    var apollo: ApolloClient = ApolloClient(url: ApolloController.url)
    var parent: Controller!
    var currentUserID: GraphQLID?
    var events = [FetchEventsQuery.Data.Event]()
    
    func fetchEvents(completion: @escaping (Swift.Result<[FetchEventsQuery.Data.Event], Error>) -> Void) {
        apollo.fetch(query: FetchEventsQuery()) { result in
            switch result {
            case .failure(let error):
                print("Error fetching events: \(error)")
                completion(.failure(error))
            case .success(let graphQLResult):
                if let events = graphQLResult.data?.events {
                    self.events.append(contentsOf: events)
                    print(self.events.count)
                    completion(.success(events))
                }
            }
        }
    }
    
    func fetchUserID(oktaID: String, completion: @escaping (Swift.Result<FetchUserIdQuery.Data.User, Error>) -> Void) {
        apollo.fetch(query: FetchUserIdQuery(oktaId: oktaID)) { result in
            switch result {
            case .failure(let error):
                print("Error getting user ID: \(error)")
                completion(.failure(error))
            case .success(let graphQLResult):
                if let user = graphQLResult.data?.user {
                    print("Current User: \(user)")
                    self.currentUserID = user.id
                    completion(.success(user))
                }
            }
        }
    }
    
    func updateProfilePic(image: String, graphQLID: String, accessToken: String, file: GraphQLFile, completion: @escaping (Swift.Result<AddProfilePicMutation.Data.UpdateUser, Error>) -> Void) {
        apollo = configureApolloClient(accessToken: accessToken)
        apollo.upload(operation: AddProfilePicMutation(image: image, id: graphQLID), files: [file]) { result in
            switch result {
            case .failure(let error):
                print("Error updating users profile picture: \(error)")
                completion(.failure(error))
            case .success(let graphQLResult):
                if let user = graphQLResult.data?.updateUser {
                    let userID = user.id
                    let profileImage = user.profileImage
                    print("Success! User ID: \(userID), Profile Image: \(String(describing: profileImage))")
                    completion(.success(user))
                }
            }
        }
    }
    
    func updateProfileImage(urlString: String, graphQLID: String, accessToken: String, completion: @escaping (Swift.Result<UpdateUserInfoMutation.Data.UpdateUser, Error>) -> Void) {
        apollo = configureApolloClient(accessToken: accessToken)
        apollo.perform(mutation: UpdateUserInfoMutation(profileImage: urlString, id: graphQLID)) { result in
            switch result {
            case .failure(let error):
                print("Error updating users profile picture on back end: \(error)")
                completion(.failure(error))
            case .success(let graphQLResult):
                if let response = graphQLResult.data?.updateUser {
                    let profileImage = response.profileImage
                    let userID = response.id
                    print("Successfully updated users profile image: \(String(describing: profileImage)), for user ID: \(userID)")
                    completion(.success(response))
                }
            }
        }
    }
    
    func configureApolloClient(accessToken: String) -> ApolloClient {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        let client = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
        let transport = HTTPNetworkTransport(url: ApolloController.url, client: client)
        transport.delegate = self
        
        return ApolloClient(networkTransport: transport)
    }
    
    func hostImage(imageData: Data, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let config = CLDConfiguration(cloudName: "communitycalendar1")
        let cloudinary = CLDCloudinary(configuration: config)
        cloudinary.createUploader().upload(data: imageData, uploadPreset: "ComCal") { response, error in
            if let error = error {
                print("Error hosting image: \(error)")
                completion(.failure(error))
            }
            if let response = response, let urlString = response.secureUrl {
                print("Cloudinary response: \(response)")
                completion(.success(urlString))
            }
        }
    }
}