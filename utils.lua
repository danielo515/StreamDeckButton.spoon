local utils = {}
-- Utility functions
---@param tbl table
---@param keyPath string
---@return any
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

---@param imagePath string
---@return string|nil
function utils.loadImageAsBase64(imagePath)
	local image = hs.image.imageFromPath(imagePath)
	if image then
		local imageData = image:encodeAsURLString()
		return imageData
	end
	return nil
end

return utils
