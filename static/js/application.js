
$(function() {
  var pagerize;
  if (Paginator.hasNextPage()) {
    pagerize = Paginator.pagerize;
    $(Paginator.nextPagerElement()).click(function(e) {
      e.preventDefault();
      return Paginator.pagerize();
    });
  }
  return $('.actions .edit').click(function(e) {
    var $E;
    e.preventDefault();
    console.log('Edit!');
    $E = new Editor($(this).parents('article'));
    return $E.edit();
  });
});
