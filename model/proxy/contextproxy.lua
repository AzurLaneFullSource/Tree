local var0_0 = class("ContextProxy", pm.Proxy)

function var0_0.getCurrentContext(arg0_1)
	return arg0_1.data[#arg0_1.data]
end

function var0_0.pushContext(arg0_2, arg1_2)
	table.insert(arg0_2.data, arg1_2)
end

function var0_0.popContext(arg0_3)
	return table.remove(arg0_3.data)
end

function var0_0.cleanContext(arg0_4)
	arg0_4.data = {}
end

function var0_0.getContextCount(arg0_5)
	return #arg0_5.data
end

function var0_0.getContextByMediator(arg0_6, arg1_6)
	for iter0_6 = #arg0_6.data, 1, -1 do
		local var0_6 = arg0_6.data[iter0_6]
		local var1_6 = var0_6:getContextByMediator(arg1_6)

		if var1_6 then
			return var1_6, var0_6
		end
	end

	return nil
end

function var0_0.CleanUntilMediator(arg0_7, arg1_7)
	for iter0_7 = #arg0_7.data, 1, -1 do
		if not (arg0_7.data[iter0_7].mediator.__cname == arg1_7.__cname) then
			table.remove(arg0_7.data, iter0_7)
		else
			break
		end
	end
end

function var0_0.GetPrevContext(arg0_8, arg1_8)
	return arg0_8.data[#arg0_8.data - arg1_8]
end

function var0_0.RemoveContext(arg0_9, arg1_9)
	for iter0_9 = #arg0_9.data, 1, -1 do
		if arg1_9 == arg0_9.data[iter0_9] then
			table.remove(arg0_9.data, iter0_9)
		end
	end
end

function var0_0.PushContext2Prev(arg0_10, arg1_10, arg2_10)
	arg2_10 = arg2_10 or 1

	local var0_10 = math.clamp(#arg0_10.data + 1 - arg2_10, 1, #arg0_10.data + 1)

	table.insert(arg0_10.data, var0_10, arg1_10)
end

return var0_0
