$ ->
    if Paginator.hasNextPage()
        pagerize = Paginator.pagerize
        $(Paginator.nextPagerElement()).click (e) ->
            e.preventDefault()
            Paginator.pagerize()
