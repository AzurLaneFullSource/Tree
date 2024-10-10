ys.Battle.BattleFormulas = ys.Battle.BattleFormulas or {}

local var0_0 = ys.Battle.BattleFormulas
local var1_0 = ys.Battle.BattleConst
local var2_0 = pg.gameset
local var3_0 = ys.Battle.BattleAttr
local var4_0 = ys.Battle.BattleConfig
local var5_0 = ys.Battle.BattleConfig.AnitAirRepeaterConfig
local var6_0 = pg.bfConsts
local var7_0 = var6_0.SECONDs / var4_0.viewFPS * var4_0.BulletSpeedConvertConst
local var8_0 = var6_0.SECONDs / var4_0.calcFPS * var4_0.ShipSpeedConvertConst
local var9_0 = var6_0.SECONDs / var4_0.viewFPS * var4_0.AircraftSpeedConvertConst
local var10_0 = var4_0.AIR_ASSIST_RELOAD_RATIO * var6_0.PERCENT
local var11_0 = var4_0.DAMAGE_ENHANCE_FROM_SHIP_TYPE
local var12_0 = var4_0.AMMO_DAMAGE_ENHANCE
local var13_0 = var4_0.AMMO_DAMAGE_REDUCE
local var14_0 = var4_0.SHIP_TYPE_ACCURACY_ENHANCE

function var0_0.GetFleetTotalHP(arg0_1)
	local var0_1 = arg0_1:GetFlagShip()
	local var1_1 = arg0_1:GetUnitList()
	local var2_1 = var6_0.NUM0

	for iter0_1, iter1_1 in ipairs(var1_1) do
		if iter1_1 == var0_1 then
			var2_1 = var2_1 + var3_0.GetCurrent(iter1_1, "maxHP") * var6_0.HP_CONST
		else
			var2_1 = var2_1 + var3_0.GetCurrent(iter1_1, "maxHP")
		end
	end

	return var2_1
end

function var0_0.GetFleetVelocity(arg0_2)
	local var0_2 = arg0_2[1]

	if var0_2 then
		local var1_2 = var3_0.GetCurrent(var0_2, "fleetVelocity")

		if var1_2 > var6_0.NUM0 then
			return var1_2 * var6_0.PERCENT
		end
	end

	local var2_2 = var6_0.NUM0
	local var3_2 = #arg0_2

	for iter0_2, iter1_2 in ipairs(arg0_2) do
		var2_2 = var2_2 + iter1_2:GetAttrByName("velocity")
	end

	local var4_2 = var6_0.NUM1 - var6_0.SPEED_CONST * (var3_2 - var6_0.NUM1)

	return var2_2 / var3_2 * var4_2
end

function var0_0.GetFleetReload(arg0_3)
	local var0_3 = var6_0.NUM0

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		var0_3 = var0_3 + iter1_3:GetReload()
	end

	return var0_3
end

function var0_0.GetFleetTorpedoPower(arg0_4)
	local var0_4 = var6_0.NUM0

	for iter0_4, iter1_4 in ipairs(arg0_4) do
		var0_4 = var0_4 + iter1_4:GetTorpedoPower()
	end

	return var0_4
end

function var0_0.AttrFixer(arg0_5, arg1_5)
	if arg0_5 == SYSTEM_DUEL then
		local var0_5 = arg1_5.level
		local var1_5 = arg1_5.durability
		local var2_5, var3_5 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(arg0_5, var0_5)

		arg1_5.durability = var1_5 * var2_5 + var3_5
	end
end

function var0_0.HealFixer(arg0_6, arg1_6)
	local var0_6 = 1

	if arg0_6 == SYSTEM_DUEL then
		local var1_6 = arg1_6.level

		var0_6 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(arg0_6, var1_6)
	end

	return var0_6
end

function var0_0.ConvertShipSpeed(arg0_7)
	return arg0_7 * var8_0
end

function var0_0.ConvertAircraftSpeed(arg0_8)
	if arg0_8 then
		return arg0_8 * var9_0
	else
		return nil
	end
end

function var0_0.ConvertBulletSpeed(arg0_9)
	return arg0_9 * var7_0
end

function var0_0.ConvertBulletDataSpeed(arg0_10)
	return arg0_10 / var7_0
end

