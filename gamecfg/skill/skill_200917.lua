return {
	effect_list = {
		{
			target_choise = "TargetSelf",
			type = "BattleSkillChangeDiveState",
			arg_list = {
				state = "STATE_RAID",
				expose = true
			}
		}
	},
	{
		effect_list = {
			{
				target_choise = "TargetSelf",
				type = "BattleSkillChangeDiveState",
				arg_list = {
					state = "STATE_RAID",
					expose = true
				}
			},
			{
				target_choise = "TargetSelf",
				type = "BattleSkillAddBuff",
				arg_list = {
					buff_id = 200946
				}
			}
		}
	},
	{
		effect_list = {
			{
				target_choise = "TargetSelf",
				type = "BattleSkillChangeDiveState",
				arg_list = {
					state = "STATE_RAID",
					expose = true
				}
			},
			{
				target_choise = "TargetSelf",
				type = "BattleSkillAddBuff",
				arg_list = {
					buff_id = 200946
				}
			}
		}
	},
	uiEffect = "",
	name = "2024阿尔萨斯活动 潜艇功能",
	cd = 0,
	painting = 0,
	id = 200917,
	picture = "0",
	aniEffect = "",
	desc = ""
}
