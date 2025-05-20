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
				"new.NS004",
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
				"new.NS022",
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
				"new.NS023",
				13104
			}
		}
	},
	{
		index = 6,
		end_segment = "new.NS024_1",
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"new.NS024",
				13104
			}
		}
	},
	{
		index = 7,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"new.NS025",
				13104
			}
		}
	},
	{
		index = 8,
		interrupt = true,
		view = {
			"NewMainScene"
		},
		segment = {
			{
				"new.NS026",
				40002
			}
		}
	},
	{
		index = 9,
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
					return pg.SeriesGuideMgr.CODES.MAINUI, 8
				elseif arg0_2 == "LevelScene" then
					if not arg1_2 then
						return pg.SeriesGuideMgr.CODES.CONDITION, 8
					elseif arg1_2 then
						if arg1_2.score > 1 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 10
						elseif arg1_2.total_time >= 180 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 8
						else
							return pg.SeriesGuideMgr.CODES.CONDITION, 4
						end
					end
				end
			end
		}
	},
	{
		index = 10,
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
		index = 11,
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
		index = 12,
		end_segment = "new.NS029",
		view = {
			"NewMainScene",
			"LevelScene"
		},
		condition = {
			arg = {
				1,
				40004
			},
			func = function(arg0_3, arg1_3)
				if arg0_3 == "NewMainScene" then
					return pg.SeriesGuideMgr.CODES.MAINUI, 11
				elseif arg0_3 == "LevelScene" then
					if not arg1_3 then
						return pg.SeriesGuideMgr.CODES.CONDITION, 11
					elseif arg1_3 then
						if arg1_3.score > 1 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 13
						elseif arg1_3.total_time >= 180 then
							return pg.SeriesGuideMgr.CODES.CONDITION, 11
						else
							return pg.SeriesGuideMgr.CODES.CONDITION, 4
						end
					end
				end
			end
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
		index = 15,
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
		index = 16,
		view = {
			"NewMainScene"
		},
		condition = {
			arg = {
				2
			},
			func = function(arg0_4)
				if arg0_4:getEquip(2) then
					return pg.SeriesGuideMgr.CODES.MAINUI, 17
				end

				return pg.SeriesGuideMgr.CODES.MAINUI, 16
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
		index = 17,
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
		index = 18,
		end_segment = "new.NG0037_1",
		view = {
			"NewMainScene"
		},
		condition = {
			arg = {
				3
			},
			func = function(arg0_5)
				if arg0_5 then
					return pg.SeriesGuideMgr.CODES.MAINUI, 18
				end

				return pg.SeriesGuideMgr.CODES.MAINUI, 19
			end
		},
		segment = {
			{
				"new.NG0037",
				20012
			}
		}
	}
}
