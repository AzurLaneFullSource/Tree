local var0_0 = {
	BLACK_HOLE_RANGE = 2,
	DECOY_RANGE = 5,
	TIME_INTERVAL = 0.0166666666666667,
	LANTERN_RANGE = 3,
	STAGE_CONFIG = {
		BASE_CONFIG = {
			base_rate = 1,
			wave = {
				{
					"Item_1",
					5,
					10
				},
				{
					"Item_2",
					5,
					20
				},
				{
					"Item_3",
					5,
					30
				},
				{
					"Item_4",
					5,
					40
				}
			},
			extra_time = {
				120,
				1000
			},
			ability_rate = {
				gravity = 0.5,
				teleport = 0.5,
				rush = 0.5,
				doppelgangers = 0.5,
				delay = 0.5,
				blackhole = 0.5,
				stealth = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				gravity = true,
				teleport = true,
				rush = true,
				doppelgangers = true,
				delay = true,
				blackhole = true,
				stealth = true,
				breakpassable = true
			}
		},
		Spring23Level_1 = {
			base_rate = 1,
			wave = {
				{
					"Item_1",
					30,
					10
				},
				{
					"Item_2",
					40,
					10
				}
			},
			extra_time = {
				120,
				300
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true
			}
		},
		Spring23Level_2 = {
			base_rate = 1,
			wave = {
				{
					"Item_3",
					20,
					20
				},
				{
					"Item_4",
					30,
					20
				}
			},
			extra_time = {
				120,
				300
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true,
				breakpassable = true
			}
		},
		Spring23Level_3 = {
			base_rate = 1,
			wave = {
				{
					"Item_6",
					30,
					20
				},
				{
					"Item_5",
					30,
					20
				}
			},
			extra_time = {
				150,
				500
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5,
				doppelgangers = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true,
				doppelgangers = true,
				breakpassable = true
			}
		},
		Spring23Level_4 = {
			base_rate = 1,
			wave = {
				{
					"Item_1",
					30,
					20
				},
				{
					"Item_3",
					30,
					30
				}
			},
			extra_time = {
				150,
				500
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5,
				doppelgangers = 0.5,
				delay = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true,
				doppelgangers = true,
				delay = true,
				breakpassable = true
			}
		},
		Spring23Level_5 = {
			base_rate = 1,
			wave = {
				{
					"Item_2",
					20,
					40
				},
				{
					"Item_4",
					20,
					40
				}
			},
			extra_time = {
				150,
				500
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5,
				doppelgangers = 0.5,
				delay = 0.5,
				stealth = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true,
				doppelgangers = true,
				delay = true,
				stealth = true,
				breakpassable = true
			}
		},
		Spring23Level_6 = {
			base_rate = 1,
			wave = {
				{
					"Item_1",
					30,
					30
				},
				{
					"Item_3",
					30,
					40
				}
			},
			extra_time = {
				150,
				600
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5,
				doppelgangers = 0.5,
				delay = 0.5,
				stealth = 0.5,
				gravity = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true,
				doppelgangers = true,
				delay = true,
				stealth = true,
				gravity = true,
				breakpassable = true
			}
		},
		Spring23Level_7 = {
			base_rate = 1,
			wave = {
				{
					"Item_1",
					5,
					70
				},
				{
					"Item_2",
					5,
					70
				},
				{
					"Item_3",
					5,
					70
				},
				{
					"Item_4",
					5,
					70
				},
				{
					"Item_6",
					5,
					70
				},
				{
					"Item_5",
					5,
					70
				}
			},
			extra_time = {
				120,
				700
			},
			ability_rate = {
				blackhole = 0.5,
				teleport = 0.5,
				rush = 0.5,
				doppelgangers = 0.5,
				delay = 0.5,
				stealth = 0.5,
				gravity = 0.5,
				breakpassable = 0.5
			},
			ability_config = {
				blackhole = true,
				teleport = true,
				rush = true,
				doppelgangers = true,
				delay = true,
				stealth = true,
				gravity = true,
				breakpassable = true
			}
		}
	}
}

function var0_0.GetStageConfig(arg0_1)
	return setmetatable(var0_0.STAGE_CONFIG[arg0_1] or {}, {
		__index = var0_0.STAGE_CONFIG.BASE_CONFIG
	})
end

