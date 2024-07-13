ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillInstantCoolDown", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillInstantCoolDown = var1_0
var1_0.__name = "BattleSkillInstantCoolDown"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._weaponType = arg0_1._tempData.arg_list.weaponType
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:_GetWeapon(arg1_2)

	if var0_2 then
		var0_2:QuickCoolDown()
	end
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:DoDataEffect(arg1_3, nil)
end

function var1_0._GetWeapon(arg0_4, arg1_4)
	local var0_4

	if arg0_4._weaponType == "AirAssist" then
		var0_4 = arg1_4:GetAirAssistQueue():GetQueueHead()
	end

	return var0_4
end
