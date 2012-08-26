path = require('path')
argv = require('optimist')
  .usage('Usage: $0 --server [server url] --wsport [websocket port to use] --webport [js port to use] -w [watch directory] -w [watch directory]')
  .demand(['w'])
  .default('server', 'localhost')
  .default('wsport', 8008)
  .default('webport', 8009)
  .argv

watchPaths = argv.w
if !Array.isArray watchPaths
  watchPaths = [watchPaths]

wsport = argv.wsport
webport = argv.webport

watch = require('nodewatch')
io = require('socket.io').listen(wsport)

watch.add(path.resolve(watchPath)) for watchPath in watchPaths

watchEventListen = false;
_socket = null
io.sockets.on('connection', (socket) ->
  console.log 'connection'
  _socket = socket
  if watchEventListen is false # event listen once
    watch.onChange(() ->
      console.log('emit reload')
      _socket.emit('reload')
    )
    watchEventListen = true
);

http =  require 'http'
fs = require 'fs'
server = http.createServer (req, res) ->
    if req.url == '/'
      res.writeHead 200, { 'Content-Type': 'text/html' }
      res.write '<html><head><title>NOF5 Webserver</title></head><body><h1>NOF5 works!</h1></body></html>'

    else if req.url == '/NOF5-client.js'
      res.writeHead 200, { 'Content-Type': 'text/javascript' }
      js = fs.readFileSync('NOF5-client.js').toString()
      js = js.replace('#{wsport}', wsport)
      js = js.replace('#{server}', argv.server)
      res.write js

    else
      res.writeHead 404, { 'Content-Type': 'text/plain' }
      res.write 'Not Found'

    res.end()
  server.listen webport

scriptUrl = "#{argv.server}:#{argv.webport}/NOF5-client.js"
console.log "NOF5 starting.."
console.log '<script src="http://cdnjs.cloudflare.com/ajax/libs/socket.io/0.9.6/socket.io.min.js"></script>'
console.log '<script src="http://'+scriptUrl+'"></script>'
