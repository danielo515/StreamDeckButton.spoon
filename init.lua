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

-- Load the utilities module and msg module
local utilities = dofile(hs.spoons.resourcePath("utilities.lua"))
local msg = dofile(hs.spoons.resourcePath("msg.lua"))

-- Extract utility functions and msg functions to separate variables
local getValueForKeyPath = utilities.getValueForKeyPath
local getImageMessage = msg.getImageMessage
local setTitleMessage = msg.setTitleMessage
local showOkMessage = msg.showOkMessage

-- Attach msg helper methods to the main obj
obj.getImageMessage = getImageMessage
obj.setTitleMessage = setTitleMessage
obj.showOkMessage = showOkMessage

obj.keyDownSubscribers = {}
obj.willAppearSubscribers = {}

local keyDownSubscribers = obj.keyDownSubscribers
local willAppearSubscribers = obj.willAppearSubscribers

---@param id string
---@param callback function
function obj:subscribeKeyDown(id, callback)
	if not id or not callback then
		return
	end
	keyDownSubscribers[id] = keyDownSubscribers[id] or {}
	table.insert(keyDownSubscribers[id], callback)
end

---@param id string
---@param callback function
function obj:subscribeWillAppear(id, callback)
	if not id or not callback then
		return
	end
	willAppearSubscribers[id] = willAppearSubscribers[id] or {}
	table.insert(willAppearSubscribers[id], callback)
end

---@param message string
---@return string|nil
local function msgHandler(message)
	local params = json.decode(message)
	if params == nil then
		return
	end

	local event = params.event
	if event == nil then
		return
	end

	local id = getValueForKeyPath(params, "payload.settings.id")
	if id == nil then
		return
	end
	if contexts[id] == nil then
		contexts[id] = params.context
		print("context added for id: " .. id)
		obj.setTitle(id, "Not loaded")
	end

	local response = {}
	if event == "keyDown" then
		if contexts[id] == nil then
			return
		end
		if keyDownSubscribers[id] then
			for _, callback in ipairs(keyDownSubscribers[id]) do
				response = callback(contexts[id], params)
			end
		end
	elseif event == "willAppear" then
		if willAppearSubscribers[id] then
			for _, callback in ipairs(willAppearSubscribers[id]) do
				response = callback(contexts[id], params)
			end
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
	local message = setTitleMessage(contexts[id], title)
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
