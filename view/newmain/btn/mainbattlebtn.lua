local var0 = class("MainBattleBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	local var0 = getProxy(ChapterProxy):getActiveChapter()

	arg0:emit(NewMainMediator.GO_SCENE, SCENE.LEVEL, {
		chapterId = var0 and var0.id,
		mapIdx = var0 and var0:getConfig("map")
	})
end

function var0.IsFixed(arg0)
	return true
end

return var0
