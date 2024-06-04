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
				centerPosFun = function(arg0)
					return Vector3(3, -1.8, 0.5)
				end,
				rotationFun = function(arg0)
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
	init_effect = "",
	name = "",
	time = 8,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 14478,
	icon = 14478,
	last_effect = ""
}
