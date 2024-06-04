return {
	init_effect = "",
	name = "挑战关卡第8关双盾无法击破",
	time = 0,
	picture = "",
	desc = "挑战关卡第8关双盾无法击破",
	stack = 1,
	id = 8516,
	icon = 8516,
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
				effect = "shield02",
				count = 999999,
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

					return Vector3(math.sin(var0) * 2.5, 0.75, math.cos(var0) * 3.5)
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
				effect = "shield02",
				count = 999999,
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

					return Vector3(math.sin(var0) * 2.5, 0.75, math.cos(var0) * 3.5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 90, 0)
				end
			}
		}
	}
}
