ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleFormulas

var0.Battle.BattleDataFunction = var0.Battle.BattleDataFunction or {}

local var3 = var0.Battle.BattleDataFunction
local var4 = pg.puzzle_card_template
local var5 = pg.puzzle_ship_template
local var6 = pg.puzzle_combat_template
local var7 = pg.puzzle_card_affix

function var3.GetDungeonTmpDataByID(arg0)
	return require("GameCfg.dungeon." .. arg0)
end

function var3.ClearDungeonCfg(arg0)
	package.loaded["GameCfg.dungeon." .. arg0] = nil
end

function var3.GetSkillTemplate(arg0, arg1)
	arg1 = arg1 or 1

	local var0 = "skill_" .. arg0
	local var1 = pg.ConvertedSkill[var0]
	local var2 = var1[arg1] or var1[0]

	var2.name = getSkillName(arg0)

	return var2
end

function var3.ConvertSkillTemplate()
	pg.ConvertedSkill = {}

	setmetatable(pg.ConvertedSkill, {
		__index = function(arg0, arg1)
			local var0 = arg1
			local var1 = pg.skillCfg[arg1]

			if var1 then
				local var2 = {}
				local var3 = {}

				for iter0, iter1 in pairs(var1) do
					var3[iter0] = Clone(iter1)
				end

				var2[0] = var3

				for iter2, iter3 in ipairs(var1) do
					local var4 = Clone(var3)

					for iter4, iter5 in pairs(iter3) do
						var4[iter4] = iter5
					end

					var2[iter2] = var4
				end

				pg.ConvertedSkill[var0] = var2

				return var2
			end
		end
	})
end

function var3.GetBuffTemplate(arg0, arg1)
	arg1 = arg1 or 1

	local var0 = "buff_" .. arg0
	local var1 = pg.ConvertedBuff[var0]

	return var1[arg1] or var1[0]
end

function var3.ConvertBuffTemplate()
	pg.ConvertedBuff = {}

	setmetatable(pg.ConvertedBuff, {
		__index = function(arg0, arg1)
			local var0 = arg1
			local var1 = pg.buffCfg[arg1]

			if var1 then
				local var2 = {}
				local var3 = {}

				for iter0, iter1 in pairs(var1) do
					var3[iter0] = Clone(iter1)
				end

				var2[0] = var3

				for iter2, iter3 in ipairs(var1) do
					local var4 = Clone(var3)

					for iter4, iter5 in pairs(iter3) do
						var4[iter4] = iter5
					end

					var2[iter2] = var4
				end

				pg.ConvertedBuff[var0] = var2

				return var2
			end
		end
	})
end

