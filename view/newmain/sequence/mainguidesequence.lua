local var0 = class("MainGuideSequence")
local var1 = {
	{
		id = "NG002",
		condition = function()
			local var0 = getProxy(TaskProxy):getTaskById(10302)
			local var1 = getProxy(FleetProxy):getFleetById(11)

			return var0 and var0:isFinish() and not var0:isReceive() and var1:isEmpty()
		end,
		args = function()
			return _.any(getProxy(BayProxy):getShips(), function(arg0)
				return arg0 and arg0.configId == 308031
			end) and {} or {
				1
			}
		end
	},
	{
		id = "NG004",
		condition = function()
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
			local var1 = var0 and not var0:isEnd()
			local var2 = false

			if var1 then
				local var3 = var0:getConfig("config_data")[1]
				local var4 = getProxy(ChapterProxy):getChapterById(var3)

				var2 = var4 and var4:isClear()
			end

			return var1 and var2
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG005",
		condition = function()
			local var0 = getProxy(PlayerProxy):getRawData().level

			return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "CommanderCatMediator")
		end,
		args = function()
			return {}
		end
	},
	{
		id = "NG0022",
		condition = function()
			local var0 = getProxy(PlayerProxy):getRawData().level

			return pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "EquipmentTransformTreeMediator")
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
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not tobool(var0) then
				return false
			end

			local var1 = getProxy(ChapterProxy)
			local var2 = var1:getChapterById(1690005)

			return var2 and var2:isClear() and var1:getMapById(var1:getLastMapForActivity())
		end,
		args = function()
			local var0 = getProxy(ChapterProxy)
			local var1 = var0:getLastMapForActivity()

			return var0:getMapById(var1):getConfig("type") == Map.ACTIVITY_HARD and {
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
			local var0 = PlayerPrefs.GetInt("ryza_task_help_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0

			warning(var0)

			return var0 and {
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
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_RYZA)

			if var0 and not var0:isEnd() and table.contains(var0.data1_list, 56205) then
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

function var0.Execute(arg0, arg1)
	if IsUnityEditor and not ENABLE_GUIDE then
		if arg1 then
			arg1()
		end

		return
	end

	local var0 = _.detect(var1, function(arg0)
		local var0 = arg0.id
		local var1 = arg0.condition

		return not pg.NewStoryMgr.GetInstance():IsPlayed(var0) and var1()
	end)

	if not var0 then
		arg1()

		return
	end

	local var1 = var0.id
	local var2 = var0.args()

	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		arg1()

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		arg1()

		return
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = var1
	})
	pg.NewGuideMgr.GetInstance():Play(var1, var2, function()
		if var0.nextOne then
			local var0, var1 = var0.nextOne()

			arg0:PlayNextOne(var0, var1)
		end
	end, arg1)
end

function var0.PlayNextOne(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	pg.NewGuideMgr.GetInstance():Play(arg1, arg2, function()
		return
	end)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1
	})
end

return var0
