return {
	effect_list = {
		{
			id = 1,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 2,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_1)
					local var0_1 = arg0_1 * 3

					return Vector3(math.sin(var0_1) * 3, 0.75, math.cos(var0_1) * 3)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, arg0_2 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 2,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 2,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_3)
					local var0_3 = arg0_3 * 3 + 2.512

					return Vector3(math.sin(var0_3) * 3, 0.75, math.cos(var0_3) * 3)
				end,
				rotationFun = function(arg0_4)
					return Vector3(0, arg0_4 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
				end
			}
		},
		{
			id = 3,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 2,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_5)
					local var0_5 = arg0_5 * 3 - 2.512

					return Vector3(math.sin(var0_5) * 3, 0.75, math.cos(var0_5) * 3)
				end,
				rotationFun = function(arg0_6)
					return Vector3(0, arg0_6 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
				end
			}
		},
		{
			id = 4,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 4,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_7)
					local var0_7 = arg0_7 * 3

					return Vector3(math.sin(var0_7) * 5, 0.75, math.cos(var0_7) * 5)
				end,
				rotationFun = function(arg0_8)
					return Vector3(0, arg0_8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 5,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 4,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_9)
					local var0_9 = arg0_9 * 3 + 1.256

					return Vector3(math.sin(var0_9) * 5, 0.75, math.cos(var0_9) * 5)
				end,
				rotationFun = function(arg0_10)
					return Vector3(0, arg0_10 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 162, 0)
				end
			}
		},
		{
			id = 6,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 4,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_11)
					local var0_11 = arg0_11 * 3 + 2.512

					return Vector3(math.sin(var0_11) * 5, 0.75, math.cos(var0_11) * 5)
				end,
				rotationFun = function(arg0_12)
					return Vector3(0, arg0_12 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
				end
			}
		},
		{
			id = 7,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 4,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_13)
					local var0_13 = arg0_13 * 3 - 1.256

					return Vector3(math.sin(var0_13) * 5, 0.75, math.cos(var0_13) * 5)
				end,
				rotationFun = function(arg0_14)
					return Vector3(0, arg0_14 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 18, 0)
				end
			}
		},
		{
			id = 8,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 4,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_15)
					local var0_15 = arg0_15 * 3 - 2.512

					return Vector3(math.sin(var0_15) * 5, 0.75, math.cos(var0_15) * 5)
				end,
				rotationFun = function(arg0_16)
					return Vector3(0, arg0_16 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
				end
			}
		},
		{
			id = 9,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_17)
					local var0_17 = arg0_17 * 3

					return Vector3(math.sin(var0_17) * 8, 0.75, math.cos(var0_17) * 8)
				end,
				rotationFun = function(arg0_18)
					return Vector3(0, arg0_18 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 10,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_19)
					local var0_19 = arg0_19 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

					return Vector3(math.sin(var0_19) * 8, 0.75, math.cos(var0_19) * 8)
				end,
				rotationFun = function(arg0_20)
					return Vector3(0, arg0_20 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
				end
			}
		},
		{
			id = 11,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_21)
					local var0_21 = arg0_21 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

					return Vector3(math.sin(var0_21) * 8, 0.75, math.cos(var0_21) * 8)
				end,
				rotationFun = function(arg0_22)
					return Vector3(0, arg0_22 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
				end
			}
		}
	},
	{
		time = 5
	},
	{
		time = 5.5
	},
	{
		time = 6
	},
	{
		time = 6.5
	},
	{
		time = 7
	},
	{
		time = 7.5
	},
	{
		time = 8
	},
	{
		time = 8.5
	},
	{
		time = 9
	},
	{
		time = 10
	},
	time = 1,
	name = "",
	init_effect = "",
	stack = 1,
	id = 15541,
	picture = "",
	last_effect = "",
	desc = ""
}
