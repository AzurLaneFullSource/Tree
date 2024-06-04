local var0 = class("ContextProxy", pm.Proxy)

function var0.getCurrentContext(arg0)
	return arg0.data[#arg0.data]
end

function var0.pushContext(arg0, arg1)
	table.insert(arg0.data, arg1)
end

function var0.popContext(arg0)
	return table.remove(arg0.data)
end

function var0.cleanContext(arg0)
	arg0.data = {}
end

function var0.getContextCount(arg0)
	return #arg0.data
end

function var0.getContextByMediator(arg0, arg1)
	for iter0 = #arg0.data, 1, -1 do
		local var0 = arg0.data[iter0]
		local var1 = var0:getContextByMediator(arg1)

		if var1 then
			return var1, var0
		end
	end

	return nil
end

function var0.CleanUntilMediator(arg0, arg1)
	for iter0 = #arg0.data, 1, -1 do
		if not (arg0.data[iter0].mediator.__cname == arg1.__cname) then
			table.remove(arg0.data, iter0)
		else
			break
		end
	end
end

function var0.GetPrevContext(arg0, arg1)
	return arg0.data[#arg0.data - arg1]
end

function var0.RemoveContext(arg0, arg1)
	for iter0 = #arg0.data, 1, -1 do
		if arg1 == arg0.data[iter0] then
			table.remove(arg0.data, iter0)
		end
	end
end

function var0.PushContext2Prev(arg0, arg1, arg2)
	arg2 = arg2 or 1

	local var0 = math.clamp(#arg0.data + 1 - arg2, 1, #arg0.data + 1)

	table.insert(arg0.data, var0, arg1)
end

return var0
