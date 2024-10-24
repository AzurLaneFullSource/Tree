return {
	effect_list = {
		{
			type = "BattleBuffCastSkillRandom",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				time = 0.5,
				skill_id_list = {
					201141,
					201142
				},
				range = {
					{
						0,
						0.5
					},
					{
						0.5,
						1
					}
				}
			}
		},
		{
			type = "BattleBuffCastSkillRandom",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				quota = 1,
				target = "TargetSelf",
				time = 1,
				skill_id_list = {
					201141,
					201142
				},
				range = {
					{
						0,
						0.5
					},
					{
						0.5,
						1
					}
				}
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201144,
				target = "TargetSelf",
				time = 5
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				buff_id = 201145,
				target = "TargetSelf",
				time = 0.2
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onTeammateShipDying"
			},
			arg_list = {
				buff_id = 201142
			}
		}
	},
	{},
	{},
	init_effect = "",
	name = "2024风帆二期活动 T2怪群",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201141,
	icon = 201141,
	last_effect = ""
}
