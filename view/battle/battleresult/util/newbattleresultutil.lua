local var0 = class("NewBattleResultUtil")

function var0.Score2Grade(arg0, arg1)
	local var0 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1
	local var2
	local var3

	if arg0 > 0 then
		var3 = var0[arg0 + 1]
		var1 = "battlescore/battle_score_" .. var3 .. "/letter_" .. var3
		var2 = "battlescore/battle_score_" .. var3 .. "/label_" .. var3
	else
		local var4

		if arg1 == ys.Battle.BattleConst.DEAD_FLAG then
			var3 = var0[2]
			var4 = "flag_destroy"
		else
			var3 = var0[1]
		end

		var1 = "battlescore/battle_score_" .. var3 .. "/letter_" .. var3
		var2 = "battlescore/battle_score_" .. var3 .. "/label_" .. (var4 or var3)
	end

	return var1, var2
end

function var0.Score2Bg(arg0)
	return arg0 > 1 and "Victory" or "Failed"
end

function var0.GetChapterName(arg0)
	local var0 = pg.expedition_data_template[arg0.stageId]

	return var0 and var0.name or ""
end

local function var1(arg0, arg1)
	if arg0 == 1 or arg0 == 4 or arg0 == 8 then
		return arg1.score > 1
	elseif arg0 == 2 or arg0 == 3 then
		return not arg1.statistics._deadUnit
	elseif arg0 == 6 then
		return arg1.statistics._boss_destruct < 1
	elseif arg0 == 5 then
		return not arg1.statistics._badTime
	elseif arg0 == 7 then
		return true
	end

	return nil
end

local function var2(arg0)
	return ({
		"battle_result_victory",
		"battle_result_undefeated",
		"battle_result_sink_limit",
		"battle_preCombatLayer_time_hold",
		"battle_result_time_limit",
		"battle_result_boss_destruct",
		"battle_preCombatLayer_damage_before_end",
		"battle_result_defeat_all_enemys"
	})[arg0]
end

function var0.ColorObjective(arg0)
	local var0
	local var1
	local var2

	if arg0 == nil then
		var0 = "check_mark"
		var2 = "#FFFFFFFF"
	elseif arg0 == true then
		var0 = "jiesuan_bg22"
		var2 = "#FFFFFFFF"
	else
		var0 = "jiesuan_bg23"
		var2 = "#FFFFFF80"
	end

	return var0, var2
end

function var0.GetObjectives(arg0)
	local var0 = {}
	local var1 = pg.expedition_data_template[arg0.stageId]
	local var2 = function(arg0)
		if not arg0 or type(arg0) ~= "table" then
			return
		end

		local var0 = i18n(var2(arg0[1]), arg0[2])
		local var1 = var1(arg0[1], arg0)
		local var2, var3 = var0.ColorObjective(var1)

		table.insert(var0, {
			text = setColorStr(var0, var3),
			icon = var2
		})
	end

	for iter0 = 1, 3 do
		var2(var1["objective_" .. iter0])
	end

	return var0
end

function var0.IsOpBonus(arg0)
	for iter0, iter1 in ipairs(arg0) do
		if pg.benefit_buff_template[iter1].benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			return true
		end
	end

	return false
end

function var0.GetPlayerExpOffset(arg0, arg1)
	local var0 = arg0
	local var1 = var0.level
	local var2 = arg1.level
	local var3 = arg1.exp - var0.exp

	while var1 < var2 do
		var3 = var3 + pg.user_level[var1].exp
		var1 = var1 + 1
	end

	if var1 == pg.user_level[#pg.user_level].level then
		var3 = 0
	end

	return var3
end

function var0.HasSubShip(arg0)
	for iter0, iter1 in ipairs(arg0) do
		local var0 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1.configId).type

		if table.contains(TeamType.SubShipType, var0) then
			return true
		end
	end

	return false
end

function var0.HasSurfaceShip(arg0)
	for iter0, iter1 in ipairs(arg0) do
		local var0 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1.configId).type

		if not table.contains(TeamType.SubShipType, var0) then
			return true
		end
	end

	return false
end

function var0.SeparateSurfaceAndSubShips(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var2 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1.configId).type

		if table.contains(TeamType.SubShipType, var2) then
			table.insert(var1, iter1)
		else
			table.insert(var0, iter1)
		end
	end

	return var0, var1
end

function var0.SeparateMvpShip(arg0, arg1, arg2)
	if not arg1 or arg1 == 0 then
		arg1 = arg2
	end

	local var0
	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(arg0) do
		if iter1.id ~= arg1 then
			local var4 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter1.configId).type
			local var5 = TeamType.GetTeamFromShipType(var4)

			if var5 == TeamType.Vanguard then
				table.insert(var1, iter1)
			elseif var5 == TeamType.Main then
				table.insert(var2, iter1)
			elseif var5 == TeamType.Submarine then
				table.insert(var3, iter1)
			end
		else
			var0 = iter1
		end
	end

	return var1, var2, var3, var0
end

function var0.SpecialInsertItem(arg0, arg1, arg2, arg3, arg4)
	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0, iter1)
	end

	for iter2, iter3 in ipairs(arg2) do
		table.insert(arg0, iter3)
	end

	for iter4, iter5 in ipairs(arg3) do
		table.insert(arg0, iter5)
	end

	table.insert(arg0, #arg0, arg4)
end

function var0.GetShipExpOffset(arg0, arg1)
	assert(arg1, arg0:getConfig("name"))

	if arg0.level < arg1.level then
		local var0 = arg0:getConfig("rarity")
		local var1 = 0

		for iter0 = arg0.level, arg1.level - 1 do
			var1 = var1 + getExpByRarityFromLv1(var0, iter0)
		end

		return var1 + arg1:getExp() - arg0:getExp()
	else
		return math.ceil(arg1:getExp() - arg0:getExp())
	end
end

function var0.GetSeasonScoreOffset(arg0, arg1)
	return arg1.score - arg0.score
end

function var0.GetMaxOutput(arg0, arg1)
	local var0 = 0

	if arg1.mvpShipID == -1 then
		for iter0, iter1 in ipairs(arg0) do
			local var1 = arg1[iter1.id] or {}

			var0 = math.max(var1.output or 0, var0)
		end
	elseif arg1.mvpShipID and arg1.mvpShipID ~= 0 then
		var0 = (arg1[arg1.mvpShipID] or {}).output or 0
	end

	return var0
end

function var0.RemoveNonStatisticShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		if arg1[iter1.id] then
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