function var3.GetBuffBulletRes(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}
	local var1 = {}

	arg1 = arg1 or {}

	local var2 = var3.GetPlayerShipModelFromID(arg0)
	local var3 = function(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0

			if arg1[iter1] then
				var0 = arg1[iter1].level
			else
				var0 = 1
			end

			iter1 = arg4 and arg4:RemapSkillId(iter1) or iter1

			local var1 = var3.SkillTranform(arg2, iter1)
			local var2 = var3.GetResFromBuff(var1, var0, var1, arg3)

			for iter2, iter3 in ipairs(var2) do
				var0[#var0 + 1] = iter3
			end
		end
	end

	var3(var2.buff_list)
	var3(var2.hide_buff_list)

	local var4 = var2.airassist_time

	for iter0, iter1 in ipairs(var4) do
		local var5 = var3.GetResFromSkill(iter1, 1, nil, arg3)

		for iter2, iter3 in ipairs(var5) do
			var0[#var0 + 1] = iter3
		end
	end

	local var6 = var3.GetShipTransformDataTemplate(arg0)

	if var6 and var6.skill_id ~= 0 and pg.transform_data_template[var6.skill_id].skill_id ~= 0 then
		local var7 = pg.transform_data_template[var6.skill_id].skill_id
		local var8

		if arg1[var7] then
			var8 = arg1[var7].level
		else
			var8 = 1
		end

		local var9 = var3.GetResFromBuff(var7, var8, var1, arg3)

		for iter4, iter5 in ipairs(var9) do
			var0[#var0 + 1] = iter5
		end
	end

	if var3.GetShipMetaFromDataTemplate(arg0) then
		var3(var2.buff_list_display)
	end

	return var0
end

function var3.getWeaponResource(arg0, arg1)
	local var0 = var0.Battle.BattleResourceManager.GetWeaponResource(arg0)

	for iter0, iter1 in ipairs(var0) do
		arg1[#arg1 + 1] = iter1
	end
end

function var3.GetResFromBuff(arg0, arg1, arg2, arg3)
	local var0 = {}
	local var1 = arg0 .. "_" .. arg1

	if arg2[var1] then
		return var0
	else
		arg2[var1] = true
	end

	local var2 = var3.GetBuffTemplate(arg0, arg1)

	if var2.init_effect and var2.init_effect ~= "" then
		local var3 = var2.init_effect

		if var2.skin_adapt then
			var3 = var3.SkinAdaptFXID(var3, arg3)
		end

		var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetFXPath(var3)
	end

	if var2.last_effect and var2.last_effect ~= "" then
		local var4 = type(var2.last_effect) == "table" and var2.last_effect or {
			var2.last_effect
		}

		for iter0, iter1 in ipairs(var4) do
			var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetFXPath(iter1)
		end
	end

	for iter2, iter3 in ipairs(var2.effect_list) do
		local var5 = iter3.arg_list.skill_id

		if var5 ~= nil then
			local var6 = var3.GetResFromSkill(var5, arg1, arg2, arg3)

			for iter4, iter5 in ipairs(var6) do
				var0[#var0 + 1] = iter5
			end
		end

		local var7 = iter3.arg_list.skill_id_list

		if var7 ~= nil then
			for iter6, iter7 in ipairs(var7) do
				local var8 = var3.GetResFromSkill(iter7, arg1, arg2, arg3)

				for iter8, iter9 in ipairs(var8) do
					var0[#var0 + 1] = iter9
				end
			end
		end

		local var9 = iter3.arg_list.damage_attr_list

		if var9 ~= nil then
			for iter10, iter11 in pairs(var9) do
				local var10 = var3.GetResFromSkill(iter11, arg1, arg2, arg3)

				for iter12, iter13 in ipairs(var10) do
					var0[#var0 + 1] = iter13
				end
			end
		end

		local var11 = iter3.arg_list.bullet_id

		if var11 then
			local var12 = var0.Battle.BattleResourceManager.GetBulletResource(var11)

			for iter14, iter15 in ipairs(var12) do
				var0[#var0 + 1] = iter15
			end
		end

		local var13 = iter3.arg_list.weapon_id

		if var13 then
			var3.getWeaponResource(var13, var0)
		end

		local var14 = iter3.arg_list.skin_id

		if var14 then
			local var15 = var0.Battle.BattleResourceManager.GetEquipSkinBulletRes(var14)

			for iter16, iter17 in ipairs(var15) do
				var0[#var0 + 1] = iter17
			end
		end

		local var16 = iter3.arg_list.ship_skin_id

		if var16 then
			local var17 = var3.GetPlayerShipSkinDataFromID(var16)

			var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetCharacterPath(var17.prefab)
		end

		local var18 = iter3.arg_list.buff_id

		if var18 then
			local var19 = var3.GetResFromBuff(var18, arg1, arg2, arg3)

			for iter18, iter19 in ipairs(var19) do
				if type(iter19) == "string" then
					var0[#var0 + 1] = iter19
				elseif type(iter19) == "table" then
					for iter20, iter21 in ipairs(iter19) do
						var0[#var0 + 1] = iter21
					end
				end
			end
		end

		local var20 = iter3.arg_list.buff_skin_id

		if var20 then
			local var21 = var3.GetResFromBuff(var20, arg1, arg2, arg3)

			for iter22, iter23 in ipairs(var21) do
				if type(iter23) == "string" then
					var0[#var0 + 1] = iter23
				elseif type(iter23) == "table" then
					for iter24, iter25 in ipairs(iter23) do
						var0[#var0 + 1] = iter25
					end
				end
			end
		end

		local var22 = iter3.arg_list.effect

		if var22 then
			var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetFXPath(var22)
		end
	end

	return var0
end

function var3.GetBuffListRes(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var2 = iter1.id
		local var3 = iter1.level

		for iter2, iter3 in ipairs(var3.GetResFromBuff(var2, var3, var1, arg2)) do
			var0[#var0 + 1] = iter3
		end
	end

	return var0
end

function var3.GetResFromSkill(arg0, arg1, arg2, arg3)
	arg1 = arg1 or 1

	local var0 = {}
	local var1 = var3.GetSkillTemplate(arg0, arg1)

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.type == var0.Battle.BattleSkillGridmanFloat.__name then
				table.insert(var0, "UI/combatgridmanskillfloat")
			end

			if iter1.type == var0.Battle.BattleSkillFusion.__name then
				local var0 = iter1.arg_list
				local var1 = var0.Battle.BattleResourceManager.GetShipResource(var0.fusion_id, var0.ship_skin_id)

				for iter2, iter3 in ipairs(var1) do
					table.insert(var0, iter3)
				end

				local var2 = var0.weapon_id_list

				for iter4, iter5 in ipairs(var2) do
					var3.getWeaponResource(iter5, var0)
				end

				local var3 = var0.buff_list

				for iter6, iter7 in ipairs(var3) do
					local var4 = var3.GetResFromBuff(iter7, arg1, arg2)

					for iter8, iter9 in ipairs(var4) do
						var0[#var0 + 1] = iter9
					end
				end
			end

			local var5 = iter1.arg_list.weapon_id

			if var5 ~= nil then
				var3.getWeaponResource(var5, var0)
			end

			local var6 = iter1.arg_list.buff_id

			if var6 then
				local var7 = var3.GetResFromBuff(var6, arg1, arg2)

				for iter10, iter11 in ipairs(var7) do
					var0[#var0 + 1] = iter11
				end
			end

			local var8 = iter1.arg_list.damage_buff_id

			if var8 then
				local var9 = iter1.arg_list.damage_buff_lv or 1
				local var10 = var3.GetResFromBuff(var8, var9, arg2)

				for iter12, iter13 in ipairs(var10) do
					var0[#var0 + 1] = iter13
				end
			end

			local var11 = iter1.arg_list.effect

			if var11 then
				var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetFXPath(var11)
			end

			local var12 = iter1.arg_list.finale_effect

			if var12 then
				var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetFXPath(var12)
			end

			local var13 = iter1.arg_list.spawnData

			if var13 then
				local var14 = var0.Battle.BattleResourceManager.GetMonsterRes(var13)

				for iter14, iter15 in ipairs(var14) do
					var0[#var0 + 1] = iter15
				end
			end
		end
	end

	if type(var1.painting) == "string" then
		var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetHrzIcon(var1.painting)
	end

	if type(var1.castCV) == "table" then
		var0.Battle.BattleResourceManager.GetInstance():AddPreloadCV(var1.castCV.skinID)
	end

	if var1.focus_duration then
		if var1.cutin_cover then
			var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var1.cutin_cover)
		elseif arg3 then
			local var3 = var3.GetPlayerShipSkinDataFromID(arg3).painting

			var0[#var0 + 1] = var0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var3)
		end
	end

	var2(var1.effect_list)

	for iter0, iter1 in ipairs(var1) do
		var2(iter1.effect_list)
	end

	return var0
end

function var3.GetShipSkillTriggerCount(arg0, arg1)
	local function var0(arg0)
		local var0 = 0

		for iter0, iter1 in pairs(arg0) do
			local var1 = var3.GetBuffTemplate(iter1.id).effect_list

			for iter2, iter3 in ipairs(var1) do
				local var2 = iter3.trigger

				for iter4, iter5 in ipairs(var2) do
					if table.contains(arg1, iter5) then
						var0 = var0 + 1
					end
				end
			end
		end

		return var0
	end

	local var1 = 0
	local var2 = arg0.skills or {}
	local var3 = var1 + var0(var2)
	local var4 = var3.GetEquipSkill(arg0.equipment)
	local var5 = {}

	for iter0, iter1 in ipairs(var4) do
		table.insert(var5, {
			id = iter1
		})
	end

	return var3 + var0(var5)
end

function var3.GetSongList(arg0)
	local var0 = {
		initList = {},
		otherList = {}
	}

	for iter0, iter1 in pairs(arg0) do
		local var1 = var3.GetBuffTemplate(iter0, 1)

		for iter2, iter3 in ipairs(var1.effect_list) do
			if iter3.type == var0.Battle.BattleBuffDiva.__name then
				if table.contains(iter3.trigger, "onInitGame") then
					for iter4, iter5 in ipairs(iter3.arg_list.bgm_list) do
						var0.initList[iter5] = true
					end
				end

				if not table.contains(iter3.trigger, "onInitGame") or #iter3.trigger > 1 then
					for iter6, iter7 in ipairs(iter3.arg_list.bgm_list) do
						var0.otherList[iter7] = true
					end
				end
			end
		end
	end

	return var0
end

function var3.GetCardRes(arg0)
	local var0 = {}
	local var1 = var0.Battle.BattleCardPuzzleCard.GetCardEffectConfig(arg0)

	for iter0, iter1 in ipairs(var1.effect_list) do
		local var2 = var3.GetCardFXRes(iter1)

		for iter2, iter3 in ipairs(var2) do
			table.insert(var0, iter3)
		end
	end

	for iter4, iter5 in pairs(var1.effect_list) do
		local var3 = var3.GetCardFXRes(iter5)

		for iter6, iter7 in ipairs(var3) do
			table.insert(var0, iter7)
		end
	end

	return var0
end

function var3.GetCardFXRes(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		if iter1.type == "BattleCardPuzzleSkillCreateCard" then
			local var1 = var3.GetCardRes(iter1.arg_list.card_id)

			for iter2, iter3 in ipairs(var1) do
				table.insert(var0, iter3)
			end
		elseif iter1.type == "BattleCardPuzzleSkillFire" then
			local var2 = var0.Battle.BattleResourceManager.GetWeaponResource(iter1.arg_list.weapon_id)

			for iter4, iter5 in ipairs(var2) do
				table.insert(var0, iter5)
			end
		elseif iter1.type == "BattleCardPuzzleSkillAddBuff" then
			local var3 = var3.GetResFromBuff(iter1.arg_list.buff_id, 1, {})

			for iter6, iter7 in ipairs(var3) do
				table.insert(var0, iter7)
			end
		end
	end

	return var0
end

function var3.NeedSkillPainting(arg0)
	local var0 = false

	if var3.GetSkillTemplate(arg0).focus_duration then
		var0 = true
	end

	return var0
end

function var3.SkinAdaptFXID(arg0, arg1)
	return arg0 .. "_" .. arg1
end

function var3.GetFleetReload(arg0)
	return var2.GetFleetReload(arg0)
end

function var3.GetFleetTorpedoPower(arg0)
	return var2.GetFleetTorpedoPower(arg0)
end

function var3.SortFleetList(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		var0[#var0 + 1] = arg1[iter1]

		var0[iter0]:SetFormationIndex(iter0)
	end

	return var0
end

function var3.GetLimitAttributeRange(arg0, arg1)
	if pg.battle_attribute_range[arg0] then
		return math.clamp(arg1, pg.battle_attribute_range[arg0].min / 10000, pg.battle_attribute_range[arg0].max / 10000)
	end

	return arg1
end

function var3.GetPuzzleCardDataTemplate(arg0)
	assert(var4[arg0] ~= nil, ">>puzzle_card_template<< 找不到卡牌配置：" .. arg0)

	return var4[arg0]
end

function var3.GetPuzzleShipDataTemplate(arg0)
	assert(var5[arg0] ~= nil, ">>puzzle_ship_template<< 找不到卡牌舰船配置：" .. arg0)

	return var5[arg0]
end

function var3.GetPuzzleDungeonTemplate(arg0)
	assert(var6[arg0] ~= nil, ">>puzzle_combat_template<< 找不到卡牌关卡配置：" .. arg0)

	return var6[arg0]
end

function var3.GetPuzzleCardAffixDataTemplate(arg0)
	assert(var7[arg0] ~= nil, ">>puzzle_card_affix<< 找不到卡牌关卡配置：" .. arg0)

	return var7[arg0]
end
