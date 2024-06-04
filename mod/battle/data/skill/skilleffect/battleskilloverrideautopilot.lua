ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleSkillOverrideAutoPilot", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillOverrideAutoPilot = var3
var3.__name = "BattleSkillOverrideAutoPilot"

function var3.Ctor(arg0, arg1, arg2)
	var3.super.Ctor(arg0, arg1, arg2)

	arg0._AIID = arg0._tempData.arg_list.ai_id
end

function var3.DoDataEffect(arg0, arg1)
	local var0 = arg1:GetFleetVO()

	if not var0 then
		return
	end

	var0:OverrideJoyStickAutoBot(arg0._AIID)
end

function var3.DataEffectWithoutTarget(arg0, arg1)
	arg0:DoDataEffect(arg1)
end
