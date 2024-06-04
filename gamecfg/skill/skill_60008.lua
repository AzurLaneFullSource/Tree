return {
	uiEffect = "AimEffectUI",
	name = "海伦娜-舰队之眼",
	cd = 0,
	painting = 1,
	id = 60008,
	picture = "0",
	aniEffect = "",
	desc = "舰队之眼",
	effect_list = {
		{
			target_choise = "TargetHarmRandom",
			type = "BattleSkillAddBuff",
			arg_list = {
				buff_id = 60015
			},
			targetAniEffect = {
				effect = "aim",
				posFun = function(arg0, arg1, arg2)
					arg2 = math.min(1, arg2 / 40)

					local var0 = arg0.x - arg1.x
					local var1 = var0 * (1 - arg2)
					local var2 = 1 * arg2
					local var3 = arg0.z - arg1.z + var0 * (1 - arg2) * arg2

					if arg2 >= 1 then
						var3 = 0
					elseif arg2 >= 0.8 then
						var3 = var3 * (-4 * arg2 + 4)
					elseif arg2 >= 0.5 then
						var3 = var3 * arg2
					else
						var3 = var3 * (1 - arg2)
					end

					return Vector3(var1, var2, var3)
				end
			}
		}
	}
}
