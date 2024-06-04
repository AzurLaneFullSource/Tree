return {
	effect_list = {
		{
			type = "BattleBuffRecordShield",
			trigger = {
				"onTakeDamage",
				"onUpdate"
			},
			arg_list = {
				convertRate = 0.2,
				effect = "Shield_mojiaduoer",
				exhaust_remove = 1,
				srcTag = {
					"MJDESLOW"
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 17951,
				target = "TargetSelf",
				effectAttachData = {
					"BattleBuffRecordShield<=0"
				}
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
	init_effect = "",
	name = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 17950,
	icon = 17950,
	last_effect = ""
}
