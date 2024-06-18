local var0_0 = class("CourtYardVariedInteraction", import(".CourtYardInteraction"))

function var0_0.InitData(arg0_1)
	var0_0.super.InitData(arg0_1)

	arg0_1.total = 1
end

function var0_0.GetInterActionUserCnt(arg0_2)
	local var0_2 = arg0_2.host:GetOwner()

	if isa(var0_2, CourtYardFurniture) then
		return #var0_2:GetUsingSlots()
	else
		return 1
	end
end

function var0_0.GetUserAction(arg0_3)
	local var0_3 = arg0_3:GetInterActionUserCnt()

	return arg0_3.userActions[var0_3]
end

function var0_0.GetOwnerAction(arg0_4)
	local var0_4 = arg0_4:GetInterActionUserCnt()

	return arg0_4.ownerActions[var0_4]
end

function var0_0.Reset(arg0_5)
	arg0_5.index = 0

	arg0_5:Update(arg0_5.loop)
end

function var0_0.OnStepEnd(arg0_6)
	if arg0_6:IsCompleteOwnerStep() then
		arg0_6:DoStep()
	end
end

return var0_0
