local socket = require("socket")

local server = assert(socket.bind("*", 8080))
print("Server started at port 8080")

local function handleSigint()
  print("\nReceived SIGINT. Closing server...")
  server:close()
  os.exit()
end

--os.execute("trap 'lua -e \"require('script').handleSigint()' INT")

local success, err

local function handleHttpRequest(client)
  local request = "" 
  local line 

  repeat
    line = client:receive()
    if line then
      request = request .. line .. "\n"
    end
  until not line or line == ""
  
  local lines = {}
  for line in request:gmatch("([^\r\n]+)") do
    table.insert(lines, line)
  end
  
  print(request)

  if #lines > 0 then

    local requestLine = lines[1]
    print("Request Line: ", requestLine)

    local requestLineData= {}
    for data in string.gmatch(requestLine, "([^%s]+)") do
      table.insert(requestLineData, data)
    end

    local httpMethod = requestLineData[1]
    local httpPath = requestLineData[2]
    print(httpMethod)
    print(httpPath)
    
    local response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"

    local htmlContent = [[
    <!DOCTYPE html>
    <html>
      <head>
        <title>
          LuaSocket server
        </title>
      </head>
      <body>
        <h1>Hello!</h1>
        <p>Hello, world! From lua socket server</p>
        <p>Enda en linje fra min lua socket server</p>
        <table>
          <thead>
            <tr>
              <th>Hallo</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Wow hallo</td>
            </tr>
          </tbody>
        </table>
      </body>
    </html>
    ]]
    response = response .. htmlContent
    client:send(response)
  end

  client:close()
end

while true do
  local client, serv_err = server:accept()

  if client then
    print("Client cconnected!")

    handleHttpRequest(client)
  else
    print("Error accepting client connection: ", serv_err)
  end
end


--[[Find way to reach this code that makes sense
--success, err = pcall(function()
--  server:close()
--end)

--if success then
 -- print("Server did closed gracefully")
--else
  --print("Something happened when the server tried to close: ", err)
--end

--
--
--local http = require("socket.http")
--local url = "https://api.example.com/data"

-- Define headers as a table
-- local headers = {
  -- ["Authorization"] = "Bearer YourAccessToken",
  -- ["Content-Type"] = "application/json",
    -- Add any other headers you need
--}

-- Make the HTTP request with headers
--local response, status, headers, statusline = http.request {
--    url = url,
--    method = "GET",  -- or "POST", "PUT", etc.
--    headers = headers,
--}

-- Check the response status
--if status == 200 then
--    print("Request successful!")
--    print("Response:", response)
--else
--    print("Request failed. Status code:", status)
print("Status line:", statusline)
end

--
--]]


local Engine = {}


