ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleAttr
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleUnitEvent
local var7_0 = var0_0.Battle.UnitState
local var8_0 = class("BattleMinionUnit", var0_0.Battle.BattleEnemyUnit)

var0_0.Battle.BattleMinionUnit = var8_0
var8_0.__name = "BattleMinionUnit"

function var8_0.Ctor(arg0_1, arg1_1, arg2_1)
	var8_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var8_0.GetUnitType(arg0_2)
	return var2_0.UnitType.MINION_UNIT
end

function var8_0.SetMaster(arg0_3, arg1_3)
	arg0_3._master = arg1_3
end

function var8_0.InheritMasterAttr(arg0_4)
	var4_0.SetMinionAttr(arg0_4)
	var4_0.InitDOTAttr(arg0_4._attr, arg0_4._tmpData)
	arg0_4:setStandardLabelTag()
end

function var8_0.SetTemplate(arg0_5, arg1_5, arg2_5)
	arg0_5._tmpID = arg1_5
	arg0_5._tmpData = var1_0.GetMonsterTmpDataFromID(arg0_5._tmpID)

	arg0_5:configWeaponQueueParallel()
	arg0_5:InitCldComponent()
end

function var8_0.IsShowHPBar(arg0_6)
	return false
end

function var8_0.GetMaster(arg0_7)
	return arg0_7._master
end

function var8_0.DispatchVoice(arg0_8)
	return
end

function var8_0.Retreat(arg0_9)
	var8_0.super.Retreat(arg0_9)
	arg0_9:SetDeathReason(var2_0.UnitDeathReason.LEAVE)
	arg0_9:DeacActionClear()
	arg0_9._battleProxy:KillUnit(arg0_9:GetUniqueID())
end
