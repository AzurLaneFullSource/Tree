ys.Battle.BattleCardPuzzleFormulas = ys.Battle.BattleCardPuzzleFormulas or {}

local var0 = ys.Battle.BattleCardPuzzleFormulas
local var1 = ys.Battle.BattleConst
local var2 = pg.gameset
local var3 = ys.Battle.BattleAttr
local var4 = ys.Battle.BattleConfig
local var5 = ys.Battle.BattleConfig.AnitAirRepeaterConfig
local var6 = pg.bfConsts
local var7 = var4.AMMO_DAMAGE_ENHANCE
local var8 = var4.AMMO_DAMAGE_REDUCE

var0.CUSTOM_FORMULA = {
	double_energy = "energy*5+combo+2"
}

function var0.CreateContextCalculateDamage(arg0, arg1, arg2, arg3)
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

	if var3.GetCurrent(arg1, "perfectDodge") == 1 then
		var19 = true
	end

	if not var19 then
		var21 = var23

		if var3.GetCurrent(arg0, "GCT") == 1 then
			var20 = true
			var18 = math.max(1, var6.DFT_CRIT_EFFECT + var3.GetCurrent(arg0, "criDamage") - var3.GetCurrent(arg1, "criDamageResist"))
		else
			var20 = false
		end
	else
		var21 = var1

		local var26 = {
			isMiss = true,
			isDamagePrevent = false,
			isCri = var20
		}

		return var21, var26
	end

	local var27 = var6.NUM1
	local var28 = var3.GetCurrent(arg0, "damageRatioBullet")
	local var29 = var3.GetTagAttr(arg0, arg1)
	local var30 = var3.GetCurrent(arg1, "injureRatio")
	local var31 = (var6:GetFixAmmo() or var12[var16] or var27) + var3.GetCurrent(arg0, var4.DAMAGE_AMMO_TO_ARMOR_RATE_ENHANCE[var16])
	local var32 = var3.GetCurrent(arg0, var4.DAMAGE_TO_ARMOR_RATE_ENHANCE[var16])
	local var33 = var3.GetCurrent(arg0, var7[var11.ammo_type])
	local var34 = var3.GetCurrent(arg1, var8[var11.ammo_type])
	local var35 = var3.GetCurrent(arg0, "comboTag")
	local var36 = var3.GetCurrent(arg1, var35)
	local var37 = math.max(var27, math.floor(var21 * var15 * (var27 - arg2) * var31 * (var27 + var32) * var18 * (var27 + var28) * var29 * (var27 + var30) * (var27 + var33 - var34) * (var27 + var36) * (var27 + math.min(var3[1], math.max(-var3[1], var17)) * var3[2])))

	if arg1:GetCurrentOxyState() == var1.OXY_STATE.DIVE then
		var37 = math.floor(var37 * var11.antisub_enhancement)
	end

	local var38 = {
		isMiss = var19,
		isCri = var20,
		damageAttr = var9
	}
	local var39 = arg0:GetDamageEnhance()

	if var39 ~= 1 then
		var37 = math.floor(var37 * var39)
	end

	local var40 = var37 * var14.repressReduce

	if var13 ~= 0 then
		var40 = var40 * (Mathf.RandomFloat(var13) + 1)
	end

	local var41 = var3.GetCurrent(arg0, "damageEnhanceProjectile")
	local var42 = math.max(0, var40 + var41) * arg0:GetWeaponCardPuzzleEnhance()
	local var43 = math.floor(var42)
	local var44 = var11.DMG_font[var16]

	if var41 < 0 then
		var44 = var4.BULLET_DECREASE_DMG_FONT
	end

	return var43, var38, var44
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
