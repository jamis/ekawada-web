var Behaviors = {
  add: function(trigger, behavior, handler) {
    document.observe(trigger, function(event) {
      var element = event.findElement("*[data-behaviors~=" + behavior + "]");
      if (element) handler(element, event);
    });
  },

  addSelector: function(trigger, selector, handler) {
    document.observe(trigger, function(event) {
      var element = event.findElement(selector);
      if (element) handler(element, event);
    });
  }
};
