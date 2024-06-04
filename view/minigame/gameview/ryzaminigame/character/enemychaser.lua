local var0 = class("EnemyChaser", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0.WeaponName = "Bullet"
var0.ConfigSkillCD = 10
var0.StatusOffset = {
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

function var0.InitUI(arg0, arg1)
	var0.super.InitUI(arg0, arg1)

	arg0.hp = arg1.hp or 1
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 2
	arg0.skillCD = 0

	arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		local var0 = arg0.StatusOffset[arg0.status]

		arg0.responder:Create({
			name = arg0.WeaponName,
			pos = {
				arg0.pos.x + var0[1],
				arg0.pos.y + var0[2]
			},
			realPos = {
				arg0.realPos.x + var0[1],
				arg0.realPos.y + var0[2]
			},
			mark = string.split(arg0.status, "_")[2]
		})
	end)
end

function var0.TimeTrigger(arg0, arg1)
	var0.super.TimeTrigger(arg0, arg1)

	arg0.skillCD = arg0.skillCD - arg1

	if not arg0.lock and arg0.skillCD <= 0 and arg0.responder:SearchRyza(arg0, arg0.search) then
		local var0 = arg0.responder.reactorRyza.pos

		if (var0.x == arg0.pos.x or var0.y == arg0.pos.y) and (var0 - arg0.pos):SqrMagnitude() >= 9 then
			local var1 = var0 - arg0.pos

			if var1.x > 0 then
				arg0:PlayAnim("Attack_E")
			elseif var1.x < 0 then
				arg0:PlayAnim("Attack_W")
			elseif var1.y > 0 then
				arg0:PlayAnim("Attack_S")
			elseif var1.y < 0 then
				arg0:PlayAnim("Attack_N")
			end

			arg0.skillCD = arg0.ConfigSkillCD
		end
	end
end

return var0