function var0_0.CreateContextCalculateDamage(arg0_11)
	return function(arg0_12, arg1_12, arg2_12, arg3_12)
		local var0_12 = var6_0.NUM1
		local var1_12 = var6_0.NUM0
		local var2_12 = var6_0.NUM10000
		local var3_12 = var6_0.DRATE
		local var4_12 = var6_0.ACCURACY
		local var5_12 = arg0_12:GetWeaponHostAttr()
		local var6_12 = arg0_12:GetWeapon()
		local var7_12 = arg0_12:GetWeaponTempData()
		local var8_12 = var7_12.type
		local var9_12 = var7_12.attack_attribute
		local var10_12 = var6_12:GetConvertedAtkAttr()
		local var11_12 = arg0_12:GetTemplate()
		local var12_12 = var11_12.damage_type
		local var13_12 = var11_12.random_damage_rate
		local var14_12 = arg1_12._attr
		local var15_12 = arg3_12 or var0_12

		arg2_12 = arg2_12 or var1_12

		local var16_12 = var14_12.armorType
		local var17_12 = var5_12.formulaLevel - var14_12.formulaLevel
		local var18_12 = var0_12
		local var19_12 = false
		local var20_12 = false
		local var21_12 = var0_12
		local var22_12 = arg0_12:GetCorrectedDMG()
		local var23_12 = (var0_12 + arg0_12:GetWeaponAtkAttr() * var10_12) * var22_12

		if var9_12 == var1_0.WeaponDamageAttr.CANNON then
			var15_12 = var0_12 + var3_0.GetCurrent(arg1_12, "injureRatioByCannon") + var3_0.GetCurrent(arg0_12, "damageRatioByCannon")
		elseif var9_12 == var1_0.WeaponDamageAttr.TORPEDO then
			var15_12 = var0_12 + var3_0.GetCurrent(arg1_12, "injureRatioByBulletTorpedo") + var3_0.GetCurrent(arg0_12, "damageRatioByBulletTorpedo")
		elseif var9_12 == var1_0.WeaponDamageAttr.AIR then
			local var24_12 = var3_0.GetCurrent(arg0_12, "airResistPierceActive") == 1 and var3_0.GetCurrent(arg0_12, "airResistPierce") or 0

			var15_12 = var15_12 * math.min(var3_12[7] / (var14_12.antiAirPower + var3_12[7]) + var24_12, 1) * (var0_12 + var3_0.GetCurrent(arg1_12, "injureRatioByAir") + var3_0.GetCurrent(arg0_12, "damageRatioByAir"))
		elseif var9_12 == var1_0.WeaponDamageAttr.ANTI_AIR then
			-- block empty
		elseif var9_12 == var1_0.WeaponDamageAttr.ANIT_SUB then
			-- block empty
		end

		local var25_12 = var5_12.luck - var14_12.luck
		local var26_12 = var3_0.GetCurrent(arg1_12, "perfectDodge")
		local var27_12 = math.max(var5_12.attackRating, 0)
		local var28_12

		if var26_12 == 1 then
			var28_12 = true
		else
			local var29_12 = var4_12[1] + var27_12 / (var27_12 + var14_12.dodgeRate + var4_12[2]) + (var25_12 + var17_12) * var6_0.PERCENT1
			local var30_12 = var3_0.GetCurrent(arg0_12, "accuracyRateExtra")
			local var31_12 = var3_0.GetCurrent(arg0_12, var14_0[arg1_12:GetTemplate().type])
			local var32_12 = var3_0.GetCurrent(arg1_12, "dodgeRateExtra")
			local var33_12 = math.max(var3_12[5], math.min(var0_12, var29_12 + var30_12 + var31_12 - var32_12))

			var28_12 = not var0_0.IsHappen(var33_12 * var2_12)
		end

		if not var28_12 then
			local var34_12
			local var35_12 = var3_0.GetCurrent(arg0_12, "GCT") == 1 and 1 or var6_0.DFT_CRIT_RATE + var27_12 / (var27_12 + var14_12.dodgeRate + var3_12[4]) + (var25_12 + var17_12) * var3_12[3] + var3_0.GetCurrent(arg0_12, "cri") + var3_0.GetTagAttrCri(arg0_12, arg1_12)

			var21_12 = math.random(var4_0.RANDOM_DAMAGE_MIN, var4_0.RANDOM_DAMAGE_MAX) + var23_12

			if var0_0.IsHappen(var35_12 * var2_12) then
				var20_12 = true

				local var36_12 = var6_0.DFT_CRIT_EFFECT + var3_0.GetTagAttrCriDmg(arg0_12, arg1_12) + var3_0.GetCurrent(arg0_12, "criDamage") - var3_0.GetCurrent(arg1_12, "criDamageResist")

				var18_12 = math.max(1, var36_12)
			else
				var20_12 = false
			end
		else
			var21_12 = var1_12

			local var37_12 = {
				isMiss = true,
				isDamagePrevent = false,
				isCri = var20_12
			}

			return var21_12, var37_12
		end

		local var38_12 = var6_0.NUM1
		local var39_12 = var3_0.GetCurrent(arg0_12, "damageRatioBullet")
		local var40_12 = var3_0.GetTagAttr(arg0_12, arg1_12, arg0_11)
		local var41_12 = var3_0.GetCurrent(arg1_12, "injureRatio")
		local var42_12 = (var6_12:GetFixAmmo() or var12_12[var16_12] or var38_12) + var3_0.GetCurrent(arg0_12, var4_0.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE[var16_12])
		local var43_12 = var3_0.GetCurrent(arg0_12, var4_0.DAMAGE_TO_ARMOR_RATE_ENHANCE[var16_12])
		local var44_12 = var3_0.GetCurrent(arg0_12, var12_0[var11_12.ammo_type])
		local var45_12 = var3_0.GetCurrent(arg1_12, var13_0[var11_12.ammo_type])
		local var46_12 = var3_0.GetCurrent(arg0_12, "comboTag")
		local var47_12 = var3_0.GetCurrent(arg1_12, var46_12)
		local var48_12 = math.max(var38_12, math.floor(var21_12 * var15_12 * (var38_12 - arg2_12) * var42_12 * (var38_12 + var43_12) * var18_12 * (var38_12 + var39_12) * var40_12 * (var38_12 + var41_12) * (var38_12 + var44_12 - var45_12) * (var38_12 + var47_12) * (var38_12 + math.min(var3_12[1], math.max(-var3_12[1], var17_12)) * var3_12[2])))

		if arg1_12:GetCurrentOxyState() == var1_0.OXY_STATE.DIVE then
			var48_12 = math.floor(var48_12 * var11_12.antisub_enhancement)
		end

		local var49_12 = {
			isMiss = var28_12,
			isCri = var20_12,
			damageAttr = var9_12
		}
		local var50_12 = arg0_12:GetDamageEnhance()

		if var50_12 ~= 1 then
			var48_12 = math.floor(var48_12 * var50_12)
		end

		local var51_12 = var48_12 * var14_12.repressReduce

		if var13_12 ~= 0 then
			var51_12 = var51_12 * (Mathf.RandomFloat(var13_12) + 1)
		end

		local var52_12 = var3_0.GetCurrent(arg0_12, "damageEnhanceProjectile")
		local var53_12 = math.max(0, var51_12 + var52_12)

		if arg0_11 then
			var53_12 = var53_12 * (var6_0.NUM1 + var3_0.GetCurrent(arg0_12, "worldBuffResistance"))
		end

		local var54_12 = math.floor(var53_12)
		local var55_12 = var11_12.DMG_font[var16_12]

		if var52_12 < 0 then
			var55_12 = var4_0.BULLET_DECREASE_DMG_FONT
		end

		return var54_12, var49_12, var55_12
	end
end

function var0_0.CalculateIgniteDamage(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13._attr

	return arg0_13:GetWeapon():GetCorrectedDMG() * (1 + var0_13[arg1_13] * var6_0.PERCENT) * arg2_13
end

function var0_0.WeaponDamagePreCorrection(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetTemplateData()
	local var1_14 = arg1_14 or var0_14.damage
	local var2_14 = var0_14.corrected

	return var1_14 * arg0_14:GetPotential() * var2_14 * var6_0.PERCENT
end

function var0_0.WeaponAtkAttrPreRatio(arg0_15)
	return arg0_15:GetTemplateData().attack_attribute_ratio * var6_0.PERCENT2
end

function var0_0.GetMeteoDamageRatio(arg0_16)
	local var0_16 = {}
	local var1_16 = var6_0.METEO_RATE
	local var2_16 = var1_16[1]

	if arg0_16 >= var1_16[2] then
		for iter0_16 = 1, arg0_16 + 1 do
			var0_16[iter0_16] = var2_16
		end

		return var0_16
	else
		local var3_16 = 1 - var2_16 * arg0_16

		for iter1_16 = 1, arg0_16 do
			local var4_16 = math.random() * var3_16 * (var1_16[3] + var1_16[4] * (iter1_16 - 1) / arg0_16)

			var0_16[iter1_16] = var4_16 + var2_16
			var3_16 = math.max(0, var3_16 - var4_16)
		end

		var0_16[arg0_16 + 1] = var3_16

		return var0_16
	end
end

function var0_0.CalculateFleetAntiAirTotalDamage(arg0_17)
	local var0_17 = arg0_17:GetCrewUnitList()
	local var1_17 = 0

	for iter0_17, iter1_17 in pairs(var0_17) do
		local var2_17 = var3_0.GetCurrent(iter0_17, "antiAirPower")

		for iter2_17, iter3_17 in ipairs(iter1_17) do
			local var3_17 = iter3_17:GetConvertedAtkAttr()
			local var4_17 = iter3_17:GetCorrectedDMG()

			var1_17 = var1_17 + math.max(1, (var2_17 * var3_17 + 1) * var4_17)
		end
	end

	return var1_17
end

function var0_0.CalculateRepaterAnitiAirTotalDamage(arg0_18)
	local var0_18 = arg0_18:GetHost()
	local var1_18 = arg0_18:GetConvertedAtkAttr()
	local var2_18 = arg0_18:GetCorrectedDMG()
	local var3_18 = var3_0.GetCurrent(var0_18, "antiAirPower")

	return (math.max(1, (var3_18 * var1_18 + 1) * var2_18))
end

function var0_0.RollRepeaterHitDice(arg0_19, arg1_19)
	local var0_19 = arg0_19:GetHost()
	local var1_19 = var3_0.GetCurrent(var0_19, "antiAirPower")
	local var2_19 = math.max(var3_0.GetCurrent(var0_19, "attackRating"), 0)
	local var3_19 = var3_0.GetCurrent(arg1_19, "airPower")
	local var4_19 = var3_0.GetCurrent(arg1_19, "dodgeLimit")
	local var5_19 = var3_0.GetCurrent(arg1_19, "dodge")
	local var6_19 = var3_19 / var5_0.const_A + var5_0.const_B
	local var7_19 = var6_19 / (var1_19 * var5_19 + var6_19 + var5_0.const_C)
	local var8_19 = math.min(var4_19, var7_19)

	return var0_0.IsHappen(var8_19 * var6_0.NUM10000)
end

function var0_0.AntiAirPowerWeight(arg0_20)
	return arg0_20 * arg0_20
end

function var0_0.CalculateDamageFromAircraftToMainShip(arg0_21, arg1_21)
	local var0_21 = var3_0.GetCurrent(arg0_21, "airPower")
	local var1_21 = var3_0.GetCurrent(arg1_21, "antiAirPower")
	local var2_21 = var3_0.GetCurrent(arg0_21, "crashDMG")
	local var3_21 = arg0_21:GetHPRate()
	local var4_21 = var3_0.GetCurrent(arg0_21, "formulaLevel")
	local var5_21 = var3_0.GetCurrent(arg1_21, "formulaLevel")
	local var6_21 = var3_0.GetCurrent(arg1_21, "injureRatio")
	local var7_21 = var3_0.GetCurrent(arg1_21, "injureRatioByAir")
	local var8_21 = var6_0.PLANE_LEAK_RATE
	local var9_21 = math.max(var8_21[1], math.floor((var2_21 * (var8_21[2] + var0_21 * var8_21[3]) + var4_21 * var8_21[4]) * (var3_21 * var8_21[5] + var8_21[6]) * (var8_21[7] + (var4_21 - var5_21) * var8_21[8]) * (var8_21[9] / (var1_21 + var8_21[10])) * (var8_21[11] + var6_21) * (var8_21[12] + var7_21)))

	return (math.floor(var9_21 * var3_0.GetCurrent(arg1_21, "repressReduce")))
end

function var0_0.CalculateDamageFromShipToMainShip(arg0_22, arg1_22)
	local var0_22 = var3_0.GetCurrent(arg0_22, "cannonPower")
	local var1_22 = var3_0.GetCurrent(arg0_22, "torpedoPower")
	local var2_22 = arg0_22:GetHPRate()
	local var3_22 = var3_0.GetCurrent(arg0_22, "formulaLevel")
	local var4_22 = var3_0.GetCurrent(arg1_22, "formulaLevel")
	local var5_22 = var3_0.GetCurrent(arg1_22, "injureRatio")
	local var6_22 = var6_0.LEAK_RATE
	local var7_22 = math.max(var6_22[1], math.floor(((var0_22 + var1_22) * var6_22[2] + var3_22 * var6_22[7]) * (var6_22[5] + var5_22) * (var2_22 * var6_22[3] + var6_22[4]) * (var6_22[5] + (var3_22 - var4_22) * var6_22[6])))

	return (math.floor(var7_22 * var3_0.GetCurrent(arg1_22, "repressReduce")))
end

function var0_0.CalculateDamageFromSubmarinToMainShip(arg0_23, arg1_23)
	local var0_23 = var3_0.GetCurrent(arg0_23, "torpedoPower")
	local var1_23 = arg0_23:GetHPRate()
	local var2_23 = var3_0.GetCurrent(arg0_23, "formulaLevel")
	local var3_23 = var3_0.GetCurrent(arg1_23, "formulaLevel")
	local var4_23 = var3_0.GetCurrent(arg1_23, "injureRatio")
	local var5_23 = var6_0.SUBMARINE_KAMIKAZE

	return (math.max(var5_23[1], math.floor((var0_23 * var5_23[2] + var2_23 * var5_23[3]) * (var5_23[4] + var4_23) * (var1_23 * var5_23[5] + var5_23[6]) * (var5_23[7] + (var2_23 - var3_23) * var5_23[8]))))
end

function var0_0.RollSubmarineDualDice(arg0_24)
	local var0_24 = var3_0.GetCurrent(arg0_24, "dodgeRate")
	local var1_24 = var0_24 / (var0_24 + var4_0.MONSTER_SUB_KAMIKAZE_DUAL_K) * var4_0.MONSTER_SUB_KAMIKAZE_DUAL_P

	return var0_0.IsHappen(var1_24 * var6_0.NUM10000)
end

function var0_0.CalculateCrashDamage(arg0_25, arg1_25)
	local var0_25 = var3_0.GetCurrent(arg0_25, "maxHP")
	local var1_25 = var3_0.GetCurrent(arg1_25, "maxHP")
	local var2_25 = var0_25 * var6_0.CRASH_RATE[1]
	local var3_25 = var1_25 * var6_0.CRASH_RATE[1]
	local var4_25 = var3_0.GetCurrent(arg0_25, "hammerDamageRatio")
	local var5_25 = var3_0.GetCurrent(arg1_25, "hammerDamageRatio")
	local var6_25 = var3_0.GetCurrent(arg0_25, "hammerDamagePrevent")
	local var7_25 = var3_0.GetCurrent(arg1_25, "hammerDamagePrevent")
	local var8_25 = math.min(var6_25, var4_0.HammerCFG.PreventUpperBound)
	local var9_25 = math.min(var7_25, var4_0.HammerCFG.PreventUpperBound)
	local var10_25 = math.sqrt(var0_25 * var1_25) * var6_0.CRASH_RATE[2]
	local var11_25 = math.min(var2_25, var10_25)
	local var12_25 = math.min(var3_25, var10_25)
	local var13_25 = math.floor(var11_25 * (1 + var5_25) * (1 - var8_25))
	local var14_25 = math.floor(var13_25 * var3_0.GetCurrent(arg0_25, "repressReduce"))
	local var15_25 = math.floor(var12_25 * (1 + var4_25) * (1 - var9_25))
	local var16_25 = math.floor(var15_25 * var3_0.GetCurrent(arg1_25, "repressReduce"))

	return var14_25, var16_25
end

function var0_0.CalculateFleetDamage(arg0_26)
	return arg0_26 * var6_0.SCORE_RATE[1]
end

function var0_0.CalculateFleetOverDamage(arg0_27, arg1_27)
	if arg1_27 == arg0_27:GetFlagShip() then
		return var3_0.GetCurrent(arg1_27, "maxHP") * var6_0.SCORE_RATE[2]
	else
		return var3_0.GetCurrent(arg1_27, "maxHP") * var6_0.SCORE_RATE[3]
	end
end

function var0_0.CalculateReloadTime(arg0_28, arg1_28)
	return arg0_28 / var4_0.K1 / math.sqrt((arg1_28 + var4_0.K2) * var4_0.K3)
end

function var0_0.CaclulateReloaded(arg0_29, arg1_29)
	return math.sqrt((arg1_29 + var4_0.K2) * var4_0.K3) * arg0_29 * var4_0.K1
end

function var0_0.CaclulateReloadAttr(arg0_30, arg1_30)
	local var0_30 = arg0_30 / var4_0.K1 / arg1_30

	return math.max(var0_30 * var0_30 / var4_0.K3 - var4_0.K2, 0)
end

function var0_0.CaclulateAirAssistReloadMax(arg0_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in ipairs(arg0_31) do
		var0_31 = var0_31 + iter1_31:GetTemplateData().reload_max
	end

	return var0_31 / #arg0_31 * var10_0
end

function var0_0.CaclulateDOTPlace(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = arg1_32.arg_list

	if var0_32.tagOnly and not arg3_32:ContainsLabelTag(var0_32.tagOnly) then
		return false
	end

	local var1_32 = var4_0.DOT_CONFIG[var0_32.dotType]
	local var2_32 = arg2_32 and arg2_32:GetAttrByName(var1_32.hit) or var6_0.NUM0
	local var3_32 = arg3_32 and arg3_32:GetAttrByName(var1_32.resist) or var6_0.NUM0

	return var0_0.IsHappen(arg0_32 * (var6_0.NUM1 + var2_32) * (var6_0.NUM1 - var3_32))
end

function var0_0.CaclulateDOTDuration(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.arg_list
	local var1_33 = var4_0.DOT_CONFIG[var0_33.dotType]

	return (arg1_33 and arg1_33:GetAttrByName(var1_33.prolong) or var6_0.NUM0) - (arg2_33 and arg2_33:GetAttrByName(var1_33.shorten) or var6_0.NUM0)
end

function var0_0.CaclulateDOTDamageEnhanceRate(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.arg_list
	local var1_34 = var4_0.DOT_CONFIG[var0_34.dotType]

	return ((arg1_34 and arg1_34:GetAttrByName(var1_34.enhance) or var6_0.NUM0) - (arg2_34 and arg2_34:GetAttrByName(var1_34.reduce) or var6_0.NUM0)) * var6_0.PERCENT2
end

function var0_0.CaclulateMetaDotaDamage(arg0_35, arg1_35)
	local var0_35 = ys.Battle.BattleDataFunction.GetMetaBossTemplate(arg0_35)

	if type(var0_35.state) == "string" then
		return 0
	end

	local var1_35 = var0_35.state
	local var2_35 = os.time({
		year = var1_35[1][1][1],
		month = var1_35[1][1][2],
		day = var1_35[1][1][3],
		hour = var1_35[1][2][1],
		minute = var1_35[1][2][2],
		second = var1_35[1][2][3]
	})
	local var3_35 = os.time({
		year = var1_35[2][1][1],
		month = var1_35[2][1][2],
		day = var1_35[2][1][3],
		hour = var1_35[2][2][1],
		minute = var1_35[2][2][2],
		second = var1_35[2][2][3]
	})
	local var4_35 = os.difftime(var3_35, var2_35)
	local var5_35 = math.floor(var4_35 / 86400)
	local var6_35 = math.floor(os.difftime(pg.TimeMgr.GetInstance():GetServerTime(), var2_35) / 86400)
	local var7_35 = pg.gameset.world_metaboss_supportattack.description
	local var8_35 = var7_35[1]
	local var9_35 = var5_35 - var7_35[2]
	local var10_35 = var7_35[3]
	local var11_35 = var7_35[4]
	local var12_35 = var7_35[5]
	local var13_35 = ys.Battle.BattleDataFunction.GetMetaBossLevelTemplate(arg0_35, arg1_35).hp
	local var14_35 = math.floor(var13_35 * var10_35 / var12_35 / (1 + 0.5 * var11_35) / (var9_35 - var8_35) * math.min(var6_35 - var8_35 + 1, var9_35 - var8_35))

	return var14_35 + math.random(math.floor(var11_35 * var14_35))
end

function var0_0.CalculateMaxAimBiasRange(arg0_36)
	local var0_36 = var4_0.AIM_BIAS_FLEET_RANGE_MOD
	local var1_36

	if #arg0_36 == 1 then
		local var2_36 = arg0_36[1]

		var1_36 = var3_0.GetCurrent(arg0_36[1], "dodgeRate") * var0_36
	else
		local var3_36 = {}

		for iter0_36, iter1_36 in ipairs(arg0_36) do
			table.insert(var3_36, var3_0.GetCurrent(iter1_36, "dodgeRate"))
		end

		table.sort(var3_36, function(arg0_37, arg1_37)
			return arg1_37 < arg0_37
		end)

		var1_36 = (var3_36[1] + var3_36[2] * 0.6 + (var3_36[3] or 0) * 0.3) / #var3_36 * var0_36
	end

	return (math.min(var1_36, var4_0.AIM_BIAS_MAX_RANGE_SCOUT))
end

function var0_0.CalculateMaxAimBiasRangeSub(arg0_38)
	local var0_38 = var3_0.GetCurrent(arg0_38[1], "dodgeRate") * var4_0.AIM_BIAS_SUB_RANGE_MOD

	return (math.min(var0_38, var4_0.AIM_BIAS_MAX_RANGE_SUB))
end

function var0_0.CalculateMaxAimBiasRangeMonster(arg0_39)
	local var0_39 = var3_0.GetCurrent(arg0_39[1], "dodgeRate") * var4_0.AIM_BIAS_MONSTER_RANGE_MOD

	return (math.min(var0_39, var4_0.AIM_BIAS_MAX_RANGE_MONSTER))
end

function var0_0.CalculateBiasDecay(arg0_40)
	local var0_40 = arg0_40 * var4_0.AIM_BIAS_DECAY_MOD_MONSTER

	return (math.min(var0_40, var4_0.AIM_BIAS_DECAY_SPEED_MAX_SCOUT))
end

function var0_0.CalculateBiasDecayMonster(arg0_41)
	local var0_41 = arg0_41 * var4_0.AIM_BIAS_DECAY_MOD

	return (math.min(var0_41, var4_0.AIM_BIAS_DECAY_SPEED_MAX_MONSTER))
end

function var0_0.CalculateBiasDecayMonsterInSmoke(arg0_42)
	local var0_42 = arg0_42 * var4_0.AIM_BIAS_DECAY_MOD * var4_0.AIM_BIAS_DECAY_SMOKE

	return (math.min(var0_42, var4_0.AIM_BIAS_DECAY_SPEED_MAX_MONSTER))
end

function var0_0.CalculateBiasDecayDiving(arg0_43)
	local var0_43 = math.max(0, arg0_43 - var4_0.AIM_BIAS_DECAY_SUB_CONST) * var4_0.AIM_BIAS_DECAY_MOD

	return (math.min(var0_43, var4_0.AIM_BIAS_DECAY_SPEED_MAX_SUB))
end

function var0_0.WorldEnemyAttrEnhance(arg0_44, arg1_44)
	return 1 + arg0_44 / (1 + var4_0.WORLD_ENEMY_ENHANCEMENT_CONST_C^(var4_0.WORLD_ENEMY_ENHANCEMENT_CONST_B - arg1_44))
end

local var15_0 = setmetatable({}, {
	__index = function(arg0_45, arg1_45)
		return 0
	end
})

function var0_0.WorldMapRewardAttrEnhance(arg0_46, arg1_46)
	arg0_46 = arg0_46 or var15_0
	arg1_46 = arg1_46 or var15_0

	local var0_46
	local var1_46
	local var2_46
	local var3_46 = {
		{
			var2_0.attr_world_value_X1.key_value / 10000,
			var2_0.attr_world_value_X2.key_value / 10000
		},
		{
			var2_0.attr_world_value_Y1.key_value / 10000,
			var2_0.attr_world_value_Y2.key_value / 10000
		},
		{
			var2_0.attr_world_value_Z1.key_value / 10000,
			var2_0.attr_world_value_Z2.key_value / 10000
		}
	}
	local var4_46 = var2_0.attr_world_damage_fix.key_value / 10000
	local var5_46

	if arg0_46[1] == 0 then
		var5_46 = var3_46[1][2]
	else
		var5_46 = arg1_46[1] / arg0_46[1]
	end

	local var6_46 = 1 - math.clamp(var5_46, var3_46[1][1], var3_46[1][2])

	if arg0_46[2] == 0 then
		var5_46 = var3_46[2][2]
	else
		var5_46 = arg1_46[2] / arg0_46[2]
	end

	local var7_46 = 1 - math.clamp(var5_46, var3_46[2][1], var3_46[2][2])

	if arg0_46[3] == 0 then
		var5_46 = var3_46[3][2]
	else
		var5_46 = arg1_46[3] / arg0_46[3]
	end

	local var8_46 = math.max(1 - math.clamp(var5_46, var3_46[3][1], var3_46[3][2]), -var4_46)

	return var6_46, var7_46, var8_46
end

function var0_0.WorldMapRewardHealingRate(arg0_47, arg1_47)
	local var0_47 = {
		var2_0.attr_world_value_H1.key_value / 10000,
		var2_0.attr_world_value_H2.key_value / 10000
	}

	arg0_47 = arg0_47 or var15_0
	arg1_47 = arg1_47 or var15_0

	local var1_47

	if arg0_47[3] == 0 then
		var1_47 = var0_47[2]
	else
		var1_47 = arg1_47[3] / arg0_47[3]
	end

	return math.clamp(var1_47, var0_47[1], var0_47[2])
end

function var0_0.CalcDamageLock()
	return 0, {
		false,
		true,
		false
	}
end

function var0_0.CalcDamageLockA2M()
	return 0
end

function var0_0.CalcDamageLockS2M()
	return 0
end

function var0_0.CalcDamageLockCrush()
	return 0, 0
end

function var0_0.UnilateralCrush()
	return 0, 100000
end

function var0_0.ChapterRepressReduce(arg0_53)
	return 1 - arg0_53 * 0.01
end

function var0_0.IsHappen(arg0_54)
	if arg0_54 <= 0 then
		return false
	elseif arg0_54 >= 10000 then
		return true
	else
		return arg0_54 >= math.random(10000)
	end
end

function var0_0.WeightRandom(arg0_55)
	local var0_55, var1_55 = var0_0.GenerateWeightList(arg0_55)

	return (var0_0.WeightListRandom(var0_55, var1_55))
end

function var0_0.WeightListRandom(arg0_56, arg1_56)
	local var0_56 = math.random(0, arg1_56)

	for iter0_56, iter1_56 in pairs(arg0_56) do
		local var1_56 = iter0_56.min
		local var2_56 = iter0_56.max

		if var1_56 <= var0_56 and var0_56 <= var2_56 then
			return iter1_56
		end
	end
end

function var0_0.GenerateWeightList(arg0_57)
	local var0_57 = {}
	local var1_57 = -1

	for iter0_57, iter1_57 in ipairs(arg0_57) do
		local var2_57 = iter1_57.weight
		local var3_57 = iter1_57.rst
		local var4_57 = var1_57 + 1
		local var5_57

		var1_57 = var1_57 + var2_57

		local var6_57 = var1_57

		var0_57[{
			min = var4_57,
			max = var6_57
		}] = var3_57
	end

	return var0_57, var1_57
end

function var0_0.IsListHappen(arg0_58)
	for iter0_58, iter1_58 in ipairs(arg0_58) do
		if var0_0.IsHappen(iter1_58[1]) then
			return true, iter1_58[2]
		end
	end

	return false, nil
end

function var0_0.BulletYAngle(arg0_59, arg1_59)
	return math.rad2Deg * math.atan2(arg1_59.z - arg0_59.z, arg1_59.x - arg0_59.x)
end

function var0_0.RandomPosNull(arg0_60, arg1_60)
	arg1_60 = arg1_60 or 10

	local var0_60 = arg0_60.distance or 10
	local var1_60 = var0_60 * var0_60
	local var2_60 = ys.Battle.BattleTargetChoise.TargetAll()
	local var3_60
	local var4_60

	for iter0_60 = 1, arg1_60 do
		local var5_60 = true
		local var6_60 = var0_0.RandomPos(arg0_60)

		for iter1_60, iter2_60 in pairs(var2_60) do
			local var7_60 = iter2_60:GetPosition()

			if var1_60 > Vector3.SqrDistance(var6_60, var7_60) then
				var5_60 = false

				break
			end
		end

		if var5_60 then
			return var6_60
		end
	end

	return nil
end

function var0_0.RandomPos(arg0_61)
	local var0_61 = arg0_61[1] or 0
	local var1_61 = arg0_61[2] or 0
	local var2_61 = arg0_61[3] or 0

	if arg0_61.rangeX or arg0_61.rangeY or arg0_61.rangeZ then
		local var3_61 = var0_0.RandomDelta(arg0_61.rangeX)
		local var4_61 = var0_0.RandomDelta(arg0_61.rangeY)
		local var5_61 = var0_0.RandomDelta(arg0_61.rangeZ)

		return Vector3(var0_61 + var3_61, var1_61 + var4_61, var2_61 + var5_61)
	else
		local var6_61 = var0_0.RandomPosXYZ(arg0_61, "X1", "X2")
		local var7_61 = var0_0.RandomPosXYZ(arg0_61, "Y1", "Y2")
		local var8_61 = var0_0.RandomPosXYZ(arg0_61, "Z1", "Z2")

		return Vector3(var0_61 + var6_61, var1_61 + var7_61, var2_61 + var8_61)
	end
end

function var0_0.RandomPosXYZ(arg0_62, arg1_62, arg2_62)
	arg1_62 = arg0_62[arg1_62]
	arg2_62 = arg0_62[arg2_62]

	if arg1_62 and arg2_62 then
		return math.random(arg1_62, arg2_62)
	else
		return 0
	end
end

function var0_0.RandomPosCenterRange(arg0_63)
	local var0_63 = var0_0.RandomDelta(arg0_63.rangeX)
	local var1_63 = var0_0.RandomDelta(arg0_63.rangeY)
	local var2_63 = var0_0.RandomDelta(arg0_63.rangeZ)

	return Vector3(var0_63, var1_63, var2_63)
end

function var0_0.RandomDelta(arg0_64)
	if arg0_64 and arg0_64 > 0 then
		return math.random(arg0_64 + arg0_64) - arg0_64
	else
		return 0
	end
end

function var0_0.simpleCompare(arg0_65, arg1_65)
	local var0_65, var1_65 = string.find(arg0_65, "%p+")
	local var2_65 = string.sub(arg0_65, var0_65, var1_65)
	local var3_65 = string.sub(arg0_65, var1_65 + 1, #arg0_65)
	local var4_65 = getCompareFuncByPunctuation(var2_65)
	local var5_65 = tonumber(var3_65)

	return var4_65(arg1_65, var5_65)
end

function var0_0.parseCompareUnitAttr(arg0_66, arg1_66, arg2_66)
	local var0_66, var1_66 = string.find(arg0_66, "%p+")
	local var2_66 = string.sub(arg0_66, var0_66, var1_66)
	local var3_66 = string.sub(arg0_66, 1, var0_66 - 1)
	local var4_66 = string.sub(arg0_66, var1_66 + 1, #arg0_66)
	local var5_66 = getCompareFuncByPunctuation(var2_66)
	local var6_66 = tonumber(var3_66) or arg1_66:GetAttrByName(var3_66)
	local var7_66 = tonumber(var4_66) or arg2_66:GetAttrByName(var4_66)

	return var5_66(var6_66, var7_66)
end

function var0_0.parseCompareUnitTemplate(arg0_67, arg1_67, arg2_67)
	local var0_67, var1_67 = string.find(arg0_67, "%p+")
	local var2_67 = string.sub(arg0_67, var0_67, var1_67)
	local var3_67 = string.sub(arg0_67, 1, var0_67 - 1)
	local var4_67 = string.sub(arg0_67, var1_67 + 1, #arg0_67)
	local var5_67 = getCompareFuncByPunctuation(var2_67)
	local var6_67 = tonumber(var3_67) or arg1_67:GetTemplateValue(var3_67)
	local var7_67 = tonumber(var4_67) or arg2_67:GetTemplateValue(var4_67)

	return var5_67(var6_67, var7_67)
end

function var0_0.parseCompareBuffAttachData(arg0_68, arg1_68)
	local var0_68, var1_68 = string.find(arg0_68, "%p+")
	local var2_68 = string.sub(arg0_68, var0_68, var1_68)
	local var3_68 = string.sub(arg0_68, 1, var0_68 - 1)

	if arg1_68.__name ~= var3_68 then
		return true
	end

	local var4_68 = tonumber(string.sub(arg0_68, var1_68 + 1, #arg0_68))
	local var5_68 = arg1_68:GetEffectAttachData()

	return getCompareFuncByPunctuation(var2_68)(var5_68, var4_68)
end

function var0_0.parseCompare(arg0_69, arg1_69)
	local var0_69, var1_69 = string.find(arg0_69, "%p+")
	local var2_69 = string.sub(arg0_69, var0_69, var1_69)
	local var3_69 = string.sub(arg0_69, 1, var0_69 - 1)
	local var4_69 = string.sub(arg0_69, var1_69 + 1, #arg0_69)
	local var5_69 = getCompareFuncByPunctuation(var2_69)
	local var6_69 = tonumber(var3_69) or arg1_69:GetCurrent(var3_69)
	local var7_69 = tonumber(var4_69) or arg1_69:GetCurrent(var4_69)

	return var5_69(var6_69, var7_69)
end

function var0_0.parseFormula(arg0_70, arg1_70)
	local var0_70 = {}
	local var1_70 = {}

	for iter0_70 in string.gmatch(arg0_70, "%w+%.?%w*") do
		table.insert(var0_70, iter0_70)
	end

	for iter1_70 in string.gmatch(arg0_70, "[^%w%.]") do
		table.insert(var1_70, iter1_70)
	end

	local var2_70 = {}
	local var3_70 = {}
	local var4_70 = 1
	local var5_70 = var0_70[1]

	var5_70 = tonumber(var5_70) or arg1_70:GetCurrent(var5_70)

	for iter2_70, iter3_70 in ipairs(var1_70) do
		var4_70 = var4_70 + 1

		local var6_70 = tonumber(var0_70[var4_70]) or arg1_70:GetCurrent(var0_70[var4_70])

		if iter3_70 == "+" or iter3_70 == "-" then
			table.insert(var3_70, var5_70)

			var5_70 = var6_70

			table.insert(var2_70, iter3_70)
		elseif iter3_70 == "*" or iter3_70 == "/" then
			var5_70 = getArithmeticFuncByOperator(iter3_70)(var5_70, var6_70)
		end
	end

	table.insert(var3_70, var5_70)

	local var7_70 = 1
	local var8_70 = var3_70[var7_70]

	while var7_70 < #var3_70 do
		local var9_70 = getArithmeticFuncByOperator(var2_70[var7_70])

		var7_70 = var7_70 + 1
		var8_70 = var9_70(var8_70, var3_70[var7_70])
	end

	return var8_70
end
