local var0_0 = class("IslandInteractionConditionUntil")

var0_0.SHOW_TYPE_CAN_ACCEPT_TASK = 1
var0_0.SHOW_TYPE_EXIST_TASK = 2
var0_0.SHOW_TYPE_CAN_SUBMIT_TASK = 3
var0_0.SHOW_TYPE_FINISHED_TASK = 4
var0_0.SHOW_TYPE_CAN_SIGNIN = 5
var0_0.SHOW_TYPE_CAN_SELECT_GIFT = 6
var0_0.SHOW_TYPE_CAN_INVITE_PLAYER = 7
var0_0.SHOW_TYPE_CANT_SIGNIN = 8
var0_0.SHOW_TYPE_CAN_WILD_GATHER = 9
var0_0.SHOW_TYPE_CAN_WILD_SIGNIN = 10
var0_0.SHOW_TYPE_ABILITY = 11
var0_0.SHOW_TYPE_TASK_TARGET = 12

function var0_0.Check(arg0_1, arg1_1)
	local var0_1 = arg1_1[1]
	local var1_1 = arg1_1[2]
	local var2_1 = arg1_1[3]

	return switch(var0_1, {
		[var0_0.SHOW_TYPE_CAN_ACCEPT_TASK] = function()
			local var0_2 = arg0_1:GetTaskAgency():GetFutureTask(var1_1)

			return var0_2 and var0_2:IsUnlock()
		end,
		[var0_0.SHOW_TYPE_EXIST_TASK] = function()
			local var0_3 = arg0_1:GetTaskAgency():GetTask(var1_1)

			return var0_3 and not var0_3:IsFinish()
		end,
		[var0_0.SHOW_TYPE_CAN_SUBMIT_TASK] = function()
			local var0_4 = arg0_1:GetTaskAgency():GetTask(var1_1)

			return var0_4 and var0_4:IsFinish()
		end,
		[var0_0.SHOW_TYPE_FINISHED_TASK] = function()
			return (arg0_1:GetTaskAgency():IsFinishTask(var1_1))
		end,
		[var0_0.SHOW_TYPE_CAN_SIGNIN] = function()
			return getProxy(IslandProxy):GetIsland().id == arg0_1.id and arg0_1:GetSignInAgency():CanSignIn()
		end,
		[var0_0.SHOW_TYPE_CAN_SELECT_GIFT] = function()
			local var0_7 = getProxy(IslandProxy):GetIsland().id == arg0_1.id

			return var0_7 and arg0_1:GetSignInAgency():CanSelectGift() or not var0_7
		end,
		[var0_0.SHOW_TYPE_CAN_INVITE_PLAYER] = function()
			return getProxy(IslandProxy):GetIsland().id == arg0_1.id and arg0_1:GetSignInAgency():CanInvite()
		end,
		[var0_0.SHOW_TYPE_CANT_SIGNIN] = function()
			return getProxy(IslandProxy):GetIsland().id == arg0_1.id and not arg0_1:GetSignInAgency():CanSignIn()
		end,
		[var0_0.SHOW_TYPE_ABILITY] = function()
			return arg0_1:GetAblityAgency():HasAbility(var1_1)
		end,
		[var0_0.SHOW_TYPE_TASK_TARGET] = function()
			local var0_11 = arg0_1:GetTaskAgency():GetTask(var1_1)

			return var0_11 and var0_11:GetTargetById(var2_1) and not var0_11:GetTargetById(var2_1):IsFinish()
		end
	}, function()
		assert(false, "非法显示条件类型:" .. var0_1)
	end)
end

return var0_0
