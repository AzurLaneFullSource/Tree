ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillChangeDiveState = class("BattleSkillChangeDiveState", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillChangeDiveState.__name = "BattleSkillChangeDiveState"

local var1 = var0.Battle.BattleSkillChangeDiveState

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._state = arg0._tempData.arg_list.state
	arg0._expose = arg0._tempData.arg_list.expose
end

function var1.DoDataEffect(arg0, arg1, arg2)
	if arg2:IsAlive() then
		local var0 = arg2:GetOxyState() or arg2:InitOxygen()

		arg2:ChangeOxygenState(arg0._state)
		var0:SetForceExpose(arg0._expose)
	end
end
