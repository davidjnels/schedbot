// Generated by CoffeeScript 1.12.4
(function() {
  module.exports = {
    test: function(req, res) {
      return res.json({
        cards: [
          {
            cardTitle: 'TestWebhookTitle',
            cardSubtitle: 'TestWebhookSubtitle',
            cardImage: 'https://www.motion.ai/images/logo_molecules_gradient.png',
            cardLink: 'https://www.motion.ai',
            buttons: {
              buttonText: 'WebhookButton 1',
              buttonType: 'webview',
              webviewHeight: 'compact',
              target: 'https://dashboard.motion.ai'
            }
          }
        ]
      });
    }
  };

}).call(this);

//# sourceMappingURL=WebviewController.js.map
