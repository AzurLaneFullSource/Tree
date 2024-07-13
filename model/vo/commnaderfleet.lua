local var0_0 = class("CommnaderFleet", import(".BaseVO"))

var0_0.RENAME_CODE_TIME = 60

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:Update(arg1_1)
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.name = arg1_2.name or i18n("commander_prefab_name", arg0_2.id)
	arg0_2.commanders = arg1_2.commanders or {}
	arg0_2.renameTime = 0
end

function var0_0.canRename(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_3 = var0_0.RENAME_CODE_TIME - (var0_3 - arg0_3.renameTime)

	if var1_3 <= 0 then
		return true
	end

	return false, i18n("commander_prefab_rename_time", var1_3)
end

function var0_0.updateCommander(arg0_4, arg1_4, arg2_4)
	arg0_4.commanders[arg1_4] = arg2_4
end

function var0_0.getName(arg0_5)
	return arg0_5.name
end

function var0_0.updateName(arg0_6, arg1_6)
	arg0_6.name = arg1_6
	arg0_6.renameTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.getCommanderByPos(arg0_7, arg1_7)
	return arg0_7.commanders[arg1_7]
end

function var0_0.getCommander(arg0_8)
	return arg0_8.commanders
end

function var0_0.updateCommanders(arg0_9, arg1_9)
	arg0_9.commanders = arg1_9
end

function var0_0.contains(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.commanders) do
		if iter1_10.id == arg1_10 then
			return true
		end
	end

	return false
end

function var0_0.getCommanderIds(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.commanders) do
		table.insert(var0_11, iter1_11.id)
	end

	return var0_11
end

function var0_0.removeCommander(arg0_12, arg1_12)
	for iter0_12, iter1_12 in pairs(arg0_12.commanders) do
		if iter1_12.id == arg1_12 then
			arg0_12.commanders[iter0_12] = nil
		end
	end
end

function var0_0.isEmpty(arg0_13)
	return table.getCount(arg0_13.commanders) == 0
end

function var0_0.isSame(arg0_14, arg1_14)
	local var0_14 = arg0_14.commanders[1]
	local var1_14 = arg1_14[1]
	local var2_14 = arg0_14.commanders[2]
	local var3_14 = arg1_14[2]
	local var4_14 = var0_14 == nil and var1_14 == nil or var0_14 and var1_14 and var0_14.id == var1_14.id
	local var5_14 = var2_14 == nil and var3_14 == nil or var2_14 and var3_14 and var2_14.id == var3_14.id

	return var4_14 and var5_14
end

function var0_0.isSameId(arg0_15, arg1_15)
	local var0_15 = arg0_15.commanders[1]
	local var1_15 = arg1_15[1]
	local var2_15 = arg0_15.commanders[2]
	local var3_15 = arg1_15[2]
	local var4_15 = var0_15 == nil and var1_15 == nil or var0_15 and var1_15 and var0_15.id == var1_15
	local var5_15 = var2_15 == nil and var3_15 == nil or var2_15 and var3_15 and var2_15.id == var3_15

	return var4_15 and var5_15
end

return var0_0
