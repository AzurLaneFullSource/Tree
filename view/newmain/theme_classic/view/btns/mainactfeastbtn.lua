local var0 = class("MainActFeastBtn", import(".MainBaseActivityBtn"))

function var0.InShowTime(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	arg0.config = {
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

	return var0 and not var0:isEnd()
end

function var0.CustomOnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.FEAST)
end

return var0
