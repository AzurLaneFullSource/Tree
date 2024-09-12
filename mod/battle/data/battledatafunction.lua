ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleFormulas

var0_0.Battle.BattleDataFunction = var0_0.Battle.BattleDataFunction or {}

local var3_0 = var0_0.Battle.BattleDataFunction
local var4_0 = pg.puzzle_card_template
local var5_0 = pg.puzzle_ship_template
local var6_0 = pg.puzzle_combat_template
local var7_0 = pg.puzzle_card_affix

function var3_0.GetDungeonTmpDataByID(arg0_1)
	return require("GameCfg.dungeon." .. arg0_1)
end

function var3_0.ClearDungeonCfg(arg0_2)
	package.loaded["GameCfg.dungeon." .. arg0_2] = nil
end

function var3_0.GetSkillTemplate(arg0_3, arg1_3)
	arg1_3 = arg1_3 or 1

	local var0_3 = "skill_" .. arg0_3
	local var1_3 = pg.ConvertedSkill[var0_3]
	local var2_3 = var1_3[arg1_3] or var1_3[0]

	var2_3.name = getSkillName(arg0_3)

	return var2_3
end

function var3_0.ConvertSkillTemplate()
	pg.ConvertedSkill = {}

	setmetatable(pg.ConvertedSkill, {
		__index = function(arg0_5, arg1_5)
			local var0_5 = arg1_5
			local var1_5 = pg.skillCfg[arg1_5]

			if var1_5 then
				local var2_5 = {}
				local var3_5 = {}

				for iter0_5, iter1_5 in pairs(var1_5) do
					var3_5[iter0_5] = Clone(iter1_5)
				end

				var2_5[0] = var3_5

				for iter2_5, iter3_5 in ipairs(var1_5) do
					local var4_5 = Clone(var3_5)

					for iter4_5, iter5_5 in pairs(iter3_5) do
						var4_5[iter4_5] = iter5_5
					end

					var2_5[iter2_5] = var4_5
				end

				pg.ConvertedSkill[var0_5] = var2_5

				return var2_5
			end
		end
	})
end

function var3_0.GetBuffTemplate(arg0_6, arg1_6)
	arg1_6 = arg1_6 or 1

	local var0_6 = "buff_" .. arg0_6
	local var1_6 = pg.ConvertedBuff[var0_6]

	return var1_6[arg1_6] or var1_6[0]
end

function var3_0.ConvertBuffTemplate()
	pg.ConvertedBuff = {}

	setmetatable(pg.ConvertedBuff, {
		__index = function(arg0_8, arg1_8)
			local var0_8 = arg1_8
			local var1_8 = pg.buffCfg[arg1_8]

			if var1_8 then
				local var2_8 = {}
				local var3_8 = {}

				for iter0_8, iter1_8 in pairs(var1_8) do
					var3_8[iter0_8] = Clone(iter1_8)
				end

				var2_8[0] = var3_8

				for iter2_8, iter3_8 in ipairs(var1_8) do
					local var4_8 = Clone(var3_8)

					for iter4_8, iter5_8 in pairs(iter3_8) do
						var4_8[iter4_8] = iter5_8
					end

					var2_8[iter2_8] = var4_8
				end

				pg.ConvertedBuff[var0_8] = var2_8

				return var2_8
			end
		end
	})
end

