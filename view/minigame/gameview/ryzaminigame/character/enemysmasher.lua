local var0_0 = class("EnemySmasher", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0_0.ConfigSkillCD = 10
var0_0.ConfigSkillCount = 3
var0_0.ImpackRange = 20

function var0_0.InitUI(arg0_1, arg1_1)
	var0_0.super.InitUI(arg0_1, arg1_1)

	arg0_1.hp = arg1_1.hp or 2
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 2

	eachChild(arg0_1.rtScale:Find("front"), function(arg0_2)
		arg0_2:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_2, false)
		end)
	end)
	arg0_1.mainTarget:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0_1.triggerCount = defaultValue(arg0_1.triggerCount, 0) + 1

		switch(arg0_1.triggerCount, {
			function()
				setActive(arg0_1.rtScale:Find("front/EF_Bullet_UP"), true)
			end,
			function()
				setActive(arg0_1.rtScale:Find("front/EF_Bullet_UP_High"), true)
			end
		})

		arg0_1.triggerCount = arg0_1.triggerCount % 2
	end)
	arg0_1.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		switch(arg0_1.status, {
			Attack_S = function()
				arg0_1.impackCD = 0
				arg0_1.impackCount = arg0_1.ConfigSkillCount
			end
		})

		arg0_1.lock = false

		if arg0_1.hp <= 0 then
			arg0_1:Destroy()
		end
	end)

	arg0_1.skillCD = 0
	arg0_1.impackCount = 0
end

function var0_0.TimeTrigger(arg0_9, arg1_9)
	var0_0.super.TimeTrigger(arg0_9, arg1_9)

	arg0_9.skillCD = arg0_9.skillCD - arg1_9

	if not arg0_9.lock and arg0_9.skillCD <= 0 and arg0_9.responder:SearchRyza(arg0_9, arg0_9.search) and (arg0_9.responder.reactorRyza.pos - arg0_9.pos):SqrMagnitude() >= 4 then
		arg0_9:PlayAnim("Attack_S")

		arg0_9.skillCD = arg0_9.ConfigSkillCD
		arg0_9.skillCenterPos = arg0_9.responder.reactorRyza.realPos
	end

	local function var0_9()
		if arg0_9.responder.reactorRyza.hide then
			return false
		else
			local var0_10 = arg0_9.responder.reactorRyza.realPos - arg0_9.skillCenterPos

			return var0_10.x * var0_10.x < arg0_9.ImpackRange * arg0_9.ImpackRange / 4 and var0_10.y * var0_10.y < arg0_9.ImpackRange * arg0_9.ImpackRange / 4
		end
	end

	if arg0_9.impackCount > 0 then
		if var0_9() then
			arg0_9.impackCD = arg0_9.impackCD - arg1_9

			if arg0_9.impackCD <= 0 then
				arg0_9.impackCount = arg0_9.impackCount - 1
				arg0_9.impackCD = 0.5

				local var1_9 = arg0_9.responder.reactorRyza.pos
				local var2_9 = arg0_9.responder.reactorRyza.realPos

				arg0_9.responder:Create({
					name = "Impack",
					pos = {
						var1_9.x,
						var1_9.y
					},
					realPos = {
						var2_9.x,
						var2_9.y
					}
				})
			end
		else
			arg0_9.impackCount = 0
			arg0_9.impackCD = nil
		end
	end
end

return var0_0
