local var0_0 = class("MainActMapBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_map"
end

function var0_0.GetActivity(arg0_2)
	if arg0_2.config.time and arg0_2.config.time[1] == "default" then
		local var0_2 = arg0_2.config.time[2]
		local var1_2 = pg.activity_template[var0_2].type
		local var2_2 = getProxy(ActivityProxy):getActivitiesByType(var1_2)

		return (_.detect(var2_2, function(arg0_3)
			return not arg0_3:isEnd()
		end))
	end

	return nil
end

function var0_0.GetActivityID(arg0_4)
	local var0_4 = arg0_4:GetActivity()

	return var0_4 and var0_4.id
end

function var0_0.OnInit(arg0_5)
	setActive(arg0_5.tipTr.gameObject, arg0_5:IsShowTip())
end

function var0_0.IsShowTip(arg0_6)
	if arg0_6:GetActivityID() == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
		return OtherworldMapScene.IsShowTip()
	end

	return getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()
end

function var0_0.CustomOnClick(arg0_7)
	local var0_7 = arg0_7:GetActivity()

	if var0_7 then
		local var1_7 = var0_7:getConfig("type")

		if var1_7 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
		elseif var1_7 == ActivityConst.ACTIVITY_TYPE_ZPROJECT then
			arg0_7:emit(NewMainMediator.SKIP_ACTIVITY_MAP, var0_7.id)
		end
	end
end

return var0_0
