ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleAttr
local var4 = pg.ship_data_statistics
local var5 = pg.ship_data_template
local var6 = pg.ship_skin_template
local var7 = pg.enemy_data_statistics
local var8 = pg.weapon_property
local var9 = pg.formation_template
local var10 = pg.auto_pilot_template
local var11 = pg.aircraft_template
local var12 = pg.ship_skin_words
local var13 = pg.equip_data_statistics
local var14 = pg.equip_data_template
local var15 = pg.spweapon_data_statistics
local var16 = pg.enemy_data_skill
local var17 = pg.ship_data_personality
local var18 = pg.enemy_data_by_type
local var19 = pg.ship_data_by_type
local var20 = pg.ship_level
local var21 = pg.skill_data_template
local var22 = pg.ship_data_trans
local var23 = pg.battle_environment_behaviour_template
local var24 = pg.equip_skin_template
local var25 = pg.activity_template
local var26 = pg.activity_event_worldboss
local var27 = pg.world_joint_boss_template
local var28 = pg.world_boss_level
local var29 = pg.guild_boss_event
local var30 = pg.ship_strengthen_meta
local var31 = pg.map_data
local var32 = pg.strategy_data_template

var0.Battle.BattleDataFunction = var0.Battle.BattleDataFunction or {}

local var33 = var0.Battle.BattleDataFunction

