exports = window if window

Item = Backbone.Model.extend
  defaults:
    order: 0
    deleted: false
    content: ""

  initialize: ->
    for a in _.keys @defaults
      continue if @get a
      obj = {}
      obj[a] = @defaults[a]
      @set obj

  url: ->
    ""

exports.Item = Item

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
    @destination = @$ "#destination"
    @render()
    return

  render: ->
    # TODO: determine what (if anything to do)

  addOne: (item) ->
    view = new ListItemView model: item
    window.foo = view
    @destination.append view.render().el

  newAttributes: ->
    return {
      content: @input.val()
      deleted: false
    }

  createOnEnter: (e) ->
    return unless e.keyCode == 13
    item = new Item @newAttributes()
    @list.add item
    @input.val ""


exports.app = new App()
