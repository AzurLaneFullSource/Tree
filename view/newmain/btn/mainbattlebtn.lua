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

function var0_0.ShowOrHideBtnEffect(arg0_3, arg1_3)
	local var0_3 = arg0_3._tf:Find("FX")

	if IsNil(var0_3) then
		return
	end

	setActive(var0_3, arg1_3)
end

return var0_0
