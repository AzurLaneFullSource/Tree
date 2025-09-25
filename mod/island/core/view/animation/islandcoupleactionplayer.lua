local var0_0 = class("IslandCoupleActionPlayer", import("..IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	arg0_1:Init()
end

function var0_0.Play(arg0_2, arg1_2, arg2_2, arg3_2)
	if not arg2_2 or not arg1_2 then
		return
	end

	arg0_2:EnableOrDisablePlayerOp(arg2_2, arg1_2, false)
	arg0_2:EnableOrDisableUnitSyn(arg2_2, arg1_2, false)
	arg0_2:SendStartEvent(arg2_2, arg1_2)

	local var0_2 = false
	local var1_2 = Vector3(0, 0, 0)

	seriesAsync({
		function(arg0_3)
			var0_2, var1_2 = arg0_2:NavigateToPoint(arg2_2, arg1_2, arg3_2, arg0_3)
		end,
		function(arg0_4)
			onNextTick(arg0_4)
		end,
		function(arg0_5)
			arg0_2:EnableOrDisablePlayerSyn(arg1_2, false)

			if not var0_2 then
				arg0_5()

				return
			end

			arg0_2:Face2Face(var1_2, arg2_2, arg1_2, arg0_5)
		end,
		function(arg0_6)
			if not var0_2 then
				arg0_6()

				return
			end

			arg0_2:PlayCoupleActions(arg2_2, arg1_2, arg3_2, arg0_6)
		end,
		function(arg0_7)
			IslandTaskHelper.OnActionEnd(arg3_2.id)
			arg0_2:EnableOrDisablePlayerSyn(arg1_2, true)
			arg0_2:EnableOrDisableUnitSyn(arg2_2, arg1_2, true)
			arg0_2:EnableOrDisablePlayerOp(arg2_2, arg1_2, true)
			arg0_7()
		end
	}, function()
		arg0_2:SendEndEvent(arg2_2, arg1_2)
	end)
end

function var0_0.SendStartEvent(arg0_9, arg1_9, arg2_9)
	if arg0_9:GetView():IsPlayer(arg1_9.id) or arg0_9:GetView():IsPlayer(arg2_9.id) then
		arg0_9:NotifiyCore(ISLAND_EVT.START_COUPLE_ACTION)
	end
end

function var0_0.SendEndEvent(arg0_10, arg1_10, arg2_10)
	if arg0_10:GetView():IsPlayer(arg1_10.id) or arg0_10:GetView():IsPlayer(arg2_10.id) then
		arg0_10:NotifiyCore(ISLAND_EVT.END_COUPLE_ACTION)
	end
end

function var0_0.NavigateToPoint(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = arg3_11.respond_point and arg3_11.respond_point ~= "" and BuildVector3(arg3_11.respond_point) or Vector3(0, 0, 2)
	local var1_11 = var0_11.magnitude
	local var2_11 = arg1_11._go.transform.rotation * var0_11
	local var3_11 = arg1_11._go.transform.position + var2_11
	local var4_11 = IslandCalcUtil.GetCanReachOptPoint(arg2_11._go.transform.position, var1_11, arg1_11.agent, arg1_11._tf.position, var3_11, 36)

	if not var4_11 then
		arg4_11()

		if arg0_11:GetView():IsPlayer(arg1_11.id) or arg0_11:GetView():IsPlayer(arg2_11.id) then
			arg0_11:OnNavigateToPointFailed()
		end

		return false
	end

	local var5_11 = {
		speed = 5,
		waitUntilDone = true,
		hide = false,
		unitId = arg2_11.id,
		unitType = arg2_11.unitType,
		position = {
			var4_11.x,
			var4_11.y,
			var4_11.z
		}
	}

	arg0_11:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, {
		navData = var5_11,
		callback = arg4_11
	})

	local var6_11 = IslandCalcUtil.RotationOffset(arg1_11._go.transform.position, var3_11, var4_11)

	return true, var6_11
end

function var0_0.OnNavigateToPointFailed(arg0_12)
	pg.TipsMgr.GetInstance():ShowTips(i18n("island_no_position_to_reponse_action"))
end

function var0_0.Face2Face(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = arg3_13._go.transform
	local var1_13 = arg2_13._go.transform
	local var2_13 = var1_13.position - var0_13.position
	local var3_13 = Quaternion.LookRotation(var2_13)

	var0_13.rotation = Quaternion.Euler(0, var3_13.eulerAngles.y, 0)
	var1_13.rotation = arg1_13 * var1_13.rotation

	if isa(arg3_13, IslandPlayerUnit) then
		arg3_13.targetRotation = var0_13.rotation
	end

	if isa(arg2_13, IslandPlayerUnit) then
		arg2_13.targetRotation = var1_13.rotation
	end

	arg4_13()
end

function var0_0.PlayCoupleActions(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	parallelAsync({
		function(arg0_15)
			arg2_14:PlayAnimation(arg3_14.responder_feedback, 0.25, arg0_15)
		end,
		function(arg0_16)
			arg1_14:PlayAnimation(arg3_14.resource .. "_end", 0.25, arg0_16)
		end
	}, arg4_14)
end

function var0_0.EnableOrDisablePlayerSyn(arg0_17, arg1_17, arg2_17)
	if isa(arg1_17, IslandPlayerUnit) then
		arg1_17:ActiveOrDisactive(arg2_17)
	end
end

function var0_0.EnableOrDisablePlayerOp(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg0_18:GetView():IsPlayer(arg1_18.id) or arg0_18:GetView():IsPlayer(arg2_18.id) then
		if arg3_18 then
			arg0_18:GetView():EnablePlayerOp()
		else
			arg0_18:GetView():DisablePlayerOp()
			IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController)):EnablePlayerLook()
		end
	end
end

function var0_0.EnableOrDisableUnitSyn(arg0_19, arg1_19, arg2_19, arg3_19)
	local function var0_19(arg0_20, arg1_20)
		if arg1_20 then
			arg0_20:WakeUp()
		else
			arg0_20:Sleep()
		end
	end

	if isa(arg1_19, IslandVisitorUnit) then
		var0_19(arg1_19, arg3_19)
	end

	if isa(arg2_19, IslandVisitorUnit) then
		var0_19(arg2_19, arg3_19)
	end
end

return var0_0
