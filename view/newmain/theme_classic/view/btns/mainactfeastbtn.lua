local var0_0 = class("MainActFeastBtn", import(".MainBaseActivityBtn"))

function var0_0.InShowTime(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	arg0_1.config = {
		param = "0",
		name = "event_minigame",
		type = 0,
		text_pic = "text_event_minigame",
		id = 20,
		group_id = 5,
		pic = "event_minigame",
		order = 1,
		time = {
			"default"
		}
	}

	return var0_1 and not var0_1:isEnd()
end

function var0_0.CustomOnClick(arg0_2)
	arg0_2:emit(NewMainMediator.GO_SCENE, SCENE.FEAST)
end

return var0_0
