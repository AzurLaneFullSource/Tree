local var0 = class("Guide")

function var0.Data2GuideStep(arg0, arg1)
	if arg1.hideui then
		return GuideHideUIStep.New(arg1)
	elseif arg1.stories then
		return GuideStoryStep.New(arg1)
	elseif arg1.notifies then
		return GuideSendNotifiesStep.New(arg1)
	elseif arg1.showSign then
		return GuideShowSignStep.New(arg1)
	elseif arg1.doFunc then
		return GuideDoFunctionStep.New(arg1)
	elseif arg1.ui then
		return GuideFindUIStep.New(arg1)
	else
		return GuideDoNothingStep.New(arg1)
	end
end

function var0.Ctor(arg0, arg1)
	arg0.steps = {}

	for iter0, iter1 in ipairs(arg1.events) do
		local var0 = arg0:Data2GuideStep(iter1)

		if arg1.isWorld ~= nil then
			var0:UpdateIsWorld(arg1.isWorld)
		end

		table.insert(arg0.steps, var0)
	end
end

function var0.GetStepsWithCode(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.steps) do
		if not arg1 or iter1:IsMatchWithCode(arg1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
