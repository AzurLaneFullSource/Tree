local var0_0 = class("NewEducateGuideSequence")

var0_0.config = {
	NewEducateTalentLayer = {
		{
			id = "tb2_1",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			args = function()
				return {}
			end
		}
	},
	NewEducateMainScene = {
		{
			id = "tb2_2",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb2_3"
			end
		},
		{
			id = "tb2_3",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1 and not getProxy(NewEducateProxy):GetCurChar():GetFSM():GetState(NewEducateFSM.STYSTEM.TOPIC)
			end,
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb2_4"
			end
		},
		{
			id = "tb2_4",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			args = function()
				return {}
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
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb2_6"
			end
		},
		{
			id = "tb2_6",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb2_7"
			end
		},
		{
			id = "tb2_7",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb2_9",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 2
			end,
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb2_10"
			end
		},
		{
			id = "tb2_10",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 2
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb2_11",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 3
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb2_13",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 6
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb2_15",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 8
			end,
			args = function()
				return {}
			end
		}
	},
	NewEducateScheduleScene = {
		{
			id = "tb2_8",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 1
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb2_14",
			condition = function()
				return getProxy(NewEducateProxy):GetCurChar():GetRoundData().round == 6
			end,
			args = function()
				return {}
			end
		}
	}
}

function var0_0.CheckGuide(arg0_35, arg1_35)
	local var0_35 = arg1_35 or function()
		return
	end

	if NewEducateConst.LOCK_GUIDE then
		var0_35()

		return
	end

	if getProxy(NewEducateProxy):GetCurChar():GetGameCnt() ~= 1 then
		var0_35()

		return
	end

	local var1_35 = var0_0.config[arg0_35] or {}
	local var2_35 = underscore.detect(var1_35, function(arg0_37)
		local var0_37 = arg0_37.id
		local var1_37 = arg0_37.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_37) and var1_37()
	end)

	if not var2_35 then
		var0_35()

		return
	end

	local var3_35 = var2_35.id
	local var4_35 = var2_35.args()

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		var0_35()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		var0_35()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var3_35
	})
	pg.NewGuideMgr.GetInstance():Play(var3_35, var4_35, function()
		if var2_35.nextOne then
			local var0_38, var1_38 = var2_35.nextOne()

			var0_0.PlayNextOne(var0_38, var1_38)
		end
	end, var0_35)
end

function var0_0.PlayNextOne(arg0_39, arg1_39)
	if not arg0_39 then
		return
	end

	pg.NewGuideMgr.GetInstance():Play(arg0_39, arg1_39, function()
		return
	end)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_39
	})
end

return var0_0
