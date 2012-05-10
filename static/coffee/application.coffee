$ ->
    if Paginator.hasNextPage()
        pagerize = Paginator.pagerize
        $(Paginator.nextPagerElement()).click (e) ->
            e.preventDefault()
            Paginator.pagerize()

    $('.actions .edit').click (e) ->
        e.preventDefault()
        console.log('Edit!')
        $E = new Editor $(@).parents('article')
        $E.edit()
