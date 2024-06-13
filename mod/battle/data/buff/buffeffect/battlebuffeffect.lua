ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas

var0.Battle.BattleBuffEffect = class("BattleBuffEffect")
var0.Battle.BattleBuffEffect.__name = "BattleBuffEffect"

local var2 = var0.Battle.BattleUnitEvent
local var3 = var0.Battle.BattleBuffEffect

var3.FX_TYPE_NOR = 0
var3.FX_TYPE_MOD_ATTR = 1
var3.FX_TYPE_CASTER = 2
var3.FX_TYPE_LINK = 3
var3.FX_TYPE_MOD_VELOCTIY = 4
var3.FX_TYPE_DOT = 5
var3.FX_TTPE_MOD_BATTLE_UNIT_TYPE = 6

function var3.Ctor(arg0, arg1)
	arg0._tempData = Clone(arg1)
	arg0._type = arg0._tempData.type

	local var0 = arg0._tempData.arg_list

	arg0._quota = var0.quota or -1
	arg0._indexRequire = var0.index
	arg0._damageAttrRequire = var0.damageAttr
	arg0._damageReasonRequire = var0.damageReason
	arg0._damageSrcTagRequire = var0.srcTag
	arg0._deathCauseRequire = var0.deathCause
	arg0._countType = var0.countType
	arg0._behit = var0.be_hit_condition
	arg0._ammoTypeRequire = var0.ammoType
	arg0._ammoIndexRequire = var0.ammoIndex
	arg0._bulletTagRequire = var0.bulletTag
	arg0._victimTagRequire = var0.victimTag
	arg0._buffStateIDRequire = var0.buff_state_id
	arg0._cloakRequire = var0.cloak_state
	arg0._fleetAttrRequire = var0.fleetAttr
	arg0._fleetAttrDeltaRequire = var0.fleetAttrDelta
	arg0._stackRequire = var0.stack_require

	arg0:ConfigHPTrigger()
	arg0:ConfigAttrTrigger()
	arg0:SetActive()
end

function var3.GetEffectType(arg0)
	return var3.FX_TYPE_NOR
end

function var3.GetPopConfig(arg0)
	return arg0._tempData.pop
end

function var3.HaveQuota(arg0)
	if arg0._quota == 0 then
		return false
	else
		return true
	end
end

function var3.GetEffectAttachData(arg0)
	return nil
end

function var3.ConfigHPTrigger(arg0)
	local var0 = arg0._tempData.arg_list

	arg0._hpUpperBound = var0.hpUpperBound
	arg0._hpLowerBound = var0.hpLowerBound

	if arg0._hpUpperBound and arg0._hpLowerBound == nil then
		arg0._hpLowerBound = 0
	end

	if arg0._hpLowerBound and arg0._hpUpperBound == nil then
		arg0._hpUpperBound = 1
	end

	arg0._hpSigned = var0.hpSigned or -1
	arg0._hpOutInterval = var0.hpOutInterval
	arg0._dHPGreater = var0.dhpGreater
	arg0._dhpSmaller = var0.dhpSmaller
	arg0._dHPGreaterMaxHP = var0.dhpGreaterMaxhp
	arg0._dhpSmallerMaxhp = var0.dhpSmallerMaxhp
end

function var3.ConfigAttrTrigger(arg0)
	local var0 = arg0._tempData.arg_list

	arg0._attrLowerBound = var0.attrLowerBound
	arg0._attrUpperBound = var0.attrUpperBound
	arg0._attrInterval = var0.attrInterval
end

function var3.SetCaster(arg0, arg1)
	arg0._caster = arg1
end

function var3.SetCommander(arg0, arg1)
	arg0._commander = arg1
end

function var3.SetBullet(arg0, arg1)
	return
end

function var3.SetArgs(arg0, arg1, arg2)
	return
end

function var3.SetOrb(arg0)
	return
end

function var3.Trigger(arg0, arg1, arg2, arg3, arg4)
	arg0[arg1](arg0, arg2, arg3, arg4)
end

