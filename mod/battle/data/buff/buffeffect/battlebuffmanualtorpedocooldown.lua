ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffManualTorpedoCoolDown = class("BattleBuffManualTorpedoCoolDown", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffManualTorpedoCoolDown.__name = "BattleBuffManualTorpedoCoolDown"

local var1 = var0.Battle.BattleBuffManualTorpedoCoolDown

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._rant = arg0._tempData.arg_list.rant or 10000
end

function var1.onTrigger(arg0, arg1)
	var1.super.onTrigger(arg0, arg1, buff, attach)

	if var0.Battle.BattleFormulas.IsHappen(arg0._rant) then
		local var0 = arg1:GetTorpedoQueue():GetQueueHead()

		if var0 then
			var0:QuickCoolDown()
		end
	end
end
