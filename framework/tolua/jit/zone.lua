local var0 = table.remove

return setmetatable({
	flush = function(arg0)
		for iter0 = #arg0, 1, -1 do
			arg0[iter0] = nil
		end
	end,
	get = function(arg0)
		return arg0[#arg0]
	end
}, {
	__call = function(arg0, arg1)
		if arg1 then
			arg0[#arg0 + 1] = arg1
		else
			return (assert(var0(arg0), "empty zone stack"))
		end
	end
})
