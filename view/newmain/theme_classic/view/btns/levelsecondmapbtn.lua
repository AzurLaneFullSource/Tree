local var0_0 = class("LevelSecondMapBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_second_map"
end

function var0_0.GetActivity(arg0_2)
	if arg0_2.config and arg0_2.config.time and arg0_2.config.time[1] == "default" then
		local var0_2 = arg0_2.config.time[2]
		local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)

		if var1_2 and not var1_2:isEnd() and var0_2 ~= getProxy(ActivityProxy):getEnterReadyActivity()[1] then
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

	if var0_5 == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
		return OtherworldMapScene.IsShowTip()
	end

	return getProxy(ChapterProxy):IsActivitySPChapterActive(var0_5) and SettingsProxy.IsShowActivityMapSPTip()
end

function var0_0.CustomOnClick(arg0_6)
	local var0_6 = arg0_6:GetActivity()

	if var0_6 then
		switch(var0_6:getConfig("type"), {
			[ActivityConst.ACTIVITY_TYPE_ZPROJECT] = function()
				arg0_6:emit(LevelMediator2.ON_ACTIVITY_MAP, var0_6.id)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2] = function()
				arg0_6:emit(LevelMediator2.ON_OPEN_ACT_BOSS_BATTLE)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSRUSH] = function()
				arg0_6:emit(LevelMediator2.ON_BOSSRUSH_MAP)
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE] = function()
				arg0_6:emit(LevelMediator2.ON_BOSSSINGLE_MAP, {
					mode = OtherworldMapScene.MODE_BATTLE
				})
			end,
			[ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE] = function()
				arg0_6:emit(LevelMediator2.ON_CLUE_MAP)
			end
		})
	end
end

function var0_0.ResPath(arg0_12)
	return "LinkButton_mellow"
end

return var0_0
