document.observe("dom:loaded", function() {
  $(document.body).observe("change", function(event) {
    var element = event.element();
    var group = element.readAttribute("data-tab-group")
    if(group && !group.blank()) {
      var tabs = element.readAttribute("data-tabs")
      var container = element.up("." + group);
      var selection = $F(element);
      container.select('.' + tabs).invoke("hide");
      container.select('.' + selection).invoke("show");
    }
  });

  $(document.body).observe("click", function(event) {
    var element = event.findElement("a[data-toggle]");
    if(element) {
      var action = element.readAttribute("data-toggle");
      element.hide();
      element.next().show();
      event.stop();
    }
  });
});
