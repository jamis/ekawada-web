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
  if($('pages')) {
    if(window.location.hash) {
      var id = window.location.hash.substr(1);
      selectTab(id);
    } else {
      var id = $('pages').down('.tab-body').id;
      selectTab(id);
    }
  }

  Behaviors.add("click", "tab", function(element) {
    selectTab(element.readAttribute("data-link"));
  });

  Behaviors.add("click", "add-alias", function(element) {
    $('aliases').show();
    var template = $$('#aliases li:last').first();
    var row = template.clone(true);
    template.insert({before: row});
    row.show();
    row.down('input').focus();
  });

  Behaviors.add("click", "remove-alias", function(element) {
    element.up('li').remove();
    if($$('#aliases li').length < 2) {
      $('aliases').hide();
    }
  });
});
