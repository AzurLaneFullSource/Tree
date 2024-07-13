return {
	LevelScene = {
		{
			id = "NG002",
			condition = function()
				local var0_1 = getProxy(TaskProxy):getTaskById(10302)
				local var1_1 = getProxy(FleetProxy):getFleetById(11)

				return var0_1 and var0_1:isFinish() and not var0_1:isReceive() and var1_1:isEmpty()
			end,
			args = function(arg0_2)
				if getProxy(ChapterProxy):getActiveChapter() then
					arg0_2:switchToMap()
				end

				return _.any(getProxy(BayProxy):getShips(), function(arg0_3)
					return arg0_3 and arg0_3.configId == 308031
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
				local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

				if not tobool(var0_4) then
					return false
				end

				local var1_4 = getProxy(ChapterProxy)
				local var2_4 = var1_4:getChapterById(1690005)

				return var2_4 and var2_4:isClear() and var1_4:getMapById(var1_4:getLastMapForActivity())
			end,
			args = function()
				local var0_5 = getProxy(ChapterProxy)
				local var1_5 = var0_5:getLastMapForActivity()

				return var0_5:getMapById(var1_5):getConfig("type") == Map.ACTIVITY_HARD and {
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
			condition = function(arg0_10)
				return arg0_10.contextData.mode == DockyardScene.MODE_DESTROY
			end,
			args = function()
				return {}
			end
		}
	},
	GameHallScene = {
		{
			id = "NG0039",
			condition = function(arg0_12)
				return PLATFORM_CODE ~= PLATFORM_CHT
			end,
			args = function()
				return {}
			end
		},
		{
			id = "NG0040",
			condition = function(arg0_14)
				return PLATFORM_CODE ~= PLATFORM_CHT
			end,
			args = function()
				return {}
			end
		}
	}
}
