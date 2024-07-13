local var0_0 = class("WSBaseCommand")

local function var1_0(arg0_1, arg1_1)
	return arg0_1 ~= nil and type(arg0_1) == arg1_1
end

local var2_0 = {
	__index = function(arg0_2, arg1_2)
		local var0_2 = rawget(arg0_2, "class")

		if var1_0(rawget(var0_0, arg1_2), "function") then
			return var0_2[arg1_2]
		elseif var1_0(rawget(var0_2, arg1_2), "function") then
			return function(arg0_3, ...)
				arg0_3:Op(arg1_2, ...)
			end
		else
			local var1_2 = rawget(arg0_2, arg1_2)

			if var1_2 == nil then
				return var0_2[arg1_2]
			else
				return var1_2
			end
		end
	end
}

function var0_0.Ctor(arg0_4, arg1_4)
	arg0_4.index = arg1_4
	arg0_4.wsOps = {}

	setmetatable(arg0_4, var2_0)
end

function var0_0.Dispose(arg0_5)
	return
end

function var0_0.Op(arg0_6, arg1_6, ...)
	assert(arg1_6 and #arg1_6 > 0)

	if #arg0_6.wsOps > 0 then
		WorldConst.Print("ignore operation: " .. arg1_6 .. ", current operation: " .. arg0_6.wsOps[#arg0_6.wsOps])

		return
	end

	WorldConst.Print(arg0_6.index .. " do operation: " .. arg1_6)
	table.insert(arg0_6.wsOps, arg1_6)
	arg0_6.class[arg1_6](arg0_6, ...)
end

function var0_0.OpDone(arg0_7, arg1_7, ...)
	assert(#arg0_7.wsOps > 0, "current operation can not be nil.")

	local var0_7 = arg0_7.wsOps[#arg0_7.wsOps]

	if arg1_7 ~= nil and var0_7 .. "Done" ~= arg1_7 then
		assert(false, "current operation " .. var0_7 .. " mismatch with " .. arg1_7)

		return
	end

	WorldConst.Print(arg0_7.index .. " operation done: " .. var0_7)
	table.remove(arg0_7.wsOps, #arg0_7.wsOps)

	if arg1_7 then
		arg0_7.class[arg1_7](arg0_7, ...)
	end
end

function var0_0.OpRaw(arg0_8, arg1_8, ...)
	local var0_8 = setmetatable({
		Op = function(arg0_9, arg1_9, ...)
			arg0_9.class[arg1_9](arg0_9, ...)
		end,
		OpDone = function(arg0_10, arg1_10, ...)
			if arg1_10 then
				arg0_10[arg1_10](arg0_10, ...)
			end
		end
	}, {
		__index = arg0_8,
		__newindex = arg0_8
	})

	var0_8[arg1_8](var0_8, ...)
end

function var0_0.OpClear(arg0_11)
	arg0_11.wsOps = {}
end

return var0_0
