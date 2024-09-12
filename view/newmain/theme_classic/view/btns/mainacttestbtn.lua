local var0_0 = class("MainActTestBtn", import(".MainBaseActivityBtn"))
local var1_0 = true

function var0_0.InShowTime(arg0_1)
	arg0_1.config = {
		param = "0",
		name = "event_all",
		time = "always",
		text_pic = "text_event_all",
		type = 0,
		pic = "event_all_default",
		id = 9,
		group_id = 1,
		order = 99
	}

	return var1_0
end

function var0_0.CustomOnClick(arg0_2)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DREAMLAND)
end

return var0_0
