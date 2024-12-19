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
					201201,
					201202
				},
				range = {
					{
						0,
						0.6
					},
					{
						0.6,
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
					201201,
					201202
				},
				range = {
					{
						0,
						0.6
					},
					{
						0.6,
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
				buff_id = 201203,
				target = "TargetSelf",
				time = 2
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onTeammateShipDying"
			},
			arg_list = {
				buff_id = 201202
			}
		}
	},
	{},
	{},
	{},
	{},
	init_effect = "",
	name = "2024鲁梅活动 怪群",
	time = 0,
	picture = "",
	desc = "",
	stack = 1,
	id = 201201,
	icon = 201201,
	last_effect = ""
}
