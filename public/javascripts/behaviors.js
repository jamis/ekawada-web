var Behaviors = {
  add: function(trigger, behavior, handler) {
    document.observe(trigger, function(event) {
      var element = event.findElement("*[data-behaviors~=" + behavior + "]");
      if (element) handler(element, event);
    });
  }
};
