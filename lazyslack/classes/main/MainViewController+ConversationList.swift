//
// MainViewController+ConversationList.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func makeConversationListView(context: SlackHTTPClient.Context,
                                tags: [SlackHTTPAPIChannelResponse]) {
    
    makeContentBox(container: grapchStackView,
                   value: .init(identifier: "conversationList")) { view in
      
      view.actions = tags.compactMap({ .init(title: $0.name ?? $0.id, value: $0) })
      view.actionCallback = { [weak self] values in
        
        guard let `self` = self else {return }
        
        self.conversationMembersAction(context: context,
                                       values.compactMap({ $0.value as? SlackHTTPAPIChannelResponse }))
      }
    }
  }
  
  func conversationMembersAction(context: SlackHTTPClient.Context,
                                 _ channel: [SlackHTTPAPIChannelResponse]) {
    
    guard let channelID = channel.first?.id else { return }
    
    context.channel = channelID
    
    slackHTTPClient.conversationMembers(channel: channelID,
                                        token: context.token,
                                        cookie: context.cookie) { [weak self] response in
      
      guard let `self` = self else { return }
      
      NOSTDOUT.display(response)
      
      DispatchQueue.main.async { [weak self] in
        
        guard let `self` = self else { return }
        
        self.makeConversationMembersView(context: context,
                                         response: response)
      }
    }
  }
}
