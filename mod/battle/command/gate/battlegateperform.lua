local var0_0 = class("BattleGatePerform")

ys.Battle.BattleGatePerform = var0_0
var0_0.__name = "BattleGatePerform"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.stageId

	print(var0_1)

	local var1_1 = pg.expedition_data_template[var0_1].dungeon_id
	local var2_1 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1_1).fleet_prefab or {}
	local var3_1 = {}

	if arg0_1.mainFleetId then
		local var4_1 = getProxy(BayProxy)
		local var5_1 = getProxy(FleetProxy)

		if not arg1_1.LegalFleet(arg0_1.mainFleetId) then
			return
		end

		local var6_1 = var5_1:getFleetById(arg0_1.mainFleetId)
		local var7_1 = var4_1:getSortShipsByFleet(var6_1)

		for iter0_1, iter1_1 in ipairs(var7_1) do
			var3_1[#var3_1 + 1] = iter1_1.id
		end
	end

	local var8_1 = {
		stageId = var0_1,
		system = SYSTEM_PERFORM,
		memory = arg0_1.memory,
		exitCallback = arg0_1.exitCallback,
		prefabFleet = var2_1,
		mainFleetId = arg0_1.mainFleetId
	}

	if arg0_1.memory then
		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var8_1)
	else
		local function var9_1(arg0_2)
			arg1_1:sendNotification(GAME.STORY_UPDATE, {
				storyId = tostring(var0_1)
			})

			var8_1.token = arg0_2.key

			arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var8_1)
		end

		local function var10_1(arg0_3)
			arg1_1:RequestFailStandardProcess(arg0_3)
		end

		BeginStageCommand.SendRequest(SYSTEM_PERFORM, var3_1, {
			var0_1
		}, var9_1, var10_1)
	end
end

function var0_0.Exit(arg0_4, arg1_4)
	if arg0_4.memory then
		arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, {
			system = SYSTEM_PERFORM
		})
	else
		local var0_4 = arg1_4.GeneralPackage(arg0_4, {})

		local function var1_4(arg0_5)
			arg1_4:sendNotification(GAME.FINISH_STAGE_DONE, {
				system = SYSTEM_PERFORM,
				exitCallback = arg0_4.exitCallback
			})
		end

		local function var2_4(arg0_6)
			arg1_4:RequestFailStandardProcess(arg0_6)
		end

		arg1_4:SendRequest(var0_4, var1_4, var2_4)
	end
end

return var0_0
