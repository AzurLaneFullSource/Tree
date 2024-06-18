local var0_0 = ys.Battle.BattleDataProxy
local var1_0 = ys.Battle.BattleEvent
local var2_0 = ys.Battle.BattleFormulas
local var3_0 = ys.Battle.BattleConst
local var4_0 = ys.Battle.BattleConfig
local var5_0 = ys.Battle.BattleDataFunction
local var6_0 = ys.Battle.BattleAttr
local var7_0 = ys.Battle.BattleVariable

function var0_0.SetupCalculateDamage(arg0_1, arg1_1)
	arg0_1._calculateDamage = arg1_1 or var2_0.CreateContextCalculateDamage()
end

function var0_0.SetupDamageKamikazeAir(arg0_2, arg1_2)
	arg0_2._calculateDamageKamikazeAir = arg1_2 or var2_0.CalculateDamageFromAircraftToMainShip
end

function var0_0.SetupDamageKamikazeShip(arg0_3, arg1_3)
	arg0_3._calculateDamageKamikazeShip = arg1_3 or var2_0.CalculateDamageFromShipToMainShip
end

function var0_0.SetupDamageCrush(arg0_4, arg1_4)
	arg0_4._calculateDamageCrush = arg1_4 or var2_0.CalculateCrashDamage
end

function var0_0.ClearFormulas(arg0_5)
	arg0_5._calculateDamage = nil
	arg0_5._calculateDamageKamikazeAir = nil
	arg0_5._calculateDamageKamikazeShip = nil
	arg0_5._calculateDamageCrush = nil
end

function var0_0.HandleBulletHit(arg0_6, arg1_6, arg2_6)
	if not arg2_6 then
		assert(false, "HandleBulletHit, but no vehicleData")

		return false
	elseif not arg1_6 then
		assert(false, "HandleBulletHit, but no bulletData")

		return false
	end

	if var6_0.IsSpirit(arg2_6) then
		return false
	end

	if arg1_6:IsCollided(arg2_6:GetUniqueID()) == true then
		return
	end

	arg1_6:Hit(arg2_6:GetUniqueID(), arg2_6:GetUnitType())

	local var0_6 = {
		_bullet = arg1_6,
		equipIndex = arg1_6:GetWeapon():GetEquipmentIndex(),
		bulletTag = arg1_6:GetExtraTag()
	}

	arg1_6:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_COLLIDE, var0_6)

	if arg2_6:GetUnitType() == var3_0.UnitType.PLAYER_UNIT and arg2_6:GetIFF() == var4_0.FRIENDLY_CODE then
		ys.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var3_0.ShakeType.HIT])
	end

	return true
end

