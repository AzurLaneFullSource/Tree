local var0_0 = class("IslandUpdateStoryPlayer", import(".IslandBasePerformancePlayer"))

function var0_0.Play(arg0_1, arg1_1, arg2_1)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_1.index,
		callback = arg2_1
	})
end

return var0_0
