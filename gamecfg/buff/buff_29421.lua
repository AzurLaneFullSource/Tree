return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onSubmarineRaid",
				"onSubmarineFreeSpecial"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				skill_id = 29421
			}
		}
	},
	{},
	init_effect = "",
	name = "全弹发射",
	time = 0,
	color = "red",
	picture = "",
	desc = "进入战斗后，触发专属弹幕-I168I",
	stack = 1,
	id = 29421,
	icon = 29420,
	last_effect = ""
}
