var Editor;

Editor = (function() {

  Editor.name = 'Editor';

  function Editor(article) {
    var self;
    this.article = article;
    self = this;
    this.contents = this.article.children('header, .body');
    this.form = $('<form/>').attr({
      method: 'POST',
      action: "/entry.update?id=" + (this.article.data('entry-id'))
    }).append($('<h1/>').append($('<input/>').attr({
      id: 'entry_title',
      name: 'entry_title',
      type: 'text',
      value: this.article.find('h1').data('entry-title')
    })), $('<textarea/>').attr({
      id: 'entry_body',
      name: 'entry_body',
      rows: 10,
      cols: 30
    }).text(this.article.find('.body').data('raw-body')), $('<p/>').append($('<input/>').attr({
      type: 'submit',
      value: '✔ 更新'
    }))).submit(function(e) {
      console.log('Submit');
      e.preventDefault();
      return self.update();
    });
    $('<button/>').text('キャンセル').click(function(e) {
      e.preventDefault();
      return self.cancel();
    }).appendTo(this.form.find('p'));
  }

  Editor.prototype.edit = function() {
    this.contents.detach();
    return this.form.appendTo(this.article);
  };

  Editor.prototype.cancel = function() {
    this.form.detach();
    return this.contents.appendTo(this.article);
  };

  Editor.prototype.update = function() {
    var self;
    self = this;
    return $.ajax({
      type: 'POST',
      url: this.form.attr('action'),
      data: this.form.serialize()
    }).done(function(res) {
      console.log('Success');
      self.replaceArticle(res.title, res.body, res.formattedBody);
      self.cancel();
      return $('<p/>').addClass('notice').text('更新しました').insertBefore(self.article.find('header')).delay(1000).fadeOut(600);
    }).fail(function() {
      console.log('Fail');
      return $('<p/>').addClass('error').text('更新に失敗しました').insertBefore(self.article.find('header')).delay(1000).fadeOut(600);
    }).always(function() {
      return console.log('Completed');
    });
  };

  Editor.prototype.replaceArticle = function(title, body, formattedBody) {
    this.contents.find('h1').data('entry-title', title).find('a:link').text(title);
    return this.contents.find('div.body').replaceWith($('<div/>').addClass('body').data('raw-body', body).append($(formattedBody)));
  };

  return Editor;

})();
