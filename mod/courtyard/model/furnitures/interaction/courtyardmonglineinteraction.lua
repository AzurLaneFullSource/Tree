local var0_0 = class("CourtYardMonglineInteraction", import(".CourtYardInteraction"))

function var0_0.DoStep(arg0_1)
	arg0_1.statesCnt[arg0_1.host.user] = 1
	arg0_1.statesCnt[arg0_1.host.owner] = 1
	arg0_1.totalUserActionCnt = #arg0_1.userActions
	arg0_1.totalOwnerActionCnt = #arg0_1.ownerActions

	var0_0.super.DoStep(arg0_1)
end

function var0_0.PlayUserAction(arg0_2)
	local var0_2 = arg0_2.statesCnt[arg0_2.host.user] + 1

	if var0_2 > arg0_2.totalUserActionCnt then
		return
	end

	arg0_2.statesCnt[arg0_2.host.user] = var0_2
	arg0_2.states[arg0_2.host.user] = false

	print("ship..............", var0_2, arg0_2.userActions[var0_2])
	arg0_2.host:GetUser():UpdateInteraction(arg0_2:PackData(arg0_2.userActions[var0_2]))
end

function var0_0.PlayOwnerAction(arg0_3)
	local var0_3 = arg0_3.statesCnt[arg0_3.host.owner] + 1

	if var0_3 > arg0_3.totalOwnerActionCnt then
		return
	end

	arg0_3.statesCnt[arg0_3.host.owner] = var0_3
	arg0_3.states[arg0_3.host.owner] = false

	print("furn", var0_3, arg0_3.ownerActions[var0_3])
	arg0_3.host:GetOwner():UpdateInteraction(arg0_3:PackData(arg0_3.ownerActions[var0_3]))
end

function var0_0.StepEnd(arg0_4, arg1_4)
	if arg0_4.preheatProcess then
		arg0_4:DoStep()

		arg0_4.preheatProcess = false
	else
		if arg0_4.index == 0 then
			return
		end

		arg0_4.states[arg1_4] = true

		if arg0_4.host:GetUser() == arg1_4 then
			arg0_4:PlayUserAction()
		elseif arg0_4.host:GetOwner() == arg1_4 then
			arg0_4:PlayOwnerAction()
		end

		if arg0_4:IsFinishAll() then
			arg0_4:AllStepEnd()
		end
	end
end

function var0_0.IsFinishAll(arg0_5)
	return arg0_5.statesCnt[arg0_5.host.owner] >= arg0_5.totalOwnerActionCnt and arg0_5.statesCnt[arg0_5.host.user] >= arg0_5.totalUserActionCnt
end

function var0_0.Clear(arg0_6)
	var0_0.super.Clear(arg0_6)

	arg0_6.statesCnt = {}
end

return var0_0
