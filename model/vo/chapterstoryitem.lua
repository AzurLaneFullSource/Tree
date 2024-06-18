local var0_0 = class("ChapterStoryItem", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.story_template
end

function var0_0.GetStoryName(arg0_2)
	return arg0_2:getConfig("story")
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("name")
end

function var0_0.GetIcon(arg0_4)
	local var0_4 = arg0_4:getConfig("icon")

	return "StoryPointIcon/" .. var0_4, var0_4
end

function var0_0.GetPosition(arg0_5)
	return arg0_5:getConfig("pos")
end

function var0_0.IsClear(arg0_6)
	return pg.NewStoryMgr.GetInstance():IsPlayed(arg0_6:GetStoryName())
end

return var0_0
