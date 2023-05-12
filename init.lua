--- === StreamDeckButton ===
local Events = {
	keyDown = "keyDown",
	willAppear = "willAppear",
	willDisappear = "willDisappear",
	keyUp = "keyUp",
}
local obj = {
	Events = Events,
	contexts = {},
}

obj.__index = obj

-- Metadata
obj.name = "StreamDeckButton"
obj.settingsPath = "streamDeckButton"
obj.version = "3.0.1" -- x-release-please-version
obj.author = "Danielo Rodríguez <rdanielo@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/danielo515/StreamDeckButton.spoon"

--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new("StreamDeckButton", "debug")

local json = hs.json
local s = hs.settings
local contexts = obj.contexts

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
local is = hs.inspect

local function getSettings()
	local settings = s.get(obj.name) or {}
	return settings
end

local function storeInSettings(id, context)
	local settings = getSettings()
	settings[id] = settings[id] or {}
	settings[id][context] = true
	s.set(obj.name, settings)
	obj.logger.df("Settings: %s", is(settings))
end

function obj:init()
	local settings = getSettings()
	for id, contexts in pairs(settings) do
		self.logger.df("Restoring context for id %s %s", id, contexts)
		self.contexts[id] = contexts
	end
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
	obj.logger.d("Received message")
	local params = json.decode(message)
	if params == nil then
		obj.logger.e("params is nil")
		obj.logger.d("message: " .. message)
		return
	end
	obj.logger.d("decoded message: ", is(params))

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
		obj.logger.f("new id found: %s with this context: %s", id, params.context)
		obj.setTitle(id, "Not loaded", params.context)
		contexts[id] = { [params.context] = true }
	end
	contexts[id][params.context] = true -- always store the context
	storeInSettings(id, params.context)

	if contexts[id] == nil then
		obj.logger.e("conntexts[id] is nil forr id: %s", id)
		return
	end
	local response = {}
	if event == "keyDown" then
		if keyDownSubscribers[id] then
			for _, callback in ipairs(keyDownSubscribers[id]) do
				response = callback(params.context, params)
			end
		end
	elseif event == "willAppear" then
		if willAppearSubscribers[id] then
			for _, callback in ipairs(willAppearSubscribers[id]) do
				response = callback(params.context, params)
			end
		end
	end

	if response == nil then
		response = showOkMessage(contexts[id])
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
function obj.setTitle(id, title, ctx)
	if id == nil then
		obj.logger.d("setTitle: id is nil")
		return
	end
	-- the context param is an internal optional parameter
	local contexts = (ctx and { [ctx] = true }) or contexts[id]
	if contexts == nil then
		obj.logger.f("setTitle: context is nil ctx:%s, contexts[%s]:%s", ctx, id, contexts)
		return
	end
	for context, _ in pairs(contexts) do
		local message = getTitleMessage(context, title)
		obj.server:send(json.encode(message))
	end
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
		obj.logger.e("setImage: id is nil or contexts[id] is nil", id)
		return
	end
	for context, _ in pairs(contexts[id]) do
		local message = getImageMessage(context, imagePath)
		obj.server:send(json.encode(message))
	end
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
	obj.logger.df("Settings: %s", hs.inspect(getSettings()))
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
