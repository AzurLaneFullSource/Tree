local var0 = class("DecodeMiniGameView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "DecodeGameUI"
end

function var0.didEnter(arg0)
	arg0.controller = DecodeGameController.New()

	arg0.controller.view:SetUI(arg0._tf)

	local var0 = function()
		arg0:emit(var0.ON_BACK)
	end

	local function var1(arg0)
		if arg0:GetMGHubData().count > 0 then
			local var0 = arg0.controller:GetSaveData()

			arg0:StoreDataToServer(var0)

			arg0.onGetAward = arg0

			arg0:SendSuccess(0)
		end
	end

	local function var2()
		local var0 = arg0:GetMGHubData()

		if var0.ultimate == 0 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	end

	arg0.controller:SetCallback(var0, var1, var2)

	local var3 = arg0:PackData()

	arg0.controller:SetUp(var3)
end

function var0.GetData(arg0, arg1)
	local var0 = PlayerPrefs.GetInt("DecodeGameMapId", 1)
	local var1 = arg1:GetRuntimeData("elements")

	local function var2()
		for iter0 = 1, 60 do
			if not table.contains(var1, iter0) then
				table.insert(var1, iter0)

				break
			end
		end
	end

	local function var3()
		table.remove(var1, 1)
	end

	if #var1 ~= arg0.usedtime then
		local var4 = arg0.usedtime - #var1

		for iter0 = 1, var4 do
			var2()
		end

		local var5 = #var1 - arg0.usedtime

		for iter1 = 1, var5 do
			var3()
		end
	end

	return {
		mapId = var0,
		unlocks = var1,
		canUseCnt = arg0.count,
		passwords = DecodeGameConst.MAPS_PASSWORD,
		isFinished = arg0.ultimate > 0
	}
end

function var0.PackData(arg0)
	local var0 = arg0:GetMGHubData()
	local var1 = arg0:GetMGData()

	return var0.GetData(var0, var1)
end

function var0.OnGetAwardDone(arg0, arg1)
	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE and arg0.onGetAward then
		arg0.onGetAward()

		arg0.onGetAward = nil
	end
end

function var0.willExit(arg0)
	local var0 = arg0.controller.mapId or 1

	PlayerPrefs.SetInt("DecodeGameMapId", var0)
	PlayerPrefs.Save()
	arg0.controller:Dispose()
end

return var0
