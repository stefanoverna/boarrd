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

  function Widget(area, guid, is_new) {
    this.init(area, guid, is_new);
  }

  Widget.prototype = {
    init: function(area, guid, is_new) {
      var self = this;
      this._dashboard_data = $("#dashboard").metadata({type: "elem", name: "script"});
      this._guid = guid;
      this._area = area;

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

      if (this._$dom) return;

      this._$dom = $("#dashboard .widget-template > .widget-box").clone().appendTo("#"+this._area+" .column-inner");

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

    firstLoad();

    var $columns = $dashboard.find(".column .column-inner");

    $columns.each(function() {
      var $area = $(this);
      $area.parents(".column").find(".add-new-widget input").click(function() {
        var guid = GUID();
        window.widgets.push(new Widget($area.parents(".column").attr("id"), guid, true));
      });
    });

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

  });

});
