local msg = {}
msg.__index = msg

local utilities = dofile(hs.spoons.resourcePath("utils.lua"))
local loadImageAsBase64 = utilities.loadImageAsBase64

--- StreamDeckButton.getImageMessage(context, imagePath)
--- Function
--- Generates an image message for the StreamDeckButton
---
--- Parameters:
---  * context - A string containing the context for the button
---  * imagePath - A string containing the path to the image file
---
--- Returns:
---  * An event table if the image was successfully loaded, otherwise nil
function msg.getImageMessage(context, imagePath)
	local imageBase64 = loadImageAsBase64(imagePath)
	if imageBase64 then
		return {
			event = "setImage",
			context = context,
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

--- StreamDeckButton.setTitleMessage(context, title)
--- Function
--- Generates a title message for the StreamDeckButton
---
--- Parameters:
---  * context - A string containing the context for the button
---  * title - A string containing the title text for the button
---
--- Returns:
---  * A table containing the title message details
function msg.setTitleMessage(context, title)
	return {
		event = "setTitle",
		context = context,
		payload = {
			title = title,
			target = 0,
			state = 0,
		},
	}
end

--- StreamDeckButton.showOkMessage(context)
--- Function
--- Generates a 'showOk' message for the StreamDeckButton
---
--- Parameters:
---  * context - A string containing the context for the button
---
--- Returns:
---  * A table containing the 'showOk' message details
function msg.showOkMessage(context)
	return {
		event = "showOk",
		context = context,
	}
end

return msg
