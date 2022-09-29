//
//  MainViewController.swift
//

import AppKit

import NOFoundation

import lazyapi

class MainViewController: BaseViewController {
  
  @IBOutlet weak var grapchStackView: NSStackView!
  @IBOutlet private weak var musicButton: NSButton!
  
  var slackHTTPClient: SlackHTTPClient!
  var soundtrackPlayer = SoundtrackPlayer()
  
  private var chainOfContent: NOLazyList?
  
  override func setupInterface() {
    super.setupInterface()
    
    musicButton.state = .off
    
    self.slackHTTPClient = SlackHTTPClient(context: .init(
      token: "YOUR_API_TOKEN",
      cookie: "RELATED_API_COOKIES"))
    
    chainOfContent = .init(value: .init(identifier: "init", values: [.init(value: NSView())]))
    
    makeConversationListActionsView(
      context: slackHTTPClient.context,
      actions: [
        .direct,
        .public,
        .group,
        .private
      ])
  }
}

extension MainViewController {
  
  public func makeContentBox(
    container: NSStackView,
    value: NOLazyValue,
    viewBoxClosure: SetValueCallback<NOActionsView>) {
      
      var value = value
      
      chainOfContent?.removeTail(value)
      
      let separatorView = NSBox()
      separatorView.boxType = .separator
      container.addArrangedSubview(separatorView)
      
      let view = NOActionsView()
      view.viewWidthCallback = { [weak container] in
        
        guard let container = container else { return .zero }
        
        return container.frame.size.width
      }
      viewBoxClosure(view)
      container.addArrangedSubview(view)
      
      value.values = [
        .init(value: separatorView),
        .init(value: view)
      ]
      chainOfContent?.addNode(value)
    }
}
