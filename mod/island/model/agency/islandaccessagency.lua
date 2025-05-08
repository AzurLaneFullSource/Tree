local var0_0 = class("IslandAccessAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.accessType = arg1_1.open_flag or IslandConst.ACCESS_TYPE_OPEN
	arg0_1.whiteList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.white_list) do
		table.insert(arg0_1.whiteList, iter1_1)
	end

	arg0_1.blackList = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.black_list) do
		table.insert(arg0_1.blackList, iter3_1)
	end

	arg0_1.visitorList = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.visitor_history) do
		table.insert(arg0_1.visitorList, iter5_1)
	end
end

function var0_0.SetWhiteList(arg0_2, arg1_2)
	arg0_2.whiteList = arg1_2
end

function var0_0.GetWhiteList(arg0_3)
	return arg0_3.whiteList
end

function var0_0.SetBlackList(arg0_4, arg1_4)
	arg0_4.blackList = arg1_4
end

function var0_0.AddBlackList(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5) do
		if not arg0_5:InBlackList(iter1_5) then
			table.insert(arg0_5.blackList, iter1_5)
		end
	end
end

function var0_0.CanAccess(arg0_6, arg1_6)
	if arg0_6:InWhiteList(arg1_6) then
		return true
	end

	if arg0_6:InBlackList(arg1_6) then
		return false
	end

	return arg0_6:IsOpenAccess()
end

function var0_0.IsOpenAccess(arg0_7)
	return arg0_7:GetAccessType() == IslandConst.ACCESS_TYPE_OPEN
end

function var0_0.InWhiteList(arg0_8, arg1_8)
	return table.contains(arg0_8.whiteList, arg1_8)
end

function var0_0.InBlackList(arg0_9, arg1_9)
	return table.contains(arg0_9.blackList, arg1_9)
end

function var0_0.GetAccessType(arg0_10)
	return arg0_10.accessType
end

function var0_0.SetAccessType(arg0_11, arg1_11)
	arg0_11.accessType = arg1_11
end

return var0_0
