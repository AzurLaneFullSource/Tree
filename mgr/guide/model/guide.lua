local var0_0 = class("Guide")

function var0_0.Data2GuideStep(arg0_1, arg1_1)
	if arg1_1.hideui then
		return GuideHideUIStep.New(arg1_1)
	elseif arg1_1.stories then
		return GuideStoryStep.New(arg1_1)
	elseif arg1_1.notifies then
		return GuideSendNotifiesStep.New(arg1_1)
	elseif arg1_1.showSign then
		return GuideShowSignStep.New(arg1_1)
	elseif arg1_1.doFunc then
		return GuideDoFunctionStep.New(arg1_1)
	elseif arg1_1.ui then
		return GuideFindUIStep.New(arg1_1)
	else
		return GuideDoNothingStep.New(arg1_1)
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.steps = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.events) do
		local var0_2 = arg0_2:Data2GuideStep(iter1_2)

		if arg1_2.isWorld ~= nil then
			var0_2:UpdateIsWorld(arg1_2.isWorld)
		end

		table.insert(arg0_2.steps, var0_2)
	end
end

function var0_0.GetStepsWithCode(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.steps) do
		if not arg1_3 or iter1_3:IsMatchWithCode(arg1_3) then
			table.insert(var0_3, iter1_3)
		end
	end

	return var0_3
end

return var0_0
