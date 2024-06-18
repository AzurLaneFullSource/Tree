local var0_0 = class("CourtYardInteraction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.host = arg1_1
	arg0_1.isReset = false

	arg0_1:Clear()
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.loop = arg1_2

	arg0_2:InitData()
	arg0_2:DoPreheatStep(arg0_2.ownerPreheat, arg0_2.userPreheat)
end

function var0_0.InitData(arg0_3)
	local var0_3, var1_3, var2_3, var3_3, var4_3, var5_3 = arg0_3.host:GetActions()

	arg0_3.ownerPreheat = var3_3
	arg0_3.userPreheat = var4_3
	arg0_3.tailAction = var5_3
	arg0_3.ownerActions = var0_3
	arg0_3.userActions = var1_3
	arg0_3.closeBodyMask = var2_3
	arg0_3.total = #var0_3
	arg0_3.index = 0
end

function var0_0.DoPreheatStep(arg0_4, arg1_4, arg2_4)
	arg0_4.preheatProcess = false

	if arg1_4 then
		arg0_4.preheatProcess = true

		arg0_4.host:GetOwner():UpdateInteraction(arg0_4:PackData(arg1_4, true))

		if arg2_4 then
			arg0_4.host:GetUser():UpdateInteraction(arg0_4:PackData(arg2_4, true))
		end
	else
		arg0_4:DoStep()
	end
end

function var0_0.DoStep(arg0_5)
	if arg0_5.index >= arg0_5.total then
		arg0_5:AllStepEnd()

		return
	end

	arg0_5.index = arg0_5.index + 1
	arg0_5.states[arg0_5.host.user] = false
	arg0_5.states[arg0_5.host.owner] = false

	arg0_5.host:GetUser():UpdateInteraction(arg0_5:PackData(arg0_5:GetUserAction()))
	arg0_5.host:GetOwner():UpdateInteraction(arg0_5:PackData(arg0_5:GetOwnerAction()))

	arg0_5.isReset = false
end

function var0_0.GetUserAction(arg0_6)
	return arg0_6.userActions[arg0_6.index]
end

function var0_0.GetOwnerAction(arg0_7)
	return arg0_7.ownerActions[arg0_7.index]
end

function var0_0.DoTailStep(arg0_8)
	arg0_8.index = 0

	arg0_8.host:GetUser():UpdateInteraction(arg0_8:PackData(arg0_8.tailAction))
	arg0_8.host:GetOwner():UpdateInteraction(arg0_8:PackData(arg0_8.tailAction))
end

function var0_0.PackData(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.index / arg0_9.total

	return {
		action = arg1_9,
		slot = arg0_9.host,
		closeBodyMask = arg0_9.closeBodyMask[arg0_9.index],
		progress = var0_9,
		total = arg0_9.total,
		index = arg0_9.index,
		isReset = arg0_9.isReset,
		block = arg2_9
	}
end

function var0_0.StepEnd(arg0_10, arg1_10)
	if arg0_10.preheatProcess then
		arg0_10:OnPreheatDone()
		arg0_10:DoStep()
	else
		if arg0_10.index == 0 then
			return
		end

		arg0_10.states[arg1_10] = true

		arg0_10:OnStepEnd()
	end
end

function var0_0.OnPreheatDone(arg0_11)
	arg0_11.host:GetOwner():OnPreheatActionEnd(arg0_11.host)
end

function var0_0.AllStepEnd(arg0_12)
	if arg0_12.loop and arg0_12.total > 1 then
		arg0_12.isReset = true
		arg0_12.index = 0

		arg0_12:DoStep()
	elseif arg0_12.loop and arg0_12.total == 1 then
		-- block empty
	elseif not arg0_12.loop and arg0_12.tailAction then
		arg0_12:DoTailStep()
	else
		arg0_12.host:End()
		arg0_12:Clear()
	end
end

function var0_0.Clear(arg0_13)
	arg0_13.index = 0
	arg0_13.states = {}
	arg0_13.total = 0
	arg0_13.loop = nil
end

function var0_0.GetIndex(arg0_14)
	return arg0_14.index
end

function var0_0.IsCompleteStep(arg0_15)
	return arg0_15:IsCompleteUserStep() and arg0_15:IsCompleteOwnerStep()
end

function var0_0.IsCompleteUserStep(arg0_16)
	return arg0_16.states[arg0_16.host.user] == true
end

function var0_0.IsCompleteOwnerStep(arg0_17)
	return arg0_17.states[arg0_17.host.owner] == true
end

function var0_0.OnStepEnd(arg0_18)
	if arg0_18:IsCompleteStep() then
		arg0_18:DoStep()
	end
end

function var0_0.Reset(arg0_19)
	return
end

return var0_0
