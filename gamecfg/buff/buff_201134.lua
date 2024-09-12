return {
	init_effect = "",
	name = "2024天城航母活动 剧情战 长门meta弹幕",
	time = 2,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 201134,
	icon = 201134,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201135,
				target = "TargetShipTag",
				ship_tag_list = {
					"NagatoMETA"
				}
			}
		}
	}
}
