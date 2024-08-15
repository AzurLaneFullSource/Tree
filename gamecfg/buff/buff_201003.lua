return {
	init_effect = "",
	name = "2024匹兹堡活动 EX BOSS本体监听",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201003,
	icon = 201003,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffHPLink",
			trigger = {
				"onTakeDamage",
				"onRemove"
			},
			arg_list = {
				number = 0.6
			}
		}
	}
}
