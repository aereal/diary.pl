class Editor
    constructor: (@article) ->
        self = @
        @contents = @article.children('header, .body')
        @form = $('<form/>').attr(method: 'POST', action: "/entry.update?id=#{@article.data('entry-id')}").append(
            $('<h1/>').append(
                $('<input/>').attr(id: 'entry_title', name: 'entry_title', type: 'text', value: @article.find('h1').data('entry-title'))),
            $('<textarea/>').attr(id: 'entry_body', name: 'entry_body', rows: 10, cols: 30).text(@article.find('.body').data('raw-body')),
            $('<p/>').append(
                $('<input/>').attr(type: 'submit', value: '✔ 更新'),
            )
        ).submit((e) ->
            console.log('Submit')
            e.preventDefault()
            self.update()
        )
        $('<button/>').text('キャンセル').click((e) ->
            e.preventDefault()
            self.cancel()
        ).appendTo(@form.find('p'))

    edit: ->
        @contents.detach()
        @form.appendTo(@article)

    cancel: ->
        @form.detach()
        @contents.appendTo(@article)

    update: ->
        self = @
        $.ajax(type: 'POST', url: @form.attr('action'), data: @form.serialize()
        ).done((res) ->
            console.log('Success')
            self.replaceArticle(res.title, res.body, res.formattedBody)
            self.cancel()
            $('<p/>').addClass('notice').text('更新しました').insertBefore(self.article.find('header')).delay(1000).fadeOut(600)
        ).fail(->
            console.log('Fail')
            $('<p/>').addClass('error').text('更新に失敗しました').insertBefore(self.article.find('header')).delay(1000).fadeOut(600)
        ).always(->
            console.log('Completed')
        )

    replaceArticle: (title, body, formattedBody) ->
        @contents.find('h1').data('entry-title', title).find('a:link').text(title)
        @contents.find('div.body').replaceWith(
            $('<div/>').addClass('body').data('raw-body', body).append($(formattedBody)))

