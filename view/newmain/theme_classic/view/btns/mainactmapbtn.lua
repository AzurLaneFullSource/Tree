local var0_0 = class("MainActMapBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_map"
end

function var0_0.GetActivity(arg0_2)
	if arg0_2.config and arg0_2.config.time and arg0_2.config.time[1] == "default" then
		local var0_2 = arg0_2.config.time[2]
		local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)

		if var1_2 and not var1_2:isEnd() then
			return var1_2
		end
	end

	return nil
end

function var0_0.GetActivityID(arg0_3)
	local var0_3 = arg0_3:GetActivity()

	return var0_3 and var0_3.id
end

function var0_0.OnInit(arg0_4)
	setActive(arg0_4.tipTr.gameObject, arg0_4:IsShowTip())
end

function var0_0.IsShowTip(arg0_5)
	local var0_5 = arg0_5:GetActivityID()
	local var1_5 = arg0_5:GetActivity():getConfig("type")

	if var0_5 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
		return OtherworldMapScene.IsShowTip()
	elseif var1_5 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH or var1_5 == ActivityConst.ACTIVITY_TYPE_BOSS_RUSH_DAL_COLLAB then
		return false
	end

	return getProxy(ChapterProxy):IsActivitySPChapterActive(var0_5) and SettingsProxy.IsShowActivityMapSPTip()
end

function var0_0.CustomOnClick(arg0_6)
	local var0_6 = arg0_6:GetActivity()

	if var0_6 then
		local var1_6 = var0_6:getConfig("type")

		if var1_6 == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
		elseif var1_6 == ActivityConst.ACTIVITY_TYPE_ZPROJECT then
			arg0_6:emit(NewMainMediator.SKIP_ACTIVITY_MAP, var0_6.id)
		end
	end
end

return var0_0
