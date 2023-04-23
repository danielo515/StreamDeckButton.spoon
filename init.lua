local obj = {}
obj.__index = obj

-- Metadata
obj.name = "StreamDeckButton"
obj.version = "1.0"
obj.author = "Danielo Rodríguez <rdanielo@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/danielo515/StreamDeckButton.spoon"

local json = hs.json
local contexts = {}
local server

-- Load the utilities module and extract utility functions to separate variables
local utilities = dofile(hs.spoons.resourcePath("utilities.lua"))
local getValueForKeyPath = utilities.getValueForKeyPath
local loadImageAsBase64 = utilities.loadImageAsBase64

-- Message handling functions
---@param id string
---@param imagePath string
---@return Event|nil
local function getImageMessage(id, imagePath)
	local imageBase64 = loadImageAsBase64(imagePath)
	if imageBase64 then
		return {
			event = "setImage",
			context = contexts[id],
			payload = {
				image = imageBase64,
				target = 0,
				state = 0,
			},
		}
	else
		hs.alert.show("Image not loaded: " .. imagePath)
		return nil
	end
end

---@param msg string
---@return string|nil
local function msgHandler(msg)
	local params = json.decode(msg)
	if params == nil then
		return
	end

	local event = params.event
	if event == nil then
		return
	end

	local id = getValueForKeyPath(params, "payload.settings.id")
	if id ~= nil and contexts[id] == nil then
		contexts[id] = params.context
		print("context added for id: " .. id)
		obj.setTitle(id, "Not loaded")
	end

	local response = {}
	if event == "keyDown" then
		if id == nil or contexts[id] == nil then
			return
		end
		response = { event = "showOk", context = contexts[id] }
	elseif event == "willAppear" then
		if id == "loadImage" then
			local imagePath = "~/Pictures/tv-test.png"
			response = getImageMessage(id, imagePath) or {}
		end
	end

	return json.encode(response)
end

---@param id string
---@param title string
function obj.setTitle(id, title)
	if id == nil or contexts[id] == nil then
		return
	end
	local message = { event = "setTitle", context = contexts[id], payload = { title = title, target = 0, state = 0 } }
	server:send(json.encode(message))
end

function obj:start()
	server = hs.httpserver.new(false, true)
	server:setName("stream-deck")
	server:setInterface("localhost")
	server:setPort(3094)
	server:setCallback(function(method, path, headers, body)
		print(method, path, headers, body)
		return "OK", 200, {}
	end)

	server:websocket("/ws", msgHandler)
end

function obj:stop()
	if server then
		server:stop()
		server = nil
	end
end

-- Return the Spoon object
return obj
