ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleMainFleetCharacter", var0.Battle.BattlePlayerCharacter)

var0.Battle.BattleMainFleetCharacter = var3
var3.__name = "BattleMainFleetCharacter"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.Update(arg0)
	var3.super.Update(arg0)
	arg0:UpdateArrowBarPostition()
end

function var3.AddArrowBar(arg0, arg1)
	var3.super.AddArrowBar(arg0, arg1)

	local var0 = LoadSprite("qicon/" .. arg0._unitData:GetTemplate().painting) or LoadSprite("heroicon/unknown")

	setImageSprite(findTF(arg0._arrowBar, "icon"), var0)
end

function var3.UpdateHPBarPosition(arg0)
	if not arg0._inViewArea then
		var3.super.UpdateHPBarPosition(arg0)
	end
end

function var3.GetReferenceVector(arg0, arg1)
	if not arg0._inViewArea then
		return var3.super.GetReferenceVector(arg0, arg1)
	else
		return arg0._arrowVector
	end
end
