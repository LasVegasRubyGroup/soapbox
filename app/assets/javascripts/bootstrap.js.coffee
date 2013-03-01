jQuery ->
  $("[rel=popover]").popover({
    placement: 'right'
    delay: { show: 300, hide: 100 }
    trigger: 'hover'
    html: true
  });
