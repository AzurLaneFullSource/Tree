ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas

var0_0.Battle.BattleBuffEffect = class("BattleBuffEffect")
var0_0.Battle.BattleBuffEffect.__name = "BattleBuffEffect"

local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleBuffEffect

var3_0.FX_TYPE_NOR = 0
var3_0.FX_TYPE_MOD_ATTR = 1
var3_0.FX_TYPE_CASTER = 2
var3_0.FX_TYPE_LINK = 3
var3_0.FX_TYPE_MOD_VELOCTIY = 4
var3_0.FX_TYPE_DOT = 5
var3_0.FX_TTPE_MOD_BATTLE_UNIT_TYPE = 6
var3_0.FX_TYPE_COUNTER = 7

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = Clone(arg1_1)
	arg0_1._type = arg0_1._tempData.type

	local var0_1 = arg0_1._tempData.arg_list

	arg0_1._quota = var0_1.quota or -1
	arg0_1._indexRequire = var0_1.index
	arg0_1._damageAttrRequire = var0_1.damageAttr
	arg0_1._damageReasonRequire = var0_1.damageReason
	arg0_1._damageSrcTagRequire = var0_1.srcTag
	arg0_1._deathCauseRequire = var0_1.deathCause
	arg0_1._countType = var0_1.countType
	arg0_1._behit = var0_1.be_hit_condition
	arg0_1._ammoTypeRequire = var0_1.ammoType
	arg0_1._ammoIndexRequire = var0_1.ammoIndex
	arg0_1._bulletTagRequire = var0_1.bulletTag
	arg0_1._victimTagRequire = var0_1.victimTag
	arg0_1._buffStateIDRequire = var0_1.buff_state_id
	arg0_1._cloakRequire = var0_1.cloak_state
	arg0_1._fleetAttrRequire = var0_1.fleetAttr
	arg0_1._fleetAttrDeltaRequire = var0_1.fleetAttrDelta
	arg0_1._stackRequire = var0_1.stack_require

	arg0_1:ConfigHPTrigger()
	arg0_1:ConfigAttrTrigger()
	arg0_1:SetActive()
end

function var3_0.GetEffectType(arg0_2)
	return var3_0.FX_TYPE_NOR
end

function var3_0.GetPopConfig(arg0_3)
	return arg0_3._tempData.pop
end

function var3_0.HaveQuota(arg0_4)
	if arg0_4._quota == 0 then
		return false
	else
		return true
	end
end

function var3_0.GetEffectAttachData(arg0_5)
	return nil
end

function var3_0.ConfigHPTrigger(arg0_6)
	local var0_6 = arg0_6._tempData.arg_list

	arg0_6._hpUpperBound = var0_6.hpUpperBound
	arg0_6._hpLowerBound = var0_6.hpLowerBound

	if arg0_6._hpUpperBound and arg0_6._hpLowerBound == nil then
		arg0_6._hpLowerBound = 0
	end

	if arg0_6._hpLowerBound and arg0_6._hpUpperBound == nil then
		arg0_6._hpUpperBound = 1
	end

	arg0_6._hpSigned = var0_6.hpSigned or -1
	arg0_6._hpOutInterval = var0_6.hpOutInterval
	arg0_6._dHPGreater = var0_6.dhpGreater
	arg0_6._dhpSmaller = var0_6.dhpSmaller
	arg0_6._dHPGreaterMaxHP = var0_6.dhpGreaterMaxhp
	arg0_6._dhpSmallerMaxhp = var0_6.dhpSmallerMaxhp
end

function var3_0.ConfigAttrTrigger(arg0_7)
	local var0_7 = arg0_7._tempData.arg_list

	arg0_7._attrLowerBound = var0_7.attrLowerBound
	arg0_7._attrUpperBound = var0_7.attrUpperBound
	arg0_7._attrInterval = var0_7.attrInterval
end

function var3_0.SetCaster(arg0_8, arg1_8)
	arg0_8._caster = arg1_8
end

function var3_0.SetCommander(arg0_9, arg1_9)
	arg0_9._commander = arg1_9
end

function var3_0.SetBullet(arg0_10, arg1_10)
	return
end

function var3_0.SetArgs(arg0_11, arg1_11, arg2_11)
	return
end

function var3_0.SetOrb(arg0_12)
	return
end

