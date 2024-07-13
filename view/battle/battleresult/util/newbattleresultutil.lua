local var0_0 = class("NewBattleResultUtil")

function var0_0.Score2Grade(arg0_1, arg1_1)
	local var0_1 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_1
	local var2_1
	local var3_1

	if arg0_1 > 0 then
		var3_1 = var0_1[arg0_1 + 1]
		var1_1 = "battlescore/battle_score_" .. var3_1 .. "/letter_" .. var3_1
		var2_1 = "battlescore/battle_score_" .. var3_1 .. "/label_" .. var3_1
	else
		local var4_1

		if arg1_1 == ys.Battle.BattleConst.DEAD_FLAG then
			var3_1 = var0_1[2]
			var4_1 = "flag_destroy"
		else
			var3_1 = var0_1[1]
		end

		var1_1 = "battlescore/battle_score_" .. var3_1 .. "/letter_" .. var3_1
		var2_1 = "battlescore/battle_score_" .. var3_1 .. "/label_" .. (var4_1 or var3_1)
	end

	return var1_1, var2_1
end

function var0_0.Score2Bg(arg0_2)
	return arg0_2 > 1 and "Victory" or "Failed"
end

function var0_0.GetChapterName(arg0_3)
	local var0_3 = pg.expedition_data_template[arg0_3.stageId]

	return var0_3 and var0_3.name or ""
end

local function var1_0(arg0_4, arg1_4)
	if arg0_4 == 1 or arg0_4 == 4 or arg0_4 == 8 then
		return arg1_4.score > 1
	elseif arg0_4 == 2 or arg0_4 == 3 then
		return not arg1_4.statistics._deadUnit
	elseif arg0_4 == 6 then
		return arg1_4.statistics._boss_destruct < 1
	elseif arg0_4 == 5 then
		return not arg1_4.statistics._badTime
	elseif arg0_4 == 7 then
		return true
	end

	return nil
end

local function var2_0(arg0_5)
	return ({
		"battle_result_victory",
		"battle_result_undefeated",
		"battle_result_sink_limit",
		"battle_preCombatLayer_time_hold",
		"battle_result_time_limit",
		"battle_result_boss_destruct",
		"battle_preCombatLayer_damage_before_end",
		"battle_result_defeat_all_enemys"
	})[arg0_5]
end

function var0_0.ColorObjective(arg0_6)
	local var0_6
	local var1_6
	local var2_6

	if arg0_6 == nil then
		var0_6 = "check_mark"
		var2_6 = "#FFFFFFFF"
	elseif arg0_6 == true then
		var0_6 = "jiesuan_bg22"
		var2_6 = "#FFFFFFFF"
	else
		var0_6 = "jiesuan_bg23"
		var2_6 = "#FFFFFF80"
	end

	return var0_6, var2_6
end

function var0_0.GetObjectives(arg0_7)
	local var0_7 = {}
	local var1_7 = pg.expedition_data_template[arg0_7.stageId]

	local function var2_7(arg0_8)
		if not arg0_8 or type(arg0_8) ~= "table" then
			return
		end

		local var0_8 = i18n(var2_0(arg0_8[1]), arg0_8[2])
		local var1_8 = var1_0(arg0_8[1], arg0_7)
		local var2_8, var3_8 = var0_0.ColorObjective(var1_8)

		table.insert(var0_7, {
			text = setColorStr(var0_8, var3_8),
			icon = var2_8
		})
	end

	for iter0_7 = 1, 3 do
		var2_7(var1_7["objective_" .. iter0_7])
	end

	return var0_7
end

function var0_0.IsOpBonus(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9) do
		if pg.benefit_buff_template[iter1_9].benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			return true
		end
	end

	return false
end

