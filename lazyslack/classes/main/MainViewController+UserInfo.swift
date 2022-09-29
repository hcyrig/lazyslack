//
//  MainViewController+UserInfo.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func makeUserInfoView(context: SlackHTTPClient.Context,
                        response: SlackHTTPAPIUserInfo.Response) {
    
    makeContentBox(container: grapchStackView,
                   value: .init(identifier: "userInfo")) { view in
      
      view.actions = [.init(title: response.user.real_name ?? response.user.name ?? .empty, value: response)]
      view.actionCallback = { [weak self] tags in
        
        guard let `self` = self else { return }
        
        guard let user = tags.first?.value as? SlackHTTPAPIUserInfo.Response,
                let userID = user.user.id else {
          return
        }
        
        context.userID = userID
        
        self.conversationHistoryActionsView(context: context)
      }
    }
  }
}
