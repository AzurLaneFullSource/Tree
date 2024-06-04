return {
	effect_list = {
		{
			id = 1,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 8,
				effect = "shield06",
				damage = 50,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 2,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 8,
				effect = "shield06",
				damage = 50,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
				end
			}
		},
		{
			id = 3,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 8,
				effect = "shield06",
				damage = 50,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
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
				count = 8,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3

					return Vector3(math.sin(var0) * 3.5, 0.75, math.cos(var0) * 3.5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
				count = 8,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST

					return Vector3(math.sin(var0) * 3.5, 0.75, math.cos(var0) * 3.5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 90, 0)
				end
			}
		}
	},
	{
		time = 5
	},
	{
		time = 6
	},
	{
		time = 7
	},
	{
		time = 8
	},
	{
		time = 9
	},
	{
		time = 10
	},
	{
		time = 11
	},
	{
		time = 12
	},
	{
		time = 13
	},
	{
		time = 15
	},
	init_effect = "",
	name = "",
	time = 5,
	picture = "",
	desc = "",
	stack = 1,
	id = 13741,
	icon = 13740,
	last_effect = ""
}
