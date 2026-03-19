local var0_0 = class("NewEducateGuideSequence")

var0_0.config = {
	NewEducateTalentLayer = {
		{
			id = "tb2_1",
			condition = function()
				return true
			end
		}
	},
	NewEducateMainScene = {
		{
			id = "tb2_2",
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb2_1") and #getProxy(NewEducateProxy):GetCurChar():GetTalentList() > 0
			end
		},
		{
			id = "tb2_3",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1 and not getProxy(NewEducateProxy):GetCurChar():GetFSM():GetState(NewEducateFSM.SYSTEM.TOPIC)
			end
		},
		{
			id = "tb2_4",
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb2_3")
			end,
			nextOne = function()
				return "tb2_5"
			end
		},
		{
			id = "tb2_5",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			nextOne = function()
				return "tb2_6"
			end
		},
		{
			id = "tb2_6",
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb2_5")
			end,
			nextOne = function()
				return "tb2_7"
			end
		},
		{
			id = "tb2_7",
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb2_6")
			end
		},
		{
			id = "tb2_9",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 2
			end,
			nextOne = function()
				return "tb2_10"
			end
		},
		{
			id = "tb2_10",
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb2_9")
			end
		},
		{
			id = "tb2_11",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():IsUnlock("rand_event")
			end
		},
		{
			id = "tb2_13",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():IsUnlock("char_event")
			end
		},
		{
			id = "tb2_15",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():IsUnlock("shop")
			end
		},
		{
			id = "tb2_17",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetPermanentData():IsTarotType()
			end
		},
		{
			id = "tb2_18",
			condition = function()
				local var0_18 = getProxy(NewEducateProxy):GetCurChar()

				if not var0_18:GetRoundData():ExistEndless() then
					return false
				end

				if var0_18:GetFSM():GetSystemNo() ~= NewEducateFSM.SYSTEM.ENDING then
					return false
				end

				local var1_18 = var0_18:GetFSM():GetState(NewEducateFSM.SYSTEM.ENDING)

				return var1_18 and var1_18:IsFinish()
			end
		}
	},
	NewEducateScheduleScene = {
		{
			id = "tb2_8",
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb2_7")
			end
		},
		{
			id = "tb2_14",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():IsUnlock("lesson_upgrade")
			end
		}
	},
	NewEducateChooseLayer = {
		{
			id = "tb2_16",
			condition = function()
				return true
			end
		}
	},
	NewEducateRankLayer = {
		{
			id = "tb2_20",
			condition = function()
				return true
			end
		}
	}
}

function var0_0.CheckGuide(arg0_23, arg1_23)
	local var0_23 = arg1_23 or function()
		return
	end

	if NewEducateConst.LOCK_GUIDE then
		var0_23()

		return
	end

	local var1_23 = getProxy(NewEducateProxy):GetCurChar()

	if var1_23:GetGameCnt() ~= 1 or var1_23:GetRoundData():IsTemp() then
		var0_23()

		return
	end

	local var2_23 = var0_0.config[arg0_23] or {}
	local var3_23 = underscore.detect(var2_23, function(arg0_25)
		local var0_25 = arg0_25.id
		local var1_25 = arg0_25.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_25) and var1_25()
	end)

	if not var3_23 then
		var0_23()

		return
	end

	local var4_23 = var3_23.id
	local var5_23 = {
		var1_23.id
	}

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		var0_23()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		var0_23()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var4_23
	})
	pg.NewGuideMgr.GetInstance():Play(var4_23, var5_23, function()
		if var3_23.nextOne then
			local var0_26 = var3_23.nextOne()

			var0_0.PlayNextOne(var0_26, var5_23)
		end
	end, var0_23)
end

function var0_0.PlayNextOne(arg0_27, arg1_27)
	if not arg0_27 then
		return
	end

	pg.NewGuideMgr.GetInstance():Play(arg0_27, arg1_27, function()
		return
	end)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_27
	})
end

return var0_0
