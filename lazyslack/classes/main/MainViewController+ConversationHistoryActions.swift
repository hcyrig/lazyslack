//
//  MainViewController+ConversationHistoryActions.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  typealias CoversationHistoryAction = (title: String, action: VoidCallback)
  
  func conversationHistoryActionsView(context: SlackHTTPClient.Context) {
    
    makeContentBox(container: grapchStackView,
                   value: .init(identifier: "conversationHistory")) { view in
      
      let actions = [
        (title: "Delete messages", action: { [weak self] in
          
          guard let `self` = self else { return }
          
          self.deleteHistoryAction(context: context,
                                   cursor: nil)
          
        }),
        (title: "Show messages", action: { [weak self] in
          
          guard let `self` = self else { return }
          
          self.conversationHistoryListAction(context: context,
                                             cursor: nil)
        })
      ]
      
      view.actions = actions.compactMap( { .init(title: $0.title, value: $0) } )
      view.actionCallback = { actions in
        
        guard let action = actions.first?.value as? CoversationHistoryAction
        else { return }
        
        action.action()
      }
    }
  }
  
  func deleteHistoryAction(context: SlackHTTPClient.Context,
                           cursor: String?) {
    
    guard let userID = context.userID else { return }
    
    guard let channelID = context.channel else { return }
    
    self.slackHTTPClient.conversationHistory(
      channel: channelID,
      token: context.token,
      cookie: context.cookie,
      cursor: cursor) { [weak self] response in
        
        guard let `self` = self else { return }
        
        NOSTDOUT.display(response)
        
        DispatchQueue.main.async { [weak self] in
          
          guard let `self` = self else { return }
          
          let messages = response.messages.filter( { $0.user == userID } )
          
          self.makeCoversationHistoryListView(context: context,
                                              messages: messages)
          
          for message in messages {
            
            self.deleteMessageAction(context: context,
                                     message.ts)
          }
          
          if response.has_more {
            
            self.deleteHistoryAction(context: context,
                                     cursor: response.response_metadata?.next_cursor)
          }
        }
      }
  }
  
  func conversationHistoryListAction(context: SlackHTTPClient.Context,
                                     cursor: String?) {
    
    guard let userID = context.userID else { return }
    
    guard let channelID = context.channel else { return }
    
    slackHTTPClient.conversationHistory(
      channel: channelID,
      token: context.token,
      cookie: context.cookie,
      cursor: cursor) { [weak self] response in
        
        guard let `self` = self else { return }
        
        NOSTDOUT.display(response)
        
        DispatchQueue.main.async { [weak self] in
          
          guard let `self` = self else { return }
          
          let message = response.messages.filter( { $0.user == userID } )
          
          self.makeCoversationHistoryListView(context: context,
                                              messages: message, unique: true)
          
          if response.has_more {
            
            self.conversationHistoryListAction(context: context,
                                               cursor: response.response_metadata?.next_cursor)
          }
        }
      }
  }
}
