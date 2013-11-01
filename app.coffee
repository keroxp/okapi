http = require "http"
connect = require "connect"
_ = require "underscore"

app = connect(connect.basicAuth "fanloilo", "Rk252313tib3!")
app.use connect.static "./dist"
app.use connect.logger()
app.use (req, res) ->  
  res.writeHead 200
  res.end()
.listen(9000)