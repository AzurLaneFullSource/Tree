ys.Battle.BattleCardPuzzleFormulas = ys.Battle.BattleCardPuzzleFormulas or {}

local var0_0 = ys.Battle.BattleCardPuzzleFormulas
local var1_0 = ys.Battle.BattleConst
local var2_0 = pg.gameset
local var3_0 = ys.Battle.BattleAttr
local var4_0 = ys.Battle.BattleConfig
local var5_0 = ys.Battle.BattleConfig.AnitAirRepeaterConfig
local var6_0 = pg.bfConsts
local var7_0 = var4_0.AMMO_DAMAGE_ENHANCE
local var8_0 = var4_0.AMMO_DAMAGE_REDUCE

var0_0.CUSTOM_FORMULA = {
	double_energy = "energy*5+combo+2"
}

function var0_0.CreateContextCalculateDamage(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = var6_0.NUM1
	local var1_1 = var6_0.NUM0
	local var2_1 = var6_0.NUM10000
	local var3_1 = var6_0.DRATE
	local var4_1 = var6_0.ACCURACY
	local var5_1 = arg0_1:GetWeaponHostAttr()
	local var6_1 = arg0_1:GetWeapon()
	local var7_1 = arg0_1:GetWeaponTempData()
	local var8_1 = var7_1.type
	local var9_1 = var7_1.attack_attribute
	local var10_1 = var6_1:GetConvertedAtkAttr()
	local var11_1 = arg0_1:GetTemplate()
	local var12_1 = var11_1.damage_type
	local var13_1 = var11_1.random_damage_rate
	local var14_1 = arg1_1._attr
	local var15_1 = arg3_1 or var0_1

	arg2_1 = arg2_1 or var1_1

	local var16_1 = var14_1.armorType
	local var17_1 = var5_1.formulaLevel - var14_1.formulaLevel
	local var18_1 = var0_1
	local var19_1 = false
	local var20_1 = false
	local var21_1 = var0_1
	local var22_1 = arg0_1:GetCorrectedDMG()
	local var23_1 = (var0_1 + arg0_1:GetWeaponAtkAttr() * var10_1) * var22_1

	if var9_1 == var1_0.WeaponDamageAttr.CANNON then
		var15_1 = var0_1 + var3_0.GetCurrent(arg1_1, "injureRatioByCannon") + var3_0.GetCurrent(arg0_1, "damageRatioByCannon")
	elseif var9_1 == var1_0.WeaponDamageAttr.TORPEDO then
		var15_1 = var0_1 + var3_0.GetCurrent(arg1_1, "injureRatioByBulletTorpedo") + var3_0.GetCurrent(arg0_1, "damageRatioByBulletTorpedo")
	elseif var9_1 == var1_0.WeaponDamageAttr.AIR then
		local var24_1 = var3_0.GetCurrent(arg0_1, "airResistPierceActive") == 1 and var3_0.GetCurrent(arg0_1, "airResistPierce") or 0

		var15_1 = var15_1 * math.min(var3_1[7] / (var14_1.antiAirPower + var3_1[7]) + var24_1, 1) * (var0_1 + var3_0.GetCurrent(arg1_1, "injureRatioByAir") + var3_0.GetCurrent(arg0_1, "damageRatioByAir"))
	elseif var9_1 == var1_0.WeaponDamageAttr.ANTI_AIR then
		-- block empty
	elseif var9_1 == var1_0.WeaponDamageAttr.ANIT_SUB then
		-- block empty
	end

	local var25_1 = var5_1.luck - var14_1.luck

	if var3_0.GetCurrent(arg1_1, "perfectDodge") == 1 then
		var19_1 = true
	end

	if not var19_1 then
		var21_1 = var23_1

		if var3_0.GetCurrent(arg0_1, "GCT") == 1 then
			var20_1 = true
			var18_1 = math.max(1, var6_0.DFT_CRIT_EFFECT + var3_0.GetCurrent(arg0_1, "criDamage") - var3_0.GetCurrent(arg1_1, "criDamageResist"))
		else
			var20_1 = false
		end
	else
		var21_1 = var1_1

		local var26_1 = {
			isMiss = true,
			isDamagePrevent = false,
			isCri = var20_1
		}

		return var21_1, var26_1
	end

	local var27_1 = var6_0.NUM1
	local var28_1 = var3_0.GetCurrent(arg0_1, "damageRatioBullet")
	local var29_1 = var3_0.GetTagAttr(arg0_1, arg1_1)
	local var30_1 = var3_0.GetCurrent(arg1_1, "injureRatio")
	local var31_1 = (var6_1:GetFixAmmo() or var12_1[var16_1] or var27_1) + var3_0.GetCurrent(arg0_1, var4_0.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE[var16_1])
	local var32_1 = var3_0.GetCurrent(arg0_1, var4_0.DAMAGE_TO_ARMOR_RATE_ENHANCE[var16_1])
	local var33_1 = var3_0.GetCurrent(arg0_1, var7_0[var11_1.ammo_type])
	local var34_1 = var3_0.GetCurrent(arg1_1, var8_0[var11_1.ammo_type])
	local var35_1 = var3_0.GetCurrent(arg0_1, "comboTag")
	local var36_1 = var3_0.GetCurrent(arg1_1, var35_1)
	local var37_1 = math.max(var27_1, math.floor(var21_1 * var15_1 * (var27_1 - arg2_1) * var31_1 * (var27_1 + var32_1) * var18_1 * (var27_1 + var28_1) * var29_1 * (var27_1 + var30_1) * (var27_1 + var33_1 - var34_1) * (var27_1 + var36_1) * (var27_1 + math.min(var3_1[1], math.max(-var3_1[1], var17_1)) * var3_1[2])))

	if arg1_1:GetCurrentOxyState() == var1_0.OXY_STATE.DIVE then
		var37_1 = math.floor(var37_1 * var11_1.antisub_enhancement)
	end

	local var38_1 = {
		isMiss = var19_1,
		isCri = var20_1,
		damageAttr = var9_1
	}
	local var39_1 = arg0_1:GetDamageEnhance()

	if var39_1 ~= 1 then
		var37_1 = math.floor(var37_1 * var39_1)
	end

	local var40_1 = var37_1 * var14_1.repressReduce

	if var13_1 ~= 0 then
		var40_1 = var40_1 * (Mathf.RandomFloat(var13_1) + 1)
	end

	local var41_1 = var3_0.GetCurrent(arg0_1, "damageEnhanceProjectile")
	local var42_1 = math.max(0, var40_1 + var41_1) * arg0_1:GetWeaponCardPuzzleEnhance()
	local var43_1 = math.floor(var42_1)
	local var44_1 = var11_1.DMG_font[var16_1]

	if var41_1 < 0 then
		var44_1 = var4_0.BULLET_DECREASE_DMG_FONT
	end

	return var43_1, var38_1, var44_1
end

function var0_0.parseCompare(arg0_2, arg1_2)
	local var0_2, var1_2 = string.find(arg0_2, "%p+")
	local var2_2 = string.sub(arg0_2, var0_2, var1_2)
	local var3_2 = string.sub(arg0_2, 1, var0_2 - 1)
	local var4_2 = string.sub(arg0_2, var1_2 + 1, #arg0_2)
	local var5_2 = getCompareFuncByPunctuation(var2_2)
	local var6_2 = tonumber(var3_2) or arg1_2:GetCurrent(var3_2)
	local var7_2 = tonumber(var4_2) or arg1_2:GetCurrent(var4_2)

	return var5_2(var6_2, var7_2)
end

function var0_0.parseFormula(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = {}

	for iter0_3 in string.gmatch(arg0_3, "%w+%.?%w*") do
		table.insert(var0_3, iter0_3)
	end

	for iter1_3 in string.gmatch(arg0_3, "[^%w%.]") do
		table.insert(var1_3, iter1_3)
	end

	local var2_3 = {}
	local var3_3 = {}
	local var4_3 = 1
	local var5_3 = var0_3[1]

	var5_3 = tonumber(var5_3) or arg1_3:GetCurrent(var5_3)

	for iter2_3, iter3_3 in ipairs(var1_3) do
		var4_3 = var4_3 + 1

		local var6_3 = tonumber(var0_3[var4_3]) or arg1_3:GetCurrent(var0_3[var4_3])

		if iter3_3 == "+" or iter3_3 == "-" then
			table.insert(var3_3, var5_3)

			var5_3 = var6_3

			table.insert(var2_3, iter3_3)
		elseif iter3_3 == "*" or iter3_3 == "/" then
			var5_3 = getArithmeticFuncByOperator(iter3_3)(var5_3, var6_3)
		end
	end

	table.insert(var3_3, var5_3)

	local var7_3 = 1
	local var8_3 = var3_3[var7_3]

	while var7_3 < #var3_3 do
		local var9_3 = getArithmeticFuncByOperator(var2_3[var7_3])

		var7_3 = var7_3 + 1
		var8_3 = var9_3(var8_3, var3_3[var7_3])
	end

	return var8_3
end
