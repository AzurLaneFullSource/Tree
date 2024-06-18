ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleNPCCharacter = class("BattleNPCCharacter", var0_0.Battle.BattleEnemyCharacter)
var0_0.Battle.BattleNPCCharacter.__name = "BattleNPCCharacter"

local var2_0 = var0_0.Battle.BattleNPCCharacter

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)

	arg0_1._preCastBound = false
end

function var2_0.SetHPColor(arg0_2, arg1_2)
	arg0_2._HPColor = arg1_2
end

function var2_0.GetHPColor(arg0_3)
	return arg0_3._HPColor
end

function var2_0.SetModleID(arg0_4, arg1_4)
	arg0_4._prefab = arg1_4
end

function var2_0.GetModleID(arg0_5)
	if arg0_5._prefab then
		return arg0_5._prefab
	else
		return arg0_5._unitData:GetTemplate().prefab
	end
end

function var2_0.SetUnvisible(arg0_6)
	arg0_6._isUnvisible = true
end

function var2_0.MakeVisible(arg0_7)
	if arg0_7._isUnvisible then
		arg0_7._go:SetActive(false)
		arg0_7._HPBar:SetActive(false)
		arg0_7._buffBar:SetActive(false)
	end
end
