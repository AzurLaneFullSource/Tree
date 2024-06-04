local var0 = class("GuildBossMission", import("...BaseVO"))

var0.MAIN_FLEET_ID = 1
var0.SUB_FLEET_ID = 11

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.position = arg1
	arg0.dailyCount = arg2 or 0
	arg0.fleets = {
		[var0.MAIN_FLEET_ID] = GuildBossMissionFleet.New({
			fleet_id = var0.MAIN_FLEET_ID
		}),
		[var0.SUB_FLEET_ID] = GuildBossMissionFleet.New({
			fleet_id = var0.SUB_FLEET_ID
		})
	}

	for iter0, iter1 in ipairs(arg3) do
		local var0 = arg0.fleets[iter1.fleet_id]

		if var0 then
			var0:Flush(iter1)
		end
	end

	arg0.active = false
	arg0.rankUpdateTime = 0
end

function var0.Flush(arg0, arg1)
	arg0.id = arg1.boss_id
	arg0.configId = arg0.id
	arg0.damage = arg1.damage or 0
	arg0.totalHp = arg1.hp or 1
	arg0.active = true
end

function var0.GetPosition(arg0)
	return arg0.position
end

function var0.bindConfigTable(arg0)
	return pg.guild_boss_event
end

function var0.GetIcon(arg0)
	return arg0:getConfig("pic") or arg0.configId
end

function var0.GetFleetByIndex(arg0, arg1)
	return arg0.fleets[arg1]
end

function var0.GetMainFleet(arg0)
	return arg0.fleets[var0.MAIN_FLEET_ID]
end

function var0.GetSubFleet(arg0)
	return arg0.fleets[var0.SUB_FLEET_ID]
end

function var0.UpdateFleet(arg0, arg1)
	arg0.fleets[arg1.id] = arg1
end

function var0.GetFleets(arg0)
	return arg0.fleets
end

function var0.GetAllShipIds(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.fleets) do
		local var1 = iter1:GetShips()

		for iter2, iter3 in ipairs(var1) do
			local var2 = GuildAssaultFleet.GetRealId(iter3.ship.id)

			table.insert(var0, var2)
		end
	end

	return var0
end

function var0.GetMyShipIds(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.fleets) do
		local var1 = iter1:GetMyShipIds()

		for iter2, iter3 in ipairs(var1) do
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.GetShipsSplitByUserID(arg0)
	local var0 = {}
	local var1 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in pairs(arg0.fleets) do
		local var2 = iter1:GetShips()

		for iter2, iter3 in ipairs(var2) do
			local var3 = iter3.member.id

			if var3 ~= var1 then
				local var4 = GuildAssaultFleet.GetRealId(iter3.ship.id)

				table.insert(var0, {
					shipID = var4,
					userID = var3
				})
			end
		end
	end

	return var0
end

function var0.GetTotalHp(arg0)
	return arg0.totalHp
end

function var0.GetHp(arg0)
	return arg0:GetTotalHp() - arg0.damage
end

function var0.IsDeath(arg0)
	return arg0.damage >= arg0:GetTotalHp()
end

function var0.GetStageID(arg0)
	return arg0:getConfig("expedition_id")[1]
end

function var0.IsMain(arg0)
	return true
end

function var0.IsFinish(arg0)
	return false
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetSubType(arg0)
	return 1
end

function var0.IsActive(arg0)
	return arg0.active
end

function var0.IsBoss(arg0)
	return true
end

function var0.GetTag(arg0)
	return 3
end

function var0.GetCanUsageCnt(arg0)
	return GuildConst.MISSION_BOSS_MAX_CNT() - arg0.dailyCount
end

function var0.ReduceDailyCnt(arg0)
	arg0.dailyCount = arg0.dailyCount + 1
end

function var0.ResetDailyCnt(arg0)
	arg0.dailyCount = 0
end

function var0.GetAwards(arg0)
	return arg0:getConfig("award")
end

function var0.CanEnterBattle(arg0)
	local var0 = not arg0:IsReachDailyCnt()
	local var1 = not arg0:IsDeath()

	return var0 and var1
end

function var0.IsReachDailyCnt(arg0)
	return arg0.dailyCount >= GuildConst.MISSION_BOSS_MAX_CNT()
end

function var0.GetPainting(arg0)
	return arg0:getConfig("painting")
end

function var0.GetPrefab(arg0)
	local var0 = arg0:getConfig("expedition_id")[2][1]
	local var1 = pg.enemy_data_statistics[var0]

	assert(var1)

	return var1.prefab
end

function var0.GetEmenyId(arg0)
	return arg0:getConfig("expedition_id")[2][1]
end

function var0.CanFormation(arg0)
	return false
end

function var0.ExistCommander(arg0, arg1)
	for iter0, iter1 in pairs(arg0.fleets) do
		if iter1:ExistCommander(arg1) then
			return true
		end
	end

	return false
end

function var0.GetFleetUserId(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg0.fleets) do
		if iter1:ContainShip(arg1, arg2) then
			return iter1
		end
	end

	return false
end

function var0.GetFleetCommanderId(arg0, arg1)
	for iter0, iter1 in pairs(arg0.fleets) do
		if iter1:ExistCommander(arg1) then
			return iter1
		end
	end

	return false
end

return var0
