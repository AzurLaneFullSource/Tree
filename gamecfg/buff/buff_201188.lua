return {
	init_effect = "",
	name = "2024鲁梅活动 轻巡护盾",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201188,
	icon = 201188,
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
					return Vector3(2.2, 0.75, 1.5)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, 180, 0)
				end
			}
		}
	}
}
