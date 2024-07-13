local var0_0 = class("EducateGuideSequence")

var0_0.config = {
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
				local var0_6 = getProxy(EducateProxy):GetCurTime()

				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_3") and var0_6.month == 2 and var0_6.week == 4
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
				local var0_10 = getProxy(EducateProxy):GetCurTime()

				return var0_10.month == 3 and var0_10.week == 2
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
				local var0_13 = getProxy(EducateProxy):GetCurTime()

				return pg.NewStoryMgr.GetInstance():IsPlayed("tb_18") and var0_13.month == 3 and var0_13.week == 2
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
				local var0_21 = getProxy(EducateProxy):GetCurTime()

				return var0_21.month == 3 and var0_21.week == 4 and #getProxy(EducateProxy):GetBuffList() > 0
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_9_2",
			condition = function()
				local var0_23 = getProxy(EducateProxy):GetTaskProxy()
				local var1_23 = var0_23:GetTargetId()
				local var2_23 = var0_23:GetTargetSetDays()
				local var3_23 = getProxy(EducateProxy):GetCurTime()

				return EducateHelper.IsSameDay(var3_23, var2_23[2]) and pg.child_target_set[var1_23].stage == 2
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_11",
			ignorePlayer = true,
			condition = function()
				local var0_25 = getProxy(EducateProxy):GetCurTime()
				local var1_25 = getProxy(EducateProxy):GetCharData()

				return var0_25.month == 4 and var0_25.week == 1 and var1_25.site == var1_25:GetSiteCnt()
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_13",
			condition = function()
				local var0_27 = getProxy(EducateProxy):GetCurTime()

				return var0_27.month == 4 and var0_27.week == 3
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_14",
			condition = function()
				local var0_29 = getProxy(EducateProxy):GetCurTime()

				return var0_29.month == 4 and var0_29.week == 4
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_21",
			condition = function()
				local var0_31 = getProxy(EducateProxy):GetTaskProxy()
				local var1_31 = var0_31:GetTargetId()
				local var2_31 = var0_31:GetTargetSetDays()
				local var3_31 = getProxy(EducateProxy):GetCurTime()

				return EducateHelper.IsSameDay(var3_31, var2_31[3]) and pg.child_target_set[var1_31].stage == 3
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_9",
			condition = function()
				local var0_33 = getProxy(EducateProxy):GetCurTime()

				return var0_33.month == 6 and var0_33.week == 1
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_22",
			condition = function()
				local var0_35 = getProxy(EducateProxy):GetTaskProxy()
				local var1_35 = var0_35:GetTargetId()
				local var2_35 = var0_35:GetTargetSetDays()
				local var3_35 = getProxy(EducateProxy):GetCurTime()

				return EducateHelper.IsSameDay(var3_35, var2_35[4]) and pg.child_target_set[var1_35].stage == 4
			end,
			args = function()
				return {}
			end
		},
		{
			id = "tb_16",
			condition = function()
				local var0_37 = getProxy(EducateProxy):GetCurTime()

				return var0_37.month == 14 and var0_37.week == 4
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

function var0_0.CheckGuide(arg0_45, arg1_45)
	if not getProxy(EducateProxy):IsFirstGame() then
		arg1_45()

		return
	end

	local var0_45 = var0_0.config[arg0_45] or {}
	local var1_45 = underscore.detect(var0_45, function(arg0_46)
		local var0_46 = arg0_46.id
		local var1_46 = arg0_46.condition

		return (arg0_46.ignorePlayer or not pg.NewStoryMgr.GetInstance():IsPlayed(var0_46)) and var1_46()
	end)

	if not var1_45 then
		arg1_45()

		return
	end

	local var2_45 = var1_45.id
	local var3_45 = var1_45.args()

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		arg1_45()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		arg1_45()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var2_45
	})
	pg.NewGuideMgr.GetInstance():Play(var2_45, var3_45, function()
		if var1_45.nextOne then
			local var0_47, var1_47 = var1_45.nextOne()

			var0_0.PlayNextOne(var0_47, var1_47)
		end
	end, arg1_45)
end

function var0_0.PlayNextOne(arg0_48, arg1_48)
	if not arg0_48 then
		return
	end

	pg.NewGuideMgr.GetInstance():Play(arg0_48, arg1_48, function()
		return
	end)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_48
	})
end

return var0_0
