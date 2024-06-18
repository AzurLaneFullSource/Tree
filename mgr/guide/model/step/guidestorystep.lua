local var0_0 = class("GuideStoryStep", import(".GuideStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.stories = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.stories) do
		table.insert(arg0_1.stories, iter1_1)
	end
end

function var0_0.GetType(arg0_2)
	return GuideStep.TYPE_STORY
end

function var0_0.GetStories(arg0_3)
	return arg0_3.stories
end

return var0_0
