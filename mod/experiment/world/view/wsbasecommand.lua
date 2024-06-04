local var0 = class("WSBaseCommand")

local function var1(arg0, arg1)
	return arg0 ~= nil and type(arg0) == arg1
end

local var2 = {
	__index = function(arg0, arg1)
		local var0 = rawget(arg0, "class")

		if var1(rawget(var0, arg1), "function") then
			return var0[arg1]
		elseif var1(rawget(var0, arg1), "function") then
			return function(arg0, ...)
				arg0:Op(arg1, ...)
			end
		else
			local var1 = rawget(arg0, arg1)

			if var1 == nil then
				return var0[arg1]
			else
				return var1
			end
		end
	end
}

function var0.Ctor(arg0, arg1)
	arg0.index = arg1
	arg0.wsOps = {}

	setmetatable(arg0, var2)
end

function var0.Dispose(arg0)
	return
end

function var0.Op(arg0, arg1, ...)
	assert(arg1 and #arg1 > 0)

	if #arg0.wsOps > 0 then
		WorldConst.Print("ignore operation: " .. arg1 .. ", current operation: " .. arg0.wsOps[#arg0.wsOps])

		return
	end

	WorldConst.Print(arg0.index .. " do operation: " .. arg1)
	table.insert(arg0.wsOps, arg1)
	arg0.class[arg1](arg0, ...)
end

function var0.OpDone(arg0, arg1, ...)
	assert(#arg0.wsOps > 0, "current operation can not be nil.")

	local var0 = arg0.wsOps[#arg0.wsOps]

	if arg1 ~= nil and var0 .. "Done" ~= arg1 then
		assert(false, "current operation " .. var0 .. " mismatch with " .. arg1)

		return
	end

	WorldConst.Print(arg0.index .. " operation done: " .. var0)
	table.remove(arg0.wsOps, #arg0.wsOps)

	if arg1 then
		arg0.class[arg1](arg0, ...)
	end
end

function var0.OpRaw(arg0, arg1, ...)
	local var0 = setmetatable({
		Op = function(arg0, arg1, ...)
			arg0.class[arg1](arg0, ...)
		end,
		OpDone = function(arg0, arg1, ...)
			if arg1 then
				arg0[arg1](arg0, ...)
			end
		end
	}, {
		__index = arg0,
		__newindex = arg0
	})

	var0[arg1](var0, ...)
end

function var0.OpClear(arg0)
	arg0.wsOps = {}
end

return var0
