return {
	desc_get = "主炮炮弹修改为穿甲弹，主炮进行2次攻击，切换为高爆弹",
	name = "专业装填手",
	init_effect = "",
	time = 0,
	color = "red",
	picture = "",
	desc = "主炮炮弹修改为穿甲弹，主炮进行2次攻击，切换为高爆弹",
	stack = 1,
	id = 1019091,
	icon = 19090,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffShiftBullet",
			trigger = {
				"onAttach",
				"onRemove"
			},
			arg_list = {
				bullet_id = 160993,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffCount",
			trigger = {
				"onFire"
			},
			arg_list = {
				countTarget = 2,
				countType = 1019093,
				index = {
					1
				}
			}
		},
		{
			type = "BattleBuffCancelBuff",
			trigger = {
				"onBattleBuffCount"
			},
			arg_list = {
				delay = 1.5,
				count = 1,
				countType = 1019093
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 1019090,
				target = "TargetSelf"
			}
		}
	}
}
