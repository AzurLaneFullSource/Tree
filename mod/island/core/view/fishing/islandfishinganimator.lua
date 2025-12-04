local var0_0 = class("IslandFishingAnimator")

var0_0.STATE_MOVEMENT = "movement"
var0_0.STATE_THROW = "fish_sub_state.fishthrow"
var0_0.STATE_IDLE = "fish_sub_state.fishidle"
var0_0.STATE_HOOKED = "fish_sub_state.fishon"
var0_0.STATE_HOOKED_2_LOOP = "fish_sub_state.fishon_2loop"
var0_0.STATE_HOOKED_3 = "fish_sub_state.fishon_3"
var0_0.STATE_HOOKED_4_LOOP = "fish_sub_state.fishon_4loop"
var0_0.STATE_HOOKED_5 = "fish_sub_state.fishon_5"
var0_0.STATE_SUCCESS = "fish_sub_state.fishsucced"
var0_0.STATE_CANCEL = "fish_sub_state.fishcancel"
var0_0.STATE_FAIL = "fish_sub_state.fishfail"

local var1_0 = 1
local var2_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.player = arg1_1
	arg0_1.state = var0_0.STATE_MOVEMENT
	arg0_1.hooked4LoopMaxCnt = 1
	arg0_1.hooked4LoopCnt = 0

	local var0_1 = Animator.StringToHash("UpperBase." .. var0_0.STATE_THROW)

	arg0_1.player._animator:GetBehaviours(var0_1, 0)[0].StateEnterFixComplete = function(arg0_2, arg1_2)
		arg0_1:OnStateEnterFixComplete(arg0_2, arg1_2)
	end
end

function var0_0.SetFishRod(arg0_3, arg1_3)
	arg0_3.fishRodAnimator = arg1_3

	pg.ViewUtils.SetLayer(arg0_3.fishRodAnimator.gameObject.transform, Layer.UIHidden)
end

function var0_0.ClearFishRod(arg0_4)
	arg0_4.fishRodAnimator = nil
end

function var0_0.OnStateEnterFixComplete(arg0_5, arg1_5, arg2_5)
	if not arg0_5.fishRodAnimator then
		return
	end

	pg.ViewUtils.SetLayer(arg0_5.fishRodAnimator.gameObject.transform, Layer.Default)
end

function var0_0.Trigger(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg0_6.state == arg1_6 then
		return
	end

	arg0_6.state = arg1_6
	arg0_6.isLoopHooked = arg0_6:IsLoopHookedAction(arg1_6)

	arg0_6:TriggerState(arg1_6, arg2_6, arg3_6)
end

function var0_0.IsLoopHookedAction(arg0_7, arg1_7)
	if arg1_7 == var0_0.STATE_HOOKED or arg1_7 == var0_0.STATE_HOOKED_2_LOOP or arg1_7 == var0_0.STATE_HOOKED_3 or arg1_7 == var0_0.STATE_HOOKED_4_LOOP then
		return true
	end

	return false
end

function var0_0.TriggerState(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg0_8:IsLoopHookedAction(arg1_8) and not arg0_8.isLoopHooked then
		return
	end

	arg0_8.player:PlayAnimation(arg1_8, arg2_8, function()
		arg0_8:OnStateFinish(arg1_8, arg2_8, arg3_8)
	end)

	if arg0_8.fishRodAnimator then
		local var0_8 = string.gsub(arg1_8, "fish_sub_state.", "")
		local var1_8 = Animator.StringToHash(var0_8)

		arg0_8.fishRodAnimator:CrossFadeInFixedTime(var1_8, arg2_8, 0)
	end
end

function var0_0.OnStateFinish(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg1_10 == var0_0.STATE_THROW then
		arg0_10:TriggerState(var0_0.STATE_IDLE, arg2_10, arg3_10)

		if arg3_10 then
			arg3_10()
		end
	elseif arg1_10 == var0_0.STATE_IDLE then
		-- block empty
	elseif arg1_10 == var0_0.STATE_HOOKED then
		arg0_10.isLoopHooked = true

		arg0_10:TriggerState(var0_0.STATE_HOOKED_2_LOOP, 0)
	elseif arg1_10 == var0_0.STATE_HOOKED_2_LOOP then
		arg0_10:TriggerState(var0_0.STATE_HOOKED_2_LOOP, 0)

		if arg3_10 then
			arg3_10()
		end
	elseif arg1_10 == var0_0.STATE_HOOKED_3 then
		arg0_10.isLoopHooked = true

		arg0_10:TriggerState(var0_0.STATE_HOOKED_4_LOOP, 0)
	elseif arg1_10 == var0_0.STATE_HOOKED_4_LOOP then
		arg0_10:TriggerState(var0_0.STATE_HOOKED_4_LOOP, 0)
	elseif arg1_10 == var0_0.STATE_HOOKED_5 then
		arg0_10:TriggerState(var0_0.STATE_SUCCESS, arg2_10, arg3_10)

		if arg3_10 then
			arg3_10()
		end
	elseif arg1_10 == var0_0.STATE_SUCCESS then
		-- block empty
	elseif arg1_10 == var0_0.STATE_CANCEL or arg1_10 == var0_0.STATE_FAIL then
		arg0_10:TriggerState(var0_0.STATE_MOVEMENT, 0.25)

		if arg3_10 then
			arg3_10()
		end
	end
end

function var0_0.Dispose(arg0_11)
	local var0_11 = Animator.StringToHash("UpperBase." .. var0_0.STATE_THROW)

	arg0_11.player._animator:GetBehaviours(var0_11, 0)[0].StateEnterFixComplete = nil
	arg0_11.fishRodAnimator = nil
end

return var0_0
