local var0_0 = class("GuildBossMission", import("...BaseVO"))

var0_0.MAIN_FLEET_ID = 1
var0_0.SUB_FLEET_ID = 11

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.position = arg1_1
	arg0_1.dailyCount = arg2_1 or 0
	arg0_1.fleets = {
		[var0_0.MAIN_FLEET_ID] = GuildBossMissionFleet.New({
			fleet_id = var0_0.MAIN_FLEET_ID
		}),
		[var0_0.SUB_FLEET_ID] = GuildBossMissionFleet.New({
			fleet_id = var0_0.SUB_FLEET_ID
		})
	}

	for iter0_1, iter1_1 in ipairs(arg3_1) do
		local var0_1 = arg0_1.fleets[iter1_1.fleet_id]

		if var0_1 then
			var0_1:Flush(iter1_1)
		end
	end

	arg0_1.active = false
	arg0_1.rankUpdateTime = 0
end

function var0_0.Flush(arg0_2, arg1_2)
	arg0_2.id = arg1_2.boss_id
	arg0_2.configId = arg0_2.id
	arg0_2.damage = arg1_2.damage or 0
	arg0_2.totalHp = arg1_2.hp or 1
	arg0_2.active = true
end

function var0_0.GetPosition(arg0_3)
	return arg0_3.position
end

function var0_0.bindConfigTable(arg0_4)
	return pg.guild_boss_event
end

function var0_0.GetIcon(arg0_5)
	return arg0_5:getConfig("pic") or arg0_5.configId
end

function var0_0.GetFleetByIndex(arg0_6, arg1_6)
	return arg0_6.fleets[arg1_6]
end

function var0_0.GetMainFleet(arg0_7)
	return arg0_7.fleets[var0_0.MAIN_FLEET_ID]
end

function var0_0.GetSubFleet(arg0_8)
	return arg0_8.fleets[var0_0.SUB_FLEET_ID]
end

function var0_0.UpdateFleet(arg0_9, arg1_9)
	arg0_9.fleets[arg1_9.id] = arg1_9
end

function var0_0.GetFleets(arg0_10)
	return arg0_10.fleets
end

function var0_0.GetAllShipIds(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.fleets) do
		local var1_11 = iter1_11:GetShips()

		for iter2_11, iter3_11 in ipairs(var1_11) do
			local var2_11 = GuildAssaultFleet.GetRealId(iter3_11.ship.id)

			table.insert(var0_11, var2_11)
		end
	end

	return var0_11
end

function var0_0.GetMyShipIds(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.fleets) do
		local var1_12 = iter1_12:GetMyShipIds()

		for iter2_12, iter3_12 in ipairs(var1_12) do
			table.insert(var0_12, iter3_12)
		end
	end

	return var0_12
end

function var0_0.GetShipsSplitByUserID(arg0_13)
	local var0_13 = {}
	local var1_13 = getProxy(PlayerProxy):getRawData().id

	for iter0_13, iter1_13 in pairs(arg0_13.fleets) do
		local var2_13 = iter1_13:GetShips()

		for iter2_13, iter3_13 in ipairs(var2_13) do
			local var3_13 = iter3_13.member.id

			if var3_13 ~= var1_13 then
				local var4_13 = GuildAssaultFleet.GetRealId(iter3_13.ship.id)

				table.insert(var0_13, {
					shipID = var4_13,
					userID = var3_13
				})
			end
		end
	end

	return var0_13
end

function var0_0.GetTotalHp(arg0_14)
	return arg0_14.totalHp
end

function var0_0.GetHp(arg0_15)
	return arg0_15:GetTotalHp() - arg0_15.damage
end

function var0_0.IsDeath(arg0_16)
	return arg0_16.damage >= arg0_16:GetTotalHp()
end

function var0_0.GetStageID(arg0_17)
	return arg0_17:getConfig("expedition_id")[1]
end

function var0_0.IsMain(arg0_18)
	return true
end

function var0_0.IsFinish(arg0_19)
	return false
end

function var0_0.GetName(arg0_20)
	return arg0_20:getConfig("name")
end

function var0_0.GetSubType(arg0_21)
	return 1
end

function var0_0.IsActive(arg0_22)
	return arg0_22.active
end

function var0_0.IsBoss(arg0_23)
	return true
end

function var0_0.GetTag(arg0_24)
	return 3
end

function var0_0.GetCanUsageCnt(arg0_25)
	return GuildConst.MISSION_BOSS_MAX_CNT() - arg0_25.dailyCount
end

function var0_0.ReduceDailyCnt(arg0_26)
	arg0_26.dailyCount = arg0_26.dailyCount + 1
end

function var0_0.ResetDailyCnt(arg0_27)
	arg0_27.dailyCount = 0
end

function var0_0.GetAwards(arg0_28)
	return arg0_28:getConfig("award")
end

function var0_0.CanEnterBattle(arg0_29)
	local var0_29 = not arg0_29:IsReachDailyCnt()
	local var1_29 = not arg0_29:IsDeath()

	return var0_29 and var1_29
end

function var0_0.IsReachDailyCnt(arg0_30)
	return arg0_30.dailyCount >= GuildConst.MISSION_BOSS_MAX_CNT()
end

function var0_0.GetPainting(arg0_31)
	return arg0_31:getConfig("painting")
end

function var0_0.GetPrefab(arg0_32)
	local var0_32 = arg0_32:getConfig("expedition_id")[2][1]
	local var1_32 = pg.enemy_data_statistics[var0_32]

	assert(var1_32)

	return var1_32.prefab
end

function var0_0.GetEmenyId(arg0_33)
	return arg0_33:getConfig("expedition_id")[2][1]
end

function var0_0.CanFormation(arg0_34)
	return false
end

function var0_0.ExistCommander(arg0_35, arg1_35)
	for iter0_35, iter1_35 in pairs(arg0_35.fleets) do
		if iter1_35:ExistCommander(arg1_35) then
			return true
		end
	end

	return false
end

function var0_0.GetFleetUserId(arg0_36, arg1_36, arg2_36)
	for iter0_36, iter1_36 in pairs(arg0_36.fleets) do
		if iter1_36:ContainShip(arg1_36, arg2_36) then
			return iter1_36
		end
	end

	return false
end

function var0_0.GetFleetCommanderId(arg0_37, arg1_37)
	for iter0_37, iter1_37 in pairs(arg0_37.fleets) do
		if iter1_37:ExistCommander(arg1_37) then
			return iter1_37
		end
	end

	return false
end

return var0_0
