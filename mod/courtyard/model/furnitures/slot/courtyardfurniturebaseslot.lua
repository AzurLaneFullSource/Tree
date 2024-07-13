local var0_0 = class("CourtYardFurnitureBaseSlot")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

var0_0.TYPE_COMMOM = 1
var0_0.TYPE_MAIN_SPINE = 2
var0_0.TYPE_SPINE_EXTRA = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.mask = nil
	arg0_1.scale = Vector3.one
	arg0_1.offset = Vector3.zero
	arg0_1.skewValue = Vector3.zero
	arg0_1.follower = nil
	arg0_1.animatorIndex = 0
	arg0_1.animators = {}
	arg0_1.bodyMask = nil
	arg0_1.name = nil

	if not arg2_1 or arg2_1 == "" then
		arg0_1.state = var3_0
	else
		arg0_1.state = var1_0

		arg0_1:OnInit(arg2_1)
	end
end

function var0_0.IsEmpty(arg0_2)
	return arg0_2.state == var1_0
end

function var0_0.IsUsing(arg0_3)
	return arg0_3.state == var2_0
end

function var0_0.Occupy(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg0_4.state == var1_0 then
		arg0_4.user = arg2_4
		arg0_4.owner = arg1_4
		arg0_4.observer = arg3_4
		arg0_4.state = var2_0

		arg2_4:WillInteraction(arg0_4)
		arg1_4:WillInteraction(arg0_4)
		arg0_4:OnAwake()
		arg3_4:StartInteraction(arg0_4)
		arg2_4:StartInteraction(arg0_4)
		arg1_4:StartInteraction(arg0_4)
		onNextTick(function()
			arg0_4:OnStart()
		end)
	end
end

function var0_0.GetUser(arg0_6)
	return arg0_6.user
end

function var0_0.GetOwner(arg0_7)
	return arg0_7.owner
end

function var0_0.Use(arg0_8)
	arg0_8.state = var2_0
end

function var0_0.Empty(arg0_9)
	arg0_9.state = var1_0
end

function var0_0.Clear(arg0_10, arg1_10)
	if arg0_10.state == var2_0 then
		arg0_10.state = var1_0

		arg0_10.observer:WillClearInteraction(arg0_10, arg1_10)
		arg0_10.user:ClearInteraction(arg0_10, arg1_10)
		arg0_10.owner:ClearInteraction(arg0_10, arg1_10)
		arg0_10.observer:ClearInteraction(arg0_10, arg1_10)

		arg0_10.user = nil
		arg0_10.owner = nil
		arg0_10.observer = nil
	end
end

function var0_0.Continue(arg0_11, arg1_11)
	arg0_11:OnContinue(arg1_11)
end

function var0_0.Stop(arg0_12)
	arg0_12:Clear(true)
	arg0_12:OnStop()
end

function var0_0.Reset(arg0_13)
	return
end

function var0_0.End(arg0_14)
	arg0_14:Clear(false)
	arg0_14:OnEnd()
end

function var0_0.GetMask(arg0_15)
	return arg0_15.mask
end

function var0_0.GetScale(arg0_16)
	return arg0_16.scale
end

function var0_0.GetOffset(arg0_17)
	return arg0_17.offset
end

function var0_0.GetFollower(arg0_18)
	return arg0_18.follower
end

function var0_0.GetBodyMask(arg0_19)
	return arg0_19.bodyMask
end

function var0_0.GetAnimators(arg0_20)
	return arg0_20.animators
end

function var0_0.GetUsingAnimator(arg0_21)
	return arg0_21.animators[arg0_21.animatorIndex]
end

function var0_0.GetName(arg0_22)
	return arg0_22.name
end

function var0_0.GetSkew(arg0_23)
	return arg0_23.skewValue
end

function var0_0.OnInit(arg0_24, arg1_24)
	return
end

function var0_0.OnAwake(arg0_25)
	return
end

function var0_0.OnStart(arg0_26)
	return
end

function var0_0.OnStop(arg0_27)
	return
end

function var0_0.OnEnd(arg0_28)
	return
end

function var0_0.OnContinue(arg0_29, arg1_29)
	return
end

return var0_0
