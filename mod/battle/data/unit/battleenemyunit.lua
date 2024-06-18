ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleAttr
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleUnitEvent
local var7_0 = var0_0.Battle.UnitState
local var8_0 = class("BattleEnemyUnit", var0_0.Battle.BattleUnit)

var0_0.Battle.BattleEnemyUnit = var8_0
var8_0.__name = "BattleEnemyUnit"

function var8_0.Ctor(arg0_1, arg1_1, arg2_1)
	var8_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._type = var2_0.UnitType.ENEMY_UNIT
	arg0_1._level = arg0_1._battleProxy:GetDungeonLevel()
end

function var8_0.Dispose(arg0_2)
	if arg0_2._aimBias then
		arg0_2._aimBias:Dispose()
	end

	var8_0.super.Dispose(arg0_2)
end

function var8_0.SetBound(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3)
	var8_0.super.SetBound(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3)

	arg0_3._weaponRightBound = arg4_3
	arg0_3._weaponLowerBound = arg2_3
end

function var8_0.UpdateAction(arg0_4)
	if arg0_4._oxyState and arg0_4._oxyState:GetCurrentDiveState() == var2_0.OXY_STATE.DIVE then
		if arg0_4:GetSpeed().x > 0 then
			arg0_4._unitState:ChangeState(var7_0.STATE_DIVELEFT)
		else
			arg0_4._unitState:ChangeState(var7_0.STATE_DIVE)
		end
	elseif arg0_4:GetSpeed().x > 0 then
		arg0_4._unitState:ChangeState(var7_0.STATE_MOVELEFT)
	else
		arg0_4._unitState:ChangeState(var7_0.STATE_MOVE)
	end
end

function var8_0.UpdateHP(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = var8_0.super.UpdateHP(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)

	if arg0_5._phaseSwitcher then
		arg0_5._phaseSwitcher:UpdateHP(arg0_5:GetHPRate())
	end

	return var0_5
end

function var8_0.SetMaster(arg0_6, arg1_6)
	arg0_6._master = arg1_6
end

function var8_0.GetMaster(arg0_7)
	return arg0_7._master
end

function var8_0.SetTemplate(arg0_8, arg1_8, arg2_8)
	var8_0.super.SetTemplate(arg0_8, arg1_8)

	arg0_8._tmpData = var1_0.GetMonsterTmpDataFromID(arg0_8._tmpID)

	arg0_8:configWeaponQueueParallel()
	arg0_8:InitCldComponent()
	arg0_8:SetAttr()

	arg2_8 = arg2_8 or {}

	local var0_8 = arg0_8:GetExtraInfo()

	for iter0_8, iter1_8 in pairs(arg2_8) do
		var0_8[iter0_8] = iter1_8
	end

	arg0_8:setStandardLabelTag()
end

function var8_0.SetTeamVO(arg0_9, arg1_9)
	arg0_9._team = arg1_9
end

function var8_0.SetFormationIndex(arg0_10, arg1_10)
	arg0_10._formationIndex = arg1_10
end

function var8_0.SetWaveIndex(arg0_11, arg1_11)
	arg0_11._waveIndex = arg1_11
end

function var8_0.SetAttr(arg0_12)
	var4_0.SetEnemyAttr(arg0_12)
	var4_0.InitDOTAttr(arg0_12._attr, arg0_12._tmpData)
end

function var8_0.GetTemplate(arg0_13)
	return arg0_13._tmpData
end

function var8_0.GetRarity(arg0_14)
	return arg0_14._tmpData.rarity
end

function var8_0.GetLevel(arg0_15)
	return arg0_15._overrideLevel or arg0_15._level or 1
end

function var8_0.GetTeam(arg0_16)
	return arg0_16._team
end

function var8_0.GetWaveIndex(arg0_17)
	return arg0_17._waveIndex
end

function var8_0.IsShowHPBar(arg0_18)
	return arg0_18._IFF ~= var5_0.FRIENDLY_CODE
end

function var8_0.IsSpectre(arg0_19)
	local var0_19
	local var1_19 = var0_0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY

	if arg0_19:GetAttr()[var1_19] ~= nil then
		var0_19 = arg0_19:GetAttrByName(var1_19)
	else
		var0_19 = arg0_19._tmpData.battle_unit_type
	end

	return var0_19 <= var5_0.SPECTRE_UNIT_TYPE, var0_19
end

function var8_0.InitCldComponent(arg0_20)
	var8_0.super.InitCldComponent(arg0_20)

	local var0_20 = {
		type = var2_0.CldType.SHIP,
		IFF = arg0_20:GetIFF(),
		UID = arg0_20:GetUniqueID(),
		Mass = var2_0.CldMass.L1,
		IsBoss = arg0_20._isBoss
	}

	arg0_20._cldComponent:SetCldData(var0_20)

	if arg0_20:GetTemplate().friendly_cld ~= 0 then
		arg0_20._cldComponent:ActiveFriendlyCld()
	end
end

function var8_0.ConfigBubbleFX(arg0_21)
	arg0_21._bubbleFX = arg0_21._tmpData.bubble_fx[1]

	arg0_21._oxyState:SetBubbleTemplate(arg0_21._tmpData.bubble_fx[2], arg0_21._tmpData.bubble_fx[3])
end
