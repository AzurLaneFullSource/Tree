return {
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			pop = {},
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 1019021
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				buff_id = 1019022
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onHPRatioUpdate"
			},
			arg_list = {
				hpUpperBound = 0.2,
				target = "TargetSelf",
				skill_id = 1019021,
				quota = 1
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
	desc_get = "耐久低于20%时，恢复总耐久度15.0%(满级25.0%)的耐久，15秒内炮击提高30%，每场战斗只能发动1次",
	name = "海之女神 +",
	init_effect = "",
	time = 0,
	color = "blue",
	picture = "",
	desc = "耐久低于20%时，恢复总耐久度$1的耐久，15秒内炮击提高30%，每场战斗只能发动1次",
	stack = 1,
	id = 1019020,
	icon = 19020,
	last_effect = ""
}
