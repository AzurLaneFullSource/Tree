local var0 = class("CourtYardFurnitureBaseSlot")
local var1 = 0
local var2 = 1
local var3 = 2

var0.TYPE_COMMOM = 1
var0.TYPE_MAIN_SPINE = 2
var0.TYPE_SPINE_EXTRA = 3

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg1
	arg0.mask = nil
	arg0.scale = Vector3.one
	arg0.offset = Vector3.zero
	arg0.skewValue = Vector3.zero
	arg0.follower = nil
	arg0.animatorIndex = 0
	arg0.animators = {}
	arg0.bodyMask = nil
	arg0.name = nil

	if not arg2 or arg2 == "" then
		arg0.state = var3
	else
		arg0.state = var1

		arg0:OnInit(arg2)
	end
end

function var0.IsEmpty(arg0)
	return arg0.state == var1
end

function var0.IsUsing(arg0)
	return arg0.state == var2
end

function var0.Occupy(arg0, arg1, arg2, arg3)
	if arg0.state == var1 then
		arg0.user = arg2
		arg0.owner = arg1
		arg0.observer = arg3
		arg0.state = var2

		arg2:WillInteraction(arg0)
		arg1:WillInteraction(arg0)
		arg0:OnAwake()
		arg3:StartInteraction(arg0)
		arg2:StartInteraction(arg0)
		arg1:StartInteraction(arg0)
		onNextTick(function()
			arg0:OnStart()
		end)
	end
end

function var0.GetUser(arg0)
	return arg0.user
end

function var0.GetOwner(arg0)
	return arg0.owner
end

function var0.Use(arg0)
	arg0.state = var2
end

function var0.Empty(arg0)
	arg0.state = var1
end

function var0.Clear(arg0, arg1)
	if arg0.state == var2 then
		arg0.state = var1

		arg0.observer:WillClearInteraction(arg0, arg1)
		arg0.user:ClearInteraction(arg0, arg1)
		arg0.owner:ClearInteraction(arg0, arg1)
		arg0.observer:ClearInteraction(arg0, arg1)

		arg0.user = nil
		arg0.owner = nil
		arg0.observer = nil
	end
end

function var0.Continue(arg0, arg1)
	arg0:OnContinue(arg1)
end

function var0.Stop(arg0)
	arg0:Clear(true)
	arg0:OnStop()
end

function var0.Reset(arg0)
	return
end

function var0.End(arg0)
	arg0:Clear(false)
	arg0:OnEnd()
end

function var0.GetMask(arg0)
	return arg0.mask
end

function var0.GetScale(arg0)
	return arg0.scale
end

function var0.GetOffset(arg0)
	return arg0.offset
end

function var0.GetFollower(arg0)
	return arg0.follower
end

function var0.GetBodyMask(arg0)
	return arg0.bodyMask
end

function var0.GetAnimators(arg0)
	return arg0.animators
end

function var0.GetUsingAnimator(arg0)
	return arg0.animators[arg0.animatorIndex]
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.GetSkew(arg0)
	return arg0.skewValue
end

function var0.OnInit(arg0, arg1)
	return
end

function var0.OnAwake(arg0)
	return
end

function var0.OnStart(arg0)
	return
end

function var0.OnStop(arg0)
	return
end

function var0.OnEnd(arg0)
	return
end

function var0.OnContinue(arg0, arg1)
	return
end

return var0
