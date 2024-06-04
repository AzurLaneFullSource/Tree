ys.Battle.BattleFormulas = ys.Battle.BattleFormulas or {}

local var0 = ys.Battle.BattleFormulas
local var1 = ys.Battle.BattleConst
local var2 = pg.gameset
local var3 = ys.Battle.BattleAttr
local var4 = ys.Battle.BattleConfig
local var5 = ys.Battle.BattleConfig.AnitAirRepeaterConfig
local var6 = pg.bfConsts
local var7 = var6.SECONDs / var4.viewFPS * var4.BulletSpeedConvertConst
local var8 = var6.SECONDs / var4.calcFPS * var4.ShipSpeedConvertConst
local var9 = var6.SECONDs / var4.viewFPS * var4.AircraftSpeedConvertConst
local var10 = var4.AIR_ASSIST_RELOAD_RATIO * var6.PERCENT
local var11 = var4.DAMAGE_ENHANCE_FROM_SHIP_TYPE
local var12 = var4.AMMO_DAMAGE_ENHANCE
local var13 = var4.AMMO_DAMAGE_REDUCE
local var14 = var4.SHIP_TYPE_ACCURACY_ENHANCE

function var0.GetFleetTotalHP(arg0)
	local var0 = arg0:GetFlagShip()
	local var1 = arg0:GetUnitList()
	local var2 = var6.NUM0

	for iter0, iter1 in ipairs(var1) do
		if iter1 == var0 then
			var2 = var2 + var3.GetCurrent(iter1, "maxHP") * var6.HP_CONST
		else
			var2 = var2 + var3.GetCurrent(iter1, "maxHP")
		end
	end

	return var2
end

function var0.GetFleetVelocity(arg0)
	local var0 = arg0[1]

	if var0 then
		local var1 = var3.GetCurrent(var0, "fleetVelocity")

		if var1 > var6.NUM0 then
			return var1 * var6.PERCENT
		end
	end

	local var2 = var6.NUM0
	local var3 = #arg0

	for iter0, iter1 in ipairs(arg0) do
		var2 = var2 + iter1:GetAttrByName("velocity")
	end

	local var4 = var6.NUM1 - var6.SPEED_CONST * (var3 - var6.NUM1)

	return var2 / var3 * var4
end

function var0.GetFleetReload(arg0)
	local var0 = var6.NUM0

	for iter0, iter1 in ipairs(arg0) do
		var0 = var0 + iter1:GetReload()
	end

	return var0
end

function var0.GetFleetTorpedoPower(arg0)
	local var0 = var6.NUM0

	for iter0, iter1 in ipairs(arg0) do
		var0 = var0 + iter1:GetTorpedoPower()
	end

	return var0
end

function var0.AttrFixer(arg0, arg1)
	if arg0 == SYSTEM_DUEL then
		local var0 = arg1.level
		local var1 = arg1.durability
		local var2, var3 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(arg0, var0)

		arg1.durability = var1 * var2 + var3
	end
end

function var0.HealFixer(arg0, arg1)
	local var0 = 1

	if arg0 == SYSTEM_DUEL then
		local var1 = arg1.level

		var0 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(arg0, var1)
	end

	return var0
end

function var0.ConvertShipSpeed(arg0)
	return arg0 * var8
end

function var0.ConvertAircraftSpeed(arg0)
	if arg0 then
		return arg0 * var9
	else
		return nil
	end
end

function var0.ConvertBulletSpeed(arg0)
	return arg0 * var7
end

function var0.ConvertBulletDataSpeed(arg0)
	return arg0 / var7
end

function var0.CreateContextCalculateDamage(arg0)
	return function(arg0, arg1, arg2, arg3)
		local var0 = var6.NUM1
		local var1 = var6.NUM0
		local var2 = var6.NUM10000
		local var3 = var6.DRATE
		local var4 = var6.ACCURACY
		local var5 = arg0:GetWeaponHostAttr()
		local var6 = arg0:GetWeapon()
		local var7 = arg0:GetWeaponTempData()
		local var8 = var7.type
		local var9 = var7.attack_attribute
		local var10 = var6:GetConvertedAtkAttr()
		local var11 = arg0:GetTemplate()
		local var12 = var11.damage_type
		local var13 = var11.random_damage_rate
		local var14 = arg1._attr
		local var15 = arg3 or var0

		arg2 = arg2 or var1

		local var16 = var14.armorType
		local var17 = var5.formulaLevel - var14.formulaLevel
		local var18 = var0
		local var19 = false
		local var20 = false
		local var21 = var0
		local var22 = arg0:GetCorrectedDMG()
		local var23 = (var0 + arg0:GetWeaponAtkAttr() * var10) * var22

		if var9 == var1.WeaponDamageAttr.CANNON then
			var15 = var0 + var3.GetCurrent(arg1, "injureRatioByCannon") + var3.GetCurrent(arg0, "damageRatioByCannon")
		elseif var9 == var1.WeaponDamageAttr.TORPEDO then
			var15 = var0 + var3.GetCurrent(arg1, "injureRatioByBulletTorpedo") + var3.GetCurrent(arg0, "damageRatioByBulletTorpedo")
		elseif var9 == var1.WeaponDamageAttr.AIR then
			local var24 = var3.GetCurrent(arg0, "airResistPierceActive") == 1 and var3.GetCurrent(arg0, "airResistPierce") or 0

			var15 = var15 * math.min(var3[7] / (var14.antiAirPower + var3[7]) + var24, 1) * (var0 + var3.GetCurrent(arg1, "injureRatioByAir") + var3.GetCurrent(arg0, "damageRatioByAir"))
		elseif var9 == var1.WeaponDamageAttr.ANTI_AIR then
			-- block empty
		elseif var9 == var1.WeaponDamageAttr.ANIT_SUB then
			-- block empty
		end

		local var25 = var5.luck - var14.luck
		local var26 = var3.GetCurrent(arg1, "perfectDodge")
		local var27 = math.max(var5.attackRating, 0)
		local var28

		if var26 == 1 then
			var28 = true
		else
			local var29 = var4[1] + var27 / (var27 + var14.dodgeRate + var4[2]) + (var25 + var17) * var6.PERCENT1
			local var30 = var3.GetCurrent(arg1, "accuracyRateExtra")
			local var31 = var3.GetCurrent(arg0, var14[arg1:GetTemplate().type])
			local var32 = var3.GetCurrent(arg1, "dodgeRateExtra")
			local var33 = math.max(var3[5], math.min(var0, var29 + var30 + var31 - var32))

			var28 = not var0.IsHappen(var33 * var2)
		end

		if not var28 then
			local var34
			local var35 = var3.GetCurrent(arg0, "GCT") == 1 and 1 or var6.DFT_CRIT_RATE + var27 / (var27 + var14.dodgeRate + var3[4]) + (var25 + var17) * var3[3] + var3.GetCurrent(arg0, "cri") + var3.GetTagAttrCri(arg0, arg1)

			var21 = math.random(var4.RANDOM_DAMAGE_MIN, var4.RANDOM_DAMAGE_MAX) + var23

			if var0.IsHappen(var35 * var2) then
				var20 = true

				local var36 = var6.DFT_CRIT_EFFECT + var3.GetTagAttrCriDmg(arg0, arg1) + var3.GetCurrent(arg0, "criDamage") - var3.GetCurrent(arg1, "criDamageResist")

				var18 = math.max(1, var36)
			else
				var20 = false
			end
		else
			var21 = var1

			local var37 = {
				isMiss = true,
				isDamagePrevent = false,
				isCri = var20
			}

			return var21, var37
		end

		local var38 = var6.NUM1
		local var39 = var3.GetCurrent(arg0, "damageRatioBullet")
		local var40 = var3.GetTagAttr(arg0, arg1, arg0)
		local var41 = var3.GetCurrent(arg1, "injureRatio")
		local var42 = (var6:GetFixAmmo() or var12[var16] or var38) + var3.GetCurrent(arg0, var4.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE[var16])
		local var43 = var3.GetCurrent(arg0, var4.DAMAGE_TO_ARMOR_RATE_ENHANCE[var16])
		local var44 = var3.GetCurrent(arg0, var12[var11.ammo_type])
		local var45 = var3.GetCurrent(arg1, var13[var11.ammo_type])
		local var46 = var3.GetCurrent(arg0, "comboTag")
		local var47 = var3.GetCurrent(arg1, var46)
		local var48 = math.max(var38, math.floor(var21 * var15 * (var38 - arg2) * var42 * (var38 + var43) * var18 * (var38 + var39) * var40 * (var38 + var41) * (var38 + var44 - var45) * (var38 + var47) * (var38 + math.min(var3[1], math.max(-var3[1], var17)) * var3[2])))

		if arg1:GetCurrentOxyState() == var1.OXY_STATE.DIVE then
			var48 = math.floor(var48 * var11.antisub_enhancement)
		end

		local var49 = {
			isMiss = var28,
			isCri = var20,
			damageAttr = var9
		}
		local var50 = arg0:GetDamageEnhance()

		if var50 ~= 1 then
			var48 = math.floor(var48 * var50)
		end

		local var51 = var48 * var14.repressReduce

		if var13 ~= 0 then
			var51 = var51 * (Mathf.RandomFloat(var13) + 1)
		end

		local var52 = var3.GetCurrent(arg0, "damageEnhanceProjectile")
		local var53 = math.max(0, var51 + var52)

		if arg0 then
			var53 = var53 * (var6.NUM1 + var3.GetCurrent(arg0, "worldBuffResistance"))
		end

		local var54 = math.floor(var53)
		local var55 = var11.DMG_font[var16]

		if var52 < 0 then
			var55 = var4.BULLET_DECREASE_DMG_FONT
		end

		return var54, var49, var55
	end
end

function var0.CalculateIgniteDamage(arg0, arg1, arg2)
	local var0 = arg0._attr

	return arg0:GetWeapon():GetCorrectedDMG() * (1 + var0[arg1] * var6.PERCENT) * arg2
end

function var0.WeaponDamagePreCorrection(arg0, arg1)
	local var0 = arg0:GetTemplateData()
	local var1 = arg1 or var0.damage
	local var2 = var0.corrected

	return var1 * arg0:GetPotential() * var2 * var6.PERCENT
end

function var0.WeaponAtkAttrPreRatio(arg0)
	return arg0:GetTemplateData().attack_attribute_ratio * var6.PERCENT2
end

function var0.GetMeteoDamageRatio(arg0)
	local var0 = {}
	local var1 = var6.METEO_RATE
	local var2 = var1[1]

	if arg0 >= var1[2] then
		for iter0 = 1, arg0 + 1 do
			var0[iter0] = var2
		end

		return var0
	else
		local var3 = 1 - var2 * arg0

		for iter1 = 1, arg0 do
			local var4 = math.random() * var3 * (var1[3] + var1[4] * (iter1 - 1) / arg0)

			var0[iter1] = var4 + var2
			var3 = math.max(0, var3 - var4)
		end

		var0[arg0 + 1] = var3

		return var0
	end
end

function var0.CalculateFleetAntiAirTotalDamage(arg0)
	local var0 = arg0:GetCrewUnitList()
	local var1 = 0

	for iter0, iter1 in pairs(var0) do
		local var2 = var3.GetCurrent(iter0, "antiAirPower")

		for iter2, iter3 in ipairs(iter1) do
			local var3 = iter3:GetConvertedAtkAttr()
			local var4 = iter3:GetCorrectedDMG()

			var1 = var1 + math.max(1, (var2 * var3 + 1) * var4)
		end
	end

	return var1
end

function var0.CalculateRepaterAnitiAirTotalDamage(arg0)
	local var0 = arg0:GetHost()
	local var1 = arg0:GetConvertedAtkAttr()
	local var2 = arg0:GetCorrectedDMG()
	local var3 = var3.GetCurrent(var0, "antiAirPower")

	return (math.max(1, (var3 * var1 + 1) * var2))
end

function var0.RollRepeaterHitDice(arg0, arg1)
	local var0 = arg0:GetHost()
	local var1 = var3.GetCurrent(var0, "antiAirPower")
	local var2 = math.max(var3.GetCurrent(var0, "attackRating"), 0)
	local var3 = var3.GetCurrent(arg1, "airPower")
	local var4 = var3.GetCurrent(arg1, "dodgeLimit")
	local var5 = var3.GetCurrent(arg1, "dodge")
	local var6 = var3 / var5.const_A + var5.const_B
	local var7 = var6 / (var1 * var5 + var6 + var5.const_C)
	local var8 = math.min(var4, var7)

	return var0.IsHappen(var8 * var6.NUM10000)
end

function var0.AntiAirPowerWeight(arg0)
	return arg0 * arg0
end

function var0.CalculateDamageFromAircraftToMainShip(arg0, arg1)
	local var0 = var3.GetCurrent(arg0, "airPower")
	local var1 = var3.GetCurrent(arg1, "antiAirPower")
	local var2 = var3.GetCurrent(arg0, "crashDMG")
	local var3 = arg0:GetHPRate()
	local var4 = var3.GetCurrent(arg0, "formulaLevel")
	local var5 = var3.GetCurrent(arg1, "formulaLevel")
	local var6 = var3.GetCurrent(arg1, "injureRatio")
	local var7 = var3.GetCurrent(arg1, "injureRatioByAir")
	local var8 = var6.PLANE_LEAK_RATE
	local var9 = math.max(var8[1], math.floor((var2 * (var8[2] + var0 * var8[3]) + var4 * var8[4]) * (var3 * var8[5] + var8[6]) * (var8[7] + (var4 - var5) * var8[8]) * (var8[9] / (var1 + var8[10])) * (var8[11] + var6) * (var8[12] + var7)))

	return (math.floor(var9 * var3.GetCurrent(arg1, "repressReduce")))
end

function var0.CalculateDamageFromShipToMainShip(arg0, arg1)
	local var0 = var3.GetCurrent(arg0, "cannonPower")
	local var1 = var3.GetCurrent(arg0, "torpedoPower")
	local var2 = arg0:GetHPRate()
	local var3 = var3.GetCurrent(arg0, "formulaLevel")
	local var4 = var3.GetCurrent(arg1, "formulaLevel")
	local var5 = var3.GetCurrent(arg1, "injureRatio")
	local var6 = var6.LEAK_RATE
	local var7 = math.max(var6[1], math.floor(((var0 + var1) * var6[2] + var3 * var6[7]) * (var6[5] + var5) * (var2 * var6[3] + var6[4]) * (var6[5] + (var3 - var4) * var6[6])))

	return (math.floor(var7 * var3.GetCurrent(arg1, "repressReduce")))
end

function var0.CalculateDamageFromSubmarinToMainShip(arg0, arg1)
	local var0 = var3.GetCurrent(arg0, "torpedoPower")
	local var1 = arg0:GetHPRate()
	local var2 = var3.GetCurrent(arg0, "formulaLevel")
	local var3 = var3.GetCurrent(arg1, "formulaLevel")
	local var4 = var3.GetCurrent(arg1, "injureRatio")
	local var5 = var6.SUBMARINE_KAMIKAZE

	return (math.max(var5[1], math.floor((var0 * var5[2] + var2 * var5[3]) * (var5[4] + var4) * (var1 * var5[5] + var5[6]) * (var5[7] + (var2 - var3) * var5[8]))))
end

function var0.RollSubmarineDualDice(arg0)
	local var0 = var3.GetCurrent(arg0, "dodgeRate")
	local var1 = var0 / (var0 + var4.MONSTER_SUB_KAMIKAZE_DUAL_K) * var4.MONSTER_SUB_KAMIKAZE_DUAL_P

	return var0.IsHappen(var1 * var6.NUM10000)
end

function var0.CalculateCrashDamage(arg0, arg1)
	local var0 = var3.GetCurrent(arg0, "maxHP")
	local var1 = var3.GetCurrent(arg1, "maxHP")
	local var2 = var0 * var6.CRASH_RATE[1]
	local var3 = var1 * var6.CRASH_RATE[1]
	local var4 = var3.GetCurrent(arg0, "hammerDamageRatio")
	local var5 = var3.GetCurrent(arg1, "hammerDamageRatio")
	local var6 = var3.GetCurrent(arg0, "hammerDamagePrevent")
	local var7 = var3.GetCurrent(arg1, "hammerDamagePrevent")
	local var8 = math.min(var6, var4.HammerCFG.PreventUpperBound)
	local var9 = math.min(var7, var4.HammerCFG.PreventUpperBound)
	local var10 = math.sqrt(var0 * var1) * var6.CRASH_RATE[2]
	local var11 = math.min(var2, var10)
	local var12 = math.min(var3, var10)
	local var13 = math.floor(var11 * (1 + var5) * (1 - var8))
	local var14 = math.floor(var13 * var3.GetCurrent(arg0, "repressReduce"))
	local var15 = math.floor(var12 * (1 + var4) * (1 - var9))
	local var16 = math.floor(var15 * var3.GetCurrent(arg1, "repressReduce"))

	return var14, var16
end

function var0.CalculateFleetDamage(arg0)
	return arg0 * var6.SCORE_RATE[1]
end

function var0.CalculateFleetOverDamage(arg0, arg1)
	if arg1 == arg0:GetFlagShip() then
		return var3.GetCurrent(arg1, "maxHP") * var6.SCORE_RATE[2]
	else
		return var3.GetCurrent(arg1, "maxHP") * var6.SCORE_RATE[3]
	end
end

function var0.CalculateReloadTime(arg0, arg1)
	return arg0 / var4.K1 / math.sqrt((arg1 + var4.K2) * var4.K3)
end

function var0.CaclulateReloaded(arg0, arg1)
	return math.sqrt((arg1 + var4.K2) * var4.K3) * arg0 * var4.K1
end

function var0.CaclulateReloadAttr(arg0, arg1)
	local var0 = arg0 / var4.K1 / arg1

	return math.max(var0 * var0 / var4.K3 - var4.K2, 0)
end

function var0.CaclulateAirAssistReloadMax(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0) do
		var0 = var0 + iter1:GetTemplateData().reload_max
	end

	return var0 / #arg0 * var10
end

function var0.CaclulateDOTPlace(arg0, arg1, arg2, arg3)
	local var0 = arg1.arg_list

	if var0.tagOnly and not arg3:ContainsLabelTag(var0.tagOnly) then
		return false
	end

	local var1 = var4.DOT_CONFIG[var0.dotType]
	local var2 = arg2 and arg2:GetAttrByName(var1.hit) or var6.NUM0
	local var3 = arg3 and arg3:GetAttrByName(var1.resist) or var6.NUM0

	return var0.IsHappen(arg0 * (var6.NUM1 + var2) * (var6.NUM1 - var3))
end

function var0.CaclulateDOTDuration(arg0, arg1, arg2)
	local var0 = arg0.arg_list
	local var1 = var4.DOT_CONFIG[var0.dotType]

	return (arg1 and arg1:GetAttrByName(var1.prolong) or var6.NUM0) - (arg2 and arg2:GetAttrByName(var1.shorten) or var6.NUM0)
end

function var0.CaclulateDOTDamageEnhanceRate(arg0, arg1, arg2)
	local var0 = arg0.arg_list
	local var1 = var4.DOT_CONFIG[var0.dotType]

	return ((arg1 and arg1:GetAttrByName(var1.enhance) or var6.NUM0) - (arg2 and arg2:GetAttrByName(var1.reduce) or var6.NUM0)) * var6.PERCENT2
end

function var0.CaclulateMetaDotaDamage(arg0, arg1)
	local var0 = ys.Battle.BattleDataFunction.GetMetaBossTemplate(arg0)

	if type(var0.state) == "string" then
		return 0
	end

	local var1 = var0.state
	local var2 = os.time({
		year = var1[1][1][1],
		month = var1[1][1][2],
		day = var1[1][1][3],
		hour = var1[1][2][1],
		minute = var1[1][2][2],
		second = var1[1][2][3]
	})
	local var3 = os.time({
		year = var1[2][1][1],
		month = var1[2][1][2],
		day = var1[2][1][3],
		hour = var1[2][2][1],
		minute = var1[2][2][2],
		second = var1[2][2][3]
	})
	local var4 = os.difftime(var3, var2)
	local var5 = math.floor(var4 / 86400)
	local var6 = math.floor(os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), var2) / 86400)
	local var7 = pg.gameset.world_metaboss_supportattack.description
	local var8 = var7[1]
	local var9 = var5 - var7[2]
	local var10 = var7[3]
	local var11 = var7[4]
	local var12 = var7[5]
	local var13 = ys.Battle.BattleDataFunction.GetMetaBossLevelTemplate(arg0, arg1).hp
	local var14 = math.floor(var13 * var10 / var12 / (1 + 0.5 * var11) / (var9 - var8) * math.min(var6 - var8 + 1, var9 - var8))

	return var14 + math.random(math.floor(var11 * var14))
end

function var0.CalculateMaxAimBiasRange(arg0)
	local var0 = var4.AIM_BIAS_FLEET_RANGE_MOD
	local var1

	if #arg0 == 1 then
		local var2 = arg0[1]

		var1 = var3.GetCurrent(arg0[1], "dodgeRate") * var0
	else
		local var3 = {}

		for iter0, iter1 in ipairs(arg0) do
			table.insert(var3, var3.GetCurrent(iter1, "dodgeRate"))
		end

		table.sort(var3, function(arg0, arg1)
			return arg1 < arg0
		end)

		var1 = (var3[1] + var3[2] * 0.6 + (var3[3] or 0) * 0.3) / #var3 * var0
	end

	return (math.min(var1, var4.AIM_BIAS_MAX_RANGE_SCOUT))
end

function var0.CalculateMaxAimBiasRangeSub(arg0)
	local var0 = var3.GetCurrent(arg0[1], "dodgeRate") * var4.AIM_BIAS_SUB_RANGE_MOD

	return (math.min(var0, var4.AIM_BIAS_MAX_RANGE_SUB))
end

function var0.CalculateMaxAimBiasRangeMonster(arg0)
	local var0 = var3.GetCurrent(arg0[1], "dodgeRate") * var4.AIM_BIAS_MONSTER_RANGE_MOD

	return (math.min(var0, var4.AIM_BIAS_MAX_RANGE_MONSTER))
end

function var0.CalculateBiasDecay(arg0)
	local var0 = arg0 * var4.AIM_BIAS_DECAY_MOD_MONSTER

	return (math.min(var0, var4.AIM_BIAS_DECAY_SPEED_MAX_SCOUT))
end

function var0.CalculateBiasDecayMonster(arg0)
	local var0 = arg0 * var4.AIM_BIAS_DECAY_MOD

	return (math.min(var0, var4.AIM_BIAS_DECAY_SPEED_MAX_MONSTER))
end

function var0.CalculateBiasDecayMonsterInSmoke(arg0)
	local var0 = arg0 * var4.AIM_BIAS_DECAY_MOD * var4.AIM_BIAS_DECAY_SMOKE

	return (math.min(var0, var4.AIM_BIAS_DECAY_SPEED_MAX_MONSTER))
end

function var0.CalculateBiasDecayDiving(arg0)
	local var0 = math.max(0, arg0 - var4.AIM_BIAS_DECAY_SUB_CONST) * var4.AIM_BIAS_DECAY_MOD

	return (math.min(var0, var4.AIM_BIAS_DECAY_SPEED_MAX_SUB))
end

function var0.WorldEnemyAttrEnhance(arg0, arg1)
	return 1 + arg0 / (1 + var4.WORLD_ENEMY_ENHANCEMENT_CONST_C^(var4.WORLD_ENEMY_ENHANCEMENT_CONST_B - arg1))
end

local var15 = setmetatable({}, {
	__index = function(arg0, arg1)
		return 0
	end
})

function var0.WorldMapRewardAttrEnhance(arg0, arg1)
	arg0 = arg0 or var15
	arg1 = arg1 or var15

	local var0
	local var1
	local var2
	local var3 = {
		{
			var2.attr_world_value_X1.key_value / 10000,
			var2.attr_world_value_X2.key_value / 10000
		},
		{
			var2.attr_world_value_Y1.key_value / 10000,
			var2.attr_world_value_Y2.key_value / 10000
		},
		{
			var2.attr_world_value_Z1.key_value / 10000,
			var2.attr_world_value_Z2.key_value / 10000
		}
	}
	local var4 = var2.attr_world_damage_fix.key_value / 10000
	local var5

	if arg0[1] == 0 then
		var5 = var3[1][2]
	else
		var5 = arg1[1] / arg0[1]
	end

	local var6 = 1 - math.clamp(var5, var3[1][1], var3[1][2])

	if arg0[2] == 0 then
		var5 = var3[2][2]
	else
		var5 = arg1[2] / arg0[2]
	end

	local var7 = 1 - math.clamp(var5, var3[2][1], var3[2][2])

	if arg0[3] == 0 then
		var5 = var3[3][2]
	else
		var5 = arg1[3] / arg0[3]
	end

	local var8 = math.max(1 - math.clamp(var5, var3[3][1], var3[3][2]), -var4)

	return var6, var7, var8
end

function var0.WorldMapRewardHealingRate(arg0, arg1)
	local var0 = {
		var2.attr_world_value_H1.key_value / 10000,
		var2.attr_world_value_H2.key_value / 10000
	}

	arg0 = arg0 or var15
	arg1 = arg1 or var15

	local var1

	if arg0[3] == 0 then
		var1 = var0[2]
	else
		var1 = arg1[3] / arg0[3]
	end

	return math.clamp(var1, var0[1], var0[2])
