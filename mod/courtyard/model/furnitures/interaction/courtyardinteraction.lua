local var0 = class("CourtYardInteraction")

function var0.Ctor(arg0, arg1)
	arg0.host = arg1
	arg0.isReset = false

	arg0:Clear()
end

function var0.Update(arg0, arg1)
	arg0.loop = arg1

	arg0:InitData()
	arg0:DoPreheatStep(arg0.ownerPreheat, arg0.userPreheat)
end

function var0.InitData(arg0)
	local var0, var1, var2, var3, var4, var5 = arg0.host:GetActions()

	arg0.ownerPreheat = var3
	arg0.userPreheat = var4
	arg0.tailAction = var5
	arg0.ownerActions = var0
	arg0.userActions = var1
	arg0.closeBodyMask = var2
	arg0.total = #var0
	arg0.index = 0
end

function var0.DoPreheatStep(arg0, arg1, arg2)
	arg0.preheatProcess = false

	if arg1 then
		arg0.preheatProcess = true

		arg0.host:GetOwner():UpdateInteraction(arg0:PackData(arg1, true))

		if arg2 then
			arg0.host:GetUser():UpdateInteraction(arg0:PackData(arg2, true))
		end
	else
		arg0:DoStep()
	end
end

function var0.DoStep(arg0)
	if arg0.index >= arg0.total then
		arg0:AllStepEnd()

		return
	end

	arg0.index = arg0.index + 1
	arg0.states[arg0.host.user] = false
	arg0.states[arg0.host.owner] = false

	arg0.host:GetUser():UpdateInteraction(arg0:PackData(arg0:GetUserAction()))
	arg0.host:GetOwner():UpdateInteraction(arg0:PackData(arg0:GetOwnerAction()))

	arg0.isReset = false
end

function var0.GetUserAction(arg0)
	return arg0.userActions[arg0.index]
end

function var0.GetOwnerAction(arg0)
	return arg0.ownerActions[arg0.index]
end

function var0.DoTailStep(arg0)
	arg0.index = 0

	arg0.host:GetUser():UpdateInteraction(arg0:PackData(arg0.tailAction))
	arg0.host:GetOwner():UpdateInteraction(arg0:PackData(arg0.tailAction))
end

function var0.PackData(arg0, arg1, arg2)
	local var0 = arg0.index / arg0.total

	return {
		action = arg1,
		slot = arg0.host,
		closeBodyMask = arg0.closeBodyMask[arg0.index],
		progress = var0,
		total = arg0.total,
		index = arg0.index,
		isReset = arg0.isReset,
		block = arg2
	}
end

function var0.StepEnd(arg0, arg1)
	if arg0.preheatProcess then
		arg0:OnPreheatDone()
		arg0:DoStep()
	else
		if arg0.index == 0 then
			return
		end

		arg0.states[arg1] = true

		arg0:OnStepEnd()
	end
end

function var0.OnPreheatDone(arg0)
	arg0.host:GetOwner():OnPreheatActionEnd(arg0.host)
end

function var0.AllStepEnd(arg0)
	if arg0.loop and arg0.total > 1 then
		arg0.isReset = true
		arg0.index = 0

		arg0:DoStep()
	elseif arg0.loop and arg0.total == 1 then
		-- block empty
	elseif not arg0.loop and arg0.tailAction then
		arg0:DoTailStep()
	else
		arg0.host:End()
		arg0:Clear()
	end
end

function var0.Clear(arg0)
	arg0.index = 0
	arg0.states = {}
	arg0.total = 0
	arg0.loop = nil
end

function var0.GetIndex(arg0)
	return arg0.index
end

function var0.IsCompleteStep(arg0)
	return arg0:IsCompleteUserStep() and arg0:IsCompleteOwnerStep()
end

function var0.IsCompleteUserStep(arg0)
	return arg0.states[arg0.host.user] == true
end

function var0.IsCompleteOwnerStep(arg0)
	return arg0.states[arg0.host.owner] == true
end

function var0.OnStepEnd(arg0)
	if arg0:IsCompleteStep() then
		arg0:DoStep()
	end
end

function var0.Reset(arg0)
	return
end

return var0
