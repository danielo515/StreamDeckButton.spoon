local msg = {}
msg.__index = msg

local utilities = dofile(hs.spoons.resourcePath("utilities.lua"))
local loadImageAsBase64 = utilities.loadImageAsBase64

---@param context string
---@param imagePath string
---@return Event|nil
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

---@param context string
---@param title string
---@return table
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

---@param context string
---@return table
function msg.showOkMessage(context)
	return {
		event = "showOk",
		context = context,
	}
end

return msg
