local var0_0 = table.remove

return setmetatable({
	flush = function(arg0_1)
		for iter0_1 = #arg0_1, 1, -1 do
			arg0_1[iter0_1] = nil
		end
	end,
	get = function(arg0_2)
		return arg0_2[#arg0_2]
	end
}, {
	__call = function(arg0_3, arg1_3)
		if arg1_3 then
			arg0_3[#arg0_3 + 1] = arg1_3
		else
			return (assert(var0_0(arg0_3), "empty zone stack"))
		end
	end
})
