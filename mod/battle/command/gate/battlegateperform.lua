local var0 = class("BattleGatePerform")

ys.Battle.BattleGatePerform = var0
var0.__name = "BattleGatePerform"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.stageId

	print(var0)

	local var1 = pg.expedition_data_template[var0].dungeon_id
	local var2 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(var1).fleet_prefab or {}
	local var3 = {}

	if arg0.mainFleetId then
		local var4 = getProxy(BayProxy)
		local var5 = getProxy(FleetProxy)

		if not arg1.LegalFleet(arg0.mainFleetId) then
			return
		end

		local var6 = var5:getFleetById(arg0.mainFleetId)
		local var7 = var4:getSortShipsByFleet(var6)

		for iter0, iter1 in ipairs(var7) do
			var3[#var3 + 1] = iter1.id
		end
	end

	local var8 = {
		stageId = var0,
		system = SYSTEM_PERFORM,
		memory = arg0.memory,
		exitCallback = arg0.exitCallback,
		prefabFleet = var2,
		mainFleetId = arg0.mainFleetId
	}

	if arg0.memory then
		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var8)
	else
		local function var9(arg0)
			arg1:sendNotification(GAME.STORY_UPDATE, {
				storyId = tostring(var0)
			})

			var8.token = arg0.key

			arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var8)
		end

		local function var10(arg0)
			arg1:RequestFailStandardProcess(arg0)
		end

		BeginStageCommand.SendRequest(SYSTEM_PERFORM, var3, {
			var0
		}, var9, var10)
	end
end

function var0.Exit(arg0, arg1)
	if arg0.memory then
		arg1:sendNotification(GAME.FINISH_STAGE_DONE, {
			system = SYSTEM_PERFORM
		})
	else
		local var0 = arg1.GeneralPackage(arg0, {})

		local function var1(arg0)
			arg1:sendNotification(GAME.FINISH_STAGE_DONE, {
				system = SYSTEM_PERFORM,
				exitCallback = arg0.exitCallback
			})
		end

		local function var2(arg0)
			arg1:RequestFailStandardProcess(arg0)
		end

		arg1:SendRequest(var0, var1, var2)
	end
end

return var0
