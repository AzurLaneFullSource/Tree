ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleAttr
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleUnitEvent
local var7 = var0.Battle.UnitState
local var8 = class("BattleMinionUnit", var0.Battle.BattleEnemyUnit)

var0.Battle.BattleMinionUnit = var8
var8.__name = "BattleMinionUnit"

function var8.Ctor(arg0, arg1, arg2)
	var8.super.Ctor(arg0, arg1, arg2)
end

function var8.GetUnitType(arg0)
	return var2.UnitType.MINION_UNIT
end

function var8.SetMaster(arg0, arg1)
	arg0._master = arg1
end

function var8.InheritMasterAttr(arg0)
	var4.SetMinionAttr(arg0)
	var4.InitDOTAttr(arg0._attr, arg0._tmpData)
	arg0:setStandardLabelTag()
end

function var8.SetTemplate(arg0, arg1, arg2)
	arg0._tmpID = arg1
	arg0._tmpData = var1.GetMonsterTmpDataFromID(arg0._tmpID)

	arg0:configWeaponQueueParallel()
	arg0:InitCldComponent()
end

function var8.IsShowHPBar(arg0)
	return false
end

function var8.GetMaster(arg0)
	return arg0._master
end

function var8.DispatchVoice(arg0)
	return
end

function var8.Retreat(arg0)
	var8.super.Retreat(arg0)
	arg0:SetDeathReason(var2.UnitDeathReason.LEAVE)
	arg0:DeacActionClear()
	arg0._battleProxy:KillUnit(arg0:GetUniqueID())
end
