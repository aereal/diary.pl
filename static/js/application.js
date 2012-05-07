var Paginator;

Paginator = {
  THRESHOLD: 70.0,
  root: $('*:root'),
  pagerSelector: 'p.pager',
  nextPagerElement: function() {
    return $('p.pager > a[rel=next]');
  },
  prevPagerElement: function() {
    return $('p.pager > a[rel=prev]');
  },
  pager: function() {
    if (!(this._pager != null)) {
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
      if (pager.next_page != null) {
        self.nextPagerElement().uri().search({
          page: pager.next_page
        });
      } else {
        self.nextPagerElement().detach();
      }
      return $.each(entries, function(idx, article) {
        var created_at, timestamp;
        created_at = new Date(article.created_at);
        timestamp = "" + (created_at.getHours()) + ":" + (created_at.getMinutes());
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
        }).text(timestamp))), $('<div/>').addClass('body').attr({
          itemprop: 'articleBody'
        }).append(article.formatted_body)).insertBefore(self.pager());
      });
    });
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
  },
  positionRatio: function() {
    return -this.root.position().top / this.root.height();
  }
};

$(document).scroll(function(e) {
  if (Paginator.hasNextPage() && Paginator.positionRatio() >= (Paginator.THRESHOLD / 100)) {
    console.log("Overed " + Paginator.THRESHOLD + "%, automatically load next page!");
    return Paginator.pagerize();
  }
});
