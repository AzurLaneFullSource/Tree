return {
	effect_list = {
		{
			id = 1,
			type = "BattleBuffShieldWall",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 3,
				bulletType = 3,
				cld_list = {
					{
						box = {
							3,
							3,
							7
						},
						offset = {
							0,
							0,
							-1.3
						}
					}
				},
				centerPosFun = function(arg0_1)
					return Vector3(4, -1.8, 0.5)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, 192, 0)
				end
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	desc_get = "鱼雷防御盾",
	name = "鱼雷防御盾",
	init_effect = "",
	time = 20,
	color = "red",
	picture = "",
	desc = "鱼雷防御盾",
	stack = 1,
	id = 15502,
	icon = 15500,
	last_effect = ""
}
