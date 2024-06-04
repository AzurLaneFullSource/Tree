return {
	init_effect = "",
	name = "",
	time = 20,
	picture = "",
	desc = "",
	stack = 1,
	id = 150001,
	icon = 150000,
	last_effect = "",
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
				effect = "bulunnusi_hudun_01",
				count = 7,
				bulletType = 1,
				cld_list = {
					{
						box = {
							3,
							5,
							8
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0)
					local var0 = arg0 * 3

					return Vector3(math.sin(var0) * 4, 0.75, math.cos(var0) * 4)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
				effect = "bulunnusi_hudun_01",
				count = 7,
				bulletType = 1,
				cld_list = {
					{
						box = {
							3,
							5,
							8
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

					return Vector3(math.sin(var0) * 4, 0.75, math.cos(var0) * 4)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
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
				effect = "bulunnusi_hudun_01",
				count = 7,
				bulletType = 1,
				cld_list = {
					{
						box = {
							3,
							5,
							8
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

					return Vector3(math.sin(var0) * 4, 0.75, math.cos(var0) * 4)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 30, 0)
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
				effect = "bulunnusi_hudun_01",
				count = 7,
				bulletType = 1,
				cld_list = {
					{
						box = {
							3,
							5,
							8
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + 1.04666666666667

					return Vector3(math.sin(var0) * 4, 0.75, math.cos(var0) * 4)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 150, 0)
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
				effect = "bulunnusi_hudun_01",
				count = 7,
				bulletType = 1,
				cld_list = {
					{
						box = {
							3,
							5,
							8
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + 3.14

					return Vector3(math.sin(var0) * 4, 0.75, math.cos(var0) * 4)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
				effect = "bulunnusi_hudun_01",
				count = 7,
				bulletType = 1,
				cld_list = {
					{
						box = {
							3,
							5,
							8
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + 5.23333333333333

					return Vector3(math.sin(var0) * 4, 0.75, math.cos(var0) * 4)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 150, 0)
				end
			}
		}
	}
}
