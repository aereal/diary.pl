var Paginator = {
    pagerSelector: 'p.pager',
    pager: function(){
        if (!this._pager) this._pager = $(this.pagerSelector);
        return this._pager;
    },
    fetchJSON: function(pageNum, callback) {
        $.getJSON('/index.api?page=' + pageNum, function(data) { callback(data.pager, data.entries) });
    },
    pagerize: function(pageNum){
        var self = this;
        this.fetchJSON(pageNum, function(pager, entries) {
            $.each(entries, self.appendArticle);
        });
    },
    popPagerElement: function() {
        this.pager().detach();
    },
    appendArticle: function(idx, article) {
        $('<article/>').attr({'itemscope': true, 'itemtype': 'http://schema.org/BlogPosting', 'itemprop': 'blogPosts'}).append(
            $('<header/>').append(
                $('<h1/>').append(
                    $('<a/>').attr({'itemprop': 'url', 'href': '/entry/' + article.id}).text(article.title)),
                $('<p/>').addClass('metadata').append(
                    $('<time/>').attr({'pubdate': true, 'itemprop': 'datePublished', 'datetime': article.created_at}).text(article.created_at))
            ),
            $('<div/>').addClass('body').attr('itemprop', 'articleBody').append(article.formatted_body)
        ).appendTo($('div.content'));
    }
};

