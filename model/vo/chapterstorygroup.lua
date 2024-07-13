local var0_0 = class("ChapterStoryGroup", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.story_group
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.id = arg0_2.configId
end

function var0_0.GetConfigID(arg0_3)
	return arg0_3.configId
end

function var0_0.GetStoryIds(arg0_4)
	return arg0_4:getConfig("list")
end

function var0_0.isUnlock(arg0_5)
	return arg0_5:IsCleanPrevChapter() and arg0_5:IsCleanPrevStory()
end

function var0_0.IsCleanPrevChapter(arg0_6)
	local var0_6 = arg0_6:getConfig("pre_chapter")

	if var0_6 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0_6):isClear()
end

function var0_0.IsCleanPrevStory(arg0_7)
	local var0_7 = arg0_7:getConfig("pre_story")

	if var0_7 == 0 then
		return true
	end

	return getProxy(ChapterProxy):GetChapterItemById(var0_7):isClear()
end

function var0_0.isClear(arg0_8)
	return _.all(arg0_8:GetChapterStories(), function(arg0_9)
		return arg0_9:IsClear()
	end) and arg0_8:IsCleanPrevChapter()
end

function var0_0.GetChapterStories(arg0_10)
	return (_.map(arg0_10:GetStoryIds(), function(arg0_11)
		return ChapterStoryItem.New({
			configId = arg0_11
		})
	end))
end

function var0_0.isAllAchieve(arg0_12)
	return true
end

function var0_0.activeAlways(arg0_13)
	return true
end

function var0_0.ifNeedHide(arg0_14)
	return false
end

function var0_0.inActTime(arg0_15)
	return true
end

return var0_0