function var3_0.Trigger(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13[arg1_13](arg0_13, arg2_13, arg3_13, arg4_13)
end

function var3_0.onAttach(arg0_14, arg1_14, arg2_14)
	arg0_14:onTrigger(arg1_14, arg2_14)
end

function var3_0.onRemove(arg0_15, arg1_15, arg2_15)
	arg0_15:onTrigger(arg1_15, arg2_15)
end

function var3_0.onBuffAdded(arg0_16, arg1_16, arg2_16, arg3_16)
	if not arg0_16:buffStateRequire(arg3_16.buffID) then
		return
	end

	arg0_16:onTrigger(arg1_16, arg2_16)
end

function var3_0.onBuffRemoved(arg0_17, arg1_17, arg2_17, arg3_17)
	if not arg0_17:buffStateRequire(arg3_17.buffID) then
		return
	end

	arg0_17:onTrigger(arg1_17, arg2_17)
end

function var3_0.onUpdate(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18:onTrigger(arg1_18, arg2_18, arg3_18)
end

function var3_0.onStack(arg0_19, arg1_19, arg2_19)
	arg0_19:onTrigger(arg1_19, arg2_19)
end

function var3_0.onBulletHit(arg0_20, arg1_20, arg2_20, arg3_20)
	if not arg0_20:equipIndexRequire(arg3_20.equipIndex) then
		return
	end

	if not arg0_20:bulletTagRequire(arg3_20.bulletTag) then
		return
	end

	if not arg0_20:victimRequire(arg3_20.target, arg1_20) then
		return
	end

	arg0_20:onTrigger(arg1_20, arg2_20, arg3_20)
end

function var3_0.onTeammateBulletHit(arg0_21, arg1_21, arg2_21, arg3_21)
	arg0_21:onBulletHit(arg1_21, arg2_21, arg3_21)
end

function var3_0.onBeHit(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg0_22._behit then
		if arg0_22._behit.damage_type == arg3_22.weaponType and arg0_22._behit.bullet_type == arg3_22.bulletType then
			arg0_22:onTrigger(arg1_22, arg2_22)
		end
	else
		arg0_22:onTrigger(arg1_22, arg2_22)
	end
end

function var3_0.onFire(arg0_23, arg1_23, arg2_23, arg3_23)
	if not arg0_23:equipIndexRequire(arg3_23.equipIndex) then
		return
	end

	arg0_23:onTrigger(arg1_23, arg2_23)
end

function var3_0.onCombo(arg0_24, arg1_24, arg2_24, arg3_24)
	if not arg0_24:equipIndexRequire(arg3_24.equipIndex) then
		return
	end

	local var0_24 = arg3_24.matchUnitCount
	local var1_24 = arg0_24._tempData.arg_list.upperBound
	local var2_24 = arg0_24._tempData.arg_list.lowerBound

	if var1_24 and var0_24 <= var1_24 then
		arg0_24:onTrigger(arg1_24, arg2_24)
	elseif var2_24 and var2_24 <= var0_24 then
		arg0_24:onTrigger(arg1_24, arg2_24)
	end
end

function var3_0.stackRequire(arg0_25, arg1_25)
	if arg0_25._stackRequire then
		local var0_25 = arg1_25:GetStack()

		return var1_0.simpleCompare(arg0_25._stackRequire, var0_25)
	else
		return true
	end
end

function var3_0.fleetAttrRequire(arg0_26, arg1_26, arg2_26)
	if arg0_26._fleetAttrRequire then
		local var0_26, var1_26 = string.find(arg0_26._fleetAttrRequire, "%p+")
		local var2_26 = string.sub(arg0_26._fleetAttrRequire, 1, var0_26 - 1)

		if arg2_26 ~= nil and var2_26 ~= arg2_26 then
			return false
		elseif arg1_26:GetFleetVO() then
			local var3_26 = arg1_26:GetFleetVO():GetFleetAttr()

			return var1_0.parseCompare(arg0_26._fleetAttrRequire, var3_26)
		else
			return false
		end
	end

	return true
end

function var3_0.fleetAttrDelatRequire(arg0_27, arg1_27)
	if arg0_27._fleetAttrDeltaRequire then
		return arg1_27 and var1_0.simpleCompare(arg0_27._fleetAttrDeltaRequire, arg1_27)
	end

	return true
end

function var3_0.equipIndexRequire(arg0_28, arg1_28)
	if not arg0_28._indexRequire then
		return true
	else
		for iter0_28, iter1_28 in ipairs(arg0_28._indexRequire) do
			if iter1_28 == arg1_28 then
				return true
			end
		end

		return false
	end
end

function var3_0.ammoRequire(arg0_29, arg1_29)
	if not arg0_29._ammoTypeRequire then
		return true
	else
		local var0_29 = arg1_29:GetWeaponByIndex(arg0_29._ammoIndexRequire)

		if not var0_29 or var0_29:GetPrimalAmmoType() ~= arg0_29._ammoTypeRequire then
			return false
		else
			return true
		end
	end
end

function var3_0.bulletTagRequire(arg0_30, arg1_30)
	if not arg0_30._bulletTagRequire then
		return true
	else
		for iter0_30, iter1_30 in ipairs(arg0_30._bulletTagRequire) do
			if table.contains(arg1_30, iter1_30) then
				return true
			else
				return false
			end
		end
	end
end

function var3_0.buffStateRequire(arg0_31, arg1_31)
	if not arg0_31._buffStateIDRequire then
		return true
	else
		return arg1_31 == arg0_31._buffStateIDRequire
	end
end

function var3_0.onWeaponSteday(arg0_32, arg1_32, arg2_32, arg3_32)
	arg0_32:onFire(arg1_32, arg2_32, arg3_32)
end

function var3_0.onChargeWeaponFire(arg0_33, arg1_33, arg2_33, arg3_33)
	arg0_33:onFire(arg1_33, arg2_33, arg3_33)
end

function var3_0.onTorpedoWeaponFire(arg0_34, arg1_34, arg2_34, arg3_34)
	arg0_34:onFire(arg1_34, arg2_34, arg3_34)
end

function var3_0.onAntiAirWeaponFireFar(arg0_35, arg1_35, arg2_35, arg3_35)
	arg0_35:onFire(arg1_35, arg2_35, arg3_35)
end

function var3_0.onAntiAirWeaponFireNear(arg0_36, arg1_36, arg2_36, arg3_36)
	arg0_36:onFire(arg1_36, arg2_36, arg3_36)
end

function var3_0.onManualMissileFire(arg0_37, arg1_37, arg2_37, arg3_37)
	arg0_37:onFire(arg1_37, arg2_37, arg3_37)
end

function var3_0.onAllInStrike(arg0_38, arg1_38, arg2_38, arg3_38)
	arg0_38:onFire(arg1_38, arg2_38, arg3_38)
end

function var3_0.onAllInStrikeSteady(arg0_39, arg1_39, arg2_39, arg3_39)
	arg0_39:onFire(arg1_39, arg2_39, arg3_39)
end

function var3_0.onPointStrikeReady(arg0_40, arg1_40, arg2_40, arg3_40)
	arg0_40:onFire(arg1_40, arg2_40, arg3_40)
end

function var3_0.onPointStrikeSteady(arg0_41, arg1_41, arg2_41, arg3_41)
	arg0_41:onFire(arg1_41, arg2_41, arg3_41)
end

function var3_0.onPointStrike(arg0_42, arg1_42, arg2_42, arg3_42)
	arg0_42:onFire(arg1_42, arg2_42, arg3_42)
end

function var3_0.onWeaonInterrupt(arg0_43, arg1_43, arg2_43, arg3_43)
	arg0_43:onTrigger(arg1_43, arg2_43)
end

function var3_0.onWeaponSuccess(arg0_44, arg1_44, arg2_44, arg3_44)
	arg0_44:onTrigger(arg1_44, arg2_44)
end

function var3_0.onChargeWeaponReady(arg0_45, arg1_45, arg2_45, arg3_45)
	arg0_45:onTrigger(arg1_45, arg2_45)
end

function var3_0.onManualTorpedoReady(arg0_46, arg1_46, arg2_46, arg3_46)
	arg0_46:onTrigger(arg1_46, arg2_46)
end

function var3_0.onAirAssistReady(arg0_47, arg1_47, arg2_47, arg3_47)
	arg0_47:onTrigger(arg1_47, arg2_47)
end

function var3_0.onManualMissileReady(arg0_48, arg1_48, arg2_48, arg3_48)
	arg0_48:onTrigger(arg1_48, arg2_48)
end

function var3_0.onTorpedoButtonPush(arg0_49, arg1_49, arg2_49, arg3_49)
	arg0_49:onTrigger(arg1_49, arg2_49)
end

function var3_0.onBeforeFatalDamage(arg0_50, arg1_50, arg2_50)
	arg0_50:onTrigger(arg1_50, arg2_50)
end

function var3_0.onAircraftCreate(arg0_51, arg1_51, arg2_51, arg3_51)
	arg0_51:onTrigger(arg1_51, arg2_51, arg3_51)
end

function var3_0.onFriendlyAircraftDying(arg0_52, arg1_52, arg2_52, arg3_52)
	if arg0_52._tempData.arg_list.templateID then
		if arg3_52.unit:GetTemplateID() == arg0_52._tempData.arg_list.templateID then
			arg0_52:onTrigger(arg1_52, arg2_52)
		end
	else
		arg0_52:onTrigger(arg1_52, arg2_52)
	end
end

function var3_0.onTeammateShipDying(arg0_53, arg1_53, arg2_53)
	arg0_53:onTrigger(arg1_53, arg2_53)
end

function var3_0.onFoeAircraftDying(arg0_54, arg1_54, arg2_54, arg3_54)
	if arg0_54._tempData.arg_list.inside then
		local var0_54 = arg3_54.unit

		if not arg1_54:GetFleetVO():GetFleetAntiAirWeapon():IsOutOfRange(var0_54) then
			arg0_54:onTrigger(arg1_54, arg2_54)
		end
	elseif arg0_54._tempData.arg_list.killer then
		if arg0_54:killerRequire(arg0_54._tempData.arg_list.killer, arg3_54.killer, arg1_54) then
			arg0_54:onTrigger(arg1_54, arg2_54)
		end
	else
		arg0_54:onTrigger(arg1_54, arg2_54)
	end
end

function var3_0.onFoeDying(arg0_55, arg1_55, arg2_55, arg3_55)
	if arg0_55._tempData.arg_list.killer then
		if arg0_55:killerRequire(arg0_55._tempData.arg_list.killer, arg3_55.killer, arg1_55) then
			arg0_55:onTrigger(arg1_55, arg2_55)
		end
	elseif arg0_55:victimRequire(arg3_55.unit, arg1_55) then
		arg0_55:onTrigger(arg1_55, arg2_55)
	else
		arg0_55:onTrigger(arg1_55, arg2_55)
	end
end

function var3_0.onSink(arg0_56, arg1_56, arg2_56)
	if arg0_56:deathCauseRequire(arg1_56) then
		arg0_56:onTrigger(arg1_56, arg2_56)
	end
end

function var3_0.deathCauseRequire(arg0_57, arg1_57)
	if not arg0_57._deathCauseRequire then
		return true
	end

	local var0_57 = arg1_57:GetDeathReason()

	return table.contains(arg0_57._deathCauseRequire, var0_57)
end

function var3_0.killerRequire(arg0_58, arg1_58, arg2_58, arg3_58)
	if not arg2_58 then
		return false
	end

	local var0_58
	local var1_58
	local var2_58 = arg2_58.__name

	if var2_58 == var0_0.Battle.BattlePlayerUnit.__name or var2_58 == var0_0.Battle.BattleNPCUnit.__name or var2_58 == var0_0.Battle.BattleMinionUnit.__name or var2_58 == var0_0.Battle.BattleEnemyUnit.__name or var2_58 == var0_0.Battle.BattleAircraftUnit.__name or var2_58 == var0_0.Battle.BattleAirFighterUnit.__name then
		var0_58 = arg2_58
	else
		var0_58 = arg2_58:GetHost()
	end

	if var0_58 then
		local var3_58 = var0_58.__name

		if var3_58 == var0_0.Battle.BattleAircraftUnit.__name then
			var1_58 = var0_58:GetMotherUnit()
		elseif var3_58 == var0_0.Battle.BattleMinionUnit.__name then
			var1_58 = var0_58:GetMaster()
		else
			var1_58 = var0_58
			var0_58 = nil
		end
	else
		return false
	end

	if arg1_58 == "self" then
		if var1_58 == arg3_58 and not var0_58 then
			return true
		end
	elseif arg1_58 == "child" and var1_58 == arg3_58 and var0_58 then
		return true
	end

	return false
end

function var3_0.victimRequire(arg0_59, arg1_59, arg2_59)
	if not arg0_59._victimTagRequire then
		return true
	elseif arg1_59:ContainsLabelTag(arg0_59._victimTagRequire) then
		return true
	else
		return false
	end
end

function var3_0.killerWeaponRequire(arg0_60, arg1_60, arg2_60, arg3_60)
	if not arg2_60 then
		return false
	end

	if not arg2_60.GetWeapon then
		return false
	end

	local var0_60 = arg2_60:GetWeapon():GetWeaponId()

	if table.contains(arg1_60, var0_60) then
		return true
	end
end

function var3_0.DamageSourceRequire(arg0_61, arg1_61, arg2_61)
	if not arg0_61._damageSrcTagRequire then
		return true
	else
		if not arg1_61 then
			return false
		end

		local var0_61 = var0_0.Battle.BattleDataProxy.GetInstance():GetUnitList()[arg1_61]

		if not var0_61 then
			return false
		end

		if var0_61:ContainsLabelTag(arg0_61._damageSrcTagRequire) then
			return true
		else
			return false
		end
	end
end

function var3_0.onInitGame(arg0_62, arg1_62, arg2_62)
	arg0_62:onTrigger(arg1_62, arg2_62)
end

function var3_0.onStartGame(arg0_63, arg1_63, arg2_63)
	arg0_63:onTrigger(arg1_63, arg2_63)
end

function var3_0.onManual(arg0_64, arg1_64, arg2_64)
	arg0_64:onTrigger(arg1_64, arg2_64)
end

function var3_0.onAutoBot(arg0_65, arg1_65, arg2_65)
	arg0_65:onTrigger(arg1_65, arg2_65)
end

function var3_0.onFlagShip(arg0_66, arg1_66, arg2_66)
	arg0_66:onTrigger(arg1_66, arg2_66)
end

function var3_0.onUpperConsort(arg0_67, arg1_67, arg2_67)
	arg0_67:onTrigger(arg1_67, arg2_67)
end

function var3_0.onLowerConsort(arg0_68, arg1_68, arg2_68)
	arg0_68:onTrigger(arg1_68, arg2_68)
end

function var3_0.onLeader(arg0_69, arg1_69, arg2_69)
	arg0_69:onTrigger(arg1_69, arg2_69)
end

function var3_0.onCenter(arg0_70, arg1_70, arg2_70)
	arg0_70:onTrigger(arg1_70, arg2_70)
end

function var3_0.onRear(arg0_71, arg1_71, arg2_71)
	arg0_71:onTrigger(arg1_71, arg2_71)
end

function var3_0.onSubLeader(arg0_72, arg1_72, arg2_72)
	arg0_72:onTrigger(arg1_72, arg2_72)
end

function var3_0.onUpperSubConsort(arg0_73, arg1_73, arg2_73)
	arg0_73:onTrigger(arg1_73, arg2_73)
end

function var3_0.onLowerSubConsort(arg0_74, arg1_74, arg2_74)
	arg0_74:onTrigger(arg1_74, arg2_74)
end

function var3_0.onBulletCollide(arg0_75, arg1_75, arg2_75, arg3_75)
	if not arg0_75:equipIndexRequire(arg3_75.equipIndex) then
		return
	end

	arg0_75:onTrigger(arg1_75, arg2_75)
end

function var3_0.onBulletCollideBefore(arg0_76, arg1_76, arg2_76, arg3_76)
	if not arg0_76:equipIndexRequire(arg3_76.equipIndex) then
		return
	end

	arg0_76:onTrigger(arg1_76, arg2_76)
end

function var3_0.onBombBulletBang(arg0_77, arg1_77, arg2_77, arg3_77)
	if not arg0_77:equipIndexRequire(arg3_77.equipIndex) then
		return
	end

	arg0_77:onTrigger(arg1_77, arg2_77)
end

function var3_0.onTorpedoBulletBang(arg0_78, arg1_78, arg2_78, arg3_78)
	if not arg0_78:equipIndexRequire(arg3_78.equipIndex) then
		return
	end

	arg0_78:onTrigger(arg1_78, arg2_78)
end

function var3_0.onBulletHitBefore(arg0_79, arg1_79, arg2_79, arg3_79)
	if arg0_79._behit then
		if arg0_79._behit.damage_type == arg3_79.weaponType and arg0_79._behit.bullet_type == arg3_79.bulletType then
			arg0_79:onTrigger(arg1_79, arg2_79)
		end
	else
		arg0_79:onTrigger(arg1_79, arg2_79)
	end
end

function var3_0.onBulletCreate(arg0_80, arg1_80, arg2_80, arg3_80)
	if not arg0_80:equipIndexRequire(arg3_80.equipIndex) then
		return
	end

	arg0_80:onTrigger(arg1_80, arg2_80, arg3_80)
end

function var3_0.onChargeWeaponBulletCreate(arg0_81, arg1_81, arg2_81, arg3_81)
	arg0_81:onBulletCreate(arg1_81, arg2_81, arg3_81)
end

function var3_0.onTorpedoWeaponBulletCreate(arg0_82, arg1_82, arg2_82, arg3_82)
	arg0_82:onBulletCreate(arg1_82, arg2_82, arg3_82)
end

function var3_0.onInternalBulletCreate(arg0_83, arg1_83, arg2_83, arg3_83)
	if not arg0_83:equipIndexRequire(arg3_83.equipIndex) then
		return
	end

	arg0_83:onTrigger(arg1_83, arg2_83, arg3_83)
end

function var3_0.onManualBulletCreate(arg0_84, arg1_84, arg2_84, arg3_84)
	if not arg0_84:equipIndexRequire(arg3_84.equipIndex) then
		return
	end

	arg0_84:onTrigger(arg1_84, arg2_84, arg3_84)
end

function var3_0.onBeforeTakeDamage(arg0_85, arg1_85, arg2_85, arg3_85)
	if arg0_85:damageCheck(arg3_85) then
		arg0_85:onTrigger(arg1_85, arg2_85, arg3_85)
	end
end

function var3_0.onTakeDamage(arg0_86, arg1_86, arg2_86, arg3_86)
	if arg0_86:damageCheck(arg3_86) then
		arg0_86:onTrigger(arg1_86, arg2_86, arg3_86)
	end
end

function var3_0.onTakeHealing(arg0_87, arg1_87, arg2_87, arg3_87)
	arg0_87:onTrigger(arg1_87, arg2_87, arg3_87)
end

function var3_0.onShieldAbsorb(arg0_88, arg1_88, arg2_88, arg3_88)
	arg0_88:onTrigger(arg1_88, arg2_88, arg3_88)
end

function var3_0.onDamageFix(arg0_89, arg1_89, arg2_89, arg3_89)
	arg0_89:onTrigger(arg1_89, arg2_89, arg3_89)
end

function var3_0.onDamageConclude(arg0_90, arg1_90, arg2_90, arg3_90)
	arg0_90:onTrigger(arg1_90, arg2_90, arg3_90)
end

function var3_0.onOverHealing(arg0_91, arg1_91, arg2_91, arg3_91)
	arg0_91:onTrigger(arg1_91, arg2_91, arg3_91)
end

function var3_0.onFleetAttrUpdate(arg0_92, arg1_92, arg2_92, arg3_92)
	arg0_92:onTrigger(arg1_92, arg2_92, arg3_92)
end

function var3_0.damageCheck(arg0_93, arg1_93)
	return arg0_93:damageAttrRequire(arg1_93.damageAttr) and arg0_93:damageReasonRequire(arg1_93.damageReason)
end

function var3_0.damageAttrRequire(arg0_94, arg1_94)
	if not arg0_94._damageAttrRequire or table.contains(arg0_94._damageAttrRequire, arg1_94) then
		return true
	else
		return false
	end
end

function var3_0.damageReasonRequire(arg0_95, arg1_95)
	if not arg0_95._damageReasonRequire or table.contains(arg0_95._damageReasonRequire, arg1_95) then
		return true
	else
		return false
	end
end

function var3_0.hpIntervalRequire(arg0_96, arg1_96, arg2_96)
	if arg0_96._hpUpperBound == nil and arg0_96._hpLowerBound == nil then
		return true
	end

	if not arg2_96 or arg0_96._hpSigned == 0 then
		-- block empty
	elseif arg2_96 * arg0_96._hpSigned < 0 then
		return false
	end

	local var0_96

	if arg0_96._hpOutInterval then
		if arg1_96 >= arg0_96._hpUpperBound or arg1_96 <= arg0_96._hpLowerBound then
			var0_96 = true
		end
	elseif arg1_96 <= arg0_96._hpUpperBound and arg1_96 >= arg0_96._hpLowerBound then
		var0_96 = true
	end

	return var0_96
end

function var3_0.dhpRequire(arg0_97, arg1_97, arg2_97)
	if arg0_97._dHPGreater then
		return arg2_97 * arg0_97._dHPGreater > 0 and math.abs(arg2_97) > math.abs(arg0_97._dHPGreater)
	elseif arg0_97._dHPGreaterMaxHP then
		local var0_97 = arg0_97._dHPGreaterMaxHP * arg1_97

		return arg2_97 * var0_97 > 0 and math.abs(arg2_97) > math.abs(var0_97)
	elseif arg0_97._dhpSmaller then
		return arg2_97 * arg0_97._dhpSmaller > 0 and math.abs(arg2_97) < math.abs(arg0_97._dhpSmaller)
	elseif arg0_97._dhpSmallerMaxhp then
		local var1_97 = arg0_97._dhpSmallerMaxhp * arg1_97

		return arg2_97 * var1_97 > 0 and math.abs(arg2_97) < math.abs(var1_97)
	else
		return true
	end
end

function var3_0.attrIntervalRequire(arg0_98, arg1_98)
	local var0_98 = true

	if arg0_98._attrUpperBound and arg1_98 >= arg0_98._attrUpperBound then
		var0_98 = false
	end

	if arg0_98._attrLowerBound and arg1_98 <= arg0_98._attrLowerBound then
		var0_98 = false
	end

	return var0_98
end

function var3_0.onHPRatioUpdate(arg0_99, arg1_99, arg2_99, arg3_99)
	local var0_99 = arg1_99:GetHPRate()
	local var1_99 = arg3_99.dHP

	if arg0_99:hpIntervalRequire(var0_99, var1_99) and arg0_99:dhpRequire(arg1_99:GetMaxHP(), var1_99) then
		arg0_99:doOnHPRatioUpdate(arg1_99, arg2_99, arg3_99)
	end
end

function var3_0.onFriendlyHpRatioUpdate(arg0_100, arg1_100, arg2_100, arg3_100)
	local var0_100 = arg3_100.unit
	local var1_100 = arg3_100.dHP
	local var2_100 = var0_100:GetHPRate()

	if arg0_100:hpIntervalRequire(var2_100, var1_100) and arg0_100:dhpRequire(var0_100:GetMaxHP(), var1_100) then
		arg0_100:doOnHPRatioUpdate(arg1_100, arg2_100, arg3_100)
	end
end

function var3_0.onTeammateHpRatioUpdate(arg0_101, arg1_101, arg2_101, arg3_101)
	arg0_101:onFriendlyHpRatioUpdate(arg1_101, arg2_101, arg3_101)
end

function var3_0.onBulletKill(arg0_102, arg1_102, arg2_102, arg3_102)
	if arg0_102._tempData.arg_list.killer_weapon_id then
		if arg0_102:killerWeaponRequire(arg0_102._tempData.arg_list.killer_weapon_id, arg3_102.killer, arg1_102) then
			arg0_102:onTrigger(arg1_102, arg2_102)
		end
	else
		arg0_102:onTrigger(arg1_102, arg2_102)
	end
end

function var3_0.onBattleBuffCount(arg0_103, arg1_103, arg2_103, arg3_103)
	local var0_103 = arg3_103.buffFX

	if var0_103:GetCountType() == arg0_103._countType then
		if var0_103:Repeater() then
			while var0_103:GetCountProgress() >= 1 do
				arg0_103:onTrigger(arg1_103, arg2_103)
				var0_103:ConsumeCount()
			end
		elseif arg0_103:onTrigger(arg1_103, arg2_103) ~= "overheat" then
			var0_103:ResetCount()
		end
	end
end

function var3_0.onShieldBroken(arg0_104, arg1_104, arg2_104, arg3_104)
	if arg3_104.shieldBuffID == arg0_104._tempData.arg_list.shieldBuffID then
		arg0_104:onTrigger(arg1_104, arg2_104)
	end
end

function var3_0.onTrigger(arg0_105, arg1_105, arg2_105, arg3_105)
	if arg0_105._quota > 0 then
		arg0_105._quota = arg0_105._quota - 1
	end
end

function var3_0.doOnHPRatioUpdate(arg0_106, arg1_106, arg2_106, arg3_106)
	arg0_106:onTrigger(arg1_106, arg2_106, arg3_106)
end

function var3_0.doOnFriendlyHPRatioUpdate(arg0_107, arg1_107, arg2_107, arg3_107)
	arg0_107:onTrigger(arg1_107, arg2_107, arg3_107)
end

function var3_0.onSubmarineDive(arg0_108, arg1_108, arg2_108, arg3_108)
	arg0_108:onTrigger(arg1_108, arg2_108, arg3_108)
end

function var3_0.onSubmarineRaid(arg0_109, arg1_109, arg2_109, arg3_109)
	arg0_109:onTrigger(arg1_109, arg2_109, arg3_109)
end

function var3_0.onSubmarineFloat(arg0_110, arg1_110, arg2_110, arg3_110)
	arg0_110:onTrigger(arg1_110, arg2_110, arg3_110)
end

function var3_0.onSubmarineRetreat(arg0_111, arg1_111, arg2_111, arg3_111)
	arg0_111:onTrigger(arg1_111, arg2_111, arg3_111)
end

function var3_0.onSubmarineAid(arg0_112, arg1_112, arg2_112, arg3_112)
	arg0_112:onTrigger(arg1_112, arg2_112, arg3_112)
end

function var3_0.onSubmarinFreeDive(arg0_113, arg1_113, arg2_113, arg3_113)
	arg0_113:onTrigger(arg1_113, arg2_113, arg3_113)
end

function var3_0.onSubmarinFreeFloat(arg0_114, arg1_114, arg2_114, arg3_114)
	arg0_114:onTrigger(arg1_114, arg2_114, arg3_114)
end

function var3_0.onSubmarineFreeSpecial(arg0_115, arg1_115, arg2_115, arg3_115)
	arg0_115:onTrigger(arg1_115, arg2_115, arg3_115)
end

function var3_0.onSubDetected(arg0_116, arg1_116, arg2_116, arg3_116)
	arg0_116:onTrigger(arg1_116, arg2_116, arg3_116)
end

function var3_0.onSubUnDetected(arg0_117, arg1_117, arg2_117, arg3_117)
	arg0_117:onTrigger(arg1_117, arg2_117, arg3_117)
end

function var3_0.onAntiSubHateChain(arg0_118, arg1_118, arg2_118, arg3_118)
	arg0_118:onTrigger(arg1_118, arg2_118, attach)
end

function var3_0.onRetreat(arg0_119, arg1_119, arg2_119, arg3_119)
	arg0_119:onTrigger(arg1_119, arg2_119, arg3_119)
end

function var3_0.onCloakUpdate(arg0_120, arg1_120, arg2_120, arg3_120)
	if arg0_120:cloakStateRequire(arg3_120.cloakState) then
		arg0_120:onTrigger(arg1_120, arg2_120, arg3_120)
	end
end

function var3_0.onTeammateCloakUpdate(arg0_121, arg1_121, arg2_121, arg3_121)
	if arg0_121:cloakStateRequire(arg3_121.cloakState) then
		arg0_121:onTrigger(arg1_121, arg2_121, arg3_121)
	end
end

function var3_0.cloakStateRequire(arg0_122, arg1_122)
	if not arg0_122._cloakRequire then
		return true
	else
		return arg0_122._cloakRequire == arg1_122
	end
end

function var3_0.Interrupt(arg0_123)
	return
end

function var3_0.Clear(arg0_124)
	arg0_124._commander = nil
end

function var3_0.getTargetList(arg0_125, arg1_125, arg2_125, arg3_125, arg4_125)
	if type(arg2_125) == "string" then
		arg2_125 = {
			arg2_125
		}
	end

	local var0_125 = arg3_125

	if table.contains(arg2_125, "TargetDamageSource") then
		var0_125 = Clone(arg3_125)
		var0_125.damageSourceID = arg4_125.damageSrc
	end

	local var1_125

	for iter0_125, iter1_125 in ipairs(arg2_125) do
		var1_125 = var0_0.Battle.BattleTargetChoise[iter1_125](arg1_125, var0_125, var1_125)
	end

	return var1_125
end

function var3_0.commanderRequire(arg0_126, arg1_126)
	if arg0_126._tempData.arg_list.CMDBuff_id then
		local var0_126, var1_126 = var0_0.Battle.BattleDataProxy.GetInstance():GetCommanderBuff()
		local var2_126
		local var3_126 = arg1_126:GetTemplate().type

		if table.contains(TeamType.SubShipType, var3_126) then
			var2_126 = var1_126
		else
			var2_126 = var0_126
		end

		local var4_126 = {}
		local var5_126 = arg0_126._tempData.arg_list.CMDBuff_id

		for iter0_126, iter1_126 in ipairs(var2_126) do
			if iter1_126.id == var5_126 then
				table.insert(var4_126, iter1_126)
			end
		end

		return #var4_126 > 0
	else
		return true
	end
end

function var3_0.IsActive(arg0_127)
	return arg0_127._isActive
end

function var3_0.SetActive(arg0_128)
	arg0_128._isActive = true
end

function var3_0.NotActive(arg0_129)
	arg0_129._isActive = false
end

function var3_0.IsLock(arg0_130)
	return arg0_130._isLock
end

function var3_0.SetLock(arg0_131)
	arg0_131._isLock = true
end

function var3_0.NotLock(arg0_132)
	arg0_132._isLock = false
end

function var3_0.Dispose(arg0_133)
	return
end
