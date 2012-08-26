socket = io.connect 'http://#{server}:#{wsport}'
div = document.createElement 'div'
div.style.backgroundColor = 'red'
div.style.width = '200px'
div.style.height = '50px'
div.style.position = 'absolute'
div.style.right = '0'
div.style.top = '0'
div.innerHTML = '<p>Updated <span>0</span> Sec(s) ago.'

timer = 0
window.setInterval( () ->
  div.getElementsByTagName('span')[0].innerHTML = ++timer
, 1000)

document.getElementsByTagName('body')[0].appendChild(div)

socket.on('reload', (data) ->
  div.innerHTML = 'reloading....'
  location.reload()
);