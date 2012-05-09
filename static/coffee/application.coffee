$ ->
    if Paginator.hasNextPage()
        pagerize = Paginator.pagerize
        $(Paginator.nextPagerElement()).click (e) ->
            e.preventDefault()
            Paginator.pagerize()

$ ->
    $('.actions .edit').click (e) ->
        e.preventDefault()
        console.log('Edit!')
        $article = $(e.target).parents('article')
        $original_contents = $article.children('header,.body')
        $original_contents.hide()
        $form = $('<form/>').
            attr(method: 'POST', action: "/entry.update?id=#{$article.data('entry-id')}").append(
                $('<h1/>').append(
                    $('<input/>').attr(id: 'entry_title', name: 'entry_title', type: 'text', value: $article.find('h1').data('entry-title'))),
                $('<textarea/>').attr(id: 'entry_body', name: 'entry_body', rows: 10, cols: 30).text($article.find('.body').data('raw-body')),
                $('<p/>').append(
                    $('<input/>').attr(type: 'submit', value: '✔ 更新'))
            ).submit((e) ->
                $.ajax(type: 'POST', url: $(this).attr('action'), data: $(this).serialize()).
                    done(-> console.log(this)).
                    fail(-> console.log('Failed')).
                    always(-> console.log('Completed'))
                false
            ).appendTo($article)
        $('<button/>').text('キャンセル').
            click((e) ->
                e.preventDefault()
                $original_contents.show()
                $form.detach()
            ).appendTo($form.find('p'))
