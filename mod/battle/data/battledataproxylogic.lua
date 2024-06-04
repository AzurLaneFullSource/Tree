local var0 = ys.Battle.BattleDataProxy
local var1 = ys.Battle.BattleEvent
local var2 = ys.Battle.BattleFormulas
local var3 = ys.Battle.BattleConst
local var4 = ys.Battle.BattleConfig
local var5 = ys.Battle.BattleDataFunction
local var6 = ys.Battle.BattleAttr
local var7 = ys.Battle.BattleVariable

function var0.SetupCalculateDamage(arg0, arg1)
	arg0._calculateDamage = arg1 or var2.CreateContextCalculateDamage()
end

function var0.SetupDamageKamikazeAir(arg0, arg1)
	arg0._calculateDamageKamikazeAir = arg1 or var2.CalculateDamageFromAircraftToMainShip
end

function var0.SetupDamageKamikazeShip(arg0, arg1)
	arg0._calculateDamageKamikazeShip = arg1 or var2.CalculateDamageFromShipToMainShip
end

function var0.SetupDamageCrush(arg0, arg1)
	arg0._calculateDamageCrush = arg1 or var2.CalculateCrashDamage
end

function var0.ClearFormulas(arg0)
	arg0._calculateDamage = nil
	arg0._calculateDamageKamikazeAir = nil
	arg0._calculateDamageKamikazeShip = nil
	arg0._calculateDamageCrush = nil
end

function var0.HandleBulletHit(arg0, arg1, arg2)
	if not arg2 then
		assert(false, "HandleBulletHit, but no vehicleData")

		return false
	elseif not arg1 then
		assert(false, "HandleBulletHit, but no bulletData")

		return false
	end

	if var6.IsSpirit(arg2) then
		return false
	end

	if arg1:IsCollided(arg2:GetUniqueID()) == true then
		return
	end

	arg1:Hit(arg2:GetUniqueID(), arg2:GetUnitType())

	local var0 = {
		_bullet = arg1,
		equipIndex = arg1:GetWeapon():GetEquipmentIndex(),
		bulletTag = arg1:GetExtraTag()
	}

	arg1:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_COLLIDE, var0)

	if arg2:GetUnitType() == var3.UnitType.PLAYER_UNIT and arg2:GetIFF() == var4.FRIENDLY_CODE then
		ys.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var3.ShakeType.HIT])
	end

	return true
end

function var0.HandleDamage(arg0, arg1, arg2, arg3, arg4)
	if arg2:GetIFF() == var4.FOE_CODE and arg2:IsShowHPBar() then
		arg0:DispatchEvent(ys.Event.New(var1.HIT_ENEMY, arg2))
	end

	local var0 = arg1:GetWeapon()
	local var1 = arg1:GetWeaponHostAttr()
	local var2 = arg1:GetExtraTag()
	local var3 = var0:GetTemplateData()
	local var4 = {
		weaponType = var3.attack_attribute,
		bulletType = arg1:GetType(),
		bulletTag = var2
	}

	arg2:TriggerBuff(var3.BuffEffectType.ON_BULLET_HIT_BEFORE, var4)

	if var6.IsInvincible(arg2) then
		return
	end

	local var5, var6, var7 = arg0._calculateDamage(arg1, arg2, arg3, arg4)
	local var8 = var6.isMiss
	local var9 = var6.isCri
	local var10 = var6.damageAttr

	arg1:AppendDamageUnit(arg2:GetUniqueID())

	local var11 = var3.type
	local var12 = var0:GetEquipmentIndex()
	local var13 = {
		target = arg2,
		damage = var5,
		weaponType = var11,
		equipIndex = var12,
		bulletTag = var2
	}
	local var14 = {
		isHeal = false,
		isMiss = var8,
		isCri = var9,
		attr = var10,
		font = var7,
		cldPos = arg1:GetPosition(),
		srcID = var1.battleUID
	}

	arg1:GetWeapon():WeaponStatistics(var5, var9, var8)

	local var15 = arg2:UpdateHP(var5 * -1, var14)

	arg0:DamageStatistics(var1.id, arg2:GetAttrByName("id"), -var15)

	if not var8 and arg1:GetWeaponTempData().type ~= var3.EquipmentType.ANTI_AIR then
		arg1:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_HIT, var13)

		local var16 = arg1:GetHost()

		if var16 and var16:IsAlive() and var16:GetUnitType() ~= ys.Battle.BattleConst.UnitType.AIRFIGHTER_UNIT then
			if table.contains(var3.AircraftUnitType, var16:GetUnitType()) then
				var16 = var16:GetMotherUnit()
			end

			local var17 = var16:GetIFF()

			for iter0, iter1 in pairs(arg0._unitList) do
				if iter1:GetIFF() == var17 and iter1 ~= var16 then
					iter1:TriggerBuff(ys.Battle.BattleConst.BuffEffectType.ON_TEAMMATE_BULLET_HIT, var13)
				end
			end
		end
	end

	local var18 = arg2:GetUnitType()
	local var19 = true

	if var18 ~= var3.UnitType.AIRCRAFT_UNIT and var18 ~= var3.UnitType.AIRFIGHTER_UNIT and var18 ~= var3.UnitType.FUNNEL_UNIT and var18 ~= var3.UnitType.UAV_UNIT then
		var19 = false
	end

	if arg2:IsAlive() then
		if not var19 then
			for iter2, iter3 in ipairs(arg1:GetAttachBuff()) do
				if iter3.hit_ignore or not var8 then
					var0.HandleBuffPlacer(iter3, arg1, arg2)
				end
			end
		end

		if not var8 then
			arg2:TriggerBuff(var3.BuffEffectType.ON_BE_HIT, var4)
		end
	else
		arg1:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_KILL, {
			unit = arg2,
			killer = arg1
		})
		arg0:obituary(arg2, var19, arg1)
		arg0:KillCountStatistics(var1.id, arg2:GetAttrByName("id"))
	end

	return var8, var9
