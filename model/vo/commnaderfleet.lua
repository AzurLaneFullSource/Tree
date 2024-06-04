local var0 = class("CommnaderFleet", import(".BaseVO"))

var0.RENAME_CODE_TIME = 60

function var0.Ctor(arg0, arg1)
	arg0:Update(arg1)
end

function var0.Update(arg0, arg1)
	arg0.id = arg1.id
	arg0.name = arg1.name or i18n("commander_prefab_name", arg0.id)
	arg0.commanders = arg1.commanders or {}
	arg0.renameTime = 0
end

function var0.canRename(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = var0.RENAME_CODE_TIME - (var0 - arg0.renameTime)

	if var1 <= 0 then
		return true
	end

	return false, i18n("commander_prefab_rename_time", var1)
end

function var0.updateCommander(arg0, arg1, arg2)
	arg0.commanders[arg1] = arg2
end

function var0.getName(arg0)
	return arg0.name
end

function var0.updateName(arg0, arg1)
	arg0.name = arg1
	arg0.renameTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.getCommanderByPos(arg0, arg1)
	return arg0.commanders[arg1]
end

function var0.getCommander(arg0)
	return arg0.commanders
end

function var0.updateCommanders(arg0, arg1)
	arg0.commanders = arg1
end

function var0.contains(arg0, arg1)
	for iter0, iter1 in pairs(arg0.commanders) do
		if iter1.id == arg1 then
			return true
		end
	end

	return false
end

function var0.getCommanderIds(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.commanders) do
		table.insert(var0, iter1.id)
	end

	return var0
end

function var0.removeCommander(arg0, arg1)
	for iter0, iter1 in pairs(arg0.commanders) do
		if iter1.id == arg1 then
			arg0.commanders[iter0] = nil
		end
	end
end

function var0.isEmpty(arg0)
	return table.getCount(arg0.commanders) == 0
end

function var0.isSame(arg0, arg1)
	local var0 = arg0.commanders[1]
	local var1 = arg1[1]
	local var2 = arg0.commanders[2]
	local var3 = arg1[2]
	local var4 = var0 == nil and var1 == nil or var0 and var1 and var0.id == var1.id
	local var5 = var2 == nil and var3 == nil or var2 and var3 and var2.id == var3.id

	return var4 and var5
end

function var0.isSameId(arg0, arg1)
	local var0 = arg0.commanders[1]
	local var1 = arg1[1]
	local var2 = arg0.commanders[2]
	local var3 = arg1[2]
	local var4 = var0 == nil and var1 == nil or var0 and var1 and var0.id == var1
	local var5 = var2 == nil and var3 == nil or var2 and var3 and var2.id == var3

	return var4 and var5
end

return var0