function var0_0.HandleDamage(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg2_7:GetIFF() == var4_0.FOE_CODE and arg2_7:IsShowHPBar() then
		arg0_7:DispatchEvent(ys.Event.New(var1_0.HIT_ENEMY, arg2_7))
	end

	local var0_7 = arg1_7:GetWeapon()
	local var1_7 = arg1_7:GetWeaponHostAttr()
	local var2_7 = arg1_7:GetExtraTag()
	local var3_7 = var0_7:GetTemplateData()
	local var4_7 = {
		weaponType = var3_7.attack_attribute,
		bulletType = arg1_7:GetType(),
		bulletTag = var2_7
	}

	arg2_7:TriggerBuff(var3_0.BuffEffectType.ON_BULLET_HIT_BEFORE, var4_7)

	if var6_0.IsInvincible(arg2_7) then
		return
	end

	local var5_7, var6_7, var7_7 = arg0_7._calculateDamage(arg1_7, arg2_7, arg3_7, arg4_7)
	local var8_7 = var6_7.isMiss
	local var9_7 = var6_7.isCri
	local var10_7 = var6_7.damageAttr

	arg1_7:AppendDamageUnit(arg2_7:GetUniqueID())

	local var11_7 = var3_7.type
	local var12_7 = var0_7:GetEquipmentIndex()
	local var13_7 = {
		target = arg2_7,
		damage = var5_7,
		weaponType = var11_7,
		equipIndex = var12_7,
		bulletTag = var2_7
	}
	local var14_7 = {
		isHeal = false,
		isMiss = var8_7,
		isCri = var9_7,
		attr = var10_7,
		font = var7_7,
		cldPos = arg1_7:GetPosition(),
		srcID = var1_7.battleUID
	}

	arg1_7:GetWeapon():WeaponStatistics(var5_7, var9_7, var8_7)

	local var15_7 = arg2_7:UpdateHP(var5_7 * -1, var14_7)

	arg0_7:DamageStatistics(var1_7.id, arg2_7:GetAttrByName("id"), -var15_7)

	if not var8_7 and arg1_7:GetWeaponTempData().type ~= var3_0.EquipmentType.ANTI_AIR then
		arg1_7:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_HIT, var13_7)

		local var16_7 = arg1_7:GetHost()

		if var16_7 and var16_7:IsAlive() and var16_7:GetUnitType() ~= ys.Battle.BattleConst.UnitType.AIRFIGHTER_UNIT then
			if table.contains(var3_0.AircraftUnitType, var16_7:GetUnitType()) then
				var16_7 = var16_7:GetMotherUnit()
			end

			local var17_7 = var16_7:GetIFF()

			for iter0_7, iter1_7 in pairs(arg0_7._unitList) do
				if iter1_7:GetIFF() == var17_7 and iter1_7 ~= var16_7 then
					iter1_7:TriggerBuff(ys.Battle.BattleConst.BuffEffectType.ON_TEAMMATE_BULLET_HIT, var13_7)
				end
			end
		end
	end

	local var18_7 = arg2_7:GetUnitType()
	local var19_7 = true

	if var18_7 ~= var3_0.UnitType.AIRCRAFT_UNIT and var18_7 ~= var3_0.UnitType.AIRFIGHTER_UNIT and var18_7 ~= var3_0.UnitType.FUNNEL_UNIT and var18_7 ~= var3_0.UnitType.UAV_UNIT then
		var19_7 = false
	end

	if arg2_7:IsAlive() then
		if not var19_7 then
			for iter2_7, iter3_7 in ipairs(arg1_7:GetAttachBuff()) do
				if iter3_7.hit_ignore or not var8_7 then
					var0_0.HandleBuffPlacer(iter3_7, arg1_7, arg2_7)
				end
			end
		end

		if not var8_7 then
			arg2_7:TriggerBuff(var3_0.BuffEffectType.ON_BE_HIT, var4_7)
		end
	else
		arg1_7:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_KILL, {
			unit = arg2_7,
			killer = arg1_7
		})
		arg0_7:obituary(arg2_7, var19_7, arg1_7)
		arg0_7:KillCountStatistics(var1_7.id, arg2_7:GetAttrByName("id"))
	end

	return var8_7, var9_7
end

