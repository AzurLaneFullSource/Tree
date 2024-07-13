local var0_0 = class("EnemyChaser", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0_0.WeaponName = "Bullet"
var0_0.ConfigSkillCD = 10
var0_0.StatusOffset = {
	Attack_E = {
		1,
		0
	},
	Attack_N = {
		0,
		-1
	},
	Attack_W = {
		-1,
		0
	},
	Attack_S = {
		0,
		1
	}
}

function var0_0.InitUI(arg0_1, arg1_1)
	var0_0.super.InitUI(arg0_1, arg1_1)

	arg0_1.hp = arg1_1.hp or 1
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 2
	arg0_1.skillCD = 0

	arg0_1.mainTarget:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		local var0_2 = arg0_1.StatusOffset[arg0_1.status]

		arg0_1.responder:Create({
			name = arg0_1.WeaponName,
			pos = {
				arg0_1.pos.x + var0_2[1],
				arg0_1.pos.y + var0_2[2]
			},
			realPos = {
				arg0_1.realPos.x + var0_2[1],
				arg0_1.realPos.y + var0_2[2]
			},
			mark = string.split(arg0_1.status, "_")[2]
		})
	end)
end

function var0_0.TimeTrigger(arg0_3, arg1_3)
	var0_0.super.TimeTrigger(arg0_3, arg1_3)

	arg0_3.skillCD = arg0_3.skillCD - arg1_3

	if not arg0_3.lock and arg0_3.skillCD <= 0 and arg0_3.responder:SearchRyza(arg0_3, arg0_3.search) then
		local var0_3 = arg0_3.responder.reactorRyza.pos

		if (var0_3.x == arg0_3.pos.x or var0_3.y == arg0_3.pos.y) and (var0_3 - arg0_3.pos):SqrMagnitude() >= 9 then
			local var1_3 = var0_3 - arg0_3.pos

			if var1_3.x > 0 then
				arg0_3:PlayAnim("Attack_E")
			elseif var1_3.x < 0 then
				arg0_3:PlayAnim("Attack_W")
			elseif var1_3.y > 0 then
				arg0_3:PlayAnim("Attack_S")
			elseif var1_3.y < 0 then
				arg0_3:PlayAnim("Attack_N")
			end

			arg0_3.skillCD = arg0_3.ConfigSkillCD
		end
	end
end

return var0_0
