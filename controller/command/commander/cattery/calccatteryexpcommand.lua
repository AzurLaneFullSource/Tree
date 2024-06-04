local var0 = class("CalcCatteryExpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(CommanderProxy):GetCommanderHome()
	local var2 = var0.isPeriod

	if not var1 then
		return
	end

	arg0.commanderExps = {}

	local var3 = var1:GetCatteries()
	local var4 = var1:getConfig("exp_number")

	for iter0, iter1 in pairs(var3) do
		if iter1:ExistCommander() then
			arg0:CalcExp(iter1, var4, var2)
		end
	end

	arg0:sendNotification(GAME.CALC_CATTERY_EXP_DONE, {
		commanderExps = arg0.commanderExps
	})
end

function var0.CalcExp(arg0, arg1, arg2, arg3)
	local var0 = arg2 / 3600
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2

	if not arg3 then
		var2 = var1 - arg1:GetCalcExpTime()
	else
		var2 = 3600
	end

	if var2 > 0 then
		local var3 = math.floor(var0 * var2)
		local var4 = arg0:AddCommanderExp(arg1:GetCommanderId(), var3)

		table.insert(arg0.commanderExps, {
			id = arg1.id,
			value = var4
		})
		arg1:UpdateCalcExpTime(var1)

		if not getProxy(CommanderProxy):InCommanderScene() then
			arg1:UpdateCacheExp(var4)
		end
	end
end

function var0.AddCommanderExp(arg0, arg1, arg2)
	local var0 = arg2
	local var1 = getProxy(CommanderProxy)
	local var2 = var1:getCommanderById(arg1)
	local var3 = var2:isMaxLevel()

	if var3 then
		var0 = 0
	end

	var2:addExp(arg2)
	var1:updateCommander(var2)

	if not var3 and var2:isMaxLevel() then
		var0 = math.max(arg2 - var2.exp, 0)
	end

	return var0
end

return var0
