$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);

jQuery(document).ready(function($) {

  setInterval(function() {
      window.location.reload();
   }, 300000);

  function GUID() {
    return 'xxxx-xxxx-xxxx-xxxx'.replace(/[xy]/g, function(c) {var r = Math.random()*16|0,v=c=='x'?r:r&0x3|0x8;return v.toString(16);}).toUpperCase();
  }

  window.widgets = [];

  window.widget = function(guid) {
    for (var i=0; i<window.widgets.length; i++) {
      var widget = window.widgets[i];
      if (widget.guid() == guid) {
        return widget;
      }
    }
    return null;
  }

  function Widget(area, guid, is_new) {
    this.init(area, guid, is_new);
  }

  Widget.prototype = {
    init: function(area, guid, is_new) {
      var self = this;
      this._dashboard_data = $("#dashboard").metadata({type: "elem", name: "script"});
      this._$dom = $("#dashboard .widget-template > .widget-box").clone();
      this._guid = guid;
      this._area = area;
      this._is_new = is_new;

      if (is_new) {
        this._$newdom = $("#dashboard .widget-template > .widget-box .new-mode").clone();
        this._$newdom.find("#widget_area").val(area);
        this._$newdom.find("#widget_guid").val(guid);

        $.facebox(this._$newdom);
      }

    },
    created: function() {
      var self = this;

      $("#facebox .close").click();

      if (this._$dom.parents(".column").length > 0) return;

      this._$dom.appendTo("#"+this._area+" .column-inner");

      // settings button
      this._$dom.find(".widget-head .actions .settings a").click(function() {
        self.showSettings();
        return false;
      });

      // remove button
      this._$dom.find(".widget-head .actions .remove a").click(function() {
        if (!confirm("Do you really want to remove this widget?")) return;
        $.ajax({
          url: self._dashboard_data.widget_show_path.replace(":id", self._guid),
          dataType: 'script',
          type: "delete"
        });
        return false;
      });

      if (this._is_new) {
        this._is_new = false;
        setTimeout(
          function() {
            self.showSettings();
          },
          1000
        );
      }

    },
    guid: function() {
      return this._guid;
    },
    showSettings: function() {
      $.facebox(this._$dom.find(".edit-mode").clone());
    },
    setWidgetTitle: function(title) {
      this._$dom.find(".widget-head .title").text(title);
    },
    setInputTitle: function(title) {
      this._$dom.find(".type-bar").text(title);
    },
    setWidgetContent: function(dom) {
      this._$dom.find(".normal-mode").empty().append(dom);
    },
    setWidgetSettings: function(dom) {
      this._$dom.find(".edit-mode").empty().append(dom);
      this._$dom.find(".edit-mode button, .edit-mode input:submit").button();
    },
    setWidgetType: function(type) {
      this._widgetType = type;
      this._$dom.addClass(type);
    },
    remove: function() {
      var self = this;
      this._$dom.slideUp(function() {
        self._$dom.remove();
      });
    }
  }

  $("#dashboard").each(function() {
    var $dashboard = $(this);
    var $widget_template = $dashboard.find(".widget-template > .widget-box");

    $widget_template.find(".new-mode button, .new-mode input:submit").button();

    var data = $dashboard.metadata({type: "elem", name: "script"});

    window.Widgets = [];
    // TODO: aggiungere i widget esistenti
    $.each(data.dashboard_areas_widgets, function(area, guids) {
      $.each(guids, function() {
        window.widgets.push(new Widget(area, this, false));
      });
    });

    $(".add-new-widget").hide();
    var old_title = $(".dashboard-title").text();
    $(".dashboard-title").text("Boarrd is loading.. Please wait..");

    $.ajax({
      url: data.load_all_widgets_path,
      dataType: 'script',
      type: "get",
      success: function() {
        $(".add-new-widget").show();
        $(".dashboard-title").text(old_title);
      },
      error: function() {
        alert("Something went badly wrong. It is probably due to LifeHacker DDOS.. Please, try to reload the page, and sorry about that!");
      }
    });

    var $columns = $dashboard.find(".column .column-inner");

    $columns.each(function() {
      var $area = $(this);
      $area.parents(".column").find(".add-new-widget input").click(function() {
        var guid = GUID();
        window.widgets.push(new Widget($area.parents(".column").attr("id"), guid, true));
      });
    });

    if (data.editable) {
      $columns.sortable({
        forcePlaceholderSize: true,
        tolerance: 'pointer',
        dropOnEmpty: true,
        connectWith: ".column .column-inner",
        placeholder: 'widget-ghost',
        handle: '.widget-head',
        delay: 500,
        opacity: 0.7,
        revert: true,
        start: function(event, ui) {
          $("#dashboard").addClass("dragging-mode");
        },
        stop: function(event, ui) {

          $("#dashboard").removeClass("dragging-mode");

          var params = []
          $.each(window.widgets, function() {
            var index = this._$dom.prevAll().length;
            params.push({
              area_position: index,
              area: this._$dom.parents(".column").attr("id"),
              guid: this.guid()
            });
          });

          $.ajax({
            url: data.reorder_widgets_path,
            dataType: 'script',
            type: "get",
            data: {"reordered_widgets": JSON.stringify(params)}
          });

        }
      });
    }

  });

});


jQuery.fn.headlines = function(options) {

  var lines = [];

  this.each(function() {
    var $scrollable_container = $(this);
    var $scrollable_element = $($(this).children().get(0));

    var old_width = $scrollable_container.css("width");
    var old_height = $scrollable_container.css("height");
    $scrollable_container.css({width: "10000px"});
    var width = $scrollable_element.width();
    $scrollable_container.css({width: old_width, height: old_height, position: "relative"});

    $scrollable_element.remove();
    var elements = [];
    for (var i=0; i<3; i++) {
      elements.push($scrollable_element.clone().appendTo($scrollable_container).css({width: width, position: "absolute", top: "0px", display: "block"}).css("left", (width + 20) * i));
    }

    lines.push({
      els: elements,
      width: width
    });

  });

  var currentLine = 0;

  function scroller(lines) {
    var line = 0;

    return function() {
      for (var i=0; i<3; i++) {
        element = lines[line].els[i];
        width = lines[line].width;
        var left = parseInt(element.css("left"));
        if (left <= -(width + 20 - 20)) {
          var next_el = i - 1;
          if (next_el < 0) {
            next_el += 3;
          }
          element.css("left", parseInt(lines[line].els[next_el].css("left")) + width + 20);
          if (++line >= lines.length) {
            line = 0;
          }
        } else {
          element.css("left", left - 10)
        }
      }
    }

  }

  setInterval(
    scroller(lines),
    200
  );

}