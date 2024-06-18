ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffAirStrikeCoolDown = class("BattleBuffAirStrikeCoolDown", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffAirStrikeCoolDown.__name = "BattleBuffAirStrikeCoolDown"

local var1_0 = var0_0.Battle.BattleBuffAirStrikeCoolDown

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._rant = arg0_2._tempData.arg_list.rant or 10000
end

function var1_0.onTrigger(arg0_3, arg1_3)
	var1_0.super.onTrigger(arg0_3, arg1_3, buff, attach)

	if var0_0.Battle.BattleFormulas.IsHappen(arg0_3._rant) then
		local var0_3 = arg1_3:GetAirAssistQueue():GetQueueHead()

		if var0_3 then
			var0_3:QuickCoolDown()
		end
	end
end
