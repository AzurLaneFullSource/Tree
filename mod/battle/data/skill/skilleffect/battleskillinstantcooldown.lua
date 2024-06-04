ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillInstantCoolDown", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillInstantCoolDown = var1
var1.__name = "BattleSkillInstantCoolDown"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._weaponType = arg0._tempData.arg_list.weaponType
end

function var1.DoDataEffect(arg0, arg1, arg2)
	local var0 = arg0:_GetWeapon(arg1)

	if var0 then
		var0:QuickCoolDown()
	end
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:DoDataEffect(arg1, nil)
end

function var1._GetWeapon(arg0, arg1)
	local var0

	if arg0._weaponType == "AirAssist" then
		var0 = arg1:GetAirAssistQueue():GetQueueHead()
	end

	return var0
end