function var3_0.GetBuffBulletRes(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = {}
	local var1_9 = {}

	arg1_9 = arg1_9 or {}

	local var2_9 = var3_0.GetPlayerShipModelFromID(arg0_9)

	local function var3_9(arg0_10)
		for iter0_10, iter1_10 in ipairs(arg0_10) do
			local var0_10

			if arg1_9[iter1_10] then
				var0_10 = arg1_9[iter1_10].level
			else
				var0_10 = 1
			end

			iter1_10 = arg4_9 and arg4_9:RemapSkillId(iter1_10) or iter1_10

			local var1_10 = var3_0.SkillTranform(arg2_9, iter1_10)
			local var2_10 = var3_0.GetResFromBuff(var1_10, var0_10, var1_9, arg3_9)

			for iter2_10, iter3_10 in ipairs(var2_10) do
				var0_9[#var0_9 + 1] = iter3_10
			end
		end
	end

	var3_9(var2_9.buff_list)
	var3_9(var2_9.hide_buff_list)

	local var4_9 = {}

	for iter0_9, iter1_9 in pairs(arg1_9) do
		table.insert(var4_9, iter0_9)
	end

	var3_9(var4_9)

	local var5_9 = var2_9.airassist_time

	for iter2_9, iter3_9 in ipairs(var5_9) do
		local var6_9 = var3_0.GetResFromSkill(iter3_9, 1, nil, arg3_9)

		for iter4_9, iter5_9 in ipairs(var6_9) do
			var0_9[#var0_9 + 1] = iter5_9
		end
	end

	local var7_9 = var3_0.GetShipTransformDataTemplate(arg0_9)

	if var7_9 and var7_9.skill_id ~= 0 and pg.transform_data_template[var7_9.skill_id].skill_id ~= 0 then
		local var8_9 = pg.transform_data_template[var7_9.skill_id].skill_id
		local var9_9

		if arg1_9[var8_9] then
			var9_9 = arg1_9[var8_9].level
		else
			var9_9 = 1
		end

		local var10_9 = var3_0.GetResFromBuff(var8_9, var9_9, var1_9, arg3_9)

		for iter6_9, iter7_9 in ipairs(var10_9) do
			var0_9[#var0_9 + 1] = iter7_9
		end
	end

	if var3_0.GetShipMetaFromDataTemplate(arg0_9) then
		var3_9(var2_9.buff_list_display)
	end

	return var0_9
end

function var3_0.getWeaponResource(arg0_11, arg1_11)
	local var0_11 = var0_0.Battle.BattleResourceManager.GetWeaponResource(arg0_11)

	for iter0_11, iter1_11 in ipairs(var0_11) do
		arg1_11[#arg1_11 + 1] = iter1_11
	end
end

function var3_0.GetResFromBuff(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = {}
	local var1_12 = arg0_12 .. "_" .. arg1_12

	if arg2_12[var1_12] then
		return var0_12
	else
		arg2_12[var1_12] = true
	end

	local var2_12 = var3_0.GetBuffTemplate(arg0_12, arg1_12)

	if var2_12.init_effect and var2_12.init_effect ~= "" then
		local var3_12 = var2_12.init_effect

		if var2_12.skin_adapt then
			var3_12 = var3_0.SkinAdaptFXID(var3_12, arg3_12)
		end

		var0_12[#var0_12 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var3_12)
	end

	if var2_12.last_effect and var2_12.last_effect ~= "" then
		local var4_12 = type(var2_12.last_effect) == "table" and var2_12.last_effect or {
			var2_12.last_effect
		}

		for iter0_12, iter1_12 in ipairs(var4_12) do
			var0_12[#var0_12 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(iter1_12)
		end
	end

	for iter2_12, iter3_12 in ipairs(var2_12.effect_list) do
		local var5_12 = iter3_12.arg_list.skill_id

		if var5_12 ~= nil then
			local var6_12 = var3_0.GetResFromSkill(var5_12, arg1_12, arg2_12, arg3_12)

			for iter4_12, iter5_12 in ipairs(var6_12) do
				var0_12[#var0_12 + 1] = iter5_12
			end
		end

		local var7_12 = iter3_12.arg_list.skill_id_list

		if var7_12 ~= nil then
			for iter6_12, iter7_12 in ipairs(var7_12) do
				local var8_12 = var3_0.GetResFromSkill(iter7_12, arg1_12, arg2_12, arg3_12)

				for iter8_12, iter9_12 in ipairs(var8_12) do
					var0_12[#var0_12 + 1] = iter9_12
				end
			end
		end

		local var9_12 = iter3_12.arg_list.damage_attr_list

		if var9_12 ~= nil then
			for iter10_12, iter11_12 in pairs(var9_12) do
				local var10_12 = var3_0.GetResFromSkill(iter11_12, arg1_12, arg2_12, arg3_12)

				for iter12_12, iter13_12 in ipairs(var10_12) do
					var0_12[#var0_12 + 1] = iter13_12
				end
			end
		end

		local var11_12 = iter3_12.arg_list.bullet_id

		if var11_12 then
			local var12_12 = var0_0.Battle.BattleResourceManager.GetBulletResource(var11_12)

			for iter14_12, iter15_12 in ipairs(var12_12) do
				var0_12[#var0_12 + 1] = iter15_12
			end
		end

		local var13_12 = iter3_12.arg_list.weapon_id

		if var13_12 then
			var3_0.getWeaponResource(var13_12, var0_12)
		end

		local var14_12 = iter3_12.arg_list.skin_id

		if var14_12 then
			local var15_12 = var0_0.Battle.BattleResourceManager.GetEquipSkinBulletRes(var14_12)

			for iter16_12, iter17_12 in ipairs(var15_12) do
				var0_12[#var0_12 + 1] = iter17_12
			end
		end

		local var16_12 = iter3_12.arg_list.ship_skin_id

		if var16_12 then
			local var17_12 = var3_0.GetPlayerShipSkinDataFromID(var16_12)

			var0_12[#var0_12 + 1] = var0_0.Battle.BattleResourceManager.GetCharacterPath(var17_12.prefab)
		end

		local var18_12 = iter3_12.arg_list.buff_id

		if var18_12 then
			local var19_12 = var3_0.GetResFromBuff(var18_12, arg1_12, arg2_12, arg3_12)

			for iter18_12, iter19_12 in ipairs(var19_12) do
				if type(iter19_12) == "string" then
					var0_12[#var0_12 + 1] = iter19_12
				elseif type(iter19_12) == "table" then
					for iter20_12, iter21_12 in ipairs(iter19_12) do
						var0_12[#var0_12 + 1] = iter21_12
					end
				end
			end
		end

		local var20_12 = iter3_12.arg_list.buff_skin_id

		if var20_12 then
			local var21_12 = var3_0.GetResFromBuff(var20_12, arg1_12, arg2_12, arg3_12)

			for iter22_12, iter23_12 in ipairs(var21_12) do
				if type(iter23_12) == "string" then
					var0_12[#var0_12 + 1] = iter23_12
				elseif type(iter23_12) == "table" then
					for iter24_12, iter25_12 in ipairs(iter23_12) do
						var0_12[#var0_12 + 1] = iter25_12
					end
				end
			end
		end

		local var22_12 = iter3_12.arg_list.effect

		if var22_12 then
			var0_12[#var0_12 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var22_12)
		end
	end

	return var0_12
end

function var3_0.GetBuffListRes(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}
	local var1_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13) do
		local var2_13 = iter1_13.id
		local var3_13 = iter1_13.level

		for iter2_13, iter3_13 in ipairs(var3_0.GetResFromBuff(var2_13, var3_13, var1_13, arg2_13)) do
			var0_13[#var0_13 + 1] = iter3_13
		end
	end

	return var0_13
end

function var3_0.GetResFromSkill(arg0_14, arg1_14, arg2_14, arg3_14)
	arg1_14 = arg1_14 or 1

	local var0_14 = {}
	local var1_14 = var3_0.GetSkillTemplate(arg0_14, arg1_14)

	local function var2_14(arg0_15)
		for iter0_15, iter1_15 in ipairs(arg0_15) do
			if iter1_15.type == "BattleBuffShieldWall" then
				print(iter1_15.arg_list.effect)
			end

			if iter1_15.type == var0_0.Battle.BattleSkillGridmanFloat.__name then
				table.insert(var0_14, "UI/combatgridmanskillfloat")
			end

			if iter1_15.type == var0_0.Battle.BattleSkillFusion.__name then
				local var0_15 = iter1_15.arg_list
				local var1_15 = var0_0.Battle.BattleResourceManager.GetShipResource(var0_15.fusion_id, var0_15.ship_skin_id)

				for iter2_15, iter3_15 in ipairs(var1_15) do
					table.insert(var0_14, iter3_15)
				end

				local var2_15 = var0_15.weapon_id_list

				for iter4_15, iter5_15 in ipairs(var2_15) do
					var3_0.getWeaponResource(iter5_15, var0_14)
				end

				local var3_15 = var0_15.buff_list

				for iter6_15, iter7_15 in ipairs(var3_15) do
					local var4_15 = var3_0.GetResFromBuff(iter7_15, arg1_14, arg2_14)

					for iter8_15, iter9_15 in ipairs(var4_15) do
						var0_14[#var0_14 + 1] = iter9_15
					end
				end
			end

			local var5_15 = iter1_15.arg_list.weapon_id

			if var5_15 ~= nil then
				var3_0.getWeaponResource(var5_15, var0_14)
			end

			local var6_15 = iter1_15.arg_list.buff_id

			if var6_15 then
				local var7_15 = var3_0.GetResFromBuff(var6_15, arg1_14, arg2_14)

				for iter10_15, iter11_15 in ipairs(var7_15) do
					var0_14[#var0_14 + 1] = iter11_15
				end
			end

			local var8_15 = iter1_15.arg_list.damage_buff_id

			if var8_15 then
				local var9_15 = iter1_15.arg_list.damage_buff_lv or 1
				local var10_15 = var3_0.GetResFromBuff(var8_15, var9_15, arg2_14)

				for iter12_15, iter13_15 in ipairs(var10_15) do
					var0_14[#var0_14 + 1] = iter13_15
				end
			end

			local var11_15 = iter1_15.arg_list.effect

			if var11_15 then
				var0_14[#var0_14 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var11_15)
			end

			local var12_15 = iter1_15.arg_list.finale_effect

			if var12_15 then
				var0_14[#var0_14 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var12_15)
			end

			local var13_15 = iter1_15.arg_list.spawnData

			if var13_15 then
				local var14_15 = var0_0.Battle.BattleResourceManager.GetMonsterRes(var13_15)

				for iter14_15, iter15_15 in ipairs(var14_15) do
					var0_14[#var0_14 + 1] = iter15_15
				end
			end
		end
	end

	if type(var1_14.painting) == "string" then
		var0_14[#var0_14 + 1] = var0_0.Battle.BattleResourceManager.GetHrzIcon(var1_14.painting)
		var0_14[#var0_14 + 1] = var0_0.Battle.BattleResourceManager.GetSquareIcon(var1_14.painting)
	end

	if type(var1_14.castCV) == "table" then
		var0_0.Battle.BattleResourceManager.GetInstance():AddPreloadCV(var1_14.castCV.skinID)
	end

	if var1_14.focus_duration then
		if var1_14.cutin_cover then
			var0_14[#var0_14 + 1] = var0_0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var1_14.cutin_cover)
		elseif arg3_14 then
			local var3_14 = var3_0.GetPlayerShipSkinDataFromID(arg3_14).painting

			var0_14[#var0_14 + 1] = var0_0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var3_14)
		end
	end

	var2_14(var1_14.effect_list)

	for iter0_14, iter1_14 in ipairs(var1_14) do
		var2_14(iter1_14.effect_list)
	end

	return var0_14
end

function var3_0.GetShipSkillTriggerCount(arg0_16, arg1_16)
	local function var0_16(arg0_17)
		local var0_17 = 0

		for iter0_17, iter1_17 in pairs(arg0_17) do
			local var1_17 = var3_0.GetBuffTemplate(iter1_17.id).effect_list

			for iter2_17, iter3_17 in ipairs(var1_17) do
				local var2_17 = iter3_17.trigger

				for iter4_17, iter5_17 in ipairs(var2_17) do
					if table.contains(arg1_16, iter5_17) then
						var0_17 = var0_17 + 1
					end
				end
			end
		end

		return var0_17
	end

	local var1_16 = 0
	local var2_16 = arg0_16.skills or {}
	local var3_16 = var1_16 + var0_16(var2_16)
	local var4_16 = var3_0.GetEquipSkill(arg0_16.equipment)
	local var5_16 = {}

	for iter0_16, iter1_16 in ipairs(var4_16) do
		table.insert(var5_16, {
			id = iter1_16
		})
	end

	return var3_16 + var0_16(var5_16)
end

function var3_0.GetSongList(arg0_18)
	local var0_18 = {
		initList = {},
		otherList = {}
	}

	for iter0_18, iter1_18 in pairs(arg0_18) do
		local var1_18 = var3_0.GetBuffTemplate(iter0_18, 1)

		for iter2_18, iter3_18 in ipairs(var1_18.effect_list) do
			if iter3_18.type == var0_0.Battle.BattleBuffDiva.__name then
				if table.contains(iter3_18.trigger, "onInitGame") then
					for iter4_18, iter5_18 in ipairs(iter3_18.arg_list.bgm_list) do
						var0_18.initList[iter5_18] = true
					end
				end

				if not table.contains(iter3_18.trigger, "onInitGame") or #iter3_18.trigger > 1 then
					for iter6_18, iter7_18 in ipairs(iter3_18.arg_list.bgm_list) do
						var0_18.otherList[iter7_18] = true
					end
				end
			end
		end
	end

	return var0_18
end

function var3_0.GetCardRes(arg0_19)
	local var0_19 = {}
	local var1_19 = var0_0.Battle.BattleCardPuzzleCard.GetCardEffectConfig(arg0_19)

	for iter0_19, iter1_19 in ipairs(var1_19.effect_list) do
		local var2_19 = var3_0.GetCardFXRes(iter1_19)

		for iter2_19, iter3_19 in ipairs(var2_19) do
			table.insert(var0_19, iter3_19)
		end
	end

	for iter4_19, iter5_19 in pairs(var1_19.effect_list) do
		local var3_19 = var3_0.GetCardFXRes(iter5_19)

		for iter6_19, iter7_19 in ipairs(var3_19) do
			table.insert(var0_19, iter7_19)
		end
	end

	return var0_19
end

function var3_0.GetCardFXRes(arg0_20)
	local var0_20 = {}

	for iter0_20, iter1_20 in ipairs(arg0_20) do
		if iter1_20.type == "BattleCardPuzzleSkillCreateCard" then
			local var1_20 = var3_0.GetCardRes(iter1_20.arg_list.card_id)

			for iter2_20, iter3_20 in ipairs(var1_20) do
				table.insert(var0_20, iter3_20)
			end
		elseif iter1_20.type == "BattleCardPuzzleSkillFire" then
			local var2_20 = var0_0.Battle.BattleResourceManager.GetWeaponResource(iter1_20.arg_list.weapon_id)

			for iter4_20, iter5_20 in ipairs(var2_20) do
				table.insert(var0_20, iter5_20)
			end
		elseif iter1_20.type == "BattleCardPuzzleSkillAddBuff" then
			local var3_20 = var3_0.GetResFromBuff(iter1_20.arg_list.buff_id, 1, {})

			for iter6_20, iter7_20 in ipairs(var3_20) do
				table.insert(var0_20, iter7_20)
			end
		end
	end

	return var0_20
end

function var3_0.NeedSkillPainting(arg0_21)
	local var0_21 = false

	if var3_0.GetSkillTemplate(arg0_21).focus_duration then
		var0_21 = true
	end

	return var0_21
end

function var3_0.SkinAdaptFXID(arg0_22, arg1_22)
	return arg0_22 .. "_" .. arg1_22
end

function var3_0.GetFleetReload(arg0_23)
	return var2_0.GetFleetReload(arg0_23)
end

function var3_0.GetFleetTorpedoPower(arg0_24)
	return var2_0.GetFleetTorpedoPower(arg0_24)
end

function var3_0.SortFleetList(arg0_25, arg1_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in ipairs(arg0_25) do
		var0_25[#var0_25 + 1] = arg1_25[iter1_25]

		var0_25[iter0_25]:SetFormationIndex(iter0_25)
	end

	return var0_25
end

function var3_0.GetLimitAttributeRange(arg0_26, arg1_26)
	if pg.battle_attribute_range[arg0_26] then
		return math.clamp(arg1_26, pg.battle_attribute_range[arg0_26].min / 10000, pg.battle_attribute_range[arg0_26].max / 10000)
	end

	return arg1_26
end

function var3_0.GetPuzzleCardDataTemplate(arg0_27)
	assert(var4_0[arg0_27] ~= nil, ">>puzzle_card_template<< 找不到卡牌配置：" .. arg0_27)

	return var4_0[arg0_27]
end

function var3_0.GetPuzzleShipDataTemplate(arg0_28)
	assert(var5_0[arg0_28] ~= nil, ">>puzzle_ship_template<< 找不到卡牌舰船配置：" .. arg0_28)

	return var5_0[arg0_28]
end

function var3_0.GetPuzzleDungeonTemplate(arg0_29)
	assert(var6_0[arg0_29] ~= nil, ">>puzzle_combat_template<< 找不到卡牌关卡配置：" .. arg0_29)

	return var6_0[arg0_29]
end

function var3_0.GetPuzzleCardAffixDataTemplate(arg0_30)
	assert(var7_0[arg0_30] ~= nil, ">>puzzle_card_affix<< 找不到卡牌关卡配置：" .. arg0_30)

	return var7_0[arg0_30]
end