end

function var0.CalcDamageLock()
	return 0, {
		false,
		true,
		false
	}
end

function var0.CalcDamageLockA2M()
	return 0
end

function var0.CalcDamageLockS2M()
	return 0
end

function var0.CalcDamageLockCrush()
	return 0, 0
end

function var0.UnilateralCrush()
	return 0, 100000
end

function var0.FriendInvincibleDamage(arg0, arg1, ...)
	local var0 = arg1:GetIFF()

	if var0 == ys.Battle.BattleConfig.FRIENDLY_CODE then
		return 1, {
			isMiss = false,
			isCri = false,
			isDamagePrevent = false
		}
	elseif var0 == ys.Battle.BattleConfig.FOE_CODE then
		return var0.CalculateDamage(arg0, arg1, ...)
	end
end

function var0.FriendInvincibleCrashDamage(arg0, arg1)
	local var0, var1 = var0.CalculateCrashDamage(arg0, arg1)
	local var2 = 1

	var1 = arg1:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE and 1 or var1

	return var2, var1
end

function var0.ChapterRepressReduce(arg0)
	return 1 - arg0 * 0.01
end

function var0.IsHappen(arg0)
	if arg0 <= 0 then
		return false
	elseif arg0 >= 10000 then
		return true
	else
		return arg0 >= math.random(10000)
	end
end

function var0.WeightRandom(arg0)
	local var0, var1 = var0.GenerateWeightList(arg0)

	return (var0.WeightListRandom(var0, var1))
end

function var0.WeightListRandom(arg0, arg1)
	local var0 = math.random(0, arg1)

	for iter0, iter1 in pairs(arg0) do
		local var1 = iter0.min
		local var2 = iter0.max

		if var1 <= var0 and var0 <= var2 then
			return iter1
		end
	end
end

function var0.GenerateWeightList(arg0)
	local var0 = {}
	local var1 = -1

	for iter0, iter1 in ipairs(arg0) do
		local var2 = iter1.weight
		local var3 = iter1.rst
		local var4 = var1 + 1
		local var5

		var1 = var1 + var2

		local var6 = var1

		var0[{
			min = var4,
			max = var6
		}] = var3
	end

	return var0, var1
end

function var0.IsListHappen(arg0)
	for iter0, iter1 in ipairs(arg0) do
		if var0.IsHappen(iter1[1]) then
			return true, iter1[2]
		end
	end

	return false, nil
end

function var0.BulletYAngle(arg0, arg1)
	return math.rad2Deg * math.atan2(arg1.z - arg0.z, arg1.x - arg0.x)
end

function var0.RandomPosNull(arg0, arg1)
	arg1 = arg1 or 10

	local var0 = arg0.distance or 10
	local var1 = var0 * var0
	local var2 = ys.Battle.BattleTargetChoise.TargetAll()
	local var3
	local var4

	for iter0 = 1, arg1 do
		local var5 = true
		local var6 = var0.RandomPos(arg0)

		for iter1, iter2 in pairs(var2) do
			local var7 = iter2:GetPosition()

			if var1 > Vector3.SqrDistance(var6, var7) then
				var5 = false

				break
			end
		end

		if var5 then
			return var6
		end
	end

	return nil
end

function var0.RandomPos(arg0)
	local var0 = arg0[1] or 0
	local var1 = arg0[2] or 0
	local var2 = arg0[3] or 0

	if arg0.rangeX or arg0.rangeY or arg0.rangeZ then
		local var3 = var0.RandomDelta(arg0.rangeX)
		local var4 = var0.RandomDelta(arg0.rangeY)
		local var5 = var0.RandomDelta(arg0.rangeZ)

		return Vector3(var0 + var3, var1 + var4, var2 + var5)
	else
		local var6 = var0.RandomPosXYZ(arg0, "X1", "X2")
		local var7 = var0.RandomPosXYZ(arg0, "Y1", "Y2")
		local var8 = var0.RandomPosXYZ(arg0, "Z1", "Z2")

		return Vector3(var0 + var6, var1 + var7, var2 + var8)
	end
end

function var0.RandomPosXYZ(arg0, arg1, arg2)
	arg1 = arg0[arg1]
	arg2 = arg0[arg2]

	if arg1 and arg2 then
		return math.random(arg1, arg2)
	else
		return 0
	end
