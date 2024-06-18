ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillChangeDiveState = class("BattleSkillChangeDiveState", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillChangeDiveState.__name = "BattleSkillChangeDiveState"

local var1_0 = var0_0.Battle.BattleSkillChangeDiveState

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._state = arg0_1._tempData.arg_list.state
	arg0_1._expose = arg0_1._tempData.arg_list.expose
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg2_2:IsAlive() then
		local var0_2 = arg2_2:GetOxyState() or arg2_2:InitOxygen()

		arg2_2:ChangeOxygenState(arg0_2._state)
		var0_2:SetForceExpose(arg0_2._expose)
	end
end
