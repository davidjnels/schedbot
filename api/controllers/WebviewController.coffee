# WebviewController
#
# @description :: Server-side logic for managing webviews
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

module.exports =


# `WebviewController.test()`

  test: (req, res) ->
    res.json
      cards: [
        cardTitle: 'TestWebhookTitle',
        cardSubtitle: 'TestWebhookSubtitle'
        cardImage: 'https://www.motion.ai/images/logo_molecules_gradient.png'
        cardLink: 'https://www.motion.ai'
        buttons:
          buttonText: 'WebhookButton 1'
          buttonType: 'webview'
          webviewHeight: 'compact'
          target:  'https://dashboard.motion.ai'
      ]
