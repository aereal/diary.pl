Paginator =
    pagerSelector: 'p.pager'
    nextPagerElement: -> $('p.pager > a[rel=next]')
    prevPagerElement: -> $('p.pager > a[rel=prev]')
    pager: ->
        if not @_pager? then @_pager = $(@pagerSelector)
        @_pager

    fetchJSON: (pageNum, callback) ->
        $.getJSON "/index.api?page=#{pageNum}", (data) ->
            callback(data.pager, data.entries)

    pagerize: ->
        self = this
        @fetchJSON @getNextPageNumber(), (pager, entries) ->
            $.each(entries, self.appendArticle)
            if pager.next_page?
                self.nextPagerElement().detach()

            if pager.prev_page?
                self.prevPagerElement().detach()

    appendArticle: (idx, article) ->
        $('<article/>').attr(itemscope: true, itemtype: 'http://schema.org/BlogPosting', itemprop: 'blogPosts').append(
            $('<header/>').append(
                $('<h1/>').append(
                    $('<a/>').attr(itemprop: 'url', href: "/entry/#{article.id}").text(article.title))
                $('<p/>').addClass('metadata').append(
                    $('<time/>').attr(pubdate: true, itemprop: 'datePublished', datetime: article.created_at).text(article.created_at)))
            $('<div/>').addClass('body').attr(itemprop: 'articleBody').append(article.formatted_body)
        ).insertBefore(@pager())

    getNextPageNumber: ->
        parseInt @nextPagerElement().uri().search(true).page

    hasNextPage: ->
        @nextPagerElement().length != 0

    hasPrevPage: ->
        @prevPagerElement().length != 0

    pageable: ->
        @hasNextPage() || @hasPrevPage()
