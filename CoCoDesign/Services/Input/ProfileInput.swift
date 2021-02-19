//
//  ProfileInput.swift
//  join_chat
//
//  Created by 79 on 7/1/20.
//  Copyright © 2020 Tomosia. All rights reserved.
//

import Foundation

struct ProfileInput {
    final class GetCategory: Input<[Category]> {
        override init() {
            super.init()
            url = APIPath.User.category
            method = .get
        }
    }

    final class UpdateProfile: Input<Profile> {
        init(profileInformation: ProfileInformation) {
            super.init()
            url = APIPath.User.profile
            method = .post

            if let name = profileInformation.name {
                parameter?.append(["name": name])
            }

            if let account = profileInformation.account {
                parameter?.append(["account": account])
            }

            if let region = profileInformation.region, let id = region.id {
                parameter?.append(["region_id": id])
            }

            if let purposeIds = profileInformation.purposes?.compactMap({ $0.id }), !purposeIds.isEmpty  {
                parameter?.append(["purpose_ids": purposeIds])
            }

            if let introduce = profileInformation.introduce {
                parameter?.append(["introduce": introduce])
            }

            if let categoryIds = profileInformation.categories?.compactMap({ $0.id }) {
                if categoryIds.isEmpty {
                    parameter?.append(["category_ids": [0]])
                } else {
                    parameter?.append(["category_ids": categoryIds])
                }
            }

            if let languageIds = profileInformation.languages?.compactMap({ $0.id }) {
                if languageIds.isEmpty {
                    parameter?.append(["language_ids": [0]])
                } else {
                    parameter?.append(["language_ids": languageIds])
                }
            }

            if let gender = profileInformation.gender {
                parameter?.append(["gender": gender.rawValue])
            }

            if let accountInvite = profileInformation.accountInvite {
                parameter?.append(["account_invite": accountInvite])
            }

            if let birthday = profileInformation.birthday {
                parameter?.append(["birthday": birthday])
            }

            if let isNewUser = profileInformation.isNewUser {
                parameter?.append(["is_new_user": isNewUser])
            }
        }
    }

    final class UpdateAvatarProfile: Input<Profile> {
        override init() {
            super.init()
            url = APIPath.User.profile
            method = .post
            header = ["Content-Type": "multipart/form-data"]
        }
    }

    final class UpdateImagesProfile: Input<UserImage> {
        override init() {
            super.init()
            url = APIPath.User.profileImages
            method = .post
            header = ["Content-Type": "multipart/form-data"]
        }
    }

    final class UpdateOrEditImagesProfile: Input<Bool> {
        init(imagesUpload: [UserImage]) {
            super.init()
            url = APIPath.User.profileUpdateImage
            method = .post
            let img = imagesUpload.map({ $0.dictionary })
            parameter = ["images": img]
        }
    }

    final class DeleteImageProfile: Input<Bool> {
        init(id: String) {
            super.init()
            url = APIPath.User.deleteProfileImageById(id: id)
            method = .delete
            header = ["Content-Type": "multipart/form-data"]
        }
    }

    final class UpdateCategoryChoose: Input<Bool> {
        init(categoryIds: [Int]) {
            super.init()
            url = APIPath.User.updateCategory
            method = .post
            parameter = ["category_ids": categoryIds]
        }
    }

    final class GetProfile: Input<Profile> {
        override init() {
            super.init()
            url = APIPath.User.profile
            method = .get
        }
    }

    final class GetLanguage: Input<[Language]> {
        override init() {
            super.init()
            url = APIPath.User.language
            method = .get
        }
    }

    final class SendDevice: Input<Bool> {
        init(deviceToken: String? = nil) {
            super.init()
            url = APIPath.User.device
            method = .put
            parameter = ["device_os": "iOS",
                         "device_name": UIDevice.current.name,
                         "device_os_version": UIDevice.current.systemVersion,
                         "app_version": Bundle.main.version,
                         "device_id": Helper.getUDID()]
            if let deviceToken = deviceToken {
                parameter?["device_token"] = deviceToken
            }
        }
    }

    final class GetFriends: Input<[Friend]> {
        init(name: String? = nil, userIds: [Int] = [], page: Int = 1) {
            super.init()
            method = .post
            url = APIPath.User.friend
            parameter?["name"] = name
            parameter?["page"] = page
            parameter?["user_id"] = userIds
        }
    }

    final class GetUserOnline: Input<[SocketUser]> {
        init(userIds: [Int]) {
            super.init()
            url = APIPath.User.onlineStatus
            parameter?["user_id"] = userIds
            method = .post
        }
    }
}
