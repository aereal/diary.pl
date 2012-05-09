
$(function() {
  var pagerize;
  if (Paginator.hasNextPage()) {
    pagerize = Paginator.pagerize;
    return $(Paginator.nextPagerElement()).click(function(e) {
      e.preventDefault();
      return Paginator.pagerize();
    });
  }
});
