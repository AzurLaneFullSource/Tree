ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = pg.ship_data_statistics
local var5_0 = pg.ship_data_template
local var6_0 = pg.ship_skin_template
local var7_0 = pg.enemy_data_statistics
local var8_0 = pg.weapon_property
local var9_0 = pg.formation_template
local var10_0 = pg.auto_pilot_template
local var11_0 = pg.aircraft_template
local var12_0 = pg.ship_skin_words
local var13_0 = pg.equip_data_statistics
local var14_0 = pg.equip_data_template
local var15_0 = pg.spweapon_data_statistics
local var16_0 = pg.enemy_data_skill
local var17_0 = pg.ship_data_personality
local var18_0 = pg.enemy_data_by_type
local var19_0 = pg.ship_data_by_type
local var20_0 = pg.ship_level
local var21_0 = pg.skill_data_template
local var22_0 = pg.ship_data_trans
local var23_0 = pg.battle_environment_behaviour_template
local var24_0 = pg.equip_skin_template
local var25_0 = pg.activity_template
local var26_0 = pg.activity_event_worldboss
local var27_0 = pg.world_joint_boss_template
local var28_0 = pg.world_boss_level
local var29_0 = pg.guild_boss_event
local var30_0 = pg.ship_strengthen_meta
local var31_0 = pg.map_data
local var32_0 = pg.strategy_data_template

var0_0.Battle.BattleDataFunction = var0_0.Battle.BattleDataFunction or {}

local var33_0 = var0_0.Battle.BattleDataFunction

function var33_0.CreateBattleUnitData(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1, arg7_1, arg8_1, arg9_1, arg10_1, arg11_1, arg12_1)
	local var0_1
	local var1_1

	if arg1_1 == var1_0.UnitType.PLAYER_UNIT then
		var0_1 = var0_0.Battle.BattlePlayerUnit.New(arg0_1, arg2_1)

		var0_1:SetSkinId(arg4_1)
		var0_1:SetWeaponInfo(arg9_1, arg10_1)

		var1_1 = Ship.WEAPON_COUNT
	elseif arg1_1 == var1_0.UnitType.SUB_UNIT then
		var0_1 = var0_0.Battle.BattleSubUnit.New(arg0_1, arg2_1)

		var0_1:SetSkinId(arg4_1)
		var0_1:SetWeaponInfo(arg9_1, arg10_1)

		var1_1 = Ship.WEAPON_COUNT
	elseif arg1_1 == var1_0.UnitType.ENEMY_UNIT then
		var0_1 = var0_0.Battle.BattleEnemyUnit.New(arg0_1, arg2_1)

		var0_1:SetOverrideLevel(arg11_1)
	elseif arg1_1 == var1_0.UnitType.MINION_UNIT then
		var0_1 = var0_0.Battle.BattleMinionUnit.New(arg0_1, arg2_1)
	elseif arg1_1 == var1_0.UnitType.BOSS_UNIT then
		var0_1 = var0_0.Battle.BattleBossUnit.New(arg0_1, arg2_1)

		var0_1:SetOverrideLevel(arg11_1)
	elseif arg1_1 == var1_0.UnitType.CONST_UNIT then
		var0_1 = var0_0.Battle.BattleConstPlayerUnit.New(arg0_1, arg2_1)

		var0_1:SetSkinId(arg4_1)
		var0_1:SetWeaponInfo(arg9_1, arg10_1)

		var1_1 = Ship.WEAPON_COUNT
	elseif arg1_1 == var1_0.UnitType.CARDPUZZLE_PLAYER_UNIT then
		var0_1 = var0_0.Battle.BattleCardPuzzlePlayerUnit.New(arg0_1, arg2_1)

		var0_1:SetSkinId(arg4_1)
		var0_1:SetWeaponInfo(arg9_1, arg10_1)
	elseif arg1_1 == var1_0.UnitType.SUPPORT_UNIT then
		var0_1 = var0_0.Battle.BattleSupportUnit.New(arg0_1, arg2_1)

		var0_1:SetSkinId(arg4_1)
		var0_1:SetWeaponInfo(arg9_1, arg10_1)
	end

	var0_1:SetTemplate(arg3_1, arg6_1, arg7_1)

	if arg1_1 == var1_0.UnitType.MINION_UNIT then
		var0_1:SetMaster(arg12_1)
		var0_1:InheritMasterAttr()
	end

	local var2_1 = {}

	if arg1_1 == var1_0.UnitType.ENEMY_UNIT or arg1_1 == var1_0.UnitType.MINION_UNIT or arg1_1 == var1_0.UnitType.BOSS_UNIT then
		for iter0_1, iter1_1 in ipairs(arg5_1) do
			var2_1[#var2_1 + 1] = {
				equipment = {
					weapon_id = {
						iter1_1.id
					}
				}
			}
		end
	else
		for iter2_1, iter3_1 in ipairs(arg5_1) do
			if not iter3_1.id then
				var2_1[#var2_1 + 1] = {
					equipment = false,
					torpedoAmmo = 0,
					skin = iter3_1.skin
				}
			else
				local var3_1 = iter3_1.equipmentInfo and iter3_1.equipmentInfo:getConfig("torpedo_ammo") or 0

				if not var1_1 or iter2_1 <= var1_1 or #var33_0.GetWeaponDataFromID(iter3_1.id).weapon_id then
					local var4_1 = var33_0.GetWeaponDataFromID(iter3_1.id)

					var2_1[#var2_1 + 1] = {
						equipment = var4_1,
						skin = iter3_1.skin,
						torpedoAmmo = var3_1
					}
				else
					var2_1[#var2_1 + 1] = {
						equipment = false,
						skin = iter3_1.skin,
						torpedoAmmo = var3_1
					}
				end
			end
		end
	end

	var0_1:SetProficiencyList(arg8_1)
	var0_1:SetEquipment(var2_1)

	return var0_1
