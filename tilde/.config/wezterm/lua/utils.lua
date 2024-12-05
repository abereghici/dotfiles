local M = {}

function M.merge_tables(...)
	local result = {}
	local tables = { ... }
	for i = 1, select("#", ...) do
		for k, v in pairs(tables[i]) do
			result[k] = v
		end
	end
	return result
end

return M
