local var0_0 = class("LanternFestivalView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "LanternFestivalUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2.controller = LanternRiddlesController.New()

	arg0_2.controller.view:SetUI(arg0_2._tf)

	local function var0_2()
		arg0_2:emit(var0_0.ON_BACK)
	end

	local function var1_2()
		arg0_2:emit(var0_0.ON_HOME)
	end

	local function var2_2()
		if arg0_2:GetMGHubData().count > 0 then
			arg0_2:SendSuccess(0)
		end
	end

	local function var3_2()
		local var0_6 = arg0_2.controller:GetSaveData()

		arg0_2:StoreDataToServer(var0_6)
	end

	arg0_2.controller:SetCallBack(var0_2, var1_2, var2_2, var3_2)

	local var4_2 = arg0_2:PackData()

	arg0_2.controller:SetUp(var4_2)
end

function var0_0.PackData(arg0_7)
	local var0_7 = 15
	local var1_7 = arg0_7:GetMGHubData()
	local var2_7 = arg0_7:GetMGData():GetRuntimeData("elements")
	local var3_7
	local var4_7

	if var2_7 and #var2_7 > 0 then
		var3_7 = _.slice(var2_7, 1, var0_7)
		var4_7 = _.slice(var2_7, var0_7 + 1, var1_7.usedtime)
	else
		var3_7 = {}

		for iter0_7 = 1, var0_7 do
			table.insert(var3_7, 0)
		end

		var4_7 = {}
	end

	return {
		finishCount = var1_7.usedtime,
		unlockCount = var1_7.count,
		nextTimes = var3_7,
		finishList = var4_7
	}
end

function var0_0.OnGetAwardDone(arg0_8, arg1_8)
	if arg1_8.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_8 = arg0_8:GetMGHubData()
		local var1_8 = var0_8.ultimate
		local var2_8 = var0_8.usedtime
		local var3_8 = var0_8:getConfig("reward_need")

		if var1_8 == 0 and var3_8 <= var2_8 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_8.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	end
end

function var0_0.willExit(arg0_9)
	arg0_9.controller:Dispose()
end

return var0_0
