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
});

document.observe("upload:complete", function(event) {
  $('add_illustration').removeClassName("busy");

  var location = event.memo.location;
  var thumbnail = event.memo.thumbnail;

  var next_number = parseInt($('thumbnails').readAttribute('data-next-number'));
  var prefix = $('thumbnails').readAttribute('data-prefix');

  $('thumbnails').writeAttribute('data-next-number', next_number+1);

  thumbnail = thumbnail.gsub("name=\"prefix." + location, "name=\"" + prefix);
  $('thumbnails').insert(thumbnail);

  var newid = "thumb." + location;
  $(newid).down('.number').innerHTML = next_number;
  $(newid).down('input.number').value = next_number;
});

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
  var li = element.up('li');
  var id = li.down('input.id');

  if(id) {
    li.hide();
    li.down('input.deleted').value = "1";
  } else {
    li.remove();
  }

  var visible_items = $$('#aliases li').select(function(e) { return e.visible(); });
  if(visible_items.length < 1) {
    $('aliases').hide();
  }
});

Behaviors.add("change", "add-illustration", function(element) {
  var form = element.up('form');
  var url = element.readAttribute("data-url");

  var original_action = form.action;
  var original_target = form.target;
  var original_enctype = form.enctype;
  var method_field = form.down("input[name=_method]");

  if (method_field) {
    var original_method = $F(method_field);
  }

  try {
    $('add_illustration').addClassName("busy");
    form.action = url;
    form.target = "invisible";
    form.enctype = "multipart/form-data";
    if (method_field) method_field.value = "POST"
    form.submit();
  } finally {
    form.action = original_action;
    form.target = original_target;
    form.enctype = original_enctype;
    if (method_field) method_field.value = original_method;
    element.value = "";
  }
});

Behaviors.add("click", "zoom-illustration", function(element, event) {
  var illustration = $(element.readAttribute('data-illustration'));
  var figure = element.up(".figure");

  var alt_src = illustration.readAttribute('data-alt-src');
  var alt_size = illustration.readAttribute('data-alt-dimensions');
  var alt_dims = alt_size.split("x");
  var alt_width = alt_dims[0];
  var alt_height = alt_dims[1];

  var caption = illustration.down('.caption').innerHTML;

  var bg = $('background');
  bg.show();
  bg.style.height = $(document.body).getHeight() + "px";

  var box = $('lightbox');
  var img = box.down('img');
  img.src = alt_src;
  img.width = alt_width;
  img.height = alt_height;

  if (figure) {
    box.style.left = "20px";
    box.style.right = "auto";
  } else {
    box.style.left = "auto";
    box.style.right = "20px";
  }

  var top = event.pointerY() - box.getHeight() / 2
  if (top + box.getHeight() > document.body.getHeight() - 5)
    top = document.body.getHeight() - box.getHeight() - 5;
  if (top < 5) top = 5;

  box.style.top = top + "px";

  box.down('.caption').innerHTML = caption;
  box.show();
});

Behaviors.add("click", "lightbox:close", function(element) {
  $('background').hide();
  $('lightbox').hide();
});

Behaviors.addSelector("click", "div.thumbnail a", function(element) {
  var div = element.up('div.thumbnail');
  var id = div.down('input.id');

  if(id) {
    if(confirm("Are you sure you want to remove this illustration?")) {
      div.hide();
      div.down('input.deleted').value = "1";
    }
  } else {
    div.remove();
  }

  event.stop();
});

Behaviors.addSelector("ajax:before", "#source_type a", function(element) {
  $$("#source_type a").invoke("removeClassName", "selected");
  element.addClassName('selected');
});

Behaviors.addSelector("click", "#existing_source a", function(element) {
  event.stop();
  $('existing_source').addClassName('hidden');
  $('new_source').addClassName('shown');
  $('existing_source').up('form').down('.which').value = 'new';
});

Behaviors.addSelector("click", "#new_source a", function(element) {
  event.stop();
  $('new_source').removeClassName('shown');
  $('existing_source').removeClassName('hidden');
  $('existing_source').up('form').down('.which').value = 'existing';
});
