return {
	desc_get = "",
	name = "",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "抚顺改-四鞍山彩蛋效果",
	stack = 1,
	id = 150865,
	icon = 11050,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				minTargetNumber = 4,
				target = "TargetSelf",
				skill_id = 150865,
				check_target = {
					"TargetAllHelp",
					"TargetShipTag"
				},
				ship_tag_list = {
					"Anshan-Class"
				}
			}
		}
	}
}
