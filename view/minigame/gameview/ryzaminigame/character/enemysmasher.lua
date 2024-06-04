local var0 = class("EnemySmasher", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0.ConfigSkillCD = 10
var0.ConfigSkillCount = 3
var0.ImpackRange = 20

function var0.InitUI(arg0, arg1)
	var0.super.InitUI(arg0, arg1)

	arg0.hp = arg1.hp or 2
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 2

	eachChild(arg0.rtScale:Find("front"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)
	arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0.triggerCount = defaultValue(arg0.triggerCount, 0) + 1

		switch(arg0.triggerCount, {
			function()
				setActive(arg0.rtScale:Find("front/EF_Bullet_UP"), true)
			end,
			function()
				setActive(arg0.rtScale:Find("front/EF_Bullet_UP_High"), true)
			end
		})

		arg0.triggerCount = arg0.triggerCount % 2
	end)
	arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		switch(arg0.status, {
			Attack_S = function()
				arg0.impackCD = 0
				arg0.impackCount = arg0.ConfigSkillCount
			end
		})

		arg0.lock = false

		if arg0.hp <= 0 then
			arg0:Destroy()
		end
	end)

	arg0.skillCD = 0
	arg0.impackCount = 0
end

function var0.TimeTrigger(arg0, arg1)
	var0.super.TimeTrigger(arg0, arg1)

	arg0.skillCD = arg0.skillCD - arg1

	if not arg0.lock and arg0.skillCD <= 0 and arg0.responder:SearchRyza(arg0, arg0.search) and (arg0.responder.reactorRyza.pos - arg0.pos):SqrMagnitude() >= 4 then
		arg0:PlayAnim("Attack_S")

		arg0.skillCD = arg0.ConfigSkillCD
		arg0.skillCenterPos = arg0.responder.reactorRyza.realPos
	end

	local function var0()
		if arg0.responder.reactorRyza.hide then
			return false
		else
			local var0 = arg0.responder.reactorRyza.realPos - arg0.skillCenterPos

			return var0.x * var0.x < arg0.ImpackRange * arg0.ImpackRange / 4 and var0.y * var0.y < arg0.ImpackRange * arg0.ImpackRange / 4
		end
	end

	if arg0.impackCount > 0 then
		if var0() then
			arg0.impackCD = arg0.impackCD - arg1

			if arg0.impackCD <= 0 then
				arg0.impackCount = arg0.impackCount - 1
				arg0.impackCD = 0.5

				local var1 = arg0.responder.reactorRyza.pos
				local var2 = arg0.responder.reactorRyza.realPos

				arg0.responder:Create({
					name = "Impack",
					pos = {
						var1.x,
						var1.y
					},
					realPos = {
						var2.x,
						var2.y
					}
				})
			end
		else
			arg0.impackCount = 0
			arg0.impackCD = nil
		end
	end
end

return var0