function var0_0.HandleMeteoDamage(arg0_8, arg1_8, arg2_8)
	local var0_8 = var2_0.GetMeteoDamageRatio(#arg2_8)

	for iter0_8, iter1_8 in ipairs(arg2_8) do
		arg0_8:HandleDamage(arg1_8, iter1_8, nil, var0_8[iter0_8])
	end
end

function var0_0.HandleDirectDamage(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9

	if arg3_9 then
		var0_9 = arg3_9:GetAttrByName("id")
	end

	local var1_9 = {
		isMiss = false,
		isCri = false,
		isHeal = false,
		damageReason = arg4_9,
		srcID = var0_9
	}
	local var2_9 = arg1_9:GetAttrByName("id")
	local var3_9 = arg1_9:UpdateHP(arg2_9 * -1, var1_9)
	local var4_9 = arg1_9:IsAlive()

	if arg3_9 then
		arg0_9:DamageStatistics(var0_9, var2_9, -var3_9)

		if not var4_9 then
			arg0_9:KillCountStatistics(var0_9, var2_9)
		end
	end

	if not var4_9 then
		local var5_9 = arg1_9:GetUnitType()
		local var6_9 = true

		if var5_9 ~= var3_0.UnitType.AIRCRAFT_UNIT and var5_9 ~= var3_0.UnitType.AIRFIGHTER_UNIT and var5_9 ~= var3_0.UnitType.FUNNEL_UNIT and var5_9 ~= var3_0.UnitType.UAV_UNIT then
			var6_9 = false
		end

		arg0_9:obituary(arg1_9, var6_9, arg3_9)
	end
end

function var0_0.obituary(arg0_10, arg1_10, arg2_10, arg3_10)
	for iter0_10, iter1_10 in pairs(arg0_10._unitList) do
		if iter1_10 ~= arg1_10 then
			if iter1_10:GetIFF() == arg1_10:GetIFF() then
				if arg2_10 then
					iter1_10:TriggerBuff(var3_0.BuffEffectType.ON_FRIENDLY_AIRCRAFT_DYING, {
						unit = arg1_10,
						killer = arg3_10
					})
				elseif not arg1_10:GetWorldDeathMark() then
					iter1_10:TriggerBuff(var3_0.BuffEffectType.ON_FRIENDLY_SHIP_DYING, {
						unit = arg1_10,
						killer = arg3_10
					})
				end
			elseif arg2_10 then
				iter1_10:TriggerBuff(var3_0.BuffEffectType.ON_FOE_AIRCRAFT_DYING, {
					unit = arg1_10,
					killer = arg3_10
				})
			else
				iter1_10:TriggerBuff(var3_0.BuffEffectType.ON_FOE_DYING, {
					unit = arg1_10,
					killer = arg3_10
				})
			end
		end
	end
end

function var0_0.HandleAircraftMissDamage(arg0_11, arg1_11, arg2_11)
	if arg2_11 == nil then
		return
	end

	local var0_11 = arg2_11:GetCloakList()

	for iter0_11, iter1_11 in ipairs(var0_11) do
		iter1_11:CloakExpose(arg0_11._airExpose)
	end

	local var1_11 = arg1_11:GetPosition()
	local var2_11 = arg2_11:NearestUnitByType(var1_11, ShipType.CloakShipTypeList)

	if var2_11 then
		var2_11:CloakExpose(arg0_11._airExposeEX)
	end

	local var3_11 = arg2_11:RandomMainVictim({
		"immuneDirectHit"
	})

	if var3_11 then
		local var4_11 = arg0_11._calculateDamageKamikazeAir(arg1_11, var3_11)

		var3_11:TriggerBuff(var3_0.BuffEffectType.ON_BE_HIT, {})
		arg0_11:HandleDirectDamage(var3_11, var4_11, arg1_11)
	end
end

function var0_0.HandleShipMissDamage(arg0_12, arg1_12, arg2_12)
	if arg2_12 == nil then
		return
	end

	local var0_12 = arg2_12:GetCloakList()

	for iter0_12, iter1_12 in ipairs(var0_12) do
		iter1_12:CloakExpose(arg0_12._shipExpose)
	end

	local var1_12 = arg1_12:GetPosition()
	local var2_12 = arg2_12:NearestUnitByType(var1_12, ShipType.CloakShipTypeList)

	if var2_12 then
		var2_12:CloakExpose(arg0_12._shipExposeEX)
	end

	local var3_12 = arg2_12:RandomMainVictim({
		"immuneDirectHit"
	})

	if var3_12 then
		local var4_12 = arg1_12:GetTemplate().type

		if table.contains(TeamType.SubShipType, var4_12) then
			local var5_12 = var2_0.CalculateDamageFromSubmarinToMainShip(arg1_12, var3_12)

			var3_12:TriggerBuff(var3_0.BuffEffectType.ON_BE_HIT, {})
			arg0_12:HandleDirectDamage(var3_12, var5_12, arg1_12)

			if var3_12:IsAlive() and var2_0.RollSubmarineDualDice(arg1_12) then
				local var6_12 = var2_0.CalculateDamageFromSubmarinToMainShip(arg1_12, var3_12)

				var3_12:TriggerBuff(var3_0.BuffEffectType.ON_BE_HIT, {})
				arg0_12:HandleDirectDamage(var3_12, var6_12, arg1_12)
			end
		else
			local var7_12 = arg0_12._calculateDamageKamikazeShip(arg1_12, var3_12)

			var3_12:TriggerBuff(var3_0.BuffEffectType.ON_BE_HIT, {})
			arg0_12:HandleDirectDamage(var3_12, var7_12, arg1_12)
		end
	end
end

function var0_0.HandleCrashDamage(arg0_13, arg1_13, arg2_13)
	local var0_13, var1_13 = arg0_13._calculateDamageCrush(arg1_13, arg2_13)

	arg0_13:HandleDirectDamage(arg1_13, var0_13, arg2_13, var3_0.UnitDeathReason.CRUSH)
	arg0_13:HandleDirectDamage(arg2_13, var1_13, arg1_13, var3_0.UnitDeathReason.CRUSH)
end

function var0_0.HandleBuffPlacer(arg0_14, arg1_14, arg2_14)
	local var0_14 = var5_0.GetBuffTemplate(arg0_14.buff_id).effect_list
	local var1_14 = false

	if var0_14[1].type == "BattleBuffDOT" then
		if var2_0.CaclulateDOTPlace(arg0_14.rant, var0_14[1], arg1_14, arg2_14) then
			var1_14 = true
		end
	elseif var2_0.IsHappen(arg0_14.rant or 10000) then
		var1_14 = true
	end

	if var1_14 then
		local var2_14 = ys.Battle.BattleBuffUnit.New(arg0_14.buff_id, arg0_14.level, arg1_14)

		var2_14:SetOrb(arg1_14, arg0_14.level)
		arg2_14:AddBuff(var2_14)
	end
end

function var0_0.HandleDOTPlace(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.arg_list
	local var1_15 = var4_0.DOT_CONFIG[var0_15.dotType]
	local var2_15 = arg1_15:GetAttrByName(var1_15.hit)

	if var2_0.IsHappen(var0_15.ACC + arg1_15:GetAttrByName(var1_15.hit) - arg2_15:GetAttrByName(var1_15.resist)) then
		return true
	end

	return false
end

function var0_0.HandleShipCrashDamageList(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16:GetHostileCldList()

	for iter0_16, iter1_16 in pairs(var0_16) do
		if not table.contains(arg2_16, iter0_16) then
			arg1_16:RemoveHostileCld(iter0_16)
		end
	end

	for iter2_16, iter3_16 in ipairs(arg2_16) do
		if var0_16[iter3_16] == nil then
			local var1_16

			local function var2_16()
				arg0_16:HandleCrashDamage(arg0_16._unitList[iter3_16], arg1_16)
			end

			local var3_16 = pg.TimeMgr.GetInstance():AddBattleTimer("shipCld", nil, var4_0.SHIP_CLD_INTERVAL, var2_16, true)

			arg1_16:AppendHostileCld(iter3_16, var3_16)
			var2_16()

			if not arg1_16:IsAlive() then
				break
			end
		end
	end
end

function var0_0.HandleShipCrashDecelerate(arg0_18, arg1_18, arg2_18)
	if arg2_18 == 0 and arg1_18:IsCrash() then
		arg1_18:SetCrash(false)
	elseif arg2_18 > 0 and not arg1_18:IsCrash() then
		arg1_18:SetCrash(true)
	end
end

function var0_0.HandleWallHitByBullet(arg0_19, arg1_19, arg2_19)
	return (arg1_19:GetCldFunc()(arg2_19))
end

function var0_0.HandleWallHitByShip(arg0_20, arg1_20, arg2_20)
	arg1_20:GetCldFunc()(arg2_20)
end

function var0_0.HandleWallDamage(arg0_21, arg1_21, arg2_21)
	if arg2_21:GetIFF() == var4_0.FOE_CODE and arg2_21:IsShowHPBar() then
		arg0_21:DispatchEvent(ys.Event.New(var1_0.HIT_ENEMY, arg2_21))
	end

	local var0_21 = var6_0.GetCurrent(arg1_21, "id")

	if var6_0.IsInvincible(arg2_21) then
		return
	end

	local var1_21, var2_21, var3_21 = arg0_21._calculateDamage(arg1_21, arg2_21)
	local var4_21 = var2_21.isMiss
	local var5_21 = var2_21.isCri
	local var6_21 = var2_21.damageAttr
	local var7_21 = {
		isHeal = false,
		isMiss = var4_21,
		isCri = var5_21,
		attr = var6_21,
		font = var3_21,
		cldPos = arg1_21:GetPosition(),
		srcID = var0_21
	}
	local var8_21 = arg2_21:UpdateHP(var1_21 * -1, var7_21)

	arg0_21:DamageStatistics(var0_21, arg2_21:GetAttrByName("id"), -var8_21)

	if arg2_21:IsAlive() then
		if not var4_21 then
			arg2_21:TriggerBuff(var3_0.BuffEffectType.ON_BE_HIT, {})
		end
	else
		arg0_21:obituary(arg2_21, false, arg1_21)
		arg0_21:KillCountStatistics(var0_21, arg2_21:GetAttrByName("id"))
	end

	return var4_21, var5_21
end
