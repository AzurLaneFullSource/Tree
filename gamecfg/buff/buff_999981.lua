return {
	init_effect = "",
	name = "肉鸽引导1 平射护盾",
	time = 999,
	picture = "",
	desc = "",
	stack = 1,
	id = 999981,
	icon = 999980,
	last_effect = "",
	effect_list = {
		{
			id = 1,
			type = "BattleBuffShieldWall",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 9999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							15
						},
						offset = {
							2,
							0,
							0
						}
					}
				},
				centerPosFun = function(arg0_1)
					return Vector3(2, -1.8, 5.5)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, 120, 0)
				end
			}
		},
		{
			id = 2,
			type = "BattleBuffShieldWall",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 9999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							15
						},
						offset = {
							2,
							0,
							0
						}
					}
				},
				centerPosFun = function(arg0_3)
					return Vector3(3.5, -1.8, 0.5)
				end,
				rotationFun = function(arg0_4)
					return Vector3(0, 192, 0)
				end
			}
		},
		{
			id = 3,
			type = "BattleBuffShieldWall",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 9999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							15
						},
						offset = {
							2,
							0,
							0
						}
					}
				},
				centerPosFun = function(arg0_5)
					return Vector3(1.5, -1.8, -4.5)
				end,
				rotationFun = function(arg0_6)
					return Vector3(0, 238, 0)
				end
			}
		}
	}
}
