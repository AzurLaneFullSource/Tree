﻿return {
	effect_list = {
		{
			type = "BattleBuffCleanse",
			trigger = {
				"onAttach"
			},
			pop = {
				displayID = 19866
			},
			arg_list = {
				buff_id_list = {
					19862,
					19863
				}
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onChargeWeaponFire"
			},
			arg_list = {
				skill_id = 19866,
				target = "TargetSelf"
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
	name = "锚定",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "锚定",
	stack = 1,
	id = 19862,
	icon = 19860,
	last_effect = ""
}