function var0_0.GetPlayerExpOffset(arg0_10, arg1_10)
	local var0_10 = arg0_10
	local var1_10 = var0_10.level
	local var2_10 = arg1_10.level
	local var3_10 = arg1_10.exp - var0_10.exp

	while var1_10 < var2_10 do
		var3_10 = var3_10 + pg.user_level[var1_10].exp
		var1_10 = var1_10 + 1
	end

	if var1_10 == pg.user_level[#pg.user_level].level then
		var3_10 = 0
	end

	return var3_10
end

function var0_0.HasSubShip(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11) do
		local var0_11 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1_11.configId).type

		if table.contains(TeamType.SubShipType, var0_11) then
			return true
		end
	end

	return false
end

function var0_0.HasSurfaceShip(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12) do
		local var0_12 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1_12.configId).type

		if not table.contains(TeamType.SubShipType, var0_12) then
			return true
		end
	end

	return false
end

function var0_0.SeparateSurfaceAndSubShips(arg0_13)
	local var0_13 = {}
	local var1_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13) do
		local var2_13 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1_13.configId).type

		if table.contains(TeamType.SubShipType, var2_13) then
			table.insert(var1_13, iter1_13)
		else
			table.insert(var0_13, iter1_13)
		end
	end

	return var0_13, var1_13
end

function var0_0.SeparateMvpShip(arg0_14, arg1_14, arg2_14)
	if not arg1_14 or arg1_14 == 0 then
		arg1_14 = arg2_14
	end

	local var0_14
	local var1_14 = {}
	local var2_14 = {}
	local var3_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14) do
		if iter1_14.id ~= arg1_14 then
			local var4_14 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1_14.configId).type
			local var5_14 = TeamType.GetTeamFromShipType(var4_14)

			if var5_14 == TeamType.Vanguard then
				table.insert(var1_14, iter1_14)
			elseif var5_14 == TeamType.Main then
				table.insert(var2_14, iter1_14)
			elseif var5_14 == TeamType.Submarine then
				table.insert(var3_14, iter1_14)
			end
		else
			var0_14 = iter1_14
		end
	end

	return var1_14, var2_14, var3_14, var0_14
end

function var0_0.SpecialInsertItem(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	for iter0_15, iter1_15 in ipairs(arg1_15) do
		table.insert(arg0_15, iter1_15)
	end

	for iter2_15, iter3_15 in ipairs(arg2_15) do
		table.insert(arg0_15, iter3_15)
	end

	for iter4_15, iter5_15 in ipairs(arg3_15) do
		table.insert(arg0_15, iter5_15)
	end

	table.insert(arg0_15, #arg0_15, arg4_15)
end

function var0_0.GetShipExpOffset(arg0_16, arg1_16)
	assert(arg1_16, arg0_16:getConfig("name"))

	if arg0_16.level < arg1_16.level then
		local var0_16 = arg0_16:getConfig("rarity")
		local var1_16 = 0

		for iter0_16 = arg0_16.level, arg1_16.level - 1 do
			var1_16 = var1_16 + getExpByRarityFromLv1(var0_16, iter0_16)
		end

		return var1_16 + arg1_16:getExp() - arg0_16:getExp()
	else
		return math.ceil(arg1_16:getExp() - arg0_16:getExp())
	end
end

function var0_0.GetSeasonScoreOffset(arg0_17, arg1_17)
	return arg1_17.score - arg0_17.score
end

function var0_0.GetMaxOutput(arg0_18, arg1_18)
	local var0_18 = 0

	if arg1_18.mvpShipID == -1 then
		for iter0_18, iter1_18 in ipairs(arg0_18) do
			local var1_18 = arg1_18[iter1_18.id] or {}

			var0_18 = math.max(var1_18.output or 0, var0_18)
		end
	elseif arg1_18.mvpShipID and arg1_18.mvpShipID ~= 0 then
		var0_18 = (arg1_18[arg1_18.mvpShipID] or {}).output or 0
	end

	return var0_18
end

function var0_0.RemoveNonStatisticShips(arg0_19, arg1_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in ipairs(arg0_19) do
		if arg1_19[iter1_19.id] then
			table.insert(var0_19, iter1_19)
		end
	end

	return var0_19
end

return var0_0
