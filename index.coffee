exports = window if window

Item = Backbone.Model.extend
  defaults:
    order: 0
    deleted: false
    content: ""

  initialize: ->
    @set
      content: @defaults.content
      deleted: @defaults.deleted
      order: @defaults.order

  url: ->
    ""

List = Backbone.Collection.extend
  model: Item

ListItemView = Backbone.View.extend
  tagName: "li"
  template: _.template($("#list-item-template").html())

  render: ->
    @$(@el).html(@template @model.toJSON())
    @setContent
    @

  setContent: ->
    @$(".content").text @model.get "content"

App = Backbone.View.extend
  el: $ "#app"

  events:
    "keypress #text": "createOnEnter"

  initialize: ->
    @input = $ "#text"
    @list = new List()
    @list.bind "all", @render, this
    @list.bind "add", @addOne, this
    @render()
    return

  render: ->
    console.log @list

  addOne: (item) ->
    console.log("addOne called", item, item.get "content")
    view = new ListItemView model: item
    window.foo = view
    console.log view.render().el
    @$("#destination").append view.render().el

  newAttributes: ->
    return {
      content: @input.val()
      deleted: false
    }

  createOnEnter: (e) ->
    return unless e.keyCode == 13
    item = new Item @newAttributes
    @list.add item
    @input.val ""
    #@list.create @newAttributes


exports.app = new App()
