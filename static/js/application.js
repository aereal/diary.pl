
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

$(function() {
  return $('.actions .edit').click(function(e) {
    var $article, $form, $original_contents;
    e.preventDefault();
    console.log('Edit!');
    $article = $(e.target).parents('article');
    $original_contents = $article.children('header,.body');
    $original_contents.hide();
    $form = $('<form/>').attr({
      method: 'POST',
      action: "/entry.update?id=" + ($article.data('entry-id'))
    }).append($('<h1/>').append($('<input/>').attr({
      id: 'entry_title',
      name: 'entry_title',
      type: 'text',
      value: $article.find('h1').data('entry-title')
    })), $('<textarea/>').attr({
      id: 'entry_body',
      name: 'entry_body',
      rows: 10,
      cols: 30
    }).text($article.find('.body').data('raw-body')), $('<p/>').append($('<input/>').attr({
      type: 'submit',
      value: '✔ 更新'
    }))).submit(function(e) {
      $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: $(this).serialize()
      }).done(function() {
        return console.log(this);
      }).fail(function() {
        return console.log('Failed');
      }).always(function() {
        return console.log('Completed');
      });
      return false;
    }).appendTo($article);
    return $('<button/>').text('キャンセル').click(function(e) {
      e.preventDefault();
      $original_contents.show();
      return $form.detach();
    }).appendTo($form.find('p'));
  });
});