end

function var33_0.InitUnitSkill(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.skills or {}

	for iter0_2, iter1_2 in pairs(var0_2) do
		local var1_2 = var0_0.Battle.BattleBuffUnit.New(iter1_2.id, iter1_2.level, arg1_2)

		arg1_2:AddBuff(var1_2)
	end
end

function var33_0.GetEquipSkill(arg0_3, arg1_3)
	local var0_3 = Ship.WEAPON_COUNT
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		local var2_3 = iter1_3.id

		if var2_3 then
			local var3_3
			local var4_3 = var33_0.GetWeaponDataFromID(var2_3)

			if var4_3 then
				for iter2_3, iter3_3 in ipairs(var4_3.skill_id) do
					iter3_3 = arg1_3 and var33_0.SkillTranform(arg1_3, iter3_3) or iter3_3

					table.insert(var1_3, iter3_3)
				end

				for iter4_3, iter5_3 in ipairs(var4_3.hidden_skill_id) do
					iter5_3 = arg1_3 and var33_0.SkillTranform(arg1_3, iter5_3) or iter5_3

					table.insert(var1_3, iter5_3)
				end
			end
		end
	end

	return var1_3
end

function var33_0.AttachWeather(arg0_4, arg1_4)
	if table.contains(arg1_4, var1_0.WEATHER.NIGHT) then
		local var0_4 = arg0_4:GetTemplate().type

		if arg0_4:GetFleetVO() then
			local var1_4 = arg0_4:GetFleetVO()

			if table.contains(TeamType.VanguardShipType, var0_4) then
				local var2_4 = var1_4:GetFleetBias()
				local var3_4 = var2_4:GetCrewCount() + 1

				var2_4:ConfigMinRange(var2_0.AIM_BIAS_MIN_RANGE_SCOUT[var3_4])
				var2_4:AppendCrew(arg0_4)
			elseif table.contains(TeamType.MainShipType, var0_4) then
				var1_4:AttachCloak(arg0_4)
			elseif table.contains(TeamType.SubShipType, var0_4) then
				local var4_4 = var0_0.Battle.BattleUnitAimBiasComponent.New()

				var4_4:ConfigRangeFormula(var0_0.Battle.BattleFormulas.CalculateMaxAimBiasRangeSub, var0_0.Battle.BattleFormulas.CalculateBiasDecay)
				var4_4:ConfigMinRange(var2_0.AIM_BIAS_MIN_RANGE_SUB)
				var4_4:AppendCrew(arg0_4)
				var4_4:Active(var4_4.STATE_ACTIVITING)
			end
		elseif arg0_4:GetUnitType() == var1_0.UnitType.ENEMY_UNIT or arg0_4:GetUnitType() == var1_0.UnitType.MINION_UNIT or arg0_4:GetUnitType() == var1_0.UnitType.BOSS_UNIT then
			local var5_4 = var0_0.Battle.BattleUnitAimBiasComponent.New()

			var5_4:ConfigRangeFormula(var0_0.Battle.BattleFormulas.CalculateMaxAimBiasRangeMonster, var0_0.Battle.BattleFormulas.CalculateBiasDecayMonster)

			if table.contains(TeamType.SubShipType, var0_4) then
				var5_4:ConfigMinRange(var2_0.AIM_BIAS_MIN_RANGE_SUB)
			else
				var5_4:ConfigMinRange(var2_0.AIM_BIAS_MIN_RANGE_MONSTER)
			end

			var5_4:AppendCrew(arg0_4)
			var5_4:SetHostile()
			var5_4:Active(var5_4.STATE_SUMMON_SICKNESS)
		end
	end
end

function var33_0.AttachSmoke(arg0_5)
	local var0_5 = arg0_5:GetUnitType()

	if var0_5 == var1_0.UnitType.ENEMY_UNIT or var0_5 == var1_0.UnitType.BOSS_UNIT then
		if arg0_5:GetAimBias() then
			local var1_5 = arg0_5:GetAimBias()
			local var2_5 = var1_5:GetCurrentState()

			if var2_5 == var1_5.STATE_SKILL_EXPOSE then
				var1_5:SomkeExitResume()
			elseif var2_5 == var1_5.STATE_ACTIVITING or var2_5 == var1_5.STATE_TOTAL_EXPOSE then
				var1_5:SmokeRecover()
			end
		else
			local var3_5 = var0_0.Battle.BattleUnitAimBiasComponent.New()

			var3_5:ConfigRangeFormula(var0_0.Battle.BattleFormulas.CalculateMaxAimBiasRangeMonster, var0_0.Battle.BattleFormulas.CalculateBiasDecayMonsterInSmoke)

			if table.contains(TeamType.SubShipType, shipType) then
				var3_5:ConfigMinRange(var2_0.AIM_BIAS_MIN_RANGE_SUB)
			else
				var3_5:ConfigMinRange(var2_0.AIM_BIAS_MIN_RANGE_MONSTER)
			end

			var3_5:AppendCrew(arg0_5)
			var3_5:SetHostile()
			var3_5:Active(var3_5.STATE_ACTIVITING)
		end
	end
end

function var33_0.InitEquipSkill(arg0_6, arg1_6, arg2_6)
	local var0_6 = var33_0.GetEquipSkill(arg0_6, arg2_6)

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var1_6 = var0_0.Battle.BattleBuffUnit.New(iter1_6, 1, arg1_6)

		arg1_6:AddBuff(var1_6)
	end
end

function var33_0.InitCommanderSkill(arg0_7, arg1_7, arg2_7)
	arg0_7 = arg0_7 or {}

	local var0_7 = var0_0.Battle.BattleState.GetInstance():GetBattleType()

	for iter0_7, iter1_7 in pairs(arg0_7) do
		local var1_7 = var0_0.Battle.BattleDataFunction.GetBuffTemplate(iter1_7.id, iter1_7.level).limit
		local var2_7 = false

		if var1_7 then
			for iter2_7, iter3_7 in ipairs(var1_7) do
				if var0_7 == iter3_7 then
					var2_7 = true

					break
				end
			end
		end

		if not var2_7 then
			local var3_7 = var0_0.Battle.BattleBuffUnit.New(iter1_7.id, iter1_7.level, arg1_7)

			var3_7:SetCommander(iter1_7.commander)
			arg1_7:AddBuff(var3_7)
		end
	end
end

function var33_0.CreateWeaponUnit(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	arg3_8 = arg3_8 or -1

	local var0_8 = arg1_8:GetUnitType()
	local var1_8
	local var2_8 = var33_0.GetWeaponPropertyDataFromID(arg0_8)

	assert(var2_8 ~= nil, "找不到武器配置：id = " .. arg0_8)

	local var3_8 = arg4_8 or var2_8.type

	if var3_8 == var1_0.EquipmentType.MAIN_CANNON then
		var1_8 = var0_0.Battle.BattleWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.SUB_CANNON then
		var1_8 = var0_0.Battle.BattleWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.TORPEDO then
		var1_8 = var0_0.Battle.BattleTorpedoUnit.New()
	elseif var3_8 == var1_0.EquipmentType.MANUAL_TORPEDO then
		var1_8 = var0_0.Battle.BattleManualTorpedoUnit.New()
	elseif var3_8 == var1_0.EquipmentType.ANTI_AIR then
		var1_8 = var0_0.Battle.BattleAntiAirUnit.New()
	elseif var3_8 == var1_0.EquipmentType.FLEET_ANTI_AIR or var3_8 == var1_0.EquipmentType.FLEET_RANGE_ANTI_AIR then
		var1_8 = var0_0.Battle.BattleWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.INTERCEPT_AIRCRAFT or var3_8 == var1_0.EquipmentType.STRIKE_AIRCRAFT then
		if var0_8 == var1_0.UnitType.SUPPORT_UNIT then
			var1_8 = var0_0.Battle.BattleSupportHiveUnit.New()
		else
			var1_8 = var0_0.Battle.BattleHiveUnit.New()
		end
	elseif var3_8 == var1_0.EquipmentType.SPECIAL then
		var1_8 = var0_0.Battle.BattleSpecialWeapon.New()
	elseif var3_8 == var1_0.EquipmentType.ANTI_SEA then
		var1_8 = var0_0.Battle.BattleDirectHitWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.HAMMER_HEAD then
		var1_8 = var0_0.Battle.BattleHammerHeadWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.BOMBER_PRE_CAST_ALERT then
		var1_8 = var0_0.Battle.BattleBombWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.POINT_HIT_AND_LOCK or var3_8 == var1_0.EquipmentType.MANUAL_MISSILE or var3_8 == var1_0.EquipmentType.MANUAL_METEOR then
		var1_8 = var0_0.Battle.BattlePointHitWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.BEAM then
		var1_8 = var0_0.Battle.BattleLaserUnit.New()
	elseif var3_8 == var1_0.EquipmentType.DEPTH_CHARGE then
		var1_8 = var0_0.Battle.BattleDepthChargeUnit.New()
	elseif var3_8 == var1_0.EquipmentType.REPEATER_ANTI_AIR then
		var1_8 = var0_0.Battle.BattleRepeaterAntiAirUnit.New()
	elseif var3_8 == var1_0.EquipmentType.DISPOSABLE_TORPEDO then
		var1_8 = var0_0.Battle.BattleDisposableTorpedoUnit.New()
	elseif var3_8 == var1_0.EquipmentType.SPACE_LASER then
		var1_8 = var0_0.Battle.BattleSpaceLaserWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.MISSILE then
		var1_8 = var0_0.Battle.BattleMissileWeaponUnit.New()
	elseif var3_8 == var1_0.EquipmentType.MANUAL_AAMISSILE then
		var1_8 = var0_0.Battle.BattleManualAAMissileUnit.New()
	elseif var3_8 == var1_0.EquipmentType.AUTO_MISSILE then
		var1_8 = var0_0.Battle.BattleAutoMissileUnit.New()
	end

	assert(var1_8 ~= nil, "创建武器失败，不存在该类型的武器：id = " .. arg0_8)
	var1_8:SetPotentialFactor(arg2_8)
	var1_8:SetEquipmentIndex(arg3_8)
	var1_8:SetTemplateData(var2_8)
	var1_8:SetHostData(arg1_8)

	if var0_8 == var1_0.UnitType.PLAYER_UNIT then
		if var2_8.auto_aftercast > 0 then
			var1_8:OverrideGCD(var2_8.auto_aftercast)
		end
	elseif var0_8 == var1_0.UnitType.ENEMY_UNIT or var1_0.UnitType.BOSS_UNIT then
		var1_8:HostOnEnemy()
	end

	if var2_8.type == var1_0.EquipmentType.INTERCEPT_AIRCRAFT or var2_8.type == var1_0.EquipmentType.STRIKE_AIRCRAFT then
		var1_8:EnterCoolDown()
	end

	return var1_8
end

function var33_0.CreateAircraftUnit(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9
	local var1_9 = var33_0.GetAircraftTmpDataFromID(arg1_9)

	assert(var1_9 ~= nil, "找不到飞机配置：id = " .. arg1_9)

	if type(var1_9.funnel_behavior) == "table" then
		if var1_9.funnel_behavior.hover_range then
			var0_9 = var0_0.Battle.BattelUAVUnit.New(arg0_9)
		elseif var1_9.funnel_behavior.AI then
			var0_9 = var0_0.Battle.BattlePatternFunnelUnit.New(arg0_9)
		else
			var0_9 = var0_0.Battle.BattleFunnelUnit.New(arg0_9)
		end
	else
		var0_9 = var0_0.Battle.BattleAircraftUnit.New(arg0_9)
	end

	var0_9:SetMotherUnit(arg2_9)
	var0_9:SetWeanponPotential(arg3_9)
	var0_9:SetTemplate(var1_9)

	return var0_9
end

function var33_0.CreateAllInStrike(arg0_10)
	local var0_10 = arg0_10:GetTemplateID()
	local var1_10 = var33_0.GetPlayerShipModelFromID(var0_10)
	local var2_10 = 0
	local var3_10 = {}

	for iter0_10, iter1_10 in ipairs(var1_10.airassist_time) do
		local var4_10 = var0_0.Battle.BattleAllInStrike.New(iter1_10)

		var4_10:SetHost(arg0_10)

		var3_10[iter0_10] = var4_10
	end

	return var3_10
end

function var33_0.ExpandAllinStrike(arg0_11)
	local var0_11 = arg0_11:GetTemplateID()
	local var1_11 = var33_0.GetPlayerShipModelFromID(var0_11).airassist_time

	if #var1_11 > 0 then
		local var2_11 = var1_11[#var1_11]
		local var3_11 = var0_0.Battle.BattleAllInStrike.New(var2_11)

		var3_11:SetHost(arg0_11)
		arg0_11:GetFleetVO():GetAirAssistVO():AppendWeapon(var3_11)
		var3_11:OverHeat()
		arg0_11:GetAirAssistQueue():AppendWeapon(var3_11)

		local var4_11 = arg0_11:GetAirAssistList()

		var4_11[#var4_11 + 1] = var3_11
	end
end

function var33_0.CreateAirFighterUnit(arg0_12, arg1_12)
	local var0_12
	local var1_12 = var33_0.GetAircraftTmpDataFromID(arg1_12.templateID)
	local var2_12 = var0_0.Battle.BattleAirFighterUnit.New(arg0_12)

	var2_12:SetWeaponTemplateID(arg1_12.weaponID)
	var2_12:SetBackwardWeaponID(arg1_12.backwardWeaponID)
	var2_12:SetTemplate(var1_12)

	return var2_12
end

function var33_0.GetPlayerShipTmpDataFromID(arg0_13)
	assert(var4_0[arg0_13] ~= nil, ">>ship_data_statistics<< 找不到玩家船只配置：id = " .. arg0_13)

	return Clone(var4_0[arg0_13])
end

function var33_0.GetPlayerShipModelFromID(arg0_14)
	assert(var5_0[arg0_14] ~= nil, ">>ship_data_template<< 找不到玩家船只模组配置：id = " .. arg0_14)

	return var5_0[arg0_14]
end

function var33_0.GetPlayerShipSkinDataFromID(arg0_15)
	assert(var6_0[arg0_15] ~= nil, ">>ship_skin_template<< 找不到舰娘皮肤配置：id = " .. arg0_15)

	return var6_0[arg0_15]
end

function var33_0.GetShipTypeTmp(arg0_16)
	assert(var19_0[arg0_16] ~= nil, ">>ship_data_by_type<< 找不到舰船类型配置：id = " .. arg0_16)

	return var19_0[arg0_16]
end

function var33_0.GetMonsterTmpDataFromID(arg0_17)
	assert(var7_0[arg0_17] ~= nil, ">>enemy_data_statistics<< 找不到敌方船只配置：id = " .. arg0_17)

	return var7_0[arg0_17]
end

function var33_0.GetAircraftTmpDataFromID(arg0_18)
	assert(var11_0[arg0_18] ~= nil, ">>aircraft_template<< 找不到飞机配置：id = " .. arg0_18)

	return var11_0[arg0_18]
end

function var33_0.GetWeaponDataFromID(arg0_19)
	if arg0_19 ~= Equipment.EQUIPMENT_STATE_EMPTY and arg0_19 ~= Equipment.EQUIPMENT_STATE_LOCK then
		assert(var13_0[arg0_19] ~= nil, ">>equip_data_statistics<< 找不到武器类装备配置：id = " .. arg0_19)
	end

	return var13_0[arg0_19]
end

function var33_0.GetEquipDataTemplate(arg0_20)
	assert(var14_0[arg0_20] ~= nil, ">>equip_data_template<< 找不到武器装备模板：id = " .. arg0_20)

	return var14_0[arg0_20]
end

function var33_0.GetSpWeaponDataFromID(arg0_21)
	assert(var15_0[arg0_21] ~= nil, ">>spweapon_data_statistics<< 找不到特殊兵装配置：id = " .. arg0_21)

	return var15_0[arg0_21]
end

function var33_0.GetWeaponPropertyDataFromID(arg0_22)
	assert(var8_0[arg0_22] ~= nil, ">>weapon_property<< 找不到武器行为配置：id = " .. arg0_22)

	return var8_0[arg0_22]
end

function var33_0.GetFormationTmpDataFromID(arg0_23)
	assert(var9_0[arg0_23] ~= nil, ">>formation_template<<找不到阵型配置：id = " .. arg0_23)

	return var9_0[arg0_23]
end

function var33_0.GetAITmpDataFromID(arg0_24)
	assert(var10_0[arg0_24] ~= nil, ">>auto_pilot_template<< 找不到移动ai配置：id = " .. arg0_24)

	return var10_0[arg0_24]
end

function var33_0.GetShipPersonality(arg0_25)
	assert(var17_0[arg0_25] ~= nil, ">>shipPersonality<< 找不到性格配置：id = " .. arg0_25)

	return var17_0[arg0_25]
end

function var33_0.GetEnemyTypeDataByType(arg0_26)
	assert(var18_0[arg0_26] ~= nil, ">>enemy_data_by_type<< 找不到怪物类型：type = " .. arg0_26)

	return var18_0[arg0_26]
end

function var33_0.GetArenaBuffByShipType(arg0_27)
	return var33_0.GetShipTypeTmp(arg0_27).arena_buff
end

function var33_0.GetPlayerUnitDurabilityExtraAddition(arg0_28, arg1_28)
	if arg0_28 == SYSTEM_DUEL then
		assert(var20_0[arg1_28] ~= nil, ">>ship_level<< 找不到等级配置：level = " .. arg1_28)

		return var20_0[arg1_28].arena_durability_ratio, var20_0[arg1_28].arena_durability_add
	else
		return 1, 0
	end
end

function var33_0.GetSkillDataTemplate(arg0_29)
	assert(var21_0[arg0_29] ~= nil, ">>skill_data_template<< 找不到技能配置：id = " .. arg0_29)

	return var21_0[arg0_29]
end

function var33_0.GetShipTransformDataTemplate(arg0_30)
	local var0_30 = var33_0.GetPlayerShipModelFromID(arg0_30)

	return var22_0[var0_30.group_type]
end

function var33_0.GetShipMetaFromDataTemplate(arg0_31)
	local var0_31 = var33_0.GetPlayerShipModelFromID(arg0_31)

	return var30_0[var0_31.group_type]
end

function var33_0.GetEquipSkinDataFromID(arg0_32)
	assert(var24_0[arg0_32] ~= nil, ">>equip_skin_template<< 找不到装备皮肤配置：id = " .. arg0_32)

	return var24_0[arg0_32]
end

function var33_0.GetEquipSkin(arg0_33)
	assert(var24_0[arg0_33] ~= nil, ">>equip_skin_template<< 找不到装备皮肤配置：id = " .. arg0_33)

	local var0_33 = var24_0[arg0_33]

	return var0_33.bullet_name, var0_33.derivate_bullet, var0_33.derivate_torpedo, var0_33.derivate_boom, var0_33.fire_fx_name, var0_33.hit_fx_name
end

function var33_0.GetEquipSkinSFX(arg0_34)
	assert(var24_0[arg0_34] ~= nil, ">>equip_skin_template<< 找不到装备皮肤配置：id = " .. arg0_34)

	local var0_34 = var24_0[arg0_34]

	return var0_34.hit_sfx, var0_34.miss_sfx
end

function var33_0.GetSpecificGuildBossEnemyList(arg0_35, arg1_35)
	local var0_35 = var29_0[arg0_35].expedition_id
	local var1_35 = {}

	if var0_35[1] == arg1_35 then
		var1_35 = var0_35[2]
	end

	return var1_35
end

function var33_0.GetSpecificEnemyList(arg0_36, arg1_36)
	local var0_36 = var25_0[arg0_36]
	local var1_36 = var26_0[var0_36.config_id].ex_expedition_enemy
	local var2_36

	for iter0_36, iter1_36 in ipairs(var1_36) do
		if iter1_36[1] == arg1_36 then
			var2_36 = iter1_36[2]

			break
		end
	end

	return var2_36
end

function var33_0.GetMetaBossTemplate(arg0_37)
	return var27_0[arg0_37]
end

function var33_0.GetMetaBossLevelTemplate(arg0_38, arg1_38)
	local var0_38 = var33_0.GetMetaBossTemplate(arg0_38).boss_level_id + (arg1_38 - 1)

	return var28_0[var0_38]
end

function var33_0.GetSpecificWorldJointEnemyList(arg0_39, arg1_39, arg2_39)
	local var0_39 = var33_0.GetMetaBossLevelTemplate(arg1_39, arg2_39)

	return {
		var0_39.enemy_id
	}
end

function var33_0.IncreaseAttributes(arg0_40, arg1_40, arg2_40)
	for iter0_40, iter1_40 in ipairs(arg2_40) do
		if iter1_40[arg1_40] ~= nil and type(iter1_40[arg1_40]) == "number" then
			arg0_40 = arg0_40 + iter1_40[arg1_40]
		end
	end
end

function var33_0.CreateAirFighterWeaponUnit(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41
	local var1_41 = var33_0.GetWeaponPropertyDataFromID(arg0_41)

	assert(var1_41 ~= nil, "找不到武器配置：id = " .. arg0_41)

	if var1_41.type == var1_0.EquipmentType.MAIN_CANNON then
		var0_41 = var0_0.Battle.BattleWeaponUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.SUB_CANNON then
		var0_41 = var0_0.Battle.BattleWeaponUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.TORPEDO then
		var0_41 = var0_0.Battle.BattleTorpedoUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.ANTI_AIR then
		var0_41 = var0_0.Battle.BattleAntiAirUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.ANTI_SEA then
		var0_41 = var0_0.Battle.BattleDirectHitWeaponUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.HAMMER_HEAD then
		var0_41 = var0_0.Battle.BattleHammerHeadWeaponUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.BOMBER_PRE_CAST_ALERT then
		var0_41 = var0_0.Battle.BattleBombWeaponUnit.New()
	elseif var1_41.type == var1_0.EquipmentType.DEPTH_CHARGE then
		var0_41 = var0_0.Battle.BattleDepthChargeUnit.New()
	end

	assert(var0_41 ~= nil, "创建武器失败，不存在该类型的武器：id = " .. arg0_41)
	var0_41:SetPotentialFactor(arg3_41)

	local var2_41 = Clone(var1_41)

	var2_41.spawn_bound = "weapon"

	var0_41:SetTemplateData(var2_41)
	var0_41:SetHostData(arg1_41, arg2_41)

	return var0_41
end

function var33_0.GetWords(arg0_42, arg1_42, arg2_42)
	local var0_42, var1_42, var2_42 = ShipWordHelper.GetWordAndCV(arg0_42, arg1_42, 1, true, arg2_42)

	return var2_42
end

function var33_0.SkillTranform(arg0_43, arg1_43)
	local var0_43 = var33_0.GetSkillDataTemplate(arg1_43).system_transform

	if var0_43[arg0_43] == nil then
		return arg1_43
	else
		return var0_43[arg0_43]
	end
end

function var33_0.GenerateHiddenBuff(arg0_44)
	local var0_44 = var33_0.GetPlayerShipModelFromID(arg0_44).hide_buff_list
	local var1_44 = {}

	for iter0_44, iter1_44 in ipairs(var0_44) do
		local var2_44 = {}

		var2_44.level = 1
		var2_44.id = iter1_44
		var1_44[iter1_44] = var2_44
	end

	return var1_44
end

function var33_0.GetDivingFilter(arg0_45)
	return var31_0[arg0_45].diving_filter
end

function var33_0.GeneratePlayerSubmarinPhase(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
	local var0_46 = arg0_46 - arg2_46

	return {
		{
			index = 0,
			switchType = 3,
			switchTo = 1,
			switchParam = var0_46
		},
		{
			switchParam = 0,
			dive = "STATE_RAID",
			switchTo = 2,
			index = 1,
			switchType = 5
		},
		{
			index = 2,
			switchType = 1,
			switchTo = 3,
			dive = "STATE_FLOAT",
			switchParam = arg4_46
		},
		{
			index = 3,
			switchType = 4,
			switchTo = 4,
			dive = "STATE_RETREAT",
			switchParam = arg1_46
		},
		{
			index = 4,
			retreat = true
		}
	}
end

function var33_0.GetEnvironmentBehaviour(arg0_47)
	assert(var23_0[arg0_47] ~= nil, ">>battle_environment_behaviour_template<< 找不到环境行为配置：id = " .. arg0_47)

	return var23_0[arg0_47]
end

function var33_0.AttachUltimateBonus(arg0_48)
	local var0_48 = arg0_48:GetTemplateID()

	if not Ship.IsMaxStarByTmpID(var0_48) then
		return
	end

	local var1_48 = var33_0.GetPlayerShipModelFromID(var0_48).specific_type

	for iter0_48, iter1_48 in ipairs(var1_48) do
		if iter1_48 == ShipType.SpecificTypeTable.gunner then
			var3_0.SetCurrent(arg0_48, "barrageCounterMod", var1_0.UltimateBonus.GunnerCountMod)
		elseif iter1_48 == ShipType.SpecificTypeTable.torpedo then
			local var2_48 = var0_0.Battle.BattleBuffUnit.New(var1_0.UltimateBonus.TorpedoBarrageBuff)

			arg0_48:AddBuff(var2_48)
		elseif iter1_48 == ShipType.SpecificTypeTable.auxiliary then
			var33_0.AuxBoost(arg0_48)
		end
	end
end

function var33_0.AuxBoost(arg0_49)
	local var0_49 = arg0_49:GetEquipment()

	for iter0_49, iter1_49 in ipairs(var0_49) do
		if iter1_49 and iter1_49.equipment and table.contains(EquipType.DeviceEquipTypes, iter1_49.equipment.type) then
			local var1_49 = iter1_49.equipment

			for iter2_49 = 1, 3 do
				local var2_49 = "attribute_" .. iter2_49

				if var1_49[var2_49] then
					local var3_49 = var1_49["value_" .. iter2_49]
					local var4_49 = AttributeType.ConvertBattleAttrName(var1_49[var2_49])
					local var5_49 = var3_0.GetBase(arg0_49, var4_49) + var3_49 * var1_0.UltimateBonus.AuxBoostValue

					var3_0.SetCurrent(arg0_49, var4_49, var5_49)
					var3_0.SetBaseAttr(arg0_49)
				end
			end
		end
	end
end

function var33_0.GetSLGStrategyBuffByCombatBuffID(arg0_50)
	for iter0_50, iter1_50 in pairs(var32_0) do
		if iter1_50.buff_id == arg0_50 then
			return iter1_50
		end
	end
end
