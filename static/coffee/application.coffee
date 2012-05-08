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
            if pager.next_page?
                self.nextPagerElement().uri().search(page: pager.next_page)
            else
                self.nextPagerElement().detach()

            $.each entries, (idx, article) ->
                created_at = new Date article.created_at
                timestamp = "#{created_at.getHours()}:#{created_at.getMinutes()}"
                $('<article/>').attr(itemscope: true, itemtype: 'http://schema.org/BlogPosting', itemprop: 'blogPosts').append(
                    $('<header/>').append(
                        $('<h1/>').append(
                            $('<a/>').attr(itemprop: 'url', href: "/entry/#{article.id}").text(article.title))
                        $('<p/>').addClass('metadata').append(
                            $('<time/>').attr(pubdate: true, itemprop: 'datePublished', datetime: article.created_at).text(timestamp)))
                    $('<div/>').addClass('body').attr(itemprop: 'articleBody').append(article.formatted_body)
                ).insertBefore(self.pager())

    getNextPageNumber: ->
        parseInt @nextPagerElement().uri().search(true).page

    hasNextPage: ->
        @nextPagerElement().length != 0

    hasPrevPage: ->
        @prevPagerElement().length != 0

    pageable: ->
        @hasNextPage() || @hasPrevPage()

$ ->
    if Paginator.hasNextPage()
        $(Paginator.nextPagerElement()).click (e) ->
            e.preventDefault()
            Paginator.pagerize()
