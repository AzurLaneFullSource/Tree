return {
	effect_list = {
		{
			type = "BattleBuffSetBattleUnitType",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				value = -100
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach"
			},
			arg_list = {
				skill_id = 200917,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 200918,
				target = "TargetSelf"
			}
		}
	},
	{},
	{},
	init_effect = "",
	name = "2024阿尔萨斯活动 潜艇功能",
	time = 1,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200917,
	icon = 200917,
	last_effect = ""
}
