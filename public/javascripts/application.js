jQuery(document).ready(function($) {

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

  function Widget(area, guid) {
    this.init(area, guid);
  }

  Widget.prototype = {
    init: function(area, guid) {
      var self = this;
      this._dashboard_data = $(".dashboard").metadata({type: "elem", name: "script"});
      this._guid = guid;
      this._area = area;
      this._$dom = $(".dashboard .widget-template > .widget").clone();
      this._$dom.insertBefore("#"+area+" .add-new-widget");
      this._$dom.find(".new-mode #widget_area").val(area);
      this._$dom.find(".new-mode #widget_guid").val(guid);
      this._$dom.find(".new-mode #widget_widget_type").change(function() {
        var widget_type = $(this).val();
        $.ajax({
          url: self._dashboard_data.input_for_path.replace(":widget_type", widget_type),
          success: function(dom) {
            if (self._$widget_input_field) {
              self._$widget_input_field.remove();
            }
            self._$widget_input_field = $(dom).insertBefore(self._$dom.find(".new-mode #widget_area"));
          }
        });
      });
      this.setMode('new');
    },
    setMode: function(mode) {
      this._$dom.find(".widget-content .mode").hide();
      this._$dom.find(".widget-content .mode."+mode+"-mode").show();
    },
    guid: function() {
      return this._guid;
    },
    setContent: function(dom) {
      this._$dom.find(".normal-mode").empty().append(dom);
    },
    setWidgetType: function(type) {
      this._widgetType = type;
      this._$dom.addClass(type);
    }
  }

  $(".dashboard").each(function() {
    var $dashboard = $(this);
    var $widget_template = $dashboard.find(".widget-template > .widget");
    var data = $dashboard.metadata({type: "elem", name: "script"});

    window.Widgets = [];
    // TODO: aggiungere i widget esistenti

    $dashboard.find(".column").each(function() {
      var $area = $(this);
      $area.find(".add-new-widget input").click(function() {
        var guid = GUID();
        window.widgets.push(new Widget($area.attr("id"), guid));
      });
    });

  });

});