function var3.onAttach(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onRemove(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onBuffAdded(arg0, arg1, arg2, arg3)
	if not arg0:buffStateRequire(arg3.buffID) then
		return
	end

	arg0:onTrigger(arg1, arg2)
end

function var3.onBuffRemoved(arg0, arg1, arg2, arg3)
	if not arg0:buffStateRequire(arg3.buffID) then
		return
	end

	arg0:onTrigger(arg1, arg2)
end

function var3.onUpdate(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onStack(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onBulletHit(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	if not arg0:bulletTagRequire(arg3.bulletTag) then
		return
	end

	if not arg0:victimRequire(arg3.target, arg1) then
		return
	end

	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onTeammateBulletHit(arg0, arg1, arg2, arg3)
	arg0:onBulletHit(arg1, arg2, arg3)
end

function var3.onBeHit(arg0, arg1, arg2, arg3)
	if arg0._behit then
		if arg0._behit.damage_type == arg3.weaponType and arg0._behit.bullet_type == arg3.bulletType then
			arg0:onTrigger(arg1, arg2)
		end
	else
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onFire(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2)
end

function var3.onCombo(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	local var0 = arg3.matchUnitCount
	local var1 = arg0._tempData.arg_list.upperBound
	local var2 = arg0._tempData.arg_list.lowerBound

	if var1 and var0 <= var1 then
		arg0:onTrigger(arg1, arg2)
	elseif var2 and var2 <= var0 then
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.stackRequire(arg0, arg1)
	if arg0._stackRequire then
		local var0 = arg1:GetStack()

		return var1.simpleCompare(arg0._stackRequire, var0)
	else
		return true
	end
end

function var3.fleetAttrRequire(arg0, arg1)
	if arg0._fleetAttrRequire then
		if arg1:GetFleetVO() then
			local var0 = arg1:GetFleetVO():GetFleetAttr()

			return var1.parseCompare(arg0._fleetAttrRequire, var0)
		else
			return false
		end
	end

	return true
end

function var3.fleetAttrDelatRequire(arg0, arg1)
	if arg0._fleetAttrDeltaRequire then
		return arg1 and var1.simpleCompare(arg0._fleetAttrDeltaRequire, arg1)
	end

	return true
end

function var3.equipIndexRequire(arg0, arg1)
	if not arg0._indexRequire then
		return true
	else
		for iter0, iter1 in ipairs(arg0._indexRequire) do
			if iter1 == arg1 then
				return true
			end
		end

		return false
	end
end

function var3.ammoRequire(arg0, arg1)
	if not arg0._ammoTypeRequire then
		return true
	else
		local var0 = arg1:GetWeaponByIndex(arg0._ammoIndexRequire)

		if not var0 or var0:GetPrimalAmmoType() ~= arg0._ammoTypeRequire then
			return false
		else
			return true
		end
	end
end

function var3.bulletTagRequire(arg0, arg1)
	if not arg0._bulletTagRequire then
		return true
	else
		for iter0, iter1 in ipairs(arg0._bulletTagRequire) do
			if table.contains(arg1, iter1) then
				return true
			else
				return false
			end
		end
	end
end

function var3.buffStateRequire(arg0, arg1)
	if not arg0._buffStateIDRequire then
		return true
	else
		return arg1 == arg0._buffStateIDRequire
	end
end

function var3.onWeaponSteday(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onChargeWeaponFire(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onTorpedoWeaponFire(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onAntiAirWeaponFireFar(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onAntiAirWeaponFireNear(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onManualMissileFire(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onAllInStrike(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onAllInStrikeSteady(arg0, arg1, arg2, arg3)
	arg0:onFire(arg1, arg2, arg3)
end

function var3.onWeaonInterrupt(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onWeaponSuccess(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onChargeWeaponReady(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onManualTorpedoReady(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onAirAssistReady(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onManualMissileReady(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onTorpedoButtonPush(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2)
end

function var3.onBeforeFatalDamage(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onAircraftCreate(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onFriendlyAircraftDying(arg0, arg1, arg2, arg3)
	if arg0._tempData.arg_list.templateID then
		if arg3.unit:GetTemplateID() == arg0._tempData.arg_list.templateID then
			arg0:onTrigger(arg1, arg2)
		end
	else
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onFriendlyShipDying(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onFoeAircraftDying(arg0, arg1, arg2, arg3)
	if arg0._tempData.arg_list.inside then
		local var0 = arg3.unit

		if not arg1:GetFleetVO():GetFleetAntiAirWeapon():IsOutOfRange(var0) then
			arg0:onTrigger(arg1, arg2)
		end
	elseif arg0._tempData.arg_list.killer then
		if arg0:killerRequire(arg0._tempData.arg_list.killer, arg3.killer, arg1) then
			arg0:onTrigger(arg1, arg2)
		end
	else
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onFoeDying(arg0, arg1, arg2, arg3)
	if arg0._tempData.arg_list.killer then
		if arg0:killerRequire(arg0._tempData.arg_list.killer, arg3.killer, arg1) then
			arg0:onTrigger(arg1, arg2)
		end
	elseif arg0:victimRequire(arg3.unit, arg1) then
		arg0:onTrigger(arg1, arg2)
	else
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onSink(arg0, arg1, arg2)
	if arg0:deathCauseRequire(arg1) then
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.deathCauseRequire(arg0, arg1)
	if not arg0._deathCauseRequire then
		return true
	end

	local var0 = arg1:GetDeathReason()

	return table.contains(arg0._deathCauseRequire, var0)
end

function var3.killerRequire(arg0, arg1, arg2, arg3)
	if not arg2 then
		return false
	end

	local var0
	local var1
	local var2 = arg2.__name

	if var2 == var0.Battle.BattlePlayerUnit.__name or var2 == var0.Battle.BattleNPCUnit.__name or var2 == var0.Battle.BattleMinionUnit.__name or var2 == var0.Battle.BattleEnemyUnit.__name or var2 == var0.Battle.BattleAircraftUnit.__name or var2 == var0.Battle.BattleAirFighterUnit.__name then
		var0 = arg2
	else
		var0 = arg2:GetHost()
	end

	if var0 then
		local var3 = var0.__name

		if var3 == var0.Battle.BattleAircraftUnit.__name then
			var1 = var0:GetMotherUnit()
		elseif var3 == var0.Battle.BattleMinionUnit.__name then
			var1 = var0:GetMaster()
		else
			var1 = var0
			var0 = nil
		end
	else
		return false
	end

	if arg1 == "self" then
		if var1 == arg3 and not var0 then
			return true
		end
	elseif arg1 == "child" and var1 == arg3 and var0 then
		return true
	end

	return false
end

function var3.victimRequire(arg0, arg1, arg2)
	if not arg0._victimTagRequire then
		return true
	elseif arg1:ContainsLabelTag(arg0._victimTagRequire) then
		return true
	else
		return false
	end
end

function var3.killerWeaponRequire(arg0, arg1, arg2, arg3)
	if not arg2 then
		return false
	end

	if not arg2.GetWeapon then
		return false
	end

	local var0 = arg2:GetWeapon():GetWeaponId()

	if table.contains(arg1, var0) then
		return true
	end
end

function var3.DamageSourceRequire(arg0, arg1, arg2)
	if not arg0._damageSrcTagRequire then
		return true
	else
		if not arg1 then
			return false
		end

		local var0 = var0.Battle.BattleDataProxy.GetInstance():GetUnitList()[arg1]

		if not var0 then
			return false
		end

		if var0:ContainsLabelTag(arg0._damageSrcTagRequire) then
			return true
		else
			return false
		end
	end
end

function var3.onInitGame(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onStartGame(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onManual(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onAutoBot(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onFlagShip(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onUpperConsort(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onLowerConsort(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onLeader(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onCenter(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onRear(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onSubLeader(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onUpperSubConsort(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onLowerSubConsort(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var3.onBulletCollide(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2)
end

function var3.onBombBulletBang(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2)
end

function var3.onTorpedoBulletBang(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2)
end

function var3.onBulletHitBefore(arg0, arg1, arg2, arg3)
	if arg0._behit then
		if arg0._behit.damage_type == arg3.weaponType and arg0._behit.bullet_type == arg3.bulletType then
			arg0:onTrigger(arg1, arg2)
		end
	else
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onChargeWeaponBulletCreate(arg0, arg1, arg2, arg3)
	arg0:onBulletCreate(arg1, arg2, arg3)
end

function var3.onTorpedoWeaponBulletCreate(arg0, arg1, arg2, arg3)
	arg0:onBulletCreate(arg1, arg2, arg3)
end

function var3.onInternalBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onManualBulletCreate(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onBeforeTakeDamage(arg0, arg1, arg2, arg3)
	if arg0:damageCheck(arg3) then
		arg0:onTrigger(arg1, arg2, arg3)
	end
end

function var3.onTakeDamage(arg0, arg1, arg2, arg3)
	if arg0:damageCheck(arg3) then
		arg0:onTrigger(arg1, arg2, arg3)
	end
end

function var3.onTakeHealing(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onShieldAbsorb(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onDamageFix(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onOverHealing(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onFleetAttrUpdate(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.damageCheck(arg0, arg1)
	return arg0:damageAttrRequire(arg1.damageAttr) and arg0:damageReasonRequire(arg1.damageReason)
end

function var3.damageAttrRequire(arg0, arg1)
	if not arg0._damageAttrRequire or table.contains(arg0._damageAttrRequire, arg1) then
		return true
	else
		return false
	end
end

function var3.damageReasonRequire(arg0, arg1)
	if not arg0._damageReasonRequire or table.contains(arg0._damageReasonRequire, arg1) then
		return true
	else
		return false
	end
end

function var3.hpIntervalRequire(arg0, arg1, arg2)
	if arg0._hpUpperBound == nil and arg0._hpLowerBound == nil then
		return true
	end

	if not arg2 or arg0._hpSigned == 0 then
		-- block empty
	elseif arg2 * arg0._hpSigned < 0 then
		return false
	end

	local var0

	if arg0._hpOutInterval then
		if arg1 >= arg0._hpUpperBound or arg1 <= arg0._hpLowerBound then
			var0 = true
		end
	elseif arg1 <= arg0._hpUpperBound and arg1 >= arg0._hpLowerBound then
		var0 = true
	end

	return var0
end

function var3.dhpRequire(arg0, arg1, arg2)
	if arg0._dHPGreater then
		return arg2 * arg0._dHPGreater > 0 and math.abs(arg2) > math.abs(arg0._dHPGreater)
	elseif arg0._dHPGreaterMaxHP then
		local var0 = arg0._dHPGreaterMaxHP * arg1

		return arg2 * var0 > 0 and math.abs(arg2) > math.abs(var0)
	elseif arg0._dhpSmaller then
		return arg2 * arg0._dhpSmaller > 0 and math.abs(arg2) < math.abs(arg0._dhpSmaller)
	elseif arg0._dhpSmallerMaxhp then
		local var1 = arg0._dhpSmallerMaxhp * arg1

		return arg2 * var1 > 0 and math.abs(arg2) < math.abs(var1)
	else
		return true
	end
end

function var3.attrIntervalRequire(arg0, arg1)
	local var0 = true

	if arg0._attrUpperBound and arg1 >= arg0._attrUpperBound then
		var0 = false
	end

	if arg0._attrLowerBound and arg1 <= arg0._attrLowerBound then
		var0 = false
	end

	return var0
end

function var3.onHPRatioUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetHPRate()
	local var1 = arg3.dHP

	if arg0:hpIntervalRequire(var0, var1) and arg0:dhpRequire(arg1:GetMaxHP(), var1) then
		arg0:doOnHPRatioUpdate(arg1, arg2, arg3)
	end
end

function var3.onFriendlyHpRatioUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg3.unit
	local var1 = arg3.dHP
	local var2 = var0:GetHPRate()

	if arg0:hpIntervalRequire(var2, var1) and arg0:dhpRequire(var0:GetMaxHP(), var1) then
		arg0:doOnHPRatioUpdate(arg1, arg2, arg3)
	end
end

function var3.onTeammateHpRatioUpdate(arg0, arg1, arg2, arg3)
	arg0:onFriendlyHpRatioUpdate(arg1, arg2, arg3)
end

function var3.onBulletKill(arg0, arg1, arg2, arg3)
	if arg0._tempData.arg_list.killer_weapon_id then
		if arg0:killerWeaponRequire(arg0._tempData.arg_list.killer_weapon_id, arg3.killer, arg1) then
			arg0:onTrigger(arg1, arg2)
		end
	else
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onBattleBuffCount(arg0, arg1, arg2, arg3)
	local var0 = arg3.buffFX

	if var0:GetCountType() == arg0._countType then
		if var0:Repeater() then
			while var0:GetCountProgress() >= 1 do
				arg0:onTrigger(arg1, arg2)
				var0:ConsumeCount()
			end
		elseif arg0:onTrigger(arg1, arg2) ~= "overheat" then
			var0:ResetCount()
		end
	end
end

function var3.onShieldBroken(arg0, arg1, arg2, arg3)
	if arg3.shieldBuffID == arg0._tempData.arg_list.shieldBuffID then
		arg0:onTrigger(arg1, arg2)
	end
end

function var3.onTrigger(arg0, arg1, arg2, arg3)
	if arg0._quota > 0 then
		arg0._quota = arg0._quota - 1
	end
end

function var3.doOnHPRatioUpdate(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.doOnFriendlyHPRatioUpdate(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarineDive(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarineRaid(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarineFloat(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarineRetreat(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarineAid(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarinFreeDive(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarinFreeFloat(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubmarineFreeSpecial(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubDetected(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onSubUnDetected(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onAntiSubHateChain(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, attach)
end

function var3.onRetreat(arg0, arg1, arg2, arg3)
	arg0:onTrigger(arg1, arg2, arg3)
end

function var3.onCloakUpdate(arg0, arg1, arg2, arg3)
	if arg0:cloakStateRequire(arg3.cloakState) then
		arg0:onTrigger(arg1, arg2, arg3)
	end
end

function var3.onTeammateCloakUpdate(arg0, arg1, arg2, arg3)
	if arg0:cloakStateRequire(arg3.cloakState) then
		arg0:onTrigger(arg1, arg2, arg3)
	end
end

function var3.cloakStateRequire(arg0, arg1)
	if not arg0._cloakRequire then
		return true
	else
		return arg0._cloakRequire == arg1
	end
end

function var3.Interrupt(arg0)
	return
end

function var3.Clear(arg0)
	arg0._commander = nil
end

function var3.getTargetList(arg0, arg1, arg2, arg3, arg4)
	if type(arg2) == "string" then
		arg2 = {
			arg2
		}
	end

	local var0 = arg3

	if table.contains(arg2, "TargetDamageSource") then
		var0 = Clone(arg3)
		var0.damageSourceID = arg4.damageSrc
	end

	local var1

	for iter0, iter1 in ipairs(arg2) do
		var1 = var0.Battle.BattleTargetChoise[iter1](arg1, var0, var1)
	end

	return var1
end

function var3.commanderRequire(arg0, arg1)
	if arg0._tempData.arg_list.CMDBuff_id then
		local var0, var1 = var0.Battle.BattleDataProxy.GetInstance():GetCommanderBuff()
		local var2
		local var3 = arg1:GetTemplate().type

		if table.contains(TeamType.SubShipType, var3) then
			var2 = var1
		else
			var2 = var0
		end

		local var4 = {}
		local var5 = arg0._tempData.arg_list.CMDBuff_id

		for iter0, iter1 in ipairs(var2) do
			if iter1.id == var5 then
				table.insert(var4, iter1)
			end
		end

		return #var4 > 0
	else
		return true
	end
end

function var3.IsActive(arg0)
	return arg0._isActive
end

function var3.SetActive(arg0)
	arg0._isActive = true
end

function var3.NotActive(arg0)
	arg0._isActive = false
end

function var3.IsLock(arg0)
	return arg0._isLock
end

function var3.SetLock(arg0)
	arg0._isLock = true
end

function var3.NotLock(arg0)
	arg0._isLock = false
end

function var3.Dispose(arg0)
	return
end
