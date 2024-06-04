local var0 = class("TowerClimbingPlayer")
local var1 = 0.6

function var0.Ctor(arg0, arg1, arg2)
	arg0.map = arg1
	arg0.player = arg2
	arg0.action = ""
end

function var0.Init(arg0, arg1)
	local var0 = arg0.player:GetShipName()

	TowerClimbingResMgr.GetPlayer(var0, function(arg0)
		arg0.shipName = var0

		arg0:OnLoaded(arg0)
		arg1()
	end)
end

function var0.OnLoaded(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.rigbody = arg0._go:GetComponent(typeof(UnityEngine.Rigidbody2D))
	arg0.physics2DItem = arg0._go:GetComponent("Physics2DItem")

	arg0.physics2DItem.CollisionEnter:AddListener(function(arg0)
		local var0 = arg0.map:GetHitBlock(arg0.collider.gameObject)

		if var0 and arg0.collider.name == TowerClimbingGameSettings.BLOCK_NAME and arg0.contacts.Length > 0 then
			arg0.map:SendEvent("EnterBlock", arg0.contacts[0], var0.block.level)
		end

		if arg0.collider.name == TowerClimbingGameSettings.FIRE_NAME then
			arg0.map:SendEvent("EnterAttacker")
		end

		if arg0.collider.name == TowerClimbingGameSettings.STAB_NAME and arg0.otherCollider.name == "player" then
			Physics2D.IgnoreCollision(arg0.collider, arg0.otherCollider)
		end

		if arg0.collider.name == TowerClimbingGameSettings.STAB_NAME and arg0.otherCollider.name == TowerClimbingGameSettings.STAB_HURT_AREA then
			arg0.map:SendEvent("EnterAttacker")
		end

		if arg0.collider.name == TowerClimbingGameSettings.GROUND_NAME then
			arg0.map:SendEvent("EnterGround")
		end
	end)
	arg0.physics2DItem.CollisionStay:AddListener(function(arg0)
		local var0 = {}

		for iter0 = 1, arg0.contacts.Length do
			table.insert(var0, arg0.contacts[iter0 - 1])
		end

		if arg0.collider.name == TowerClimbingGameSettings.BLOCK_NAME then
			arg0.map:SendEvent("StayBlock", var0, arg0.rigbody.velocity)
		end
	end)
	arg0.physics2DItem.CollisionExit:AddListener(function(arg0)
		local var0 = arg0.map:GetHitBlock(arg0.collider.gameObject)

		if arg0.collider.name == TowerClimbingGameSettings.BLOCK_NAME then
			arg0.map:SendEvent("ExitBlock", var0.block.level)
		end
	end)

	arg0.spineAnim = arg0._go:GetComponent("SpineAnimUI")

	SetParent(arg1, arg0.map._tf:Find("game/block_play_con"))

	arg1.name = "player"
	arg0._tf.localScale = Vector3(var1, var1, 1)

	setActive(arg1, true)
end

function var0.AdjustVel(arg0, arg1)
	arg0.rigbody.velocity = arg0.rigbody.velocity + arg1
end

function var0.Jump(arg0, arg1)
	local var0 = arg0.rigbody.velocity

	arg0.rigbody.velocity = Vector2(arg0.rigbody.velocity.x, arg1)
end

function var0.MoveLeft(arg0, arg1)
	arg0:SetAction("walk")

	arg0._tf.localScale = Vector3(-var1, var1, 1)
	arg0.rigbody.velocity = Vector2(-arg1, arg0.rigbody.velocity.y)
end

function var0.MoveRight(arg0, arg1)
	arg0:SetAction("walk")

	arg0._tf.localScale = Vector3(var1, var1, 1)
	arg0.rigbody.velocity = Vector2(arg1, arg0.rigbody.velocity.y)
end

function var0.BeInjured(arg0, arg1)
	arg0.rigbody.velocity = arg0.rigbody.velocity + arg1
end

function var0.Idle(arg0)
	arg0:SetAction("stand2")
end

function var0.Dead(arg0)
	setActive(arg0._tf, false)
end

function var0.Invincible(arg0, arg1)
	local var0 = arg0._tf:GetComponent("SkeletonGraphic")

	if arg1 then
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end

		local var1 = 0

		arg0.timer = Timer.New(function()
			var1 = var1 + 1

			if var1 % 2 == 0 then
				var0.color = Color.New(1, 1, 1, 1)
			else
				var0.color = Color.New(1, 0, 0, 1)
			end
		end, 0.3, -1)

		arg0.timer:Start()
	else
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end

		var0.color = Color.New(1, 1, 1, 1)
	end
end

function var0.ChangePosition(arg0, arg1)
	local var0 = arg0.map.blockContainer:InverseTransformVector(arg0.map.groundContainer:TransformVector(arg1))

	arg0._tf.anchoredPosition = var0
end

function var0.BeFatalInjured(arg0, arg1)
	arg0.spineAnim:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0.spineAnim:SetActionCallBack(nil)
			arg1()
		end
	end)

	arg0.action = "dead"

	arg0.spineAnim:SetAction(arg0.action, 0)
end

function var0.SetAction(arg0, arg1)
	if arg0.action == arg1 then
		return
	end

	arg0.action = arg1

	arg0.spineAnim:SetAction(arg1, 0)
end

function var0.Dispose(arg0)
	arg0.spineAnim:SetActionCallBack(nil)

	if LeanTween.isTweening(arg0._go) then
		LeanTween.cancel(arg0._go)
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg0.shipName then
		TowerClimbingResMgr.ReturnPlayer(arg0.shipName, arg0._go)
	end
end

return var0
