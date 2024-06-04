return {
	init_effect = "",
	name = "2024阿尔萨斯活动 辉光之城-锚定",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200928,
	icon = 200928,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				buff_id = 200929,
				target = "TargetSelf",
				killer = "self"
			}
		}
	}
}
