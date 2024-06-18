return {
	{
		index = 1,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S001",
				12003
			}
		}
	},
	{
		index = 2,
		end_segment = "S003",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S002",
				12009
			},
			{
				"S002_1",
				12026
			}
		},
		getSegment = function()
			return getProxy(BuildShipProxy):getFinishCount() > 0 and 2 or 1
		end
	},
	{
		index = 3,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S004",
				12103
			}
		}
	},
	{
		index = 4,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S005",
				13102
			}
		}
	},
	{
		index = 5,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S006",
				13104
			}
		}
	},
	{
		index = 6,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S007",
				13104
			}
		}
	},
	{
		index = 7,
		interrupt = true,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S008",
				40002
			}
		}
	},
	{
		index = 8,
		view = {
			"NewMainScene",
			"LevelScene"
		},
		condition = {
			arg = {
				1,
				40004
			},
			func = function(arg0_2, arg1_2)
				if arg0_2 == "NewMainScene" then
					return pg.SeriesGuideMgr.CODES.MAINUI, 7
				elseif arg0_2 == "LevelScene" then
					if not arg1_2 then
						return pg.SeriesGuideMgr.CODES.CONDITION, 7
					elseif arg1_2 then
						if arg1_2.score > 1 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 9
						elseif arg1_2.total_time >= 180 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 7
						else
							return pg.SeriesGuideMgr.CODES.CONDITION, 4
						end
					end
				end
			end
		}
	},
	{
		index = 9,
		end_segment = "S010",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S009",
				13104
			}
		}
	},
	{
		index = 10,
		end_segment = "S012",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S011",
				20006
			}
		}
	},
	{
		index = 11,
		end_segment = "S014",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S013",
				15003
			}
		}
	},
	{
		index = 12,
		end_segment = "S016",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S015",
				14007
			}
		}
	},
	{
		index = 13,
		end_segment = "S012",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S011",
				20006
			}
		}
	},
	{
		index = 14,
		view = {
			"NewMainScene"
		},
		condition = {
			arg = {
				2
			},
			func = function(arg0_3)
				if arg0_3:getEquip(2) then
					return pg.SeriesGuideMgr.CODES.MAINUI, 15
				end

				return pg.SeriesGuideMgr.CODES.MAINUI, 14
			end
		},
		segment = {
			{
				"S017",
				12007
			}
		}
	},
	{
		index = 15,
		end_segment = "S019",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S018",
				14003
			}
		}
	},
	{
		index = 16,
		end_segment = "S012",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S011",
				20006
			}
		}
	},
	{
		index = 17,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S020",
				12003
			},
			{
				"S020_1",
				12003
			}
		},
		getSegment = function()
			local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1)
			local var1_4 = var0_4 and not var0_4:isEnd()

			if not BuildShipScene.projectName then
				if var1_4 then
					return 1
				else
					return 2
				end
			else
				return BuildShipScene.projectName == BuildShipScene.PROJECTS.HEAVY and 2 or 1
			end
		end
	},
	{
		index = 18,
		end_segment = "S003",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S002",
				12009
			},
			{
				"S002_1",
				12026
			}
		},
		getSegment = function()
			return getProxy(BuildShipProxy):getFinishCount() > 0 and 2 or 1
		end
	},
	{
		index = 19,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S021",
				12103
			}
		}
	},
	{
		index = 20,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S022",
				13102
			}
		}
	},
	{
		index = 21,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S023",
				13104
			}
		}
	},
	{
		index = 22,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S024",
				13104
			}
		}
	},
	{
		index = 23,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S025",
				13104
			}
		}
	},
	{
		index = 24,
		interrupt = true,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S026",
				40002
			}
		}
	},
	{
		index = 25,
		view = {
			"NewMainScene",
			"LevelScene"
		},
		condition = {
			arg = {
				1,
				40004
			},
			func = function(arg0_6, arg1_6)
				if arg0_6 == "NewMainScene" then
					return pg.SeriesGuideMgr.CODES.MAINUI, 24
				elseif arg0_6 == "LevelScene" then
					if not arg1_6 then
						return pg.SeriesGuideMgr.CODES.CONDITION, 24
					elseif arg1_6 then
						if arg1_6.score > 1 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 26
						elseif arg1_6.total_time >= 180 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 24
						else
							return pg.SeriesGuideMgr.CODES.CONDITION, 20
						end
					end
				end
			end
		}
	},
	{
		index = 26,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S027",
				13104
			}
		}
	},
	{
		index = 27,
		interrupt = true,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"S028",
				40002
			}
		}
	},
	{
		index = 28,
		end_segment = "S029",
		view = {
			"NewMainScene",
			"LevelScene"
		},
		condition = {
			arg = {
				1,
				40004
			},
			func = function(arg0_7, arg1_7)
				if arg0_7 == "NewMainScene" then
					return pg.SeriesGuideMgr.CODES.MAINUI, 27
				elseif arg0_7 == "LevelScene" then
					if not arg1_7 then
						return pg.SeriesGuideMgr.CODES.CONDITION, 27
					elseif arg1_7 then
						if arg1_7.score > 1 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 29
						elseif arg1_7.total_time >= 180 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 27
						else
							return pg.SeriesGuideMgr.CODES.CONDITION, 20
						end
					end
				end
			end
		}
	}
}
