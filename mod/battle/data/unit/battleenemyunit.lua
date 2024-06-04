ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleAttr
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleUnitEvent
local var7 = var0.Battle.UnitState
local var8 = class("BattleEnemyUnit", var0.Battle.BattleUnit)

var0.Battle.BattleEnemyUnit = var8
var8.__name = "BattleEnemyUnit"

function var8.Ctor(arg0, arg1, arg2)
	var8.super.Ctor(arg0, arg1, arg2)

	arg0._type = var2.UnitType.ENEMY_UNIT
	arg0._level = arg0._battleProxy:GetDungeonLevel()
end

function var8.Dispose(arg0)
	if arg0._aimBias then
		arg0._aimBias:Dispose()
	end

	var8.super.Dispose(arg0)
end

function var8.SetBound(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	var8.super.SetBound(arg0, arg1, arg2, arg3, arg4, arg5, arg6)

	arg0._weaponRightBound = arg4
	arg0._weaponLowerBound = arg2
end

function var8.UpdateAction(arg0)
	if arg0._oxyState and arg0._oxyState:GetCurrentDiveState() == var2.OXY_STATE.DIVE then
		if arg0:GetSpeed().x > 0 then
			arg0._unitState:ChangeState(var7.STATE_DIVELEFT)
		else
			arg0._unitState:ChangeState(var7.STATE_DIVE)
		end
	elseif arg0:GetSpeed().x > 0 then
		arg0._unitState:ChangeState(var7.STATE_MOVELEFT)
	else
		arg0._unitState:ChangeState(var7.STATE_MOVE)
	end
end

function var8.UpdateHP(arg0, arg1, arg2, arg3, arg4)
	local var0 = var8.super.UpdateHP(arg0, arg1, arg2, arg3, arg4)

	if arg0._phaseSwitcher then
		arg0._phaseSwitcher:UpdateHP(arg0:GetHPRate())
	end

	return var0
end

function var8.SetMaster(arg0, arg1)
	arg0._master = arg1
end

function var8.GetMaster(arg0)
	return arg0._master
end

function var8.SetTemplate(arg0, arg1, arg2)
	var8.super.SetTemplate(arg0, arg1)

	arg0._tmpData = var1.GetMonsterTmpDataFromID(arg0._tmpID)

	arg0:configWeaponQueueParallel()
	arg0:InitCldComponent()
	arg0:SetAttr()

	arg2 = arg2 or {}

	local var0 = arg0:GetExtraInfo()

	for iter0, iter1 in pairs(arg2) do
		var0[iter0] = iter1
	end

	arg0:setStandardLabelTag()
end

function var8.SetTeamVO(arg0, arg1)
	arg0._team = arg1
end

function var8.SetFormationIndex(arg0, arg1)
	arg0._formationIndex = arg1
end

function var8.SetWaveIndex(arg0, arg1)
	arg0._waveIndex = arg1
end

function var8.SetAttr(arg0)
	var4.SetEnemyAttr(arg0)
	var4.InitDOTAttr(arg0._attr, arg0._tmpData)
end

function var8.GetTemplate(arg0)
	return arg0._tmpData
end

function var8.GetRarity(arg0)
	return arg0._tmpData.rarity
end

function var8.GetLevel(arg0)
	return arg0._overrideLevel or arg0._level or 1
end

function var8.GetTeam(arg0)
	return arg0._team
end

function var8.GetWaveIndex(arg0)
	return arg0._waveIndex
end

function var8.IsShowHPBar(arg0)
	return arg0._IFF ~= var5.FRIENDLY_CODE
end

function var8.IsSpectre(arg0)
	local var0
	local var1 = var0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY

	if arg0:GetAttr()[var1] ~= nil then
		var0 = arg0:GetAttrByName(var1)
	else
		var0 = arg0._tmpData.battle_unit_type
	end

	return var0 <= var5.SPECTRE_UNIT_TYPE, var0
end

function var8.InitCldComponent(arg0)
	var8.super.InitCldComponent(arg0)

	local var0 = {
		type = var2.CldType.SHIP,
		IFF = arg0:GetIFF(),
		UID = arg0:GetUniqueID(),
		Mass = var2.CldMass.L1,
		IsBoss = arg0._isBoss
	}

	arg0._cldComponent:SetCldData(var0)

	if arg0:GetTemplate().friendly_cld ~= 0 then
		arg0._cldComponent:ActiveFriendlyCld()
	end
end

function var8.ConfigBubbleFX(arg0)
	arg0._bubbleFX = arg0._tmpData.bubble_fx[1]

	arg0._oxyState:SetBubbleTemplate(arg0._tmpData.bubble_fx[2], arg0._tmpData.bubble_fx[3])
end
