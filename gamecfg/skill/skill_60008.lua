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
				posFun = function(arg0_1, arg1_1, arg2_1)
					arg2_1 = math.min(1, arg2_1 / 40)

					local var0_1 = arg0_1.x - arg1_1.x
					local var1_1 = var0_1 * (1 - arg2_1)
					local var2_1 = 1 * arg2_1
					local var3_1 = arg0_1.z - arg1_1.z + var0_1 * (1 - arg2_1) * arg2_1

					if arg2_1 >= 1 then
						var3_1 = 0
					elseif arg2_1 >= 0.8 then
						var3_1 = var3_1 * (-4 * arg2_1 + 4)
					elseif arg2_1 >= 0.5 then
						var3_1 = var3_1 * arg2_1
					else
						var3_1 = var3_1 * (1 - arg2_1)
					end

					return Vector3(var1_1, var2_1, var3_1)
				end
			}
		}
	}
}
