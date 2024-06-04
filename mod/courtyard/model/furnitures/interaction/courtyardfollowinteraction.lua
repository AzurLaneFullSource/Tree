local var0 = class("CourtYardFollowInteraction", import(".CourtYardInteraction"))

function var0.OnStepEnd(arg0)
	if arg0:IsCompleteOwnerStep() then
		arg0:DoStep()
	end
end

return var0
