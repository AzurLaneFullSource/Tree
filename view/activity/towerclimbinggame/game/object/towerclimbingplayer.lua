local var0_0 = class("TowerClimbingPlayer")
local var1_0 = 0.6

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.map = arg1_1
	arg0_1.player = arg2_1
	arg0_1.action = ""
end

function var0_0.Init(arg0_2, arg1_2)
	local var0_2 = arg0_2.player:GetShipName()

	TowerClimbingResMgr.GetPlayer(var0_2, function(arg0_3)
		arg0_2.shipName = var0_2

		arg0_2:OnLoaded(arg0_3)
		arg1_2()
	end)
end

function var0_0.OnLoaded(arg0_4, arg1_4)
	arg0_4._go = arg1_4
	arg0_4._tf = tf(arg1_4)
	arg0_4.rigbody = arg0_4._go:GetComponent(typeof(UnityEngine.Rigidbody2D))
	arg0_4.physics2DItem = arg0_4._go:GetComponent("Physics2DItem")

	arg0_4.physics2DItem.CollisionEnter:AddListener(function(arg0_5)
		local var0_5 = arg0_4.map:GetHitBlock(arg0_5.collider.gameObject)

		if var0_5 and arg0_5.collider.name == TowerClimbingGameSettings.BLOCK_NAME and arg0_5.contacts.Length > 0 then
			arg0_4.map:SendEvent("EnterBlock", arg0_5.contacts[0], var0_5.block.level)
		end

		if arg0_5.collider.name == TowerClimbingGameSettings.FIRE_NAME then
			arg0_4.map:SendEvent("EnterAttacker")
		end

		if arg0_5.collider.name == TowerClimbingGameSettings.STAB_NAME and arg0_5.otherCollider.name == "player" then
			Physics2D.IgnoreCollision(arg0_5.collider, arg0_5.otherCollider)
		end

		if arg0_5.collider.name == TowerClimbingGameSettings.STAB_NAME and arg0_5.otherCollider.name == TowerClimbingGameSettings.STAB_HURT_AREA then
			arg0_4.map:SendEvent("EnterAttacker")
		end

		if arg0_5.collider.name == TowerClimbingGameSettings.GROUND_NAME then
			arg0_4.map:SendEvent("EnterGround")
		end
	end)
	arg0_4.physics2DItem.CollisionStay:AddListener(function(arg0_6)
		local var0_6 = {}

		for iter0_6 = 1, arg0_6.contacts.Length do
			table.insert(var0_6, arg0_6.contacts[iter0_6 - 1])
		end

		if arg0_6.collider.name == TowerClimbingGameSettings.BLOCK_NAME then
			arg0_4.map:SendEvent("StayBlock", var0_6, arg0_4.rigbody.velocity)
		end
	end)
	arg0_4.physics2DItem.CollisionExit:AddListener(function(arg0_7)
		local var0_7 = arg0_4.map:GetHitBlock(arg0_7.collider.gameObject)

		if arg0_7.collider.name == TowerClimbingGameSettings.BLOCK_NAME then
			arg0_4.map:SendEvent("ExitBlock", var0_7.block.level)
		end
	end)

	arg0_4.spineAnim = arg0_4._go:GetComponent("SpineAnimUI")

	SetParent(arg1_4, arg0_4.map._tf:Find("game/block_play_con"))

	arg1_4.name = "player"
	arg0_4._tf.localScale = Vector3(var1_0, var1_0, 1)

	setActive(arg1_4, true)
end

function var0_0.AdjustVel(arg0_8, arg1_8)
	arg0_8.rigbody.velocity = arg0_8.rigbody.velocity + arg1_8
end

function var0_0.Jump(arg0_9, arg1_9)
	local var0_9 = arg0_9.rigbody.velocity

	arg0_9.rigbody.velocity = Vector2(arg0_9.rigbody.velocity.x, arg1_9)
end

function var0_0.MoveLeft(arg0_10, arg1_10)
	arg0_10:SetAction("walk")

	arg0_10._tf.localScale = Vector3(-var1_0, var1_0, 1)
	arg0_10.rigbody.velocity = Vector2(-arg1_10, arg0_10.rigbody.velocity.y)
end

function var0_0.MoveRight(arg0_11, arg1_11)
	arg0_11:SetAction("walk")

	arg0_11._tf.localScale = Vector3(var1_0, var1_0, 1)
	arg0_11.rigbody.velocity = Vector2(arg1_11, arg0_11.rigbody.velocity.y)
end

function var0_0.BeInjured(arg0_12, arg1_12)
	arg0_12.rigbody.velocity = arg0_12.rigbody.velocity + arg1_12
end

function var0_0.Idle(arg0_13)
	arg0_13:SetAction("stand2")
end

function var0_0.Dead(arg0_14)
	setActive(arg0_14._tf, false)
end

function var0_0.Invincible(arg0_15, arg1_15)
	local var0_15 = arg0_15._tf:GetComponent("SkeletonGraphic")

	if arg1_15 then
		if arg0_15.timer then
			arg0_15.timer:Stop()

			arg0_15.timer = nil
		end

		local var1_15 = 0

		arg0_15.timer = Timer.New(function()
			var1_15 = var1_15 + 1

			if var1_15 % 2 == 0 then
				var0_15.color = Color.New(1, 1, 1, 1)
			else
				var0_15.color = Color.New(1, 0, 0, 1)
			end
		end, 0.3, -1)

		arg0_15.timer:Start()
	else
		if arg0_15.timer then
			arg0_15.timer:Stop()

			arg0_15.timer = nil
		end

		var0_15.color = Color.New(1, 1, 1, 1)
	end
end

function var0_0.ChangePosition(arg0_17, arg1_17)
	local var0_17 = arg0_17.map.blockContainer:InverseTransformVector(arg0_17.map.groundContainer:TransformVector(arg1_17))

	arg0_17._tf.anchoredPosition = var0_17
end

function var0_0.BeFatalInjured(arg0_18, arg1_18)
	arg0_18.spineAnim:SetActionCallBack(function(arg0_19)
		if arg0_19 == "finish" then
			arg0_18.spineAnim:SetActionCallBack(nil)
			arg1_18()
		end
	end)

	arg0_18.action = "dead"

	arg0_18.spineAnim:SetAction(arg0_18.action, 0)
end

function var0_0.SetAction(arg0_20, arg1_20)
	if arg0_20.action == arg1_20 then
		return
	end

	arg0_20.action = arg1_20

	arg0_20.spineAnim:SetAction(arg1_20, 0)
end

function var0_0.Dispose(arg0_21)
	arg0_21.spineAnim:SetActionCallBack(nil)

	if LeanTween.isTweening(arg0_21._go) then
		LeanTween.cancel(arg0_21._go)
	end

	if arg0_21.timer then
		arg0_21.timer:Stop()

		arg0_21.timer = nil
	end

	if arg0_21.shipName then
		TowerClimbingResMgr.ReturnPlayer(arg0_21.shipName, arg0_21._go)
	end
end

return var0_0
