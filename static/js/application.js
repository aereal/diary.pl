var Paginator;

Paginator = {
  pagerSelector: 'p.pager',
  nextPagerElement: function() {
    return $('p.pager > a[rel=next]');
  },
  prevPagerElement: function() {
    return $('p.pager > a[rel=prev]');
  },
  pager: function() {
    if (!this._pager) {
      this._pager = $(this.pagerSelector);
    }
    return this._pager;
  },
  fetchJSON: function(pageNum, callback) {
    return $.getJSON("/index.api?page=" + pageNum, function(data) {
      return callback(data.pager, data.entries);
    });
  },
  pagerize: function() {
    var self;
    self = this;
    return this.fetchJSON(this.getNextPageNumber(), function(pager, entries) {
      $.each(entries, self.appendArticle);
      if (pager.next_page != null) {
        self.nextPagerElement().detach();
      }
      if (pager.prev_page != null) {
        return self.prevPagerElement().detach();
      }
    });
  },
  appendArticle: function(idx, article) {
    return $('<article/>').attr({
      itemscope: true,
      itemtype: 'http://schema.org/BlogPosting',
      itemprop: 'blogPosts'
    }).append($('<header/>').append($('<h1/>').append($('<a/>').attr({
      itemprop: 'url',
      href: "/entry/" + article.id
    }).text(article.title)), $('<p/>').addClass('metadata').append($('<time/>').attr({
      pubdate: true,
      itemprop: 'datePublished',
      datetime: article.created_at
    }).text(article.created_at))), $('<div/>').addClass('body').attr({
      itemprop: 'articleBody'
    }).append(article.formatted_body)).insertBefore(this.pager());
  },
  getNextPageNumber: function() {
    return parseInt(this.nextPagerElement().uri().search(true).page);
  },
  hasNextPage: function() {
    return this.nextPagerElement().length !== 0;
  },
  hasPrevPage: function() {
    return this.prevPagerElement().length !== 0;
  },
  pageable: function() {
    return this.hasNextPage() || this.hasPrevPage();
  }
};
