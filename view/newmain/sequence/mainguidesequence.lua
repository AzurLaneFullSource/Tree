local var0_0 = class("MainGuideSequence")
local var1_0 = {
	{
		id = "NG002",
		condition = function()
			local var0_1 = getProxy(TaskProxy):getTaskById(10302)
			local var1_1 = getProxy(FleetProxy):getFleetById(11)

			return var0_1 and var0_1:isFinish() and not var0_1:isReceive() and var1_1:isEmpty()
		end,
		args = function()
			return _.any(getProxy(BayProxy):getShips(), function(arg0_3)
				return arg0_3 and arg0_3.configId == 308031
			end) and {} or {
				1
			}
		end
	},
	{
		id = "NG004",
		condition = function()
			local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
			local var1_4 = var0_4 and not var0_4:isEnd()
			local var2_4 = false

			if var1_4 then
				local var3_4 = var0_4:getConfig("config_data")[1]
				local var4_4 = getProxy(ChapterProxy):getChapterById(var3_4)

				var2_4 = var4_4 and var4_4:isClear()
			end

			return var1_4 and var2_4
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG005",
		condition = function()
			local var0_6 = getProxy(PlayerProxy):getRawData().level

			return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_6, "CommanderCatMediator")
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG0022",
		condition = function()
			local var0_8 = getProxy(PlayerProxy):getRawData().level

			return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_8, "EquipmentTransformTreeMediator")
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG0023",
		condition = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed("WorldG192")
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG0030",
		condition = function()
			local var0_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not tobool(var0_12) then
				return false
			end

			local var1_12 = getProxy(ChapterProxy)
			local var2_12 = var1_12:getChapterById(1690005)

			return var2_12 and var2_12:isClear() and var1_12:getMapById(var1_12:getLastMapForActivity())
		end,
		args = function()
			local var0_13 = getProxy(ChapterProxy)
			local var1_13 = var0_13:getLastMapForActivity()

			return var0_13:getMapById(var1_13):getConfig("type") == Map.ACTIVITY_HARD and {
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
		id = "NG0031",
		condition = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed("NG0030")
		end,
		args = function()
			local var0_15 = PlayerPrefs.GetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0

			warning(var0_15)

			return var0_15 and {
				1,
				2
			} or {
				1
			}
		end
	},
	{
		id = "NG0032_1",
		condition = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed("NG0031")
		end,
		args = function()
			return PlayerPrefs.GetInt("first_enter_ryza_atelier_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 and {
				1,
				2
			} or {
				1
			}
		end,
		nextOne = function()
			local var0_18 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_RYZA)

			if var0_18 and not var0_18:isEnd() and table.contains(var0_18.data1_list, 56205) then
				return "NG0032_2", {}
			else
				return nil
			end
		end
	},
	{
		id = "NG0037",
		condition = function()
			return NewServerCarnivalScene.isShow()
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG0038",
		condition = function()
			return getProxy(PlayerProxy):getRawData().level >= 30 and PLATFORM_CODE ~= PLATFORM_CHT
		end,
		args = function()
			return {}
		end
	},
	{
		id = "tb_20",
		condition = function()
			return not LOCK_EDUCATE_SYSTEM and getProxy(EducateProxy):IsUnlockSecretary()
		end,
		args = function()
			return {}
		end
	}
}

function var0_0.Execute(arg0_25, arg1_25)
	if IsUnityEditor and not ENABLE_GUIDE then
		if arg1_25 then
			arg1_25()
		end

		return
	end

	local var0_25 = _.detect(var1_0, function(arg0_26)
		local var0_26 = arg0_26.id
		local var1_26 = arg0_26.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0_26) and var1_26()
	end)

	if not var0_25 then
		arg1_25()

		return
	end

	local var1_25 = var0_25.id
	local var2_25 = var0_25.args()

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		arg1_25()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		arg1_25()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var1_25
	})
	pg.NewGuideMgr.GetInstance():Play(var1_25, var2_25, function()
		if var0_25.nextOne then
			local var0_27, var1_27 = var0_25.nextOne()

			arg0_25:PlayNextOne(var0_27, var1_27)
		end
	end, arg1_25)
end

function var0_0.PlayNextOne(arg0_28, arg1_28, arg2_28)
	if not arg1_28 then
		return
	end

	pg.NewGuideMgr.GetInstance():Play(arg1_28, arg2_28, function()
		return
	end)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_28
	})
end

return var0_0
