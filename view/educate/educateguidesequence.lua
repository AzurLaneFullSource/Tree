local var0 = class("EducateGuideSequence")

var0.config = {
	EducateScene = {
		{
			ignorePlayer = true,
			id = "tb_1",
			condition = function()
				return getProxy(EducateProxy):GetTaskProxy():GetTaskById(EducateConst.MAIN_TASK_ID_1)
			end,
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb_2"
			end
		},
		{
			id = "tb_2",
			ignorePlayer = true,
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_1") and getProxy(EducateProxy):GetTaskProxy():GetTargetId() == 0
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_4",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_3") and var0.month == 2 and var0.week == 4
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_5",
			condition = function()
				return getProxy(EducateProxy):GetCurTime().month ~= 2
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_18",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return var0.month == 3 and var0.week == 2
			end,
			args = function()
				return {}
			end,
			nextOne = function()
				return "tb_19"
			end
		},
		{
			id = "tb_19",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_18") and var0.month == 3 and var0.week == 2
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_8",
			condition = function()
				return #getProxy(EducateProxy):GetPolaroidList() > 0
			end,
			args = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_7") and {
					1,
					3
				} or {
					1,
					2,
					3
				}
			end
		},
		{
			id = "tb_12_0",
			condition = function()
				return #getProxy(EducateProxy):GetEventProxy():GetHomeSpecEvents() > 0
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_12",
			condition = function()
				return EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_FAVOR_AND_MIND)
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_10",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return var0.month == 3 and var0.week == 4 and #getProxy(EducateProxy):GetBuffList() > 0
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_9_2",
			condition = function()
				local var0 = getProxy(EducateProxy):GetTaskProxy()
				local var1 = var0:GetTargetId()
				local var2 = var0:GetTargetSetDays()
				local var3 = getProxy(EducateProxy):GetCurTime()

				return EducateHelper.IsSameDay(var3, var2[2]) and pg.child_target_set[var1].stage == 2
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_11",
			ignorePlayer = true,
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()
				local var1 = getProxy(EducateProxy):GetCharData()

				return var0.month == 4 and var0.week == 1 and var1.site == var1:GetSiteCnt()
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_13",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return var0.month == 4 and var0.week == 3
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_14",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return var0.month == 4 and var0.week == 4
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_21",
			condition = function()
				local var0 = getProxy(EducateProxy):GetTaskProxy()
				local var1 = var0:GetTargetId()
				local var2 = var0:GetTargetSetDays()
				local var3 = getProxy(EducateProxy):GetCurTime()

				return EducateHelper.IsSameDay(var3, var2[3]) and pg.child_target_set[var1].stage == 3
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_9",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return var0.month == 6 and var0.week == 1
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_22",
			condition = function()
				local var0 = getProxy(EducateProxy):GetTaskProxy()
				local var1 = var0:GetTargetId()
				local var2 = var0:GetTargetSetDays()
				local var3 = getProxy(EducateProxy):GetCurTime()

				return EducateHelper.IsSameDay(var3, var2[4]) and pg.child_target_set[var1].stage == 4
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_16",
			condition = function()
				local var0 = getProxy(EducateProxy):GetCurTime()

				return var0.month == 14 and var0.week == 4
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_17",
			condition = function()
				return getProxy(EducateProxy):GetGameStatus() == EducateConst.STATUES_RESET
			end,
			args = function()
				return {}
			end
		}
	},
	EducateTargetLayer = {
		{
			id = "tb_3",
			ignorePlayer = true,
			condition = function()
				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_2") and getProxy(EducateProxy):GetTaskProxy():GetTaskById(EducateConst.MAIN_TASK_ID_2)
			end,
			args = function()
				return {}
			end
		}
	},
	EducateCollectEntranceLayer = {
		{
			id = "tb_7",
			condition = function()
				return EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_MEMORY)
			end,
			args = function()
				return {}
			end
		}
	}
}

function var0.CheckGuide(arg0, arg1)
	if not getProxy(EducateProxy):IsFirstGame() then
		arg1()

		return
	end

	local var0 = var0.config[arg0] or {}
	local var1 = underscore.detect(var0, function(arg0)
		local var0 = arg0.id
		local var1 = arg0.condition

		return (arg0.ignorePlayer or not pg.NewStoryMgr.GetInstance():IsPlayed(var0)) and var1()
	end)

	if not var1 then
		arg1()

		return
	end

	local var2 = var1.id
	local var3 = var1.args()

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		arg1()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		arg1()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var2
	})
	pg.NewGuideMgr.GetInstance():Play(var2, var3, function()
		if var1.nextOne then
			local var0, var1 = var1.nextOne()

			var0.PlayNextOne(var0, var1)
		end
	end, arg1)
end

function var0.PlayNextOne(arg0, arg1)
	if not arg0 then
		return
	end

	pg.NewGuideMgr.GetInstance():Play(arg0, arg1, function()
		return
	end)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0
	})
end

return var0
