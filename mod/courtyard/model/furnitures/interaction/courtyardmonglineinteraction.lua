local var0 = class("CourtYardMonglineInteraction", import(".CourtYardInteraction"))

function var0.DoStep(arg0)
	arg0.statesCnt[arg0.host.user] = 1
	arg0.statesCnt[arg0.host.owner] = 1
	arg0.totalUserActionCnt = #arg0.userActions
	arg0.totalOwnerActionCnt = #arg0.ownerActions

	var0.super.DoStep(arg0)
end

function var0.PlayUserAction(arg0)
	local var0 = arg0.statesCnt[arg0.host.user] + 1

	if var0 > arg0.totalUserActionCnt then
		return
	end

	arg0.statesCnt[arg0.host.user] = var0
	arg0.states[arg0.host.user] = false

	print("ship..............", var0, arg0.userActions[var0])
	arg0.host:GetUser():UpdateInteraction(arg0:PackData(arg0.userActions[var0]))
end

function var0.PlayOwnerAction(arg0)
	local var0 = arg0.statesCnt[arg0.host.owner] + 1

	if var0 > arg0.totalOwnerActionCnt then
		return
	end

	arg0.statesCnt[arg0.host.owner] = var0
	arg0.states[arg0.host.owner] = false

	print("furn", var0, arg0.ownerActions[var0])
	arg0.host:GetOwner():UpdateInteraction(arg0:PackData(arg0.ownerActions[var0]))
end

function var0.StepEnd(arg0, arg1)
	if arg0.preheatProcess then
		arg0:DoStep()

		arg0.preheatProcess = false
	else
		if arg0.index == 0 then
			return
		end

		arg0.states[arg1] = true

		if arg0.host:GetUser() == arg1 then
			arg0:PlayUserAction()
		elseif arg0.host:GetOwner() == arg1 then
			arg0:PlayOwnerAction()
		end

		if arg0:IsFinishAll() then
			arg0:AllStepEnd()
		end
	end
end

function var0.IsFinishAll(arg0)
	return arg0.statesCnt[arg0.host.owner] >= arg0.totalOwnerActionCnt and arg0.statesCnt[arg0.host.user] >= arg0.totalUserActionCnt
end

function var0.Clear(arg0)
	var0.super.Clear(arg0)

	arg0.statesCnt = {}
end

return var0
