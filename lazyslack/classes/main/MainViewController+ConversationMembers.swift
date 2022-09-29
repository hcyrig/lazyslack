//
//  MainViewController+ConversationMembers.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func makeConversationMembersView(context: SlackHTTPClient.Context,
                                   response: SlackHTTPAPIConversationMembers.Response) {
    
    makeContentBox(container: grapchStackView,
                   value: .init(identifier: "conversationMembers")) { view in
      
      view.actions = response.members.compactMap({ .init(title: $0, value: $0) })
      view.actionCallback = { [weak self] values in
        
        guard let `self` = self else { return }
        
        self.userInfoAction(context: context,
                            values.first?.value as? String)
      }
    }
  }
  
  func userInfoAction(context: SlackHTTPClient.Context,
                      _ userID: String? ) {
    
    guard let userID = userID else { return }
    
    context.userID = userID
    
    slackHTTPClient.userInfo(userID: userID,
                             token: context.token,
                             cookie: context.cookie) { [weak self] response in
      
      guard let `self` = self else { return }
      
      NOSTDOUT.display(response)
      
      DispatchQueue.main.async { [weak self] in
        
        guard let `self` = self else { return }
        
        self.makeUserInfoView(context: context,
                              response: response)
      }
    }
  }
}
