local var0_0 = class("MainBattleBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	local var0_1 = getProxy(ChapterProxy):getActiveChapter()

	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.LEVEL, {
		chapterId = var0_1 and var0_1.id,
		mapIdx = var0_1 and var0_1:getConfig("map")
	})
end

function var0_0.IsFixed(arg0_2)
	return true
end

return var0_0
