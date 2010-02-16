function selectTab(id) {
  var tab_link = $("tab_" + id);
  var tab_page = $(id);

  var tabs = tab_link.up(".tabs");

  tabs.select("li").invoke("removeClassName", "selected");
  $("pages").select(".tab-body").invoke("removeClassName", "selected");

  tab_link.addClassName("selected");
  tab_page.addClassName("selected");
}

document.observe("dom:loaded", function() {
  if(window.location.hash) {
    var id = window.location.hash.substr(1);
    selectTab(id);
  } else {
    var id = $('pages').down('.tab-body').id;
    selectTab(id);
  }

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
    var element;
    if(element = event.findElement("a[data-toggle]")) {
      var action = element.readAttribute("data-toggle");
      element.hide();
      element.next().show();
      event.stop();

    } else if(element = event.findElement("a[data-tab]")) {
      selectTab(element.readAttribute("data-tab"));
    }
  });
});
