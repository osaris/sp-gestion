# From http://yehudakatz.com/2011/08/12/understanding-prototypes-in-javascript/
fromPrototype = (prototype, object) ->
  newObject = {}
  newObject.prototype = prototype
  `for(prop in object)
    {
      if(object.hasOwnProperty(prop))
        newObject[prop] = object[prop];
    }`
  return newObject

window.Rails=fromPrototype Array,
  register_init: (names, fun) ->
    if(typeof(names.forEach) != 'undefined')
      names.forEach (name) ->
        Rails.register_init(name,fun)
    else
      previously_registered=this[names]
      this[names]=() ->
        if(typeof(previously_registered) != 'undefined')
          previously_registered.call()
        fun.call()
  init: (name) ->
    if(typeof(this[name]) != 'undefined')
      this[name]()

window.focus_first_visible_field = () ->
  $(':text:visible:enabled:first').focus()