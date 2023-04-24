--- === StreamDeckButton ===

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "StreamDeckButton"
obj.settingsPath = "streamDeckButton"
obj.version = "1.0.0" -- {x-release-please-version}
obj.author = "Danielo Rodríguez <rdanielo@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/danielo515/StreamDeckButton.spoon"

--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new("StreamDeckButton", "debug")

local json = hs.json
local contexts = {}

-- Load the utilities module and msg module
local utilities = dofile(hs.spoons.resourcePath("utils.lua"))
local msg = dofile(hs.spoons.resourcePath("msg.lua"))

-- Extract utility functions and msg functions to separate variables
local getValueForKeyPath = utilities.getValueForKeyPath
local getImageMessage = msg.getImageMessage
local getTitleMessage = msg.getTitleMessage
local showOkMessage = msg.showOkMessage

-- Attach msg helper methods to the main obj
obj.getImageMessage = getImageMessage
obj.getTitleMessage = getTitleMessage
obj.showOkMessage = showOkMessage

obj.keyDownSubscribers = {}
obj.willAppearSubscribers = {}

local keyDownSubscribers = obj.keyDownSubscribers
local willAppearSubscribers = obj.willAppearSubscribers

local function storeInSettings(id, context)
	local settings = hs.settings.get(obj.settingsPath) or {}
	settings[id] = settings[id] or {}
	settings[id][context] = true
	hs.settings.set(obj.settingsPath)
	obj.logger.df("Storing context %s for button %s", context, id)
end

--- StreamDeckButton:onKeyDown(id, callback)
--- Method
--- Subscribes a callback function to be called when the "keyDown" event occurs for a specific button
---
--- Parameters:
---  * id - The identifier for the button
---  * callback - A function to be called when the "keyDown" event occurs for the button with the given id
function obj:onKeyDown(id, callback)
	if not id or not callback then
		return
	end
	keyDownSubscribers[id] = keyDownSubscribers[id] or {}
	table.insert(keyDownSubscribers[id], callback)
end

--- StreamDeckButton:onWillAppear(id, callback)
--- Method
--- Subscribes a callback function to be called when the "willAppear" event occurs for a specific button
---
--- Parameters:
---  * id - The identifier for the button
---  * callback - A function to be called when the "willAppear" event occurs for the button with the given id
function obj:onWillAppear(id, callback)
	if not id or not callback then
		return
	end
	willAppearSubscribers[id] = willAppearSubscribers[id] or {}
	table.insert(willAppearSubscribers[id], callback)
end

local function msgHandler(message)
	local params = json.decode(message)
	obj.logger.d("Received message: " .. message)
	if params == nil then
		obj.logger.e("params is nil")
		return
	end

	local event = params.event
	if event == nil then
		obj.logger.e("event is nil")
		return
	end

	local id = getValueForKeyPath(params, "payload.settings.id")
	if id == nil then
		obj.logger.e("id is nil")
		return
	end
	if contexts[id] == nil then
		contexts[id] = params.context
		obj.logger.i("context added for id: " .. id)
		obj.setTitle(id, "Not loaded")
		storeInSettings(id, params.context)
	end

	local response = {}
	if event == "keyDown" then
		if contexts[id] == nil then
			return
		end
		if keyDownSubscribers[id] then
			for _, callback in ipairs(keyDownSubscribers[id]) do
				response = callback(contexts[id], params)
				if response == nil then
					response = showOkMessage(contexts[id])
				end
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

--- StreamDeckButton.setTitle(id, title)
--- Method
--- Sets the title for a specific button
---
--- Parameters:
---  * id - The identifier for the button
---  * title - The new title to set
function obj.setTitle(id, title)
	if id == nil or contexts[id] == nil then
		return
	end
	local message = getTitleMessage(contexts[id], title)
	obj.server:send(json.encode(message))
end
--- StreamDeckButton.setImage(id, imagePath)
--- Method
--- Sets the image for a specific button
---
--- Parameters:
---  * id - The identifier for the button
---  * imagePath - The path to the image to set
function obj.setImage(id, imagePath)
	if id == nil or contexts[id] == nil then
		return
	end
	local message = getImageMessage(contexts[id], imagePath)
	obj.server:send(json.encode(message))
end
--- StreamDeckButton:start()
--- Method
--- Starts the HTTP server and websocket for communication with the Stream Deck
function obj:start()
	local server = hs.httpserver.new(false, true)
	server:setName("stream-deck")
	server:setInterface("localhost")
	server:setPort(3094)
	server:setCallback(function(method, path, headers, body)
		obj.logger.d(method, path, headers, body)
		return "OK", 200, {}
	end)
	obj.logger.i("Starting server")
	server:websocket("/ws", msgHandler)
	obj.server = server
	server:start()
	obj.logger.f("Server started %s", server)
	obj.logger.d(hs.inspect(hs.settings.get(obj.settingsPath)))
end

function obj:stop()
	local server = obj.server
	if server then
		server:stop()
		server = nil
	end
end

-- Return the Spoon object
return obj
