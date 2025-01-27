return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			pop = {},
			arg_list = {
				buff_id = 18621
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 18620,
				minWeaponNumber = 1,
				check_weapon = true,
				label = {
					"CL",
					"MG"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 20,
				skill_id = 18621,
				minWeaponNumber = 1,
				check_weapon = true,
				label = {
					"DD",
					"MG"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				time = 10,
				skill_id = 18621,
				minWeaponNumber = 1,
				check_weapon = true,
				label = {
					"CL",
					"MG"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				time = 3,
				minWeaponNumber = 1,
				check_weapon = true,
				skill_id = 18621,
				label = {
					"CL",
					"MG"
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 18626,
				target = "TargetSelf"
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 1,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 2,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 3,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 4,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 5,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 6,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 7,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 8,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 9,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	{
		shipInfoScene = {
			equip = {
				{
					number = 10,
					check_indexList = {
						1
					},
					label = {
						"CL",
						"MG"
					}
				}
			}
		}
	},
	init_effect = "",
	name = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 18620,
	icon = 19690,
	last_effect = ""
}
