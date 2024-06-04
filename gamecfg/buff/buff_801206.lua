return {
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				buff_id_list = {
					801203,
					801204,
					801209
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				skill_id = 801203,
				minWeaponNumber = 1,
				check_weapon = true,
				index = {
					3
				},
				type = {
					2
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onAttach",
				"onStack"
			},
			arg_list = {
				skill_id = 801204,
				maxWeaponNumber = 0,
				check_weapon = true,
				index = {
					3
				},
				type = {
					2
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
	time = 6,
	color = "red",
	picture = "",
	desc = "",
	stack = 3,
	id = 801206,
	icon = 801200,
	last_effect = ""
}
