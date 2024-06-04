ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleAttr
local var4 = var0.Battle.BattleConst
local var5 = var4.EquipmentType
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleCardPuzzleEvent
local var8 = var0.Battle.BattleAttr

var0.Battle.BattleCardPuzzlePlayerUnit = class("BattleCardPuzzlePlayerUnit", var0.Battle.BattlePlayerUnit)
var0.Battle.BattleCardPuzzlePlayerUnit.__name = "BattleCardPuzzlePlayerUnit"

local var9 = var0.Battle.BattleCardPuzzlePlayerUnit

function var9.Ctor(arg0, arg1, arg2)
	var9.super.Ctor(arg0, arg1, arg2)
end

function var9.UpdateHP(arg0, arg1, arg2)
	if not arg0:IsAlive() then
		return
	end

	local var0 = arg0:IsAlive()

	if not var0 then
		return
	end

	local var1 = arg2.isMiss
	local var2 = arg2.isCri
	local var3 = arg2.isHeal
	local var4 = arg2.isShare
	local var5 = arg2.attr
	local var6 = arg2.font
	local var7 = arg2.cldPos
	local var8 = arg1
	local var9 = arg0:GetCurrentHP()

	if not var3 then
		local var10 = {
			damage = -arg1,
			isShare = var4,
			miss = var1,
			cri = var2,
			damageSrc = arg2.srcID,
			damageAttr = var5
		}

		arg0:TriggerBuff(var4.BuffEffectType.ON_TAKE_DAMAGE, var10)

		if var9 <= var10.damage then
			arg0:TriggerBuff(var4.BuffEffectType.ON_BEFORE_FATAL_DAMAGE, {})
		end

		arg1 = -var10.damage

		if var8.IsInvincible(arg0) then
			return 0
		end
	else
		local var11 = {
			damage = arg1,
			isHeal = var3
		}

		arg0:TriggerBuff(var4.BuffEffectType.ON_TAKE_HEALING, var11)

		var3 = var11.isHeal
		arg1 = var11.damage
	end

	local var12 = math.min(arg0:GetMaxHP(), math.max(0, var9 + arg1)) - var9
	local var13 = {
		preShieldHP = var8,
		dHP = arg1,
		validDHP = var12,
		isMiss = var1,
		isCri = var2,
		isHeal = var3,
		font = var6
	}

	if var7 and not var7:EqualZero() then
		local var14 = arg0:GetPosition()
		local var15 = arg0:GetBoxSize().x
		local var16 = var14.x - var15
		local var17 = var14.x + var15
		local var18 = var7:Clone()

		var18.x = Mathf.Clamp(var18.x, var16, var17)
		var13.posOffset = var14 - var18
	end

	arg0:UpdateHPAction(var13)

	if not arg0:IsAlive() and var0 then
		arg0:SetDeathReason(arg2.damageReason)
		arg0:DeadAction()
	end

	if arg0:IsAlive() then
		arg0:TriggerBuff(var4.BuffEffectType.ON_HP_RATIO_UPDATE, {
			dHP = arg1,
			unit = arg0
		})
	end

	return arg1
end

function var9.UpdateHPAction(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var7.UPDATE_COMMON_HP, arg1))
	var9.super.UpdateHPAction(arg0, arg1)
end

function var9.SetTemplate(arg0, arg1, arg2, arg3)
	arg0._tmpID = arg1
	arg0._tmpData = Clone(var1.GetPuzzleShipDataTemplate(arg0._tmpID))
	arg0._tmpData.scale = 100
	arg0._tmpData.parallel_max = {
		1,
		1,
		1
	}

	arg0:configWeaponQueueParallel()
	arg0:overrideSkin(arg0._tmpData.skin_id, true)
	arg0:InitCldComponent()
	arg0:setAttrFromOutBattle(arg2, arg3)

	arg0._personality = var1.GetShipPersonality(2)

	var3.SetCurrent(arg0, "srcShipType", arg0._tmpData.type)

	for iter0, iter1 in ipairs(arg0._tmpData.tag) do
		arg0:AddLabelTag(iter1)
	end
end

function var9.GetTemplate(arg0)
	return arg0._tmpData
end

function var9.InitCurrentHP(arg0)
	return
end

function var9.InitFleetCurrentHP(arg0, arg1)
	arg0:TriggerBuff(var4.BuffEffectType.ON_HP_RATIO_UPDATE, {})
end

function var9.SetCurrentHP(arg0, arg1)
	return
end

function var9.GetCurrentHP(arg0)
	return arg0._fleetCardPuzzleComponent:GetCurrentCommonHP()
end

function var9.GetMaxHP(arg0)
	return arg0._fleetCardPuzzleComponent:GetTotalCommonHP()
end

function var9.GetHP(arg0)
	return arg0:GetCurrentHP(), arg0:GetMaxHP()
end

function var9.GetHPRate(arg0)
	return arg0:GetCurrentHP() / arg0:GetMaxHP()
end

function var9.SetFleetVO(arg0, arg1)
	var9.super.SetFleetVO(arg0, arg1)

	arg0._fleetCardPuzzleComponent = arg1:GetCardPuzzleComponent()
end

function var9.LeaderSetting(arg0)
	arg0._warningValue = 1
end

function var9.SetMainFleetUnit(arg0, arg1)
	arg0._isMainFleetUnit = true

	arg0:SetMainUnitStatic(true)

	arg0._mainUnitWarningValue = 1
end

function var9.CheckWeaponInitial(arg0)
	return
end

function var9.setWeapon(arg0)
	local var0 = arg0._tmpData.default_equip

	for iter0, iter1 in ipairs(var0) do
		if iter1 ~= 0 then
			local var1 = var1.GetWeaponDataFromID(iter1)

			for iter2, iter3 in ipairs(var1) do
				if iter3 ~= -1 then
					local var2 = var0.Battle.BattleDataFunction.CreateWeaponUnit(iter3, arg0, nil, iter0)

					arg0._totalWeapon[#arg0._totalWeapon + 1] = var2

					if weaponType == var4.EquipmentType.STRIKE_AIRCRAFT then
						-- block empty
					else
						assert(#var1 < 2, "自动武器一组不允许配置多个")
						arg0:AddAutoWeapon(var2)
					end

					if weaponType == var4.EquipmentType.INTERCEPT_AIRCRAFT or weaponType == var4.EquipmentType.STRIKE_AIRCRAFT then
						arg0._hiveList[#arg0._hiveList + 1] = var2
					end

					if weaponType == var4.EquipmentType.ANTI_AIR then
						arg0._AAList[#arg0._AAList + 1] = var2
					end
				end
			end
		end
	end
end