end

function var0.HandleMeteoDamage(arg0, arg1, arg2)
	local var0 = var2.GetMeteoDamageRatio(#arg2)

	for iter0, iter1 in ipairs(arg2) do
		arg0:HandleDamage(arg1, iter1, nil, var0[iter0])
	end
end

function var0.HandleDirectDamage(arg0, arg1, arg2, arg3, arg4)
	local var0

	if arg3 then
		var0 = arg3:GetAttrByName("id")
	end

	local var1 = {
		isMiss = false,
		isCri = false,
		isHeal = false,
		damageReason = arg4,
		srcID = var0
	}
	local var2 = arg1:GetAttrByName("id")
	local var3 = arg1:UpdateHP(arg2 * -1, var1)
	local var4 = arg1:IsAlive()

	if arg3 then
		arg0:DamageStatistics(var0, var2, -var3)

		if not var4 then
			arg0:KillCountStatistics(var0, var2)
		end
	end

	if not var4 then
		local var5 = arg1:GetUnitType()
		local var6 = true

		if var5 ~= var3.UnitType.AIRCRAFT_UNIT and var5 ~= var3.UnitType.AIRFIGHTER_UNIT and var5 ~= var3.UnitType.FUNNEL_UNIT and var5 ~= var3.UnitType.UAV_UNIT then
			var6 = false
		end

		arg0:obituary(arg1, var6, arg3)
	end
end

function var0.obituary(arg0, arg1, arg2, arg3)
	for iter0, iter1 in pairs(arg0._unitList) do
		if iter1 ~= arg1 then
			if iter1:GetIFF() == arg1:GetIFF() then
				if arg2 then
					iter1:TriggerBuff(var3.BuffEffectType.ON_FRIENDLY_AIRCRAFT_DYING, {
						unit = arg1,
						killer = arg3
					})
				elseif not arg1:GetWorldDeathMark() then
					iter1:TriggerBuff(var3.BuffEffectType.ON_FRIENDLY_SHIP_DYING, {
						unit = arg1,
						killer = arg3
					})
				end
			elseif arg2 then
				iter1:TriggerBuff(var3.BuffEffectType.ON_FOE_AIRCRAFT_DYING, {
					unit = arg1,
					killer = arg3
				})
			else
				iter1:TriggerBuff(var3.BuffEffectType.ON_FOE_DYING, {
					unit = arg1,
					killer = arg3
				})
			end
		end
	end
end

function var0.HandleAircraftMissDamage(arg0, arg1, arg2)
	if arg2 == nil then
		return
	end

	local var0 = arg2:GetCloakList()

	for iter0, iter1 in ipairs(var0) do
		iter1:CloakExpose(arg0._airExpose)
	end

	local var1 = arg1:GetPosition()
	local var2 = arg2:NearestUnitByType(var1, ShipType.CloakShipTypeList)

	if var2 then
		var2:CloakExpose(arg0._airExposeEX)
	end

	local var3 = arg2:RandomMainVictim({
		"immuneDirectHit"
	})

	if var3 then
		local var4 = arg0._calculateDamageKamikazeAir(arg1, var3)

		var3:TriggerBuff(var3.BuffEffectType.ON_BE_HIT, {})
		arg0:HandleDirectDamage(var3, var4, arg1)
	end
end

function var0.HandleShipMissDamage(arg0, arg1, arg2)
	if arg2 == nil then
		return
	end

	local var0 = arg2:GetCloakList()

	for iter0, iter1 in ipairs(var0) do
		iter1:CloakExpose(arg0._shipExpose)
	end

	local var1 = arg1:GetPosition()
	local var2 = arg2:NearestUnitByType(var1, ShipType.CloakShipTypeList)

	if var2 then
		var2:CloakExpose(arg0._shipExposeEX)
	end

	local var3 = arg2:RandomMainVictim({
		"immuneDirectHit"
	})

	if var3 then
		local var4 = arg1:GetTemplate().type

		if table.contains(TeamType.SubShipType, var4) then
			local var5 = var2.CalculateDamageFromSubmarinToMainShip(arg1, var3)

			var3:TriggerBuff(var3.BuffEffectType.ON_BE_HIT, {})
			arg0:HandleDirectDamage(var3, var5, arg1)

			if var3:IsAlive() and var2.RollSubmarineDualDice(arg1) then
				local var6 = var2.CalculateDamageFromSubmarinToMainShip(arg1, var3)

				var3:TriggerBuff(var3.BuffEffectType.ON_BE_HIT, {})
				arg0:HandleDirectDamage(var3, var6, arg1)
			end
		else
			local var7 = arg0._calculateDamageKamikazeShip(arg1, var3)

			var3:TriggerBuff(var3.BuffEffectType.ON_BE_HIT, {})
			arg0:HandleDirectDamage(var3, var7, arg1)
		end
	end
end

function var0.HandleCrashDamage(arg0, arg1, arg2)
	local var0, var1 = arg0._calculateDamageCrush(arg1, arg2)

	arg0:HandleDirectDamage(arg1, var0, arg2, var3.UnitDeathReason.CRUSH)
	arg0:HandleDirectDamage(arg2, var1, arg1, var3.UnitDeathReason.CRUSH)
end

function var0.HandleBuffPlacer(arg0, arg1, arg2)
	local var0 = var5.GetBuffTemplate(arg0.buff_id).effect_list
	local var1 = false

	if var0[1].type == "BattleBuffDOT" then
		if var2.CaclulateDOTPlace(arg0.rant, var0[1], arg1, arg2) then
			var1 = true
		end
	elseif var2.IsHappen(arg0.rant or 10000) then
		var1 = true
	end

	if var1 then
		local var2 = ys.Battle.BattleBuffUnit.New(arg0.buff_id, arg0.level, arg1)

		var2:SetOrb(arg1, arg0.level)
		arg2:AddBuff(var2)
	end
end

function var0.HandleDOTPlace(arg0, arg1, arg2)
	local var0 = arg0.arg_list
	local var1 = var4.DOT_CONFIG[var0.dotType]
	local var2 = arg1:GetAttrByName(var1.hit)

	if var2.IsHappen(var0.ACC + arg1:GetAttrByName(var1.hit) - arg2:GetAttrByName(var1.resist)) then
		return true
	end

	return false
end

function var0.HandleShipCrashDamageList(arg0, arg1, arg2)
	local var0 = arg1:GetHostileCldList()

	for iter0, iter1 in pairs(var0) do
		if not table.contains(arg2, iter0) then
			arg1:RemoveHostileCld(iter0)
		end
	end

	for iter2, iter3 in ipairs(arg2) do
		if var0[iter3] == nil then
			local var1

			local function var2()
				arg0:HandleCrashDamage(arg0._unitList[iter3], arg1)
			end

			local var3 = pg.TimeMgr.GetInstance():AddBattleTimer("shipCld", nil, var4.SHIP_CLD_INTERVAL, var2, true)

			arg1:AppendHostileCld(iter3, var3)
			var2()

			if not arg1:IsAlive() then
				break
			end
		end
	end
end

function var0.HandleShipCrashDecelerate(arg0, arg1, arg2)
	if arg2 == 0 and arg1:IsCrash() then
		arg1:SetCrash(false)
	elseif arg2 > 0 and not arg1:IsCrash() then
		arg1:SetCrash(true)
	end
end

function var0.HandleWallHitByBullet(arg0, arg1, arg2)
	return (arg1:GetCldFunc()(arg2))
end

function var0.HandleWallHitByShip(arg0, arg1, arg2)
	arg1:GetCldFunc()(arg2)
end

function var0.HandleWallDamage(arg0, arg1, arg2)
	if arg2:GetIFF() == var4.FOE_CODE and arg2:IsShowHPBar() then
		arg0:DispatchEvent(ys.Event.New(var1.HIT_ENEMY, arg2))
	end

	local var0 = var6.GetCurrent(arg1, "id")

	if var6.IsInvincible(arg2) then
		return
	end

	local var1, var2, var3 = arg0._calculateDamage(arg1, arg2)
	local var4 = var2.isMiss
	local var5 = var2.isCri
	local var6 = var2.damageAttr
	local var7 = {
		isHeal = false,
		isMiss = var4,
		isCri = var5,
		attr = var6,
		font = var3,
		cldPos = arg1:GetPosition(),
		srcID = var0
	}
	local var8 = arg2:UpdateHP(var1 * -1, var7)

	arg0:DamageStatistics(var0, arg2:GetAttrByName("id"), -var8)

	if arg2:IsAlive() then
		if not var4 then
			arg2:TriggerBuff(var3.BuffEffectType.ON_BE_HIT, {})
		end
	else
		arg0:obituary(arg2, false, arg1)
		arg0:KillCountStatistics(var0, arg2:GetAttrByName("id"))
	end

	return var4, var5
end
