return {
	init_effect = "",
	name = "盾牌",
	time = 10,
	picture = "",
	desc = "盾牌",
	stack = 1,
	id = 150794,
	icon = 150790,
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
				count = 6,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							0,
							0,
							0
						}
					}
				},
				centerPosFun = function(arg0_1)
					return Vector3(2.5, -1.8, 0.5)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, 192, 0)
				end
			}
		},
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				add = -1,
				mul = 0
			}
		}
	}
}
