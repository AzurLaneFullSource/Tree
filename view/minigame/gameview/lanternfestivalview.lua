local var0 = class("LanternFestivalView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "LanternFestivalUI"
end

function var0.didEnter(arg0)
	arg0.controller = LanternRiddlesController.New()

	arg0.controller.view:SetUI(arg0._tf)

	local var0 = function()
		arg0:emit(var0.ON_BACK)
	end

	local function var1()
		arg0:emit(var0.ON_HOME)
	end

	local function var2()
		if arg0:GetMGHubData().count > 0 then
			arg0:SendSuccess(0)
		end
	end

	local function var3()
		local var0 = arg0.controller:GetSaveData()

		arg0:StoreDataToServer(var0)
	end

	arg0.controller:SetCallBack(var0, var1, var2, var3)

	local var4 = arg0:PackData()

	arg0.controller:SetUp(var4)
end

function var0.PackData(arg0)
	local var0 = 15
	local var1 = arg0:GetMGHubData()
	local var2 = arg0:GetMGData():GetRuntimeData("elements")
	local var3
	local var4

	if var2 and #var2 > 0 then
		var3 = _.slice(var2, 1, var0)
		var4 = _.slice(var2, var0 + 1, var1.usedtime)
	else
		var3 = {}

		for iter0 = 1, var0 do
			table.insert(var3, 0)
		end

		var4 = {}
	end

	return {
		finishCount = var1.usedtime,
		unlockCount = var1.count,
		nextTimes = var3,
		finishList = var4
	}
end

function var0.OnGetAwardDone(arg0, arg1)
	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0 = arg0:GetMGHubData()
		local var1 = var0.ultimate
		local var2 = var0.usedtime
		local var3 = var0:getConfig("reward_need")

		if var1 == 0 and var3 <= var2 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	end
end

function var0.willExit(arg0)
	arg0.controller:Dispose()
end

return var0
