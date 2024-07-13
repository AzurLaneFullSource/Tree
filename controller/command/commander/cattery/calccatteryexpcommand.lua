local var0_0 = class("CalcCatteryExpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(CommanderProxy):GetCommanderHome()
	local var2_1 = var0_1.isPeriod

	if not var1_1 then
		return
	end

	arg0_1.commanderExps = {}

	local var3_1 = var1_1:GetCatteries()
	local var4_1 = var1_1:getConfig("exp_number")

	for iter0_1, iter1_1 in pairs(var3_1) do
		if iter1_1:ExistCommander() then
			arg0_1:CalcExp(iter1_1, var4_1, var2_1)
		end
	end

	arg0_1:sendNotification(GAME.CALC_CATTERY_EXP_DONE, {
		commanderExps = arg0_1.commanderExps
	})
end

function var0_0.CalcExp(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg2_2 / 3600
	local var1_2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_2

	if not arg3_2 then
		var2_2 = var1_2 - arg1_2:GetCalcExpTime()
	else
		var2_2 = 3600
	end

	if var2_2 > 0 then
		local var3_2 = math.floor(var0_2 * var2_2)
		local var4_2 = arg0_2:AddCommanderExp(arg1_2:GetCommanderId(), var3_2)

		table.insert(arg0_2.commanderExps, {
			id = arg1_2.id,
			value = var4_2
		})
		arg1_2:UpdateCalcExpTime(var1_2)

		if not getProxy(CommanderProxy):InCommanderScene() then
			arg1_2:UpdateCacheExp(var4_2)
		end
	end
end

function var0_0.AddCommanderExp(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg2_3
	local var1_3 = getProxy(CommanderProxy)
	local var2_3 = var1_3:getCommanderById(arg1_3)
	local var3_3 = var2_3:isMaxLevel()

	if var3_3 then
		var0_3 = 0
	end

	var2_3:addExp(arg2_3)
	var1_3:updateCommander(var2_3)

	if not var3_3 and var2_3:isMaxLevel() then
		var0_3 = math.max(arg2_3 - var2_3.exp, 0)
	end

	return var0_3
end

return var0_0
