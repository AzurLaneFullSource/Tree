local var0 = class("ChapterStoryGroup", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.story_group
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.id = arg0.configId
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.GetStoryIds(arg0)
	return arg0:getConfig("list")
end

function var0.isUnlock(arg0)
	return arg0:IsCleanPrevChapter() and arg0:IsCleanPrevStory()
end

function var0.IsCleanPrevChapter(arg0)
	local var0 = arg0:getConfig("pre_chapter")

	if var0 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0):isClear()
end

function var0.IsCleanPrevStory(arg0)
	local var0 = arg0:getConfig("pre_story")

	if var0 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0):isClear()
end

function var0.isClear(arg0)
	return _.all(arg0:GetChapterStories(), function(arg0)
		return arg0:IsClear()
	end) and arg0:IsCleanPrevChapter()
end

function var0.GetChapterStories(arg0)
	return (_.map(arg0:GetStoryIds(), function(arg0)
		return ChapterStoryItem.New({
			configId = arg0
		})
	end))
end

function var0.isAllAchieve(arg0)
	return true
end

function var0.activeAlways(arg0)
	return true
end

function var0.ifNeedHide(arg0)
	return false
end

function var0.inActTime(arg0)
	return true
end

return var0
