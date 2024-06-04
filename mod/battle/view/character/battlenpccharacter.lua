ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent

var0.Battle.BattleNPCCharacter = class("BattleNPCCharacter", var0.Battle.BattleEnemyCharacter)
var0.Battle.BattleNPCCharacter.__name = "BattleNPCCharacter"

local var2 = var0.Battle.BattleNPCCharacter

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)

	arg0._preCastBound = false
end

function var2.SetHPColor(arg0, arg1)
	arg0._HPColor = arg1
end

function var2.GetHPColor(arg0)
	return arg0._HPColor
end

function var2.SetModleID(arg0, arg1)
	arg0._prefab = arg1
end

function var2.GetModleID(arg0)
	if arg0._prefab then
		return arg0._prefab
	else
		return arg0._unitData:GetTemplate().prefab
	end
end

function var2.SetUnvisible(arg0)
	arg0._isUnvisible = true
end

function var2.MakeVisible(arg0)
	if arg0._isUnvisible then
		arg0._go:SetActive(false)
		arg0._HPBar:SetActive(false)
		arg0._buffBar:SetActive(false)
	end
end
