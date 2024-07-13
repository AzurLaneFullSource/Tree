ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleSkillOverrideAutoPilot", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillOverrideAutoPilot = var3_0
var3_0.__name = "BattleSkillOverrideAutoPilot"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	var3_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._AIID = arg0_1._tempData.arg_list.ai_id
end

function var3_0.DoDataEffect(arg0_2, arg1_2)
	local var0_2 = arg1_2:GetFleetVO()

	if not var0_2 then
		return
	end

	var0_2:OverrideJoyStickAutoBot(arg0_2._AIID)
end

function var3_0.DataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:DoDataEffect(arg1_3)
end
