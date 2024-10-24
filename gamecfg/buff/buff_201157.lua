return {
	init_effect = "",
	name = "2024风帆二期活动 幻想之力",
	time = 7,
	picture = "",
	desc = "",
	stack = 1,
	id = 201157,
	icon = 201157,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddBuff",
			trigger = {
				"onRemove"
			},
			arg_list = {
				buff_id = 201158,
				target = "TargetPlayerFlagShip"
			}
		}
	}
}
