streamElements = {} # keep track of DOM elements for each stream

# Whenever updateViews are involved, parameters passed through will always have:
# TBPublisher constructor, TBUpdateObjects, TBSubscriber constructor
# [id, top, left, width, height, zIndex, ... ]

#
# Helper methods
#
getPosition = (divName) ->
  # Get the position of element
  pubDiv = document.getElementById(divName)
  if !pubDiv then return {}
  origRect = pubDiv.getClientRects()[0]

  rect = {
    top: origRect.top,
    left: origRect.left,
    bottom: origRect.bottom,
    right: origRect.right,
    width: origRect.width,
    height: origRect.height,
  }
  if rect.left == 0 && rect.right > 0
    rect.left = window.innerWidth - rect.right - rect.width
  if rect.left < 0
    rect.left = 0
  if rect.top == 0 && rect.bottom > 0
    rect.top = window.innerHeight - rect.bottom - rect.height
  return rect

replaceWithVideoStream = (divName, streamId, properties) ->
  typeClass = if streamId == PublisherStreamId then PublisherTypeClass else SubscriberTypeClass
  element = document.getElementById(divName)

  element.setAttribute( "data-streamid", streamId )

  streamElements[ streamId ] = element
  return element

TBError = (error) ->
  navigator.notification.alert(error)

TBSuccess = ->
  console.log("success")

TBUpdateObjects = ()->
  console.log("JS: Objects being updated in TBUpdateObjects")
  objects = document.getElementsByClassName('OT_root')

  ratios = TBGetScreenRatios()

  for e in objects
    console.log("JS: Object updated")
    streamId = e.dataset.streamid
    console.log("JS sessionId: " + streamId )
    id = e.id
    position = getPosition(id)
    Cordova.exec(TBSuccess, TBError, OTPlugin, "updateView", [streamId, position.top, position.left, position.width, position.height, TBGetZIndex(e), ratios.widthRatio, ratios.heightRatio] )
  return
TBGenerateDomHelper = ->
  domId = "PubSub" + Date.now()
  div = document.createElement('div')
  div.setAttribute( 'id', domId )
  document.body.appendChild(div)
  return domId

TBGetZIndex = (ele) ->
  zIndex = parseInt(ele.style.zIndex)
  return zIndex || parseInt(window.getComputedStyle(ele).getPropertyValue("z-index"))

TBGetScreenRatios = ()->
    # Ratio between browser window size and viewport size
    return {
        widthRatio: window.outerWidth / window.innerWidth,
        heightRatio: window.outerHeight / window.innerHeight
    }

pdebug = (msg, data) ->
  console.log "JS Lib: #{msg} - ", data
