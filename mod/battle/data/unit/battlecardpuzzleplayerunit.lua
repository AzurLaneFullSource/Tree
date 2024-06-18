ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleAttr
local var4_0 = var0_0.Battle.BattleConst
local var5_0 = var4_0.EquipmentType
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleCardPuzzleEvent
local var8_0 = var0_0.Battle.BattleAttr

var0_0.Battle.BattleCardPuzzlePlayerUnit = class("BattleCardPuzzlePlayerUnit", var0_0.Battle.BattlePlayerUnit)
var0_0.Battle.BattleCardPuzzlePlayerUnit.__name = "BattleCardPuzzlePlayerUnit"

local var9_0 = var0_0.Battle.BattleCardPuzzlePlayerUnit

function var9_0.Ctor(arg0_1, arg1_1, arg2_1)
	var9_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var9_0.UpdateHP(arg0_2, arg1_2, arg2_2)
	if not arg0_2:IsAlive() then
		return
	end

	local var0_2 = arg0_2:IsAlive()

	if not var0_2 then
		return
	end

	local var1_2 = arg2_2.isMiss
	local var2_2 = arg2_2.isCri
	local var3_2 = arg2_2.isHeal
	local var4_2 = arg2_2.isShare
	local var5_2 = arg2_2.attr
	local var6_2 = arg2_2.font
	local var7_2 = arg2_2.cldPos
	local var8_2 = arg1_2
	local var9_2 = arg0_2:GetCurrentHP()

	if not var3_2 then
		local var10_2 = {
			damage = -arg1_2,
			isShare = var4_2,
			miss = var1_2,
			cri = var2_2,
			damageSrc = arg2_2.srcID,
			damageAttr = var5_2
		}

		arg0_2:TriggerBuff(var4_0.BuffEffectType.ON_TAKE_DAMAGE, var10_2)

		if var9_2 <= var10_2.damage then
			arg0_2:TriggerBuff(var4_0.BuffEffectType.ON_BEFORE_FATAL_DAMAGE, {})
		end

		arg1_2 = -var10_2.damage

		if var8_0.IsInvincible(arg0_2) then
			return 0
		end
	else
		local var11_2 = {
			damage = arg1_2,
			isHeal = var3_2
		}

		arg0_2:TriggerBuff(var4_0.BuffEffectType.ON_TAKE_HEALING, var11_2)

		var3_2 = var11_2.isHeal
		arg1_2 = var11_2.damage
	end

	local var12_2 = math.min(arg0_2:GetMaxHP(), math.max(0, var9_2 + arg1_2)) - var9_2
	local var13_2 = {
		preShieldHP = var8_2,
		dHP = arg1_2,
		validDHP = var12_2,
		isMiss = var1_2,
		isCri = var2_2,
		isHeal = var3_2,
		font = var6_2
	}

	if var7_2 and not var7_2:EqualZero() then
		local var14_2 = arg0_2:GetPosition()
		local var15_2 = arg0_2:GetBoxSize().x
		local var16_2 = var14_2.x - var15_2
		local var17_2 = var14_2.x + var15_2
		local var18_2 = var7_2:Clone()

		var18_2.x = Mathf.Clamp(var18_2.x, var16_2, var17_2)
		var13_2.posOffset = var14_2 - var18_2
	end

	arg0_2:UpdateHPAction(var13_2)

	if not arg0_2:IsAlive() and var0_2 then
		arg0_2:SetDeathReason(arg2_2.damageReason)
		arg0_2:DeadAction()
	end

	if arg0_2:IsAlive() then
		arg0_2:TriggerBuff(var4_0.BuffEffectType.ON_HP_RATIO_UPDATE, {
			dHP = arg1_2,
			unit = arg0_2
		})
	end

	return arg1_2
end

function var9_0.UpdateHPAction(arg0_3, arg1_3)
	arg0_3:DispatchEvent(var0_0.Event.New(var7_0.UPDATE_COMMON_HP, arg1_3))
	var9_0.super.UpdateHPAction(arg0_3, arg1_3)