function var33.CreateBattleUnitData(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
	local var0
	local var1

	if arg1 == var1.UnitType.PLAYER_UNIT then
		var0 = var0.Battle.BattlePlayerUnit.New(arg0, arg2)

		var0:SetSkinId(arg4)
		var0:SetWeaponInfo(arg9, arg10)

		var1 = Ship.WEAPON_COUNT
	elseif arg1 == var1.UnitType.SUB_UNIT then
		var0 = var0.Battle.BattleSubUnit.New(arg0, arg2)

		var0:SetSkinId(arg4)
		var0:SetWeaponInfo(arg9, arg10)

		var1 = Ship.WEAPON_COUNT
	elseif arg1 == var1.UnitType.ENEMY_UNIT then
		var0 = var0.Battle.BattleEnemyUnit.New(arg0, arg2)

		var0:SetOverrideLevel(arg11)
	elseif arg1 == var1.UnitType.MINION_UNIT then
		var0 = var0.Battle.BattleMinionUnit.New(arg0, arg2)
	elseif arg1 == var1.UnitType.BOSS_UNIT then
		var0 = var0.Battle.BattleBossUnit.New(arg0, arg2)

		var0:SetOverrideLevel(arg11)
	elseif arg1 == var1.UnitType.CONST_UNIT then
		var0 = var0.Battle.BattleConstPlayerUnit.New(arg0, arg2)

		var0:SetSkinId(arg4)
		var0:SetWeaponInfo(arg9, arg10)

		var1 = Ship.WEAPON_COUNT
	elseif arg1 == var1.UnitType.CARDPUZZLE_PLAYER_UNIT then
		var0 = var0.Battle.BattleCardPuzzlePlayerUnit.New(arg0, arg2)

		var0:SetSkinId(arg4)
		var0:SetWeaponInfo(arg9, arg10)
	elseif arg1 == var1.UnitType.SUPPORT_UNIT then
		var0 = var0.Battle.BattleSupportUnit.New(arg0, arg2)

		var0:SetSkinId(arg4)
		var0:SetWeaponInfo(arg9, arg10)
	end

	var0:SetTemplate(arg3, arg6, arg7)

	local var2 = {}

	if arg1 == var1.UnitType.ENEMY_UNIT or arg1 == var1.UnitType.MINION_UNIT or arg1 == var1.UnitType.BOSS_UNIT then
		for iter0, iter1 in ipairs(arg5) do
			var2[#var2 + 1] = {
				equipment = {
					weapon_id = {
						iter1.id
					}
				}
			}
		end
	else
		for iter2, iter3 in ipairs(arg5) do
			if not iter3.id then
				var2[#var2 + 1] = {
					equipment = false,
					torpedoAmmo = 0,
					skin = iter3.skin
				}
			else
				local var3 = iter3.equipmentInfo and iter3.equipmentInfo:getConfig("torpedo_ammo") or 0

				if not var1 or iter2 <= var1 or #var33.GetWeaponDataFromID(iter3.id).weapon_id then
					local var4 = var33.GetWeaponDataFromID(iter3.id)

					var2[#var2 + 1] = {
						equipment = var4,
						skin = iter3.skin,
						torpedoAmmo = var3
					}
				else
					var2[#var2 + 1] = {
						equipment = false,
						skin = iter3.skin,
						torpedoAmmo = var3
					}
				end
			end
		end
	end

	var0:SetProficiencyList(arg8)
	var0:SetEquipment(var2)

	return var0
end

function var33.InitUnitSkill(arg0, arg1, arg2)
	local var0 = arg0.skills or {}

	for iter0, iter1 in pairs(var0) do
		local var1 = var0.Battle.BattleBuffUnit.New(iter1.id, iter1.level, arg1)

		arg1:AddBuff(var1)
	end
end

function var33.GetEquipSkill(arg0, arg1)
	local var0 = Ship.WEAPON_COUNT
	local var1 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var2 = iter1.id

		if var2 then
			local var3
			local var4 = var33.GetWeaponDataFromID(var2)

			if var4 then
				for iter2, iter3 in ipairs(var4.skill_id) do
					iter3 = arg1 and var33.SkillTranform(arg1, iter3) or iter3

					table.insert(var1, iter3)
				end

				for iter4, iter5 in ipairs(var4.hidden_skill_id) do
					iter5 = arg1 and var33.SkillTranform(arg1, iter5) or iter5

					table.insert(var1, iter5)
				end
			end
		end
	end

	return var1
end

function var33.AttachWeather(arg0, arg1)
	if table.contains(arg1, var1.WEATHER.NIGHT) then
		local var0 = arg0:GetTemplate().type

		if arg0:GetFleetVO() then
			local var1 = arg0:GetFleetVO()

			if table.contains(TeamType.VanguardShipType, var0) then
				local var2 = var1:GetFleetBias()
				local var3 = var2:GetCrewCount() + 1

				var2:ConfigMinRange(var2.AIM_BIAS_MIN_RANGE_SCOUT[var3])
				var2:AppendCrew(arg0)
			elseif table.contains(TeamType.MainShipType, var0) then
				var1:AttachCloak(arg0)
			elseif table.contains(TeamType.SubShipType, var0) then
				local var4 = var0.Battle.BattleUnitAimBiasComponent.New()

				var4:ConfigRangeFormula(var0.Battle.BattleFormulas.CalculateMaxAimBiasRangeSub, var0.Battle.BattleFormulas.CalculateBiasDecay)
				var4:ConfigMinRange(var2.AIM_BIAS_MIN_RANGE_SUB)
				var4:AppendCrew(arg0)
				var4:Active(var4.STATE_ACTIVITING)
			end
		elseif arg0:GetUnitType() == var1.UnitType.ENEMY_UNIT or arg0:GetUnitType() == var1.UnitType.MINION_UNIT or arg0:GetUnitType() == var1.UnitType.BOSS_UNIT then
			local var5 = var0.Battle.BattleUnitAimBiasComponent.New()

			var5:ConfigRangeFormula(var0.Battle.BattleFormulas.CalculateMaxAimBiasRangeMonster, var0.Battle.BattleFormulas.CalculateBiasDecayMonster)

			if table.contains(TeamType.SubShipType, var0) then
				var5:ConfigMinRange(var2.AIM_BIAS_MIN_RANGE_SUB)
			else
				var5:ConfigMinRange(var2.AIM_BIAS_MIN_RANGE_MONSTER)
			end

			var5:AppendCrew(arg0)
			var5:SetHostile()
			var5:Active(var5.STATE_SUMMON_SICKNESS)
		end
	end
end

function var33.AttachSmoke(arg0)
	local var0 = arg0:GetUnitType()

	if var0 == var1.UnitType.ENEMY_UNIT or var0 == var1.UnitType.BOSS_UNIT then
		if arg0:GetAimBias() then
			local var1 = arg0:GetAimBias()
			local var2 = var1:GetCurrentState()

			if var2 == var1.STATE_SKILL_EXPOSE then
				var1:SomkeExitResume()
			elseif var2 == var1.STATE_ACTIVITING or var2 == var1.STATE_TOTAL_EXPOSE then
				var1:SmokeRecover()
			end
		else
			local var3 = var0.Battle.BattleUnitAimBiasComponent.New()

			var3:ConfigRangeFormula(var0.Battle.BattleFormulas.CalculateMaxAimBiasRangeMonster, var0.Battle.BattleFormulas.CalculateBiasDecayMonsterInSmoke)

			if table.contains(TeamType.SubShipType, shipType) then
				var3:ConfigMinRange(var2.AIM_BIAS_MIN_RANGE_SUB)
			else
				var3:ConfigMinRange(var2.AIM_BIAS_MIN_RANGE_MONSTER)
			end

			var3:AppendCrew(arg0)
			var3:SetHostile()
			var3:Active(var3.STATE_ACTIVITING)
		end
	end
end

function var33.InitEquipSkill(arg0, arg1, arg2)
	local var0 = var33.GetEquipSkill(arg0, arg2)

	for iter0, iter1 in ipairs(var0) do
		local var1 = var0.Battle.BattleBuffUnit.New(iter1, 1, arg1)

		arg1:AddBuff(var1)
	end
end

function var33.InitCommanderSkill(arg0, arg1, arg2)
	arg0 = arg0 or {}

	local var0 = var0.Battle.BattleState.GetInstance():GetBattleType()

	for iter0, iter1 in pairs(arg0) do
		local var1 = var0.Battle.BattleDataFunction.GetBuffTemplate(iter1.id, iter1.level).limit
		local var2 = false

		if var1 then
			for iter2, iter3 in ipairs(var1) do
				if var0 == iter3 then
					var2 = true

					break
				end
			end
		end

		if not var2 then
			local var3 = var0.Battle.BattleBuffUnit.New(iter1.id, iter1.level, arg1)

			var3:SetCommander(iter1.commander)
			arg1:AddBuff(var3)
		end
	end
end

function var33.CreateWeaponUnit(arg0, arg1, arg2, arg3, arg4)
	arg3 = arg3 or -1

	local var0 = arg1:GetUnitType()
	local var1
	local var2 = var33.GetWeaponPropertyDataFromID(arg0)

	assert(var2 ~= nil, "找不到武器配置：id = " .. arg0)

	local var3 = arg4 or var2.type

	if var3 == var1.EquipmentType.MAIN_CANNON then
		var1 = var0.Battle.BattleWeaponUnit.New()
	elseif var3 == var1.EquipmentType.SUB_CANNON then
		var1 = var0.Battle.BattleWeaponUnit.New()
	elseif var3 == var1.EquipmentType.TORPEDO then
		var1 = var0.Battle.BattleTorpedoUnit.New()
	elseif var3 == var1.EquipmentType.MANUAL_TORPEDO then
		var1 = var0.Battle.BattleManualTorpedoUnit.New()
	elseif var3 == var1.EquipmentType.ANTI_AIR then
		var1 = var0.Battle.BattleAntiAirUnit.New()
	elseif var3 == var1.EquipmentType.FLEET_ANTI_AIR or var3 == var1.EquipmentType.FLEET_RANGE_ANTI_AIR then
		var1 = var0.Battle.BattleWeaponUnit.New()
	elseif var3 == var1.EquipmentType.INTERCEPT_AIRCRAFT or var3 == var1.EquipmentType.STRIKE_AIRCRAFT then
		if var0 == var1.UnitType.SUPPORT_UNIT then
			var1 = var0.Battle.BattleSupportHiveUnit.New()
		else
			var1 = var0.Battle.BattleHiveUnit.New()
		end
	elseif var3 == var1.EquipmentType.SPECIAL then
		var1 = var0.Battle.BattleSpecialWeapon.New()
	elseif var3 == var1.EquipmentType.ANTI_SEA then
		var1 = var0.Battle.BattleDirectHitWeaponUnit.New()
	elseif var3 == var1.EquipmentType.HAMMER_HEAD then
		var1 = var0.Battle.BattleHammerHeadWeaponUnit.New()
	elseif var3 == var1.EquipmentType.BOMBER_PRE_CAST_ALERT then
		var1 = var0.Battle.BattleBombWeaponUnit.New()
	elseif var3 == var1.EquipmentType.POINT_HIT_AND_LOCK or var3 == var1.EquipmentType.MANUAL_MISSILE or var3 == var1.EquipmentType.MANUAL_METEOR then
		var1 = var0.Battle.BattlePointHitWeaponUnit.New()
	elseif var3 == var1.EquipmentType.BEAM then
		var1 = var0.Battle.BattleLaserUnit.New()
	elseif var3 == var1.EquipmentType.DEPTH_CHARGE then
		var1 = var0.Battle.BattleDepthChargeUnit.New()
	elseif var3 == var1.EquipmentType.REPEATER_ANTI_AIR then
		var1 = var0.Battle.BattleRepeaterAntiAirUnit.New()
	elseif var3 == var1.EquipmentType.DISPOSABLE_TORPEDO then
		var1 = var0.Battle.BattleDisposableTorpedoUnit.New()
	elseif var3 == var1.EquipmentType.SPACE_LASER then
		var1 = var0.Battle.BattleSpaceLaserWeaponUnit.New()
	elseif var3 == var1.EquipmentType.MISSILE then
		var1 = var0.Battle.BattleMissileWeaponUnit.New()
	elseif var3 == var1.EquipmentType.MANUAL_AAMISSILE then
		var1 = var0.Battle.BattleManualAAMissileUnit.New()
	elseif var3 == var1.EquipmentType.AUTO_MISSILE then
		var1 = var0.Battle.BattleAutoMissileUnit.New()
	end

	assert(var1 ~= nil, "创建武器失败，不存在该类型的武器：id = " .. arg0)
	var1:SetPotentialFactor(arg2)
	var1:SetEquipmentIndex(arg3)
	var1:SetTemplateData(var2)
	var1:SetHostData(arg1)

	if var0 == var1.UnitType.PLAYER_UNIT then
		if var2.auto_aftercast > 0 then
			var1:OverrideGCD(var2.auto_aftercast)
		end
	elseif var0 == var1.UnitType.ENEMY_UNIT or var1.UnitType.BOSS_UNIT then
		var1:HostOnEnemy()
	end

	if var2.type == var1.EquipmentType.INTERCEPT_AIRCRAFT or var2.type == var1.EquipmentType.STRIKE_AIRCRAFT then
		var1:EnterCoolDown()
	end

	return var1
end

function var33.CreateAircraftUnit(arg0, arg1, arg2, arg3)
	local var0
	local var1 = var33.GetAircraftTmpDataFromID(arg1)

	assert(var1 ~= nil, "找不到飞机配置：id = " .. arg1)

	if type(var1.funnel_behavior) == "table" then
		if var1.funnel_behavior.hover_range then
			var0 = var0.Battle.BattelUAVUnit.New(arg0)
		elseif var1.funnel_behavior.AI then
			var0 = var0.Battle.BattlePatternFunnelUnit.New(arg0)
		else
			var0 = var0.Battle.BattleFunnelUnit.New(arg0)
		end
	else
		var0 = var0.Battle.BattleAircraftUnit.New(arg0)
	end

	var0:SetMotherUnit(arg2)
	var0:SetWeanponPotential(arg3)
	var0:SetTemplate(var1)

	return var0
end

function var33.CreateAllInStrike(arg0)
	local var0 = arg0:GetTemplateID()
	local var1 = var33.GetPlayerShipModelFromID(var0)
	local var2 = 0
	local var3 = {}

	for iter0, iter1 in ipairs(var1.airassist_time) do
		local var4 = var0.Battle.BattleAllInStrike.New(iter1)

		var4:SetHost(arg0)

		var3[iter0] = var4
	end

	return var3
end

function var33.ExpandAllinStrike(arg0)
	local var0 = arg0:GetTemplateID()
	local var1 = var33.GetPlayerShipModelFromID(var0).airassist_time

	if #var1 > 0 then
		local var2 = var1[#var1]
		local var3 = var0.Battle.BattleAllInStrike.New(var2)

		var3:SetHost(arg0)
		arg0:GetFleetVO():GetAirAssistVO():AppendWeapon(var3)
		var3:OverHeat()
		arg0:GetAirAssistQueue():AppendWeapon(var3)

		local var4 = arg0:GetAirAssistList()

		var4[#var4 + 1] = var3
	end
end

function var33.CreateAirFighterUnit(arg0, arg1)
	local var0
	local var1 = var33.GetAircraftTmpDataFromID(arg1.templateID)
	local var2 = var0.Battle.BattleAirFighterUnit.New(arg0)

	var2:SetWeaponTemplateID(arg1.weaponID)
	var2:SetBackwardWeaponID(arg1.backwardWeaponID)
	var2:SetTemplate(var1)

	return var2
end

function var33.GetPlayerShipTmpDataFromID(arg0)
	assert(var4[arg0] ~= nil, ">>ship_data_statistics<< 找不到玩家船只配置：id = " .. arg0)

	return Clone(var4[arg0])
end

function var33.GetPlayerShipModelFromID(arg0)
	assert(var5[arg0] ~= nil, ">>ship_data_template<< 找不到玩家船只模组配置：id = " .. arg0)

	return var5[arg0]
end

function var33.GetPlayerShipSkinDataFromID(arg0)
	assert(var6[arg0] ~= nil, ">>ship_skin_template<< 找不到舰娘皮肤配置：id = " .. arg0)

	return var6[arg0]
end

function var33.GetShipTypeTmp(arg0)
	assert(var19[arg0] ~= nil, ">>ship_data_by_type<< 找不到舰船类型配置：id = " .. arg0)

	return var19[arg0]
end

function var33.GetMonsterTmpDataFromID(arg0)
	assert(var7[arg0] ~= nil, ">>enemy_data_statistics<< 找不到敌方船只配置：id = " .. arg0)

	return var7[arg0]
end

function var33.GetAircraftTmpDataFromID(arg0)
	assert(var11[arg0] ~= nil, ">>aircraft_template<< 找不到飞机配置：id = " .. arg0)

	return var11[arg0]
end

function var33.GetWeaponDataFromID(arg0)
	if arg0 ~= Equipment.EQUIPMENT_STATE_EMPTY and arg0 ~= Equipment.EQUIPMENT_STATE_LOCK then
		assert(var13[arg0] ~= nil, ">>equip_data_statistics<< 找不到武器类装备配置：id = " .. arg0)
	end

	return var13[arg0]
end

function var33.GetEquipDataTemplate(arg0)
	assert(var14[arg0] ~= nil, ">>equip_data_template<< 找不到武器装备模板：id = " .. arg0)

	return var14[arg0]
end

function var33.GetSpWeaponDataFromID(arg0)
	assert(var15[arg0] ~= nil, ">>spweapon_data_statistics<< 找不到特殊兵装配置：id = " .. arg0)

	return var15[arg0]
end

function var33.GetWeaponPropertyDataFromID(arg0)
	assert(var8[arg0] ~= nil, ">>weapon_property<< 找不到武器行为配置：id = " .. arg0)

	return var8[arg0]
end

function var33.GetFormationTmpDataFromID(arg0)
	assert(var9[arg0] ~= nil, ">>formation_template<<找不到阵型配置：id = " .. arg0)

	return var9[arg0]
end

function var33.GetAITmpDataFromID(arg0)
	assert(var10[arg0] ~= nil, ">>auto_pilot_template<< 找不到移动ai配置：id = " .. arg0)

	return var10[arg0]
end

function var33.GetShipPersonality(arg0)
	assert(var17[arg0] ~= nil, ">>shipPersonality<< 找不到性格配置：id = " .. arg0)

	return var17[arg0]
end

function var33.GetEnemyTypeDataByType(arg0)
	assert(var18[arg0] ~= nil, ">>enemy_data_by_type<< 找不到怪物类型：type = " .. arg0)

	return var18[arg0]
end

function var33.GetArenaBuffByShipType(arg0)
	return var33.GetShipTypeTmp(arg0).arena_buff
end

function var33.GetPlayerUnitDurabilityExtraAddition(arg0, arg1)
	if arg0 == SYSTEM_DUEL then
		assert(var20[arg1] ~= nil, ">>ship_level<< 找不到等级配置：level = " .. arg1)

		return var20[arg1].arena_durability_ratio, var20[arg1].arena_durability_add
	else
		return 1, 0
	end
end

function var33.GetSkillDataTemplate(arg0)
	assert(var21[arg0] ~= nil, ">>skill_data_template<< 找不到技能配置：id = " .. arg0)

	return var21[arg0]
end

function var33.GetShipTransformDataTemplate(arg0)
	local var0 = var33.GetPlayerShipModelFromID(arg0)

	return var22[var0.group_type]
end

function var33.GetShipMetaFromDataTemplate(arg0)
	local var0 = var33.GetPlayerShipModelFromID(arg0)

	return var30[var0.group_type]
end

function var33.GetEquipSkinDataFromID(arg0)
	assert(var24[arg0] ~= nil, ">>equip_skin_template<< 找不到装备皮肤配置：id = " .. arg0)

	return var24[arg0]
end

function var33.GetEquipSkin(arg0)
	assert(var24[arg0] ~= nil, ">>equip_skin_template<< 找不到装备皮肤配置：id = " .. arg0)

	local var0 = var24[arg0]

	return var0.bullet_name, var0.derivate_bullet, var0.derivate_torpedo, var0.derivate_boom, var0.fire_fx_name, var0.hit_fx_name
end

function var33.GetEquipSkinSFX(arg0)
	assert(var24[arg0] ~= nil, ">>equip_skin_template<< 找不到装备皮肤配置：id = " .. arg0)

	local var0 = var24[arg0]

	return var0.hit_sfx, var0.miss_sfx
end

function var33.GetSpecificGuildBossEnemyList(arg0, arg1)
	local var0 = var29[arg0].expedition_id
	local var1 = {}

	if var0[1] == arg1 then
		var1 = var0[2]
	end

	return var1
end

function var33.GetSpecificEnemyList(arg0, arg1)
	local var0 = var25[arg0]
	local var1 = var26[var0.config_id].ex_expedition_enemy
	local var2

	for iter0, iter1 in ipairs(var1) do
		if iter1[1] == arg1 then
			var2 = iter1[2]

			break
		end
	end

	return var2
end

function var33.GetMetaBossTemplate(arg0)
	return var27[arg0]
end

function var33.GetMetaBossLevelTemplate(arg0, arg1)
	local var0 = var33.GetMetaBossTemplate(arg0).boss_level_id + (arg1 - 1)

	return var28[var0]
end

function var33.GetSpecificWorldJointEnemyList(arg0, arg1, arg2)
	local var0 = var33.GetMetaBossLevelTemplate(arg1, arg2)

	return {
		var0.enemy_id
	}
end

function var33.IncreaseAttributes(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		if iter1[arg1] ~= nil and type(iter1[arg1]) == "number" then
			arg0 = arg0 + iter1[arg1]
		end
	end
end

function var33.CreateAirFighterWeaponUnit(arg0, arg1, arg2, arg3)
	local var0
	local var1 = var33.GetWeaponPropertyDataFromID(arg0)

	assert(var1 ~= nil, "找不到武器配置：id = " .. arg0)

	if var1.type == var1.EquipmentType.MAIN_CANNON then
		var0 = var0.Battle.BattleWeaponUnit.New()
	elseif var1.type == var1.EquipmentType.SUB_CANNON then
		var0 = var0.Battle.BattleWeaponUnit.New()
	elseif var1.type == var1.EquipmentType.TORPEDO then
		var0 = var0.Battle.BattleTorpedoUnit.New()
	elseif var1.type == var1.EquipmentType.ANTI_AIR then
		var0 = var0.Battle.BattleAntiAirUnit.New()
	elseif var1.type == var1.EquipmentType.ANTI_SEA then
		var0 = var0.Battle.BattleDirectHitWeaponUnit.New()
	elseif var1.type == var1.EquipmentType.HAMMER_HEAD then
		var0 = var0.Battle.BattleHammerHeadWeaponUnit.New()
	elseif var1.type == var1.EquipmentType.BOMBER_PRE_CAST_ALERT then
		var0 = var0.Battle.BattleBombWeaponUnit.New()
	elseif var1.type == var1.EquipmentType.DEPTH_CHARGE then
		var0 = var0.Battle.BattleDepthChargeUnit.New()
	end

	assert(var0 ~= nil, "创建武器失败，不存在该类型的武器：id = " .. arg0)
	var0:SetPotentialFactor(arg3)

	local var2 = Clone(var1)

	var2.spawn_bound = "weapon"

	var0:SetTemplateData(var2)
	var0:SetHostData(arg1, arg2)

	return var0
end

function var33.GetWords(arg0, arg1, arg2)
	local var0, var1, var2 = ShipWordHelper.GetWordAndCV(arg0, arg1, 1, true, arg2)

	return var2
end

function var33.SkillTranform(arg0, arg1)
	local var0 = var33.GetSkillDataTemplate(arg1).system_transform

	if var0[arg0] == nil then
		return arg1
	else
		return var0[arg0]
	end
end

function var33.GenerateHiddenBuff(arg0)
	local var0 = var33.GetPlayerShipModelFromID(arg0).hide_buff_list
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = {}

		var2.level = 1
		var2.id = iter1
		var1[iter1] = var2
	end

	return var1
end

function var33.GetDivingFilter(arg0)
	return var31[arg0].diving_filter
end

function var33.GeneratePlayerSubmarinPhase(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0 - arg2

	return {
		{
			index = 0,
			switchType = 3,
			switchTo = 1,
			switchParam = var0
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
			switchParam = arg4
		},
		{
			index = 3,
			switchType = 4,
			switchTo = 4,
			dive = "STATE_RETREAT",
			switchParam = arg1
		},
		{
			index = 4,
			retreat = true
		}
	}
end

function var33.GetEnvironmentBehaviour(arg0)
	assert(var23[arg0] ~= nil, ">>battle_environment_behaviour_template<< 找不到环境行为配置：id = " .. arg0)

	return var23[arg0]
end

function var33.AttachUltimateBonus(arg0)
	local var0 = arg0:GetTemplateID()

	if not Ship.IsMaxStarByTmpID(var0) then
		return
	end

	local var1 = var33.GetPlayerShipModelFromID(var0).specific_type

	for iter0, iter1 in ipairs(var1) do
		if iter1 == ShipType.SpecificTypeTable.gunner then
			var3.SetCurrent(arg0, "barrageCounterMod", var1.UltimateBonus.GunnerCountMod)
		elseif iter1 == ShipType.SpecificTypeTable.torpedo then
			local var2 = var0.Battle.BattleBuffUnit.New(var1.UltimateBonus.TorpedoBarrageBuff)

			arg0:AddBuff(var2)
		elseif iter1 == ShipType.SpecificTypeTable.auxiliary then
			var33.AuxBoost(arg0)
		end
	end
end

function var33.AuxBoost(arg0)
	local var0 = arg0:GetEquipment()

	for iter0, iter1 in ipairs(var0) do
		if iter1 and iter1.equipment and table.contains(EquipType.DeviceEquipTypes, iter1.equipment.type) then
			local var1 = iter1.equipment

			for iter2 = 1, 3 do
				local var2 = "attribute_" .. iter2

				if var1[var2] then
					local var3 = var1["value_" .. iter2]
					local var4 = AttributeType.ConvertBattleAttrName(var1[var2])
					local var5 = var3.GetBase(arg0, var4) + var3 * var1.UltimateBonus.AuxBoostValue

					var3.SetCurrent(arg0, var4, var5)
					var3.SetBaseAttr(arg0)
				end
			end
		end
	end
end

function var33.GetSLGStrategyBuffByCombatBuffID(arg0)
	for iter0, iter1 in pairs(var32) do
		if iter1.buff_id == arg0 then
			return iter1
		end
	end
end