end

function var0.RandomPosCenterRange(arg0)
	local var0 = var0.RandomDelta(arg0.rangeX)
	local var1 = var0.RandomDelta(arg0.rangeY)
	local var2 = var0.RandomDelta(arg0.rangeZ)

	return Vector3(var0, var1, var2)
end

function var0.RandomDelta(arg0)
	if arg0 and arg0 > 0 then
		return math.random(arg0 + arg0) - arg0
	else
		return 0
	end
end

function var0.simpleCompare(arg0, arg1)
	local var0, var1 = string.find(arg0, "%p+")
	local var2 = string.sub(arg0, var0, var1)
	local var3 = string.sub(arg0, var1 + 1, #arg0)
	local var4 = getCompareFuncByPunctuation(var2)
	local var5 = tonumber(var3)

	return var4(arg1, var5)
end

function var0.parseCompareUnitAttr(arg0, arg1, arg2)
	local var0, var1 = string.find(arg0, "%p+")
	local var2 = string.sub(arg0, var0, var1)
	local var3 = string.sub(arg0, 1, var0 - 1)
	local var4 = string.sub(arg0, var1 + 1, #arg0)
	local var5 = getCompareFuncByPunctuation(var2)
	local var6 = tonumber(var3) or arg1:GetAttrByName(var3)
	local var7 = tonumber(var4) or arg2:GetAttrByName(var4)

	return var5(var6, var7)
end

function var0.parseCompareUnitTemplate(arg0, arg1, arg2)
	local var0, var1 = string.find(arg0, "%p+")
	local var2 = string.sub(arg0, var0, var1)
	local var3 = string.sub(arg0, 1, var0 - 1)
	local var4 = string.sub(arg0, var1 + 1, #arg0)
	local var5 = getCompareFuncByPunctuation(var2)
	local var6 = tonumber(var3) or arg1:GetTemplateValue(var3)
	local var7 = tonumber(var4) or arg2:GetTemplateValue(var4)

	return var5(var6, var7)
end

function var0.parseCompareBuffAttachData(arg0, arg1)
	local var0, var1 = string.find(arg0, "%p+")
	local var2 = string.sub(arg0, var0, var1)
	local var3 = string.sub(arg0, 1, var0 - 1)

	if arg1.__name ~= var3 then
		return true
	end

	local var4 = tonumber(string.sub(arg0, var1 + 1, #arg0))
	local var5 = arg1:GetEffectAttachData()

	return getCompareFuncByPunctuation(var2)(var5, var4)
end

function var0.parseCompare(arg0, arg1)
	local var0, var1 = string.find(arg0, "%p+")
	local var2 = string.sub(arg0, var0, var1)
	local var3 = string.sub(arg0, 1, var0 - 1)
	local var4 = string.sub(arg0, var1 + 1, #arg0)
	local var5 = getCompareFuncByPunctuation(var2)
	local var6 = tonumber(var3) or arg1:GetCurrent(var3)
	local var7 = tonumber(var4) or arg1:GetCurrent(var4)

	return var5(var6, var7)
end

function var0.parseFormula(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0 in string.gmatch(arg0, "%w+%.?%w*") do
		table.insert(var0, iter0)
	end

	for iter1 in string.gmatch(arg0, "[^%w%.]") do
		table.insert(var1, iter1)
	end

	local var2 = {}
	local var3 = {}
	local var4 = 1
	local var5 = var0[1]

	var5 = tonumber(var5) or arg1:GetCurrent(var5)

	for iter2, iter3 in ipairs(var1) do
		var4 = var4 + 1

		local var6 = tonumber(var0[var4]) or arg1:GetCurrent(var0[var4])

		if iter3 == "+" or iter3 == "-" then
			table.insert(var3, var5)

			var5 = var6

			table.insert(var2, iter3)
		elseif iter3 == "*" or iter3 == "/" then
			var5 = getArithmeticFuncByOperator(iter3)(var5, var6)
		end
	end

	table.insert(var3, var5)

	local var7 = 1
	local var8 = var3[var7]

	while var7 < #var3 do
		local var9 = getArithmeticFuncByOperator(var2[var7])

		var7 = var7 + 1
		var8 = var9(var8, var3[var7])
	end

	return var8
end
