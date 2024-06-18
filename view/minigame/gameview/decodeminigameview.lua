local var0_0 = class("DecodeMiniGameView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "DecodeGameUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2.controller = DecodeGameController.New()

	arg0_2.controller.view:SetUI(arg0_2._tf)

	local function var0_2()
		arg0_2:emit(var0_0.ON_BACK)
	end

	local function var1_2(arg0_4)
		if arg0_2:GetMGHubData().count > 0 then
			local var0_4 = arg0_2.controller:GetSaveData()

			arg0_2:StoreDataToServer(var0_4)

			arg0_2.onGetAward = arg0_4

			arg0_2:SendSuccess(0)
		end
	end

	local function var2_2()
		local var0_5 = arg0_2:GetMGHubData()

		if var0_5.ultimate == 0 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_5.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	end

	arg0_2.controller:SetCallback(var0_2, var1_2, var2_2)

	local var3_2 = arg0_2:PackData()

	arg0_2.controller:SetUp(var3_2)
end

function var0_0.GetData(arg0_6, arg1_6)
	local var0_6 = PlayerPrefs.GetInt("DecodeGameMapId", 1)
	local var1_6 = arg1_6:GetRuntimeData("elements")

	local function var2_6()
		for iter0_7 = 1, 60 do
			if not table.contains(var1_6, iter0_7) then
				table.insert(var1_6, iter0_7)

				break
			end
		end
	end

	local function var3_6()
		table.remove(var1_6, 1)
	end

	if #var1_6 ~= arg0_6.usedtime then
		local var4_6 = arg0_6.usedtime - #var1_6

		for iter0_6 = 1, var4_6 do
			var2_6()
		end

		local var5_6 = #var1_6 - arg0_6.usedtime

		for iter1_6 = 1, var5_6 do
			var3_6()
		end
	end

	return {
		mapId = var0_6,
		unlocks = var1_6,
		canUseCnt = arg0_6.count,
		passwords = DecodeGameConst.MAPS_PASSWORD,
		isFinished = arg0_6.ultimate > 0
	}
end

function var0_0.PackData(arg0_9)
	local var0_9 = arg0_9:GetMGHubData()
	local var1_9 = arg0_9:GetMGData()

	return var0_0.GetData(var0_9, var1_9)
end

function var0_0.OnGetAwardDone(arg0_10, arg1_10)
	if arg1_10.cmd == MiniGameOPCommand.CMD_COMPLETE and arg0_10.onGetAward then
		arg0_10.onGetAward()

		arg0_10.onGetAward = nil
	end
end

function var0_0.willExit(arg0_11)
	local var0_11 = arg0_11.controller.mapId or 1

	PlayerPrefs.SetInt("DecodeGameMapId", var0_11)
	PlayerPrefs.Save()
	arg0_11.controller:Dispose()
end

return var0_0
