return {
	effect_list = {
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onStartGame"
			},
			arg_list = {
				skill_id = 1012320
			}
		},
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onBulletHit"
			},
			arg_list = {
				buff_id = 1012321,
				weaponType = 2,
				rant = 10000,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onFoeDying"
			},
			arg_list = {
				quota = 4,
				target = "TargetSelf",
				killer = "self",
				skill_id = 1012323
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
	desc_get = "",
	name = "",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 1012320,
	icon = 12320,
	last_effect = ""
}
