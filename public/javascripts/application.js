jQuery(document).ready(function($) {
  $(".dashboard").each(function() {
    $dashboard = $(this);
    data = $dashboard.metadata({type: "elem", name: "script"});
    alert(data);
  });
});
