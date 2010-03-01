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
    var element = this.safeFindElement(event, "[behaves-like]");
    if(!element) return;

    var behavesLike = element.readAttribute('behaves-like').split(",");
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

  // as of 2010/02/28, latest prototype.js causes an error when
  // findElement is called with a pattern that does not match
  // any element in the chain of ancestors. As soon as this bug
  // is fixed, this workaround can go away.
  safeFindElement: function(event, pattern) {
    try {
      return event.findElement(pattern);
    } catch(e) {
      return null;
    }
  }
};