end

function var9_0.SetTemplate(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4._tmpID = arg1_4
	arg0_4._tmpData = Clone(var1_0.GetPuzzleShipDataTemplate(arg0_4._tmpID))
	arg0_4._tmpData.scale = 100
	arg0_4._tmpData.parallel_max = {
		1,
		1,
		1
	}

	arg0_4:configWeaponQueueParallel()
	arg0_4:overrideSkin(arg0_4._tmpData.skin_id, true)
	arg0_4:InitCldComponent()
	arg0_4:setAttrFromOutBattle(arg2_4, arg3_4)

	arg0_4._personality = var1_0.GetShipPersonality(2)

	var3_0.SetCurrent(arg0_4, "srcShipType", arg0_4._tmpData.type)

	for iter0_4, iter1_4 in ipairs(arg0_4._tmpData.tag) do
		arg0_4:AddLabelTag(iter1_4)
	end
end

function var9_0.GetTemplate(arg0_5)
	return arg0_5._tmpData
end

function var9_0.InitCurrentHP(arg0_6)
	return
end

function var9_0.InitFleetCurrentHP(arg0_7, arg1_7)
	arg0_7:TriggerBuff(var4_0.BuffEffectType.ON_HP_RATIO_UPDATE, {})
end

function var9_0.SetCurrentHP(arg0_8, arg1_8)
	return
end

function var9_0.GetCurrentHP(arg0_9)
	return arg0_9._fleetCardPuzzleComponent:GetCurrentCommonHP()
end

function var9_0.GetMaxHP(arg0_10)
	return arg0_10._fleetCardPuzzleComponent:GetTotalCommonHP()
end

function var9_0.GetHP(arg0_11)
	return arg0_11:GetCurrentHP(), arg0_11:GetMaxHP()
end

function var9_0.GetHPRate(arg0_12)
	return arg0_12:GetCurrentHP() / arg0_12:GetMaxHP()
end

function var9_0.SetFleetVO(arg0_13, arg1_13)
	var9_0.super.SetFleetVO(arg0_13, arg1_13)

	arg0_13._fleetCardPuzzleComponent = arg1_13:GetCardPuzzleComponent()
end

function var9_0.LeaderSetting(arg0_14)
	arg0_14._warningValue = 1
end

function var9_0.SetMainFleetUnit(arg0_15, arg1_15)
	arg0_15._isMainFleetUnit = true

	arg0_15:SetMainUnitStatic(true)

	arg0_15._mainUnitWarningValue = 1
end

function var9_0.CheckWeaponInitial(arg0_16)
	return
end

function var9_0.setWeapon(arg0_17)
	local var0_17 = arg0_17._tmpData.default_equip

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if iter1_17 ~= 0 then
			local var1_17 = var1_0.GetWeaponDataFromID(iter1_17)

			for iter2_17, iter3_17 in ipairs(var1_17) do
				if iter3_17 ~= -1 then
					local var2_17 = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(iter3_17, arg0_17, nil, iter0_17)

					arg0_17._totalWeapon[#arg0_17._totalWeapon + 1] = var2_17

					if weaponType == var4_0.EquipmentType.STRIKE_AIRCRAFT then
						-- block empty
					else
						assert(#var1_17 < 2, "自动武器一组不允许配置多个")
						arg0_17:AddAutoWeapon(var2_17)
					end

					if weaponType == var4_0.EquipmentType.INTERCEPT_AIRCRAFT or weaponType == var4_0.EquipmentType.STRIKE_AIRCRAFT then
						arg0_17._hiveList[#arg0_17._hiveList + 1] = var2_17
					end

					if weaponType == var4_0.EquipmentType.ANTI_AIR then
						arg0_17._AAList[#arg0_17._AAList + 1] = var2_17
					end
				end
			end
		end
	end
end
