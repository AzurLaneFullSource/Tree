ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleMainFleetCharacter", var0_0.Battle.BattlePlayerCharacter)

var0_0.Battle.BattleMainFleetCharacter = var3_0
var3_0.__name = "BattleMainFleetCharacter"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Update(arg0_2)
	var3_0.super.Update(arg0_2)
	arg0_2:UpdateArrowBarPostition()
end

function var3_0.AddArrowBar(arg0_3, arg1_3)
	var3_0.super.AddArrowBar(arg0_3, arg1_3)

	local var0_3 = LoadSprite("qicon/" .. arg0_3._unitData:GetTemplate().painting) or LoadSprite("heroicon/unknown")

	setImageSprite(findTF(arg0_3._arrowBar, "icon"), var0_3)
end

function var3_0.UpdateHPBarPosition(arg0_4)
	if not arg0_4._inViewArea then
		var3_0.super.UpdateHPBarPosition(arg0_4)
	end
end

function var3_0.GetReferenceVector(arg0_5, arg1_5)
	if not arg0_5._inViewArea then
		return var3_0.super.GetReferenceVector(arg0_5, arg1_5)
	else
		return arg0_5._arrowVector
	end
end