function var0_0.GetCreateConfig(arg0_2)
	local var0_2 = {}

	switch(arg0_2.name, {
		FuShun = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetFuShun)
			table.insert(var0_2, "character/FuShun")
			table.insert(var0_2, "character")
		end,
		Nenjuu = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetNenjuu)
			table.insert(var0_2, "character/Nenjuu")
			table.insert(var0_2, "character")
		end,
		Nenjuu_Doppelgangers = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetNenjuu)
			table.insert(var0_2, "character/Nenjuu_Doppelgangers")
			table.insert(var0_2, "character")
		end,
		Ice = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetIce)
			table.insert(var0_2, "object/Ice")
			table.insert(var0_2, "object")
		end,
		Bomb = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetBomb)
			table.insert(var0_2, "effect/Bomb")
			table.insert(var0_2, "object")
		end,
		SignWarp = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetTimeEffect)
			table.insert(var0_2, "effect/SignWarp")
			table.insert(var0_2, "effect")
		end,
		Rock = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Rock")
			table.insert(var0_2, "object")
		end,
		BlackHole = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetBlackHole)
			table.insert(var0_2, "object/BlackHole")
			table.insert(var0_2, "object")
		end,
		Decoy = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetEffect)
			table.insert(var0_2, "effect/Decoy")
			table.insert(var0_2, "effect")
		end,
		EF_bk_Flash_Jump = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetEffect)
			table.insert(var0_2, "effect/EF_bk_Flash_Jump")
			table.insert(var0_2, "effect")
		end,
		EF_bk_Flash_Land = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_bk_Flash_Land")
			table.insert(var0_2, "effect")
		end,
		EF_Break_E = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetEffect)
			table.insert(var0_2, "effect/EF_Break_E")
			table.insert(var0_2, "effect")
		end,
		EF_Break_N = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetEffect)
			table.insert(var0_2, "effect/EF_Break_N")
			table.insert(var0_2, "effect")
		end,
		EF_Break_S = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetEffect)
			table.insert(var0_2, "effect/EF_Break_S")
			table.insert(var0_2, "effect")
		end,
		EF_Break_W = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetEffect)
			table.insert(var0_2, "effect/EF_Break_W")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_E = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_E")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_S = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_S")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_N = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_N")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_W = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_W")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_Hit_W_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_Hit_W_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_Hit_W_fr = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_Hit_W_fr")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_Hit_E_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_Hit_E_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_Hit_E_fr = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_Hit_E_fr")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_Hit_N = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_Hit_N")
			table.insert(var0_2, "effect")
		end,
		EF_Attack_Hit_S = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_Attack_Hit_S")
			table.insert(var0_2, "effect")
		end,
		EF_bk_Freeze = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_bk_Freeze")
			table.insert(var0_2, "effect")
		end,
		EF_bk_overlay_Lantern = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_bk_overlay_Lantern")
			table.insert(var0_2, "effect")
		end,
		Lamp_A = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Lamp_A")
			table.insert(var0_2, "object")

			arg0_2.hide = true
		end,
		Pine = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Pine")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
		end,
		Plum = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Plum")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
		end,
		Pond = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Pond")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
		end,
		Manjuu_fishing = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Manjuu_fishing")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
		end,
		Fire = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Fire")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(3, 3)
		end,
		Building_A = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Building_A")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(3, 3)
			arg0_2.hide = true
		end,
		Item_1 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetItem)
			table.insert(var0_2, "object/Item")
			table.insert(var0_2, "object")
		end,
		Item_2 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetItem)
			table.insert(var0_2, "object/Item")
			table.insert(var0_2, "object")
		end,
		Item_3 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetItem)
			table.insert(var0_2, "object/Item")
			table.insert(var0_2, "object")
		end,
		Item_4 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetItem)
			table.insert(var0_2, "object/Item")
			table.insert(var0_2, "object")
		end,
		Item_5 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetItem)
			table.insert(var0_2, "object/Item")
			table.insert(var0_2, "object")
		end,
		Item_6 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetItem)
			table.insert(var0_2, "object/Item")
			table.insert(var0_2, "object")
		end,
		EF_fr_Inactivate = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetSubEffect)
			table.insert(var0_2, "effect/EF_fr_Inactivate")
			table.insert(var0_2, "object")
		end,
		EF_Ghost_E_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Ghost_E_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Ghost_N_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Ghost_N_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Ghost_N_fr = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Ghost_N_fr")
			table.insert(var0_2, "effect")
		end,
		EF_Ghost_S_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Ghost_S_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Ghost_W_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Ghost_W_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Nenjuu_Ghost_E_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Nenjuu_Ghost_E_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Nenjuu_Ghost_N_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Nenjuu_Ghost_N_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Nenjuu_Ghost_N_fr = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Nenjuu_Ghost_N_fr")
			table.insert(var0_2, "effect")
		end,
		EF_Nenjuu_Ghost_S_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Nenjuu_Ghost_S_bk")
			table.insert(var0_2, "effect")
		end,
		EF_Nenjuu_Ghost_W_bk = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetRushEffect)
			table.insert(var0_2, "effect/EF_Nenjuu_Ghost_W_bk")
			table.insert(var0_2, "effect")
		end,
		Snow_1 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Snow_1")
			table.insert(var0_2, "object")
		end,
		Snow_2 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Snow_2")
			table.insert(var0_2, "object")
		end,
		Snow_3 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Snow_3")
			table.insert(var0_2, "object")
		end,
		Snow_4 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Snow_4")
			table.insert(var0_2, "object")
		end,
		Snow_5 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Snow_5")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 1)
			arg0_2.hide = true
		end,
		Lamp_B1 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Lamp_B1")
			table.insert(var0_2, "object")

			arg0_2.hide = true
		end,
		Lamp_B2 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Lamp_B2")
			table.insert(var0_2, "object")

			arg0_2.hide = true
		end,
		Building_B = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Building_B")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(4, 3)
			arg0_2.hide = true
		end,
		["1_Arbor_1"] = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetArbor)
			table.insert(var0_2, "object/Arbor")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
			arg0_2.hide = true
		end,
		["1_Arbor_2"] = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetArbor)
			table.insert(var0_2, "object/Arbor")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
			arg0_2.hide = true
		end,
		["1_Arbor_3"] = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetArbor)
			table.insert(var0_2, "object/Arbor")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
			arg0_2.hide = true
		end,
		["1_Arbor_4"] = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetArbor)
			table.insert(var0_2, "object/Arbor")
			table.insert(var0_2, "object")

			arg0_2.size = NewPos(2, 2)
			arg0_2.hide = true
		end,
		Dango_1 = function()
			table.insert(var0_2, NenjuuGameNameSpace.TargetObject)
			table.insert(var0_2, "object/Dango")
			table.insert(var0_2, "object")
		end
	}, function()
		warning("name error:" .. arg0_2.name)
		table.insert(var0_2, false)
	end)

	return unpack(var0_2)
