local var0 = class("GuideStoryStep", import(".GuideStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.stories = {}

	for iter0, iter1 in ipairs(arg1.stories) do
		table.insert(arg0.stories, iter1)
	end
end

function var0.GetType(arg0)
	return GuideStep.TYPE_STORY
end

function var0.GetStories(arg0)
	return arg0.stories
end

return var0
