return {
	init_effect = "",
	name = "2024阿尔萨斯活动 重巡护盾",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200919,
	icon = 200919,
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
				centerPosFun = function(arg0_1)
					return Vector3(3, 0.75, 4.5)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, 140, 0)
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
				centerPosFun = function(arg0_3)
					return Vector3(3, 0.75, -0.5)
				end,
				rotationFun = function(arg0_4)
					return Vector3(0, -140, 0)
				end
			}
		}
	}
}
