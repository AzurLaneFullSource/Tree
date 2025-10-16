local var0_0 = class("IslandCoupleActionPlayer", import("..IslandBaseUnit"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.playing = false
	arg0_1.phase = var1_0

	arg0_1:Init()
end

function var0_0.IsPlaying(arg0_2)
	return arg0_2.playing
end

function var0_0.Stop(arg0_3)
	if not arg0_3:IsPlaying() then
		return
	end

	if arg0_3.phase == var1_0 then
		return
	end

	if arg0_3.phase == var2_0 and arg0_3.playData then
		local var0_3 = arg0_3.playData[2]

		arg0_3:NotifiyCore(ISLAND_EVT.REMOVE_PATH_FINDER, {
			unitId = var0_3.id,
			unitType = var0_3.unitType
		})
		arg0_3:ResetAnimation()
	elseif arg0_3.phase == var3_0 and arg0_3.playData then
		arg0_3:ResetAnimation()
	end

	arg0_3:WillExit(arg0_3.playData[2], arg0_3.playData[1])
	arg0_3:Exit(arg0_3.playData[2], arg0_3.playData[1])
end

function var0_0.ResetAnimation(arg0_4)
	local var0_4 = arg0_4.playData[1]
	local var1_4 = arg0_4.playData[2]
	local var2_4 = arg0_4:GetView():GetUnitModuleWithType(var0_4.unitType, var0_4.id)

	if var2_4 then
		var2_4:CheckMovement()
	end

	local var3_4 = arg0_4:GetView():GetUnitModuleWithType(var1_4.unitType, var1_4.id)

	if var3_4 then
		var3_4:CheckMovement()
	end
end

function var0_0.Play(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg2_5 or not arg1_5 then
		return
	end

	arg0_5.playData = {
		arg2_5,
		arg1_5
	}

	arg0_5:EnableOrDisablePlayerOp(arg2_5, arg1_5, false)
	arg0_5:EnableOrDisableUnitSyn(arg2_5, arg1_5, false)

	arg0_5.playing = true

	arg0_5:SendStartEvent(arg2_5, arg1_5)
	arg0_5:ShowOrHideCancelableBtn(arg2_5, arg1_5, true)

	local var0_5 = false
	local var1_5 = Vector3(0, 0, 0)

	seriesAsync({
		function(arg0_6)
			var0_5, var1_5 = arg0_5:NavigateToPoint(arg2_5, arg1_5, arg3_5, arg0_6)
		end,
		function(arg0_7)
			onNextTick(arg0_7)
		end,
		function(arg0_8)
			if not arg0_5.playing then
				return
			end

			arg0_5:EnableOrDisablePlayerSyn(arg1_5, false)

			if not var0_5 then
				arg0_8()

				return
			end

			arg0_5:Face2Face(var1_5, arg2_5, arg1_5, arg0_8)
		end,
		function(arg0_9)
			if not arg0_5.playing then
				return
			end

			if not var0_5 then
				arg0_9()

				return
			end

			arg0_5:PlayCoupleActions(arg2_5, arg1_5, arg3_5, arg0_9)
		end,
		function(arg0_10)
			if not arg0_5.playing then
				return
			end

			IslandTaskHelper.OnActionEnd(arg3_5.id)
			arg0_5:WillExit(arg1_5, arg2_5)
			arg0_10()
		end
	}, function()
		arg0_5:Exit(arg1_5, arg2_5, arg3_5)
	end)
end

function var0_0.WillExit(arg0_12, arg1_12, arg2_12)
	if arg1_12 then
		arg0_12:EnableOrDisablePlayerSyn(arg1_12, true)
	end

	if arg2_12 and arg1_12 then
		arg0_12:EnableOrDisableUnitSyn(arg2_12, arg1_12, true)
		arg0_12:EnableOrDisablePlayerOp(arg2_12, arg1_12, true)
	end
end

function var0_0.Exit(arg0_13, arg1_13, arg2_13)
	if arg2_13 and arg1_13 then
		arg0_13:ShowOrHideCancelableBtn(arg2_13, arg1_13, false)
		arg0_13:SendEndEvent(arg2_13, arg1_13)
	end

	arg0_13.playing = false
	arg0_13.phase = var1_0
	arg0_13.playData = nil
end

function var0_0.ShowOrHideCancelableBtn(arg0_14, arg1_14, arg2_14, arg3_14)
	if not (arg0_14:GetView():IsPlayer(arg1_14.id) or arg0_14:GetView():IsPlayer(arg2_14.id)) then
		return
	end

	if arg3_14 then
		arg0_14:NotifiyCore(ISLAND_EVT.START_DO_COUPLE_ACTION)
	else
		arg0_14:NotifiyCore(ISLAND_EVT.END_DO_COUPLE_ACTION)
	end
end

function var0_0.SendStartEvent(arg0_15, arg1_15, arg2_15)
	if arg0_15:GetView():IsPlayer(arg1_15.id) or arg0_15:GetView():IsPlayer(arg2_15.id) then
		arg0_15:NotifiyCore(ISLAND_EVT.START_COUPLE_ACTION)
	end
end

function var0_0.SendEndEvent(arg0_16, arg1_16, arg2_16)
	if arg0_16:GetView():IsPlayer(arg1_16.id) or arg0_16:GetView():IsPlayer(arg2_16.id) then
		arg0_16:NotifiyCore(ISLAND_EVT.END_COUPLE_ACTION)
	end
end

function var0_0.NavigateToPoint(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17.phase = var2_0

	local var0_17 = arg3_17.respond_point and arg3_17.respond_point ~= "" and BuildVector3(arg3_17.respond_point) or Vector3(0, 0, 2)
	local var1_17 = var0_17.magnitude
	local var2_17 = arg1_17._go.transform.rotation * var0_17
	local var3_17 = arg1_17._go.transform.position + var2_17
	local var4_17 = IslandCalcUtil.GetCanReachOptPoint(arg2_17._go.transform.position, var1_17, arg1_17.agent, arg1_17._tf.position, var3_17, 36)

	if not var4_17 then
		arg4_17()

		if arg0_17:GetView():IsPlayer(arg1_17.id) or arg0_17:GetView():IsPlayer(arg2_17.id) then
			arg0_17:OnNavigateToPointFailed()
		end

		return false
	end

	local var5_17 = {
		speed = 5,
		waitUntilDone = true,
		hide = false,
		unitId = arg2_17.id,
		unitType = arg2_17.unitType,
		position = {
			var4_17.x,
			var4_17.y,
			var4_17.z
		}
	}

	arg0_17:NotifiyCore(ISLAND_EVT.GEN_PATH_FINDER, {
		navData = var5_17,
		callback = arg4_17
	})

	local var6_17 = IslandCalcUtil.RotationOffset(arg1_17._go.transform.position, var3_17, var4_17)

	return true, var6_17
end

function var0_0.OnNavigateToPointFailed(arg0_18)
	pg.TipsMgr.GetInstance():ShowTips(i18n("island_no_position_to_reponse_action"))
end

function var0_0.Face2Face(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = arg3_19._go.transform
	local var1_19 = arg2_19._go.transform
	local var2_19 = var1_19.position - var0_19.position
	local var3_19 = Quaternion.LookRotation(var2_19)

	var0_19.rotation = Quaternion.Euler(0, var3_19.eulerAngles.y, 0)
	var1_19.rotation = arg1_19 * var1_19.rotation

	if isa(arg3_19, IslandPlayerUnit) then
		arg3_19.targetRotation = var0_19.rotation
	end

	if isa(arg2_19, IslandPlayerUnit) then
		arg2_19.targetRotation = var1_19.rotation
	end

	arg4_19()
end

function var0_0.PlayCoupleActions(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	arg0_20.phase = var3_0

	parallelAsync({
		function(arg0_21)
			arg2_20:PlayAnimation(arg3_20.responder_feedback, 0.25, arg0_21)
		end,
		function(arg0_22)
			arg1_20:PlayAnimation(arg3_20.resource .. "_end", 0.25, arg0_22)
		end
	}, arg4_20)
end

function var0_0.EnableOrDisablePlayerSyn(arg0_23, arg1_23, arg2_23)
	if isa(arg1_23, IslandPlayerUnit) then
		arg1_23:ActiveOrDisactive(arg2_23)
	end
end

function var0_0.EnableOrDisablePlayerOp(arg0_24, arg1_24, arg2_24, arg3_24)
	if arg0_24:GetView():IsPlayer(arg1_24.id) or arg0_24:GetView():IsPlayer(arg2_24.id) then
		if arg3_24 then
			arg0_24:GetView():EnablePlayerOp()
		else
			arg0_24:GetView():DisablePlayerOp()
			IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController)):EnablePlayerLook()
		end
	end
end

function var0_0.EnableOrDisableUnitSyn(arg0_25, arg1_25, arg2_25, arg3_25)
	local function var0_25(arg0_26, arg1_26)
		if arg1_26 then
			arg0_26:WakeUp()
		else
			arg0_26:Sleep()
		end
	end

	if isa(arg1_25, IslandVisitorUnit) then
		var0_25(arg1_25, arg3_25)
	end

	if isa(arg2_25, IslandVisitorUnit) then
		var0_25(arg2_25, arg3_25)
	end
end

return var0_0
