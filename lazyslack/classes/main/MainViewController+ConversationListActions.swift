//
//  MainViewController+ConversationListActions.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func makeConversationListActionsView(context: SlackHTTPClient.Context,
                                       actions: [SlackHTTPAPIConversationsType]) {
    
    context.reset()
    
    makeContentBox(container: grapchStackView,
                   value: .init(identifier: "listActions")) { view in
      
      view.actions = actions.compactMap({ .init(title: $0.key, value: $0) })
      view.actionCallback = { [weak self] values in
        
        guard let `self` = self else {return }

        self.conversationListAction(context: context,
                                    values.compactMap({ $0 }),
                                    completion: { [weak self] result in
          
          guard let `self` = self else { return }
          
          NOSTDOUT.display(result)
          
          DispatchQueue.main.async { [weak self] in
            
            guard let `self` = self else { return }
            
            self.makeConversationListView(context: context, tags: result.channels)
          }
        })
      }
    }
  }
  
  func conversationListAction(context: SlackHTTPClient.Context,
                              _ actions: [NOActionsView.ViewModel],
                              completion: @escaping SlackHTTPAPIConversationsListResponseCallback) {
    
    guard let conversationType = actions.compactMap({ $0.value as? SlackHTTPAPIConversationsType }).first else { return }
    
    context.channels = conversationType
    
    guard let channels = context.channels else { return }
    
    slackHTTPClient.conversationList(
      types: [channels],
      token: context.token,
      cookie: context.cookie) { response in
        
        completion(response)
      }
  }
}
