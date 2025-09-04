local var0_0 = class("IslandAccessAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.whiteList = {}
	arg0_1.blackList = {}
	arg0_1.visitorList = {}
	arg0_1.inviteCode = ""
	arg0_1.freshInviteCodeFlag = 0
	arg0_1.openFlag = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.flag_list) do
		table.insert(arg0_1.openFlag, iter1_1)
	end
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	arg0_2.inviteCode = arg1_2.invite_code

	for iter0_2, iter1_2 in ipairs(arg1_2.white_list or {}) do
		table.insert(arg0_2.whiteList, iter1_2)
	end

	for iter2_2, iter3_2 in ipairs(arg1_2.black_list or {}) do
		table.insert(arg0_2.blackList, iter3_2)
	end

	for iter4_2, iter5_2 in ipairs(arg1_2.visitor_history or {}) do
		table.insert(arg0_2.visitorList, IslandVisitorLog.New(iter5_2))
	end

	for iter6_2, iter7_2 in ipairs(arg1_2.daily_list) do
		if iter7_2.key == IslandConst.DL_INVITE_CODE_FLAG then
			arg0_2.freshInviteCodeFlag = iter7_2.value
		end
	end
end

function var0_0.GetVisitorLogList(arg0_3)
	return arg0_3.visitorList
end

function var0_0.AddVisitorLog(arg0_4, arg1_4)
	table.insert(arg0_4.visitorList, arg1_4)
end

function var0_0.isFreshInviteCode(arg0_5)
	return arg0_5.freshInviteCodeFlag == 1
end

function var0_0.MarkFreshInviteCodeFlag(arg0_6)
	arg0_6.freshInviteCodeFlag = 1
end

function var0_0.ResetFreshInviteCodeFlag(arg0_7)
	arg0_7.freshInviteCodeFlag = 0
end

function var0_0.GetInviteCode(arg0_8)
	return arg0_8.inviteCode
end

function var0_0.SetInviteCode(arg0_9, arg1_9)
	arg0_9.inviteCode = arg1_9
end

function var0_0.GetOpenFlag(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.openFlag) do
		table.insert(var0_10, iter1_10)
	end

	return var0_10
end

function var0_0.HasOpenFlag(arg0_11, arg1_11)
	return table.contains(arg0_11.openFlag, arg1_11)
end

function var0_0.AddOpenFlag(arg0_12, arg1_12)
	if arg0_12:HasOpenFlag(arg1_12) then
		return
	end

	table.insert(arg0_12.openFlag, arg1_12)
end

function var0_0.RemoveOpenFlag(arg0_13, arg1_13)
	if not arg0_13:HasOpenFlag(arg1_13) then
		return
	end

	table.removebyvalue(arg0_13.openFlag, arg1_13)
end

function var0_0.SetWhiteList(arg0_14, arg1_14)
	arg0_14.whiteList = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		table.insert(arg0_14.whiteList, iter1_14)
	end
end

function var0_0.GetWhiteList(arg0_15)
	return arg0_15.whiteList
end

function var0_0.SetBlackList(arg0_16, arg1_16)
	arg0_16.blackList = {}

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		table.insert(arg0_16.blackList, iter1_16)
	end
end

function var0_0.GetBlackList(arg0_17)
	return arg0_17.blackList
end

function var0_0.AddBlackList(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg1_18) do
		if not arg0_18:InBlackList(iter1_18) then
			table.insert(arg0_18.blackList, iter1_18)
		end
	end
end

function var0_0.InWhiteList(arg0_19, arg1_19)
	return table.contains(arg0_19.whiteList, arg1_19)
end

function var0_0.InBlackList(arg0_20, arg1_20)
	return table.contains(arg0_20.blackList, arg1_20)
end

return var0_0
