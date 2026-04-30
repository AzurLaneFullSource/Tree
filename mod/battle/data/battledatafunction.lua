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
		if not arg4_9 then
			return arg0_10
		end

		if table.contains(var2_9.hide_buff_list, arg0_10) then
			return arg4_9:RemapHiddenSkillId(arg0_10)
		end

		local var0_10 = arg4_9:RemapHiddenSkillId(arg0_10)

		if var0_10 == arg0_10 then
			var0_10 = arg4_9:RemapSkillId(arg0_10)
		end

		return var0_10
	end

	local function var4_9(arg0_11)
		for iter0_11, iter1_11 in ipairs(arg0_11) do
			local var0_11

			if arg1_9[iter1_11] then
				var0_11 = arg1_9[iter1_11].level
			else
				var0_11 = 1
			end

			iter1_11 = var3_9(iter1_11)

			local var1_11 = var3_0.SkillTranform(arg2_9, iter1_11)
			local var2_11 = var3_0.GetResFromBuff(var1_11, var0_11, var1_9, arg3_9)

			for iter2_11, iter3_11 in ipairs(var2_11) do
				var0_9[#var0_9 + 1] = iter3_11
			end
		end
	end

	var4_9(var2_9.buff_list)
	var4_9(var2_9.hide_buff_list)

	local var5_9 = {}

	for iter0_9, iter1_9 in pairs(arg1_9) do
		table.insert(var5_9, iter0_9)
	end

	var4_9(var5_9)

	local var6_9 = var2_9.airassist_time

	for iter2_9, iter3_9 in ipairs(var6_9) do
		local var7_9 = var3_0.GetResFromSkill(iter3_9, 1, nil, arg3_9)

		for iter4_9, iter5_9 in ipairs(var7_9) do
			var0_9[#var0_9 + 1] = iter5_9
		end
	end

	local var8_9 = var3_0.GetShipTransformDataTemplate(arg0_9)

	if var8_9 and var8_9.skill_id ~= 0 and pg.transform_data_template[var8_9.skill_id].skill_id ~= 0 then
		local var9_9 = pg.transform_data_template[var8_9.skill_id].skill_id
		local var10_9

		if arg1_9[var9_9] then
			var10_9 = arg1_9[var9_9].level
		else
			var10_9 = 1
		end

		local var11_9 = var3_0.GetResFromBuff(var9_9, var10_9, var1_9, arg3_9)

		for iter6_9, iter7_9 in ipairs(var11_9) do
			var0_9[#var0_9 + 1] = iter7_9
		end
	end

	if var3_0.GetShipMetaFromDataTemplate(arg0_9) then
		var4_9(var2_9.buff_list_display)
	end

	return var0_9
end

function var3_0.getWeaponResource(arg0_12, arg1_12)
	local var0_12 = var0_0.Battle.BattleResourceManager.GetWeaponResource(arg0_12)

	for iter0_12, iter1_12 in ipairs(var0_12) do
		arg1_12[#arg1_12 + 1] = iter1_12
	end
end

function var3_0.GetResFromBuff(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {}
	local var1_13 = arg0_13 .. "_" .. arg1_13

	if arg2_13[var1_13] then
		return var0_13
	else
		arg2_13[var1_13] = true
	end

	local var2_13 = var3_0.GetBuffTemplate(arg0_13, arg1_13)

	if var2_13.init_effect and var2_13.init_effect ~= "" then
		local var3_13 = var2_13.init_effect

		if var2_13.skin_adapt then
			var3_13 = var3_0.SkinAdaptFXID(var3_13, arg3_13)
		end

		var0_13[#var0_13 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var3_13)
	end

	if var2_13.last_effect and var2_13.last_effect ~= "" then
		local var4_13 = type(var2_13.last_effect) == "table" and var2_13.last_effect or {
			var2_13.last_effect
		}

		for iter0_13, iter1_13 in ipairs(var4_13) do
			var0_13[#var0_13 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(iter1_13)
		end
	end

	if var2_13.last_effect_stack_list then
		for iter2_13, iter3_13 in pairs(var2_13.last_effect_stack_list) do
			var0_13[#var0_13 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(iter3_13)
		end
	end

	for iter4_13, iter5_13 in ipairs(var2_13.effect_list) do
		local var5_13 = iter5_13.arg_list.skill_id

		if var5_13 ~= nil then
			local var6_13 = var3_0.GetResFromSkill(var5_13, arg1_13, arg2_13, arg3_13)

			for iter6_13, iter7_13 in ipairs(var6_13) do
				var0_13[#var0_13 + 1] = iter7_13
			end
		end

		local var7_13 = iter5_13.arg_list.skill_id_list

		if var7_13 ~= nil then
			for iter8_13, iter9_13 in ipairs(var7_13) do
				local var8_13 = var3_0.GetResFromSkill(iter9_13, arg1_13, arg2_13, arg3_13)

				for iter10_13, iter11_13 in ipairs(var8_13) do
					var0_13[#var0_13 + 1] = iter11_13
				end
			end
		end

		local var9_13 = iter5_13.arg_list.damage_attr_list

		if var9_13 ~= nil then
			for iter12_13, iter13_13 in pairs(var9_13) do
				local var10_13 = var3_0.GetResFromSkill(iter13_13, arg1_13, arg2_13, arg3_13)

				for iter14_13, iter15_13 in ipairs(var10_13) do
					var0_13[#var0_13 + 1] = iter15_13
				end
			end
		end

		local var11_13 = iter5_13.arg_list.bullet_id

		if var11_13 then
			local var12_13 = var0_0.Battle.BattleResourceManager.GetBulletResource(var11_13)

			for iter16_13, iter17_13 in ipairs(var12_13) do
				var0_13[#var0_13 + 1] = iter17_13
			end
		end

		local var13_13 = iter5_13.arg_list.weapon_id

		if var13_13 then
			var3_0.getWeaponResource(var13_13, var0_13)
		end

		local var14_13 = iter5_13.arg_list.aircraft_id_list

		if var14_13 then
			for iter18_13, iter19_13 in ipairs(var14_13) do
				var3_0.getWeaponResource(iter19_13, var0_13)
			end
		end

		local var15_13 = iter5_13.arg_list.skin_id

		if var15_13 then
			local var16_13 = var0_0.Battle.BattleResourceManager.GetEquipSkinBulletRes(var15_13)

			for iter20_13, iter21_13 in ipairs(var16_13) do
				var0_13[#var0_13 + 1] = iter21_13
			end
		end

		local var17_13 = iter5_13.arg_list.ship_skin_id

		if var17_13 then
			local var18_13 = var3_0.GetPlayerShipSkinDataFromID(var17_13)

			var0_13[#var0_13 + 1] = var0_0.Battle.BattleResourceManager.GetCharacterPath(var18_13.prefab)
		end

		local var19_13 = iter5_13.arg_list.buff_id

		if var19_13 then
			local var20_13 = var3_0.GetResFromBuff(var19_13, arg1_13, arg2_13, arg3_13)

			for iter22_13, iter23_13 in ipairs(var20_13) do
				if type(iter23_13) == "string" then
					var0_13[#var0_13 + 1] = iter23_13
				elseif type(iter23_13) == "table" then
					for iter24_13, iter25_13 in ipairs(iter23_13) do
						var0_13[#var0_13 + 1] = iter25_13
					end
				end
			end
		end

		local var21_13 = iter5_13.arg_list.buff_skin_id

		if var21_13 then
			local var22_13 = var3_0.GetResFromBuff(var21_13, arg1_13, arg2_13, arg3_13)

			for iter26_13, iter27_13 in ipairs(var22_13) do
				if type(iter27_13) == "string" then
					var0_13[#var0_13 + 1] = iter27_13
				elseif type(iter27_13) == "table" then
					for iter28_13, iter29_13 in ipairs(iter27_13) do
						var0_13[#var0_13 + 1] = iter29_13
					end
				end
			end
		end

		local var23_13 = iter5_13.arg_list.effect

		if var23_13 then
			var0_13[#var0_13 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var23_13)
		end
	end

	return var0_13
end

function var3_0.GetBuffListRes(arg0_14, arg1_14, arg2_14)
	local var0_14 = {}
	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14) do
		local var2_14 = iter1_14.id
		local var3_14 = iter1_14.level

		for iter2_14, iter3_14 in ipairs(var3_0.GetResFromBuff(var2_14, var3_14, var1_14, arg2_14)) do
			var0_14[#var0_14 + 1] = iter3_14
		end
	end

	return var0_14
end

function var3_0.GetResFromSkill(arg0_15, arg1_15, arg2_15, arg3_15)
	arg1_15 = arg1_15 or 1

	local var0_15 = {}
	local var1_15 = var3_0.GetSkillTemplate(arg0_15, arg1_15)

	local function var2_15(arg0_16)
		for iter0_16, iter1_16 in ipairs(arg0_16) do
			if iter1_16.type == "BattleBuffShieldWall" then
				print(iter1_16.arg_list.effect)
			end

			if iter1_16.type == var0_0.Battle.BattleSkillGridmanFloat.__name then
				table.insert(var0_15, "UI/combatgridmanskillfloat")
			end

			if iter1_16.type == var0_0.Battle.BattleSkillFusion.__name then
				local var0_16 = iter1_16.arg_list
				local var1_16 = var0_0.Battle.BattleResourceManager.GetShipResource(var0_16.fusion_id, var0_16.ship_skin_id)

				for iter2_16, iter3_16 in ipairs(var1_16) do
					table.insert(var0_15, iter3_16)
				end

				local var2_16 = var0_16.weapon_id_list

				for iter4_16, iter5_16 in ipairs(var2_16) do
					var3_0.getWeaponResource(iter5_16, var0_15)
				end

				local var3_16 = var0_16.buff_list

				for iter6_16, iter7_16 in ipairs(var3_16) do
					local var4_16 = var3_0.GetResFromBuff(iter7_16, arg1_15, arg2_15)

					for iter8_16, iter9_16 in ipairs(var4_16) do
						var0_15[#var0_15 + 1] = iter9_16
					end
				end
			end

			local var5_16 = iter1_16.arg_list.weapon_id

			if var5_16 ~= nil then
				var3_0.getWeaponResource(var5_16, var0_15)
			end

			local var6_16 = iter1_16.arg_list.buff_id

			if var6_16 then
				local var7_16 = var3_0.GetResFromBuff(var6_16, arg1_15, arg2_15)

				for iter10_16, iter11_16 in ipairs(var7_16) do
					var0_15[#var0_15 + 1] = iter11_16
				end
			end

			local var8_16 = iter1_16.arg_list.damage_buff_id

			if var8_16 then
				local var9_16 = iter1_16.arg_list.damage_buff_lv or 1
				local var10_16 = var3_0.GetResFromBuff(var8_16, var9_16, arg2_15)

				for iter12_16, iter13_16 in ipairs(var10_16) do
					var0_15[#var0_15 + 1] = iter13_16
				end
			end

			local var11_16 = iter1_16.arg_list.effect

			if var11_16 then
				var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var11_16)
			end

			local var12_16 = iter1_16.arg_list.finale_effect

			if var12_16 then
				var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetFXPath(var12_16)
			end

			local var13_16 = iter1_16.arg_list.spawnData

			if var13_16 then
				local var14_16 = var0_0.Battle.BattleResourceManager.GetMonsterRes(var13_16)

				for iter14_16, iter15_16 in ipairs(var14_16) do
					var0_15[#var0_15 + 1] = iter15_16
				end
			end
		end
	end

	if type(var1_15.painting) == "string" then
		var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetHrzIcon(var1_15.painting)
		var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetSquareIcon(var1_15.painting)
	end

	if type(var1_15.castCV) == "table" then
		var0_0.Battle.BattleResourceManager.GetInstance():AddPreloadCV(var1_15.castCV.skinID)
	end

	if var1_15.focus_duration then
		if var1_15.cutin_cover then
			var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var1_15.cutin_cover)
		elseif var1_15.cutin_cover_DAL then
			var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var1_15.cutin_cover_DAL)
			var0_15[#var0_15 + 1] = "UI/SkillPaintingDAL"
		elseif arg3_15 then
			local var3_15 = var3_0.GetPlayerShipSkinDataFromID(arg3_15).painting

			var0_15[#var0_15 + 1] = var0_0.Battle.BattleResourceManager.GetInstance().GetPaintingPath(var3_15)
		end
	end

	var2_15(var1_15.effect_list)

	for iter0_15, iter1_15 in ipairs(var1_15) do
		var2_15(iter1_15.effect_list)
	end

	return var0_15
end

function var3_0.GetShipSkillTriggerCount(arg0_17, arg1_17)
	local function var0_17(arg0_18)
		local var0_18 = 0

		for iter0_18, iter1_18 in pairs(arg0_18) do
			local var1_18 = var3_0.GetBuffTemplate(iter1_18.id).effect_list

			for iter2_18, iter3_18 in ipairs(var1_18) do
				local var2_18 = iter3_18.trigger

				for iter4_18, iter5_18 in ipairs(var2_18) do
					if table.contains(arg1_17, iter5_18) then
						var0_18 = var0_18 + 1
					end
				end
			end
		end

		return var0_18
	end

	local var1_17 = 0
	local var2_17 = arg0_17.skills or {}
	local var3_17 = var1_17 + var0_17(var2_17)
	local var4_17 = var3_0.GetEquipSkill(arg0_17.equipment)
	local var5_17 = {}

	for iter0_17, iter1_17 in ipairs(var4_17) do
		table.insert(var5_17, {
			id = iter1_17.buffID
		})
	end

	return var3_17 + var0_17(var5_17)
end

function var3_0.GetSongList(arg0_19)
	local var0_19 = {
		initList = {},
		otherList = {}
	}

	for iter0_19, iter1_19 in pairs(arg0_19) do
		local var1_19 = var3_0.GetBuffTemplate(iter0_19, 1)

		for iter2_19, iter3_19 in ipairs(var1_19.effect_list) do
			if iter3_19.type == var0_0.Battle.BattleBuffDiva.__name then
				if table.contains(iter3_19.trigger, "onInitGame") then
					for iter4_19, iter5_19 in ipairs(iter3_19.arg_list.bgm_list) do
						var0_19.initList[iter5_19] = true
					end
				end

				if not table.contains(iter3_19.trigger, "onInitGame") or #iter3_19.trigger > 1 then
					for iter6_19, iter7_19 in ipairs(iter3_19.arg_list.bgm_list) do
						var0_19.otherList[iter7_19] = true
					end
				end
			end
		end
	end

	return var0_19
end

function var3_0.GetCardRes(arg0_20)
	local var0_20 = {}
	local var1_20 = var0_0.Battle.BattleCardPuzzleCard.GetCardEffectConfig(arg0_20)

	for iter0_20, iter1_20 in ipairs(var1_20.effect_list) do
		local var2_20 = var3_0.GetCardFXRes(iter1_20)

		for iter2_20, iter3_20 in ipairs(var2_20) do
			table.insert(var0_20, iter3_20)
		end
	end

	for iter4_20, iter5_20 in pairs(var1_20.effect_list) do
		local var3_20 = var3_0.GetCardFXRes(iter5_20)

		for iter6_20, iter7_20 in ipairs(var3_20) do
			table.insert(var0_20, iter7_20)
		end
	end

	return var0_20
end

function var3_0.GetCardFXRes(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21) do
		if iter1_21.type == "BattleCardPuzzleSkillCreateCard" then
			local var1_21 = var3_0.GetCardRes(iter1_21.arg_list.card_id)

			for iter2_21, iter3_21 in ipairs(var1_21) do
				table.insert(var0_21, iter3_21)
			end
		elseif iter1_21.type == "BattleCardPuzzleSkillFire" then
			local var2_21 = var0_0.Battle.BattleResourceManager.GetWeaponResource(iter1_21.arg_list.weapon_id)

			for iter4_21, iter5_21 in ipairs(var2_21) do
				table.insert(var0_21, iter5_21)
			end
		elseif iter1_21.type == "BattleCardPuzzleSkillAddBuff" then
			local var3_21 = var3_0.GetResFromBuff(iter1_21.arg_list.buff_id, 1, {})

			for iter6_21, iter7_21 in ipairs(var3_21) do
				table.insert(var0_21, iter7_21)
			end
		end
	end

	return var0_21
end

function var3_0.NeedSkillPainting(arg0_22)
	local var0_22 = false

	if var3_0.GetSkillTemplate(arg0_22).focus_duration then
		var0_22 = true
	end

	return var0_22
end

function var3_0.SkinAdaptFXID(arg0_23, arg1_23)
	return arg0_23 .. "_" .. arg1_23
end

function var3_0.GetFleetReload(arg0_24)
	return var2_0.GetFleetReload(arg0_24)
end

function var3_0.GetFleetTorpedoPower(arg0_25)
	return var2_0.GetFleetTorpedoPower(arg0_25)
end

function var3_0.SortFleetList(arg0_26, arg1_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in ipairs(arg0_26) do
		var0_26[#var0_26 + 1] = arg1_26[iter1_26]

		var0_26[iter0_26]:SetFormationIndex(iter0_26)
	end

	return var0_26
end

function var3_0.GetLimitAttributeRange(arg0_27, arg1_27)
	if pg.battle_attribute_range[arg0_27] then
		return math.clamp(arg1_27, pg.battle_attribute_range[arg0_27].min / 10000, pg.battle_attribute_range[arg0_27].max / 10000)
	end

	return arg1_27
end

function var3_0.GetPuzzleCardDataTemplate(arg0_28)
	assert(var4_0[arg0_28] ~= nil, ">>puzzle_card_template<< 找不到卡牌配置：" .. arg0_28)

	return var4_0[arg0_28]
end

function var3_0.GetPuzzleShipDataTemplate(arg0_29)
	assert(var5_0[arg0_29] ~= nil, ">>puzzle_ship_template<< 找不到卡牌舰船配置：" .. arg0_29)

	return var5_0[arg0_29]
end

function var3_0.GetPuzzleDungeonTemplate(arg0_30)
	assert(var6_0[arg0_30] ~= nil, ">>puzzle_combat_template<< 找不到卡牌关卡配置：" .. arg0_30)

	return var6_0[arg0_30]
end

function var3_0.GetPuzzleCardAffixDataTemplate(arg0_31)
	assert(var7_0[arg0_31] ~= nil, ">>puzzle_card_affix<< 找不到卡牌关卡配置：" .. arg0_31)

	return var7_0[arg0_31]
end
