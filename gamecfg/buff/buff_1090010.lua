return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAllInStrike"
			},
			arg_list = {
				skill_id = 1090010,
				target = "TargetSelf"
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 1090012,
				target = "TargetSelf"
			}
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高5.0%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"5.0%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高6.1%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"6.1%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高7.2%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"7.2%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高8.3%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"8.3%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高9.4%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"9.4%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高10.5%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"10.5%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高11.6%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"11.6%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高12.7%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"12.7%(+1.1%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高13.8%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"13.8%(+1.2%)"
		}
	},
	{
		desc = "每次执行空袭后为先锋部队提高15.0%伤害，持续8秒，同技能效果不叠加",
		addition = {
			"15.0%"
		}
	},
	desc_get = "每次执行空袭后为先锋部队提高5.0%(满级15.0%)伤害，持续8秒，同技能效果不叠加",
	name = "舰队空母",
	init_effect = "",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "每次执行空袭后为先锋部队提高$1伤害，持续8秒，同技能效果不叠加",
	stack = 1,
	id = 1090010,
	icon = 3020,
	last_effect = ""
}
