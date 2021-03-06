class Mediator

  # ## Create a mediator
  constructor: (@name="") -> @channels = {}

  # ## Subscribe to a topic
  #
  # Parameters:
  #
  # - (String) topic      - The topic name
  # - (Function) callback - The function that gets called if an other module
  #                         publishes to the specified topic
  subscribe: (channel, fn) ->
    @channels[channel] = [] unless @channels[channel]?
    @channels[channel].push { context: @, callback: fn }
    @

  # ## Unsubscribe from a topic
  #
  # Parameters:
  #
  # - (String) topic      - The topic name
  # - (Function) callback - The function that gets called if an other module
  #                         publishes to the specified topic
  unsubscribe: (channel) ->
    #for subscription in @channels[channel]
    #  if subscription.context is @
    #    # remove it
    @

  # ## Publish an event
  #
  # Parameters:
  # (String) topic             - The topic name
  # (Object) data              - The data that gets published
  # (Boolean) publishReference - If the data should be passed as a reference to
  #                              the other modules this parameter has to be set
  #                              to *true*.
  #                              By default the data object gets copied so that
  #                              other modules can't influence the original
  #                              object.
  publish: (channel, data, publishReference) ->

    for topic, subscription of @channels[channel]

      if publishReference isnt true
        copy = {}
        copy[k] = v for k,v of data
        subscription.callback.apply subscription.context, [copy, topic]

      else
        subscription.callback.apply subscription.context, [data, topic]
    @

  # ## Install Pub/Sub functions to an object
  installTo: (obj) ->
    if typeof obj is "object"
      obj.subscribe = @subscribe
      obj.publish = @publish
    @