end

var0_0.SKILL_LEVEL_CONFIG = {
	ice = {
		level = 1,
		cost = {
			0,
			1000,
			1000
		},
		param = {
			7,
			9,
			11
		}
	},
	flash = {
		level = 0,
		cost = {
			2000,
			2000,
			2000
		},
		param = {
			30,
			25,
			20
		}
	},
	rush = {
		level = 0,
		cost = {
			2000,
			2000,
			2000
		},
		param = {
			{
				5,
				1.2
			},
			{
				5,
				1.3
			},
			{
				7,
				1.3
			}
		}
	},
	blessing = {
		level = 0,
		cost = {
			2000,
			1000,
			1000
		},
		param = {
			1.03,
			1.06,
			1.1
		}
	},
	decoy = {
		level = 0,
		cost = {
			5000
		}
	},
	bomb = {
		level = 0,
		cost = {
			1000
		}
	},
	lantern = {
		level = 0,
		cost = {
			1000
		}
	}
}

function var0_0.GetSkillParam(arg0_68, arg1_68)
	return var0_0.SKILL_LEVEL_CONFIG[arg0_68].param[arg1_68]
end

var0_0.ITEM_LIST = {
	"bomb",
	"lantern"
}

function var0_0.ParsingElements(arg0_69)
	local var0_69 = {
		high = arg0_69[1] or 0,
		count = arg0_69[2] or 0,
		item = arg0_69[3] and var0_0.ITEM_LIST[arg0_69[3]] or nil
	}

	for iter0_69 = 1, 7 do
		var0_69["stage_" .. iter0_69] = arg0_69[iter0_69 + 3] or 0
	end

	var0_69.level = {}

	for iter1_69, iter2_69 in ipairs({
		"bomb",
		"lantern",
		"ice",
		"flash",
		"rush",
		"blessing",
		"decoy"
	}) do
		var0_69.level[iter2_69] = arg0_69[iter1_69 + 10] or var0_0.SKILL_LEVEL_CONFIG[iter2_69].level
	end

	return var0_69
end

var0_0.ABILITY_LIST = {
	"teleport",
	"rush",
	"breakpassable",
	"gravity",
	"doppelgangers",
	"delay",
	"blackhole",
	"stealth"
}

return var0_0
