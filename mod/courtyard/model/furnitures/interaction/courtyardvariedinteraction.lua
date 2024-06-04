local var0 = class("CourtYardVariedInteraction", import(".CourtYardInteraction"))

function var0.InitData(arg0)
	var0.super.InitData(arg0)

	arg0.total = 1
end

function var0.GetInterActionUserCnt(arg0)
	local var0 = arg0.host:GetOwner()

	if isa(var0, CourtYardFurniture) then
		return #var0:GetUsingSlots()
	else
		return 1
	end
end

function var0.GetUserAction(arg0)
	local var0 = arg0:GetInterActionUserCnt()

	return arg0.userActions[var0]
end

function var0.GetOwnerAction(arg0)
	local var0 = arg0:GetInterActionUserCnt()

	return arg0.ownerActions[var0]
end

function var0.Reset(arg0)
	arg0.index = 0

	arg0:Update(arg0.loop)
end

function var0.OnStepEnd(arg0)
	if arg0:IsCompleteOwnerStep() then
		arg0:DoStep()
	end
end

return var0
