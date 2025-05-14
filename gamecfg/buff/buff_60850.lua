return {
	init_effect = "",
	name = "鲸鱼更换BGM",
	time = 0,
	color = "red",
	picture = "",
	desc = "",
	stack = 1,
	id = 60850,
	icon = 60850,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffDiva",
			trigger = {
				"onInitGame"
			},
			arg_list = {
				bgm_list = {
					"theme-thedeathXIII"
				}
			}
		}
	}
}
