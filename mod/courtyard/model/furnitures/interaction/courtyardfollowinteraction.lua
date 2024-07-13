local var0_0 = class("CourtYardFollowInteraction", import(".CourtYardInteraction"))

function var0_0.OnStepEnd(arg0_1)
	if arg0_1:IsCompleteOwnerStep() then
		arg0_1:DoStep()
	end
end

return var0_0
