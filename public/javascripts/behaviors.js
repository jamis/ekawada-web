var Behaviors = {
  observers: {},

  observe: function(trigger) {
    $(document.body).observe(trigger, this.onTrigger.bind(this));
  },

  add: function(trigger, behavior, callback) {
    if(!this.observers[trigger]) {
      this.observe(trigger);
      this.observers[trigger] = {};
    }

    if(!this.observers[trigger][behavior]) {
      this.observers[trigger][behavior] = $A();
    }

    this.observers[trigger][behavior].push(callback);
  },

  onTrigger: function(event) {
    var element = event.findElement("*[data-behaviors]");
    if(!element) return;

    var behavesLike = element.readAttribute('data-behaviors').split(",");
    if(behavesLike.length < 1) return;

    var definedBehaviors = this.observers[event.type] || {};

    for(behavior in definedBehaviors) {
      if(behavesLike.include(behavior)) {
        definedBehaviors[behavior].each(function(callback) {
          callback(element, event);
          if(event.stopped) return;
        });
      }
    }
  },
};
