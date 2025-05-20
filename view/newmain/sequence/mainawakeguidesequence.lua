local var0_0 = class("MainAwakeGuideSequence")
local var1_0 = {
	{
		id = "NG004_1",
		condition = function()
			if not pg.SeriesGuideMgr.GetInstance():IsNewVersion() then
				return false
			end

			local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
			local var1_1 = var0_1 and not var0_1:isEnd()
			local var2_1 = false

			if var1_1 then
				local var3_1 = var0_1:getConfig("config_data")[1]
				local var4_1 = getProxy(ChapterProxy):getChapterById(var3_1)

				var2_1 = var4_1 and var4_1:isClear()
			end

			return var1_1 and var2_1
		end,
		args = function()
			return {}
		end
	}
}

function var0_0.Execute(arg0_3, arg1_3)
	if IsUnityEditor and not ENABLE_GUIDE then
		if arg1_3 then
			arg1_3()
		end

		return
	end

	local var0_3 = getProxy(ContextProxy):getCurrentContext()

	if var0_3 and var0_3.mediator.__cname ~= "NewMainMediator" then
		if arg1_3 then
			arg1_3()
		end

		return
	end

	local var1_3 = _.detect(var1_0, function(arg0_4)
		local var0_4 = arg0_4.id
		local var1_4 = arg0_4.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_4) and var1_4()
	end)

	if not var1_3 then
		arg1_3()

		return
	end

	local var2_3 = var1_3.id
	local var3_3 = var1_3.args()

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		arg1_3()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		arg1_3()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var2_3
	})
	pg.NewGuideMgr.GetInstance():Play(var2_3, var3_3, nil, arg1_3)
end

return var0_0
