local var0 = class("ChapterStoryItem", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.story_template
end

function var0.GetStoryName(arg0)
	return arg0:getConfig("story")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetIcon(arg0)
	local var0 = arg0:getConfig("icon")

	return "StoryPointIcon/" .. var0, var0
end

function var0.GetPosition(arg0)
	return arg0:getConfig("pos")
end

function var0.IsClear(arg0)
	return pg.NewStoryMgr.GetInstance():IsPlayed(arg0:GetStoryName())
end

return var0
