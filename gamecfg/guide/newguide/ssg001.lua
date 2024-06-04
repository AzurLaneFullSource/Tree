return {
	LevelScene = {
		{
			id = "NG002",
			condition = function()
				local var0 = getProxy(TaskProxy):getTaskById(10302)
				local var1 = getProxy(FleetProxy):getFleetById(11)

				return var0 and var0:isFinish() and not var0:isReceive() and var1:isEmpty()
			end,
			args = function(arg0)
				if getProxy(ChapterProxy):getActiveChapter() then
					arg0:switchToMap()
				end

				return _.any(getProxy(BayProxy):getShips(), function(arg0)
					return arg0 and arg0.configId == 308031
				end) and {
					2
				} or {
					2,
					1
				}
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
					3
				} or {
					2,
					3
				}
			end
		}
	},
	ChallengeMainScene = {
		{
			id = "NG0014",
			condition = function()
				return true
			end,
			args = function()
				return {}
			end
		}
	},
	InstagramLayer = {
		{
			id = "NG0018",
			condition = function()
				return true
			end,
			args = function()
				return {}
			end
		}
	},
	DockyardScene = {
		{
			id = "NG0019",
			condition = function(arg0)
				return arg0.contextData.mode == DockyardScene.MODE_DESTROY
			end,
			args = function()
				return {}
			end
		}
	},
	GameHallScene = {
		{
			id = "NG0039",
			condition = function(arg0)
				return PLATFORM_CODE ~= PLATFORM_CHT
			end,
			args = function()
				return {}
			end
		},
		{
			id = "NG0040",
			condition = function(arg0)
				return PLATFORM_CODE ~= PLATFORM_CHT
			end,
			args = function()
				return {}
			end
		}
	}
}
