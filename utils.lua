local utils = {}
local img = hs.image
-- Utility functions

function utils.getValueForKeyPath(tbl, keyPath)
	local keys = hs.fnutils.split(keyPath, ".", nil, true)
	local value = tbl

	for _, key in ipairs(keys) do
		value = value[key]
		if value == nil then
			return nil
		end
	end

	return value
end

function utils.loadImageAsBase64(imagePath)
	local image = img.imageFromPath(imagePath)
	if image then
		local imageData = image:encodeAsURLString()
		return imageData
	end
	return nil
end

return utils
