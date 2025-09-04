local var0_0 = class("NcDoStroll", import("..base.NodeCanvasBaseTask"))

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.index = 1
	arg0_1.speed = 3
	arg0_1.rotationSpeed = 10
	arg0_1.isStopping = false
end

function var0_0.OnExecute(arg0_2)
	if not _IslandCore then
		return
	end

	arg0_2.agent = arg0_2:GetAgent()
	arg0_2.navAgent = arg0_2.agent.gameObject:GetComponent("NavMeshAgent")

	local var0_2 = arg0_2.agent.gameObject:GetComponent(typeof(WorldObjectItem))

	arg0_2.unitId = var0_2.id
	arg0_2.unitType = var0_2.type
	arg0_2.animator = _IslandFindUnit(arg0_2.unitType, arg0_2.unitId).transform:GetChild(0):GetComponent(typeof(Animator))

	local var1_2 = arg0_2:GetBlackboardVariable("pause")
	local var2_2 = _IslandCore:GetController().strollAllocator
	local var3_2 = arg0_2:GetFloatArg("pathId")

	arg0_2.chaoticOrder = arg0_2:GetBoolArg("chaoticOrder")

	local var4_2 = var2_2:GetWaypoints(var3_2)

	assert(#var4_2 > 0, "waypoints is empty")

	arg0_2.waypoints = _.map(var4_2, function(arg0_3)
		return IslandWayPoint.New(arg0_3)
	end)

	if not arg0_2:IsLegalPath() then
		arg0_2:EndAction(false)

		return
	end

	if var1_2 then
		arg0_2:ResumeMove()
	else
		arg0_2:NextOne()
	end
end

function var0_0.IsLegalPath(arg0_4)
	return arg0_4.waypoints and #arg0_4.waypoints > 1
end

function var0_0.OnUpdate(arg0_5)
	if not arg0_5:IsLegalPath() then
		return
	end

	if arg0_5.index <= 0 or arg0_5.index > #arg0_5.waypoints then
		arg0_5:EndAction(false)

		return
	end

	arg0_5:CheckProcessTime()
	arg0_5:CheckProcessAnimation()
	arg0_5:CheckArriveAnimation()
	arg0_5:CheckArriveTime()
	arg0_5:UpdateRatation()

	local var0_5 = arg0_5.waypoints[arg0_5.index].position

	if not arg0_5.navAgent.pathPending and arg0_5.navAgent.remainingDistance <= arg0_5.navAgent.stoppingDistance and not arg0_5.isStopping then
		arg0_5:OnArrive()
	end
end

function var0_0.UpdateRatation(arg0_6)
	if not arg0_6.targetRotation then
		return
	end

	arg0_6.agent.rotation = Quaternion.Slerp(arg0_6.agent.rotation, arg0_6.targetRotation, arg0_6.rotationSpeed * Time.deltaTime)

	if Vector3.Dot(arg0_6.agent.forward, arg0_6.targetRotation:ToEulerAngles().normalized) >= 0.95 then
		arg0_6.targetRotation = nil
	end
end

function var0_0.NextOne(arg0_7)
	arg0_7.targetRotation = nil
	arg0_7.isStopping = false

	if arg0_7.chaoticOrder then
		arg0_7:Shuffle()
	end

	arg0_7.index = arg0_7.index + 1

	if arg0_7.index > #arg0_7.waypoints then
		arg0_7.index = 1
	end

	local var0_7 = arg0_7.waypoints[arg0_7.index].position

	_IslandMoveUnit(arg0_7.unitType, arg0_7.unitId, var0_7, arg0_7.speed)
	arg0_7:OnProcess()
end

function var0_0.Shuffle(arg0_8)
	local var0_8 = arg0_8.waypoints[arg0_8.index]
	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.waypoints) do
		if iter1_8 ~= var0_8 then
			table.insert(var1_8, iter1_8)
		end
	end

	shuffle(var1_8)
	table.insert(var1_8, 1, var0_8)

	arg0_8.waypoints = var1_8
end

function var0_0.PauseMove(arg0_9)
	_IslandStopMoveUnit(arg0_9.unitType, arg0_9.unitId)
end

function var0_0.ResumeMove(arg0_10)
	local var0_10 = Animator.StringToHash("movement")

	arg0_10:CrossFadeInFixedTime(var0_10, 0.2)

	local var1_10 = arg0_10.waypoints[arg0_10.index].position

	_IslandMoveUnit(arg0_10.unitType, arg0_10.unitId, var1_10, arg0_10.speed)
end

function var0_0.CheckAnimationState(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg1_11:GetCurrentAnimatorStateInfo(0)

	if var0_11:IsName(arg2_11) and not arg0_11.endTime then
		local var1_11 = var0_11.length / arg1_11.speed

		arg0_11.endTime = arg0_11:GetElapsedTime() + var1_11
	end

	if arg0_11.endTime and arg0_11:GetElapsedTime() >= arg0_11.endTime then
		arg3_11()

		arg0_11.endTime = nil
	end
end

function var0_0.CheckArriveAnimation(arg0_12)
	if not arg0_12.executeArriveAnimation then
		return
	end

	local var0_12 = arg0_12.executeArriveAnimation.state

	arg0_12:CheckAnimationState(arg0_12.animator, var0_12, function()
		arg0_12:EndArriveAction()

		arg0_12.executeArriveAnimation = nil
	end)
end

function var0_0.CheckArriveTime(arg0_14)
	if not arg0_14.executeArriveTime then
		return
	end

	if arg0_14:GetElapsedTime() >= arg0_14.executeArriveTime then
		arg0_14:NextOne()

		arg0_14.executeArriveTime = nil
	end
end

function var0_0.OnArrive(arg0_15)
	arg0_15.isStopping = true

	arg0_15:ClearProcessAction()

	local var0_15 = arg0_15:GetCurrWaypoint()

	if var0_15:DisappearWhenArrive() then
		arg0_15:DisappearUnit()

		return
	end

	arg0_15:PauseMove()
	arg0_15:DoRatation()
	var0_15:RandomArriveAction()

	if not var0_15:GetActionWhenArrive() then
		arg0_15:EndArriveAction()

		return
	end

	arg0_15:ExecuteArriveAction()
end

function var0_0.EndArriveAction(arg0_16)
	local var0_16 = arg0_16:GetCurrWaypoint():GetStartNextOneTime()

	if var0_16 <= 0 then
		arg0_16:NextOne()
	else
		arg0_16.executeArriveTime = arg0_16:GetElapsedTime() + var0_16
	end
end

function var0_0.DisappearUnit(arg0_17)
	setActive(arg0_17.agent, false)
end

function var0_0.DoRatation(arg0_18)
	local var0_18 = arg0_18:GetCurrWaypoint():GetRotationWhenArrive()

	if var0_18 == 0 then
		return
	end

	arg0_18.targetRotation = Quaternion.Euler(0, var0_18, 0)
end

function var0_0.ExecuteArriveAction(arg0_19)
	local var0_19 = arg0_19:GetCurrWaypoint():GetActionWhenArrive()

	if not var0_19 then
		arg0_19:EndArriveAction()

		return
	end

	if var0_19.type == IslandWayPoint.ACTION_TYPE_CHATBUBBLE then
		seriesAsync({
			function(arg0_20)
				_IslandPlayBubble(var0_19.action, arg0_20)
			end
		}, function()
			arg0_19:EndArriveAction()
		end)
	elseif var0_19.type == IslandWayPoint.ACTION_TYPE_ANIM then
		arg0_19:PlayArriveAnimation(var0_19.action)
	end
end

function var0_0.PlayArriveAnimation(arg0_22, arg1_22)
	if not arg0_22.animator:GetCurrentAnimatorStateInfo(0):IsName(arg1_22) then
		local var0_22 = Animator.StringToHash(arg1_22)

		arg0_22:CrossFadeInFixedTime(var0_22, 0.2)

		arg0_22.executeArriveAnimation = {
			state = arg1_22
		}
	else
		arg0_22:EndArriveAction()
	end
end

function var0_0.CheckProcessTime(arg0_23)
	if not arg0_23.executeProcessActionTime then
		return
	end

	if arg0_23:GetElapsedTime() >= arg0_23.executeProcessActionTime then
		arg0_23:ExecuteProcessAction()

		arg0_23.executeProcessActionTime = nil
	end
end

function var0_0.CheckProcessAnimation(arg0_24)
	if not arg0_24.executeProcessAnimation then
		return
	end

	local var0_24 = arg0_24.executeProcessAnimation.state

	arg0_24:CheckAnimationState(arg0_24.animator, var0_24, function()
		arg0_24:ResumeMove()

		arg0_24.executeProcessAnimation = nil
	end)
end

function var0_0.OnProcess(arg0_26)
	local var0_26 = arg0_26:GetPrevWaypoint()

	var0_26:RandomProcessAction()

	local var1_26 = var0_26:GetActionWhenProcess()

	if not var1_26 then
		return
	end

	arg0_26.executeProcessActionTime = arg0_26:GetElapsedTime() + var1_26.time
end

function var0_0.ClearProcessAction(arg0_27)
	if arg0_27.executeProcessActionTime then
		arg0_27.executeProcessActionTime = nil
	end

	if arg0_27.executeProcessAnimation then
		arg0_27.executeProcessAnimation = nil
	end
end

function var0_0.ExecuteProcessAction(arg0_28)
	local var0_28 = arg0_28:GetPrevWaypoint():GetActionWhenProcess()

	if not var0_28 then
		return
	end

	arg0_28:PauseMove()

	if var0_28.type == IslandWayPoint.ACTION_TYPE_CHATBUBBLE then
		seriesAsync({
			function(arg0_29)
				_IslandPlayBubble(var0_28.action, arg0_29)
			end
		}, function()
			arg0_28:ResumeMove()
		end)
	elseif var0_28.type == IslandWayPoint.ACTION_TYPE_ANIM then
		arg0_28:PlayProcessAnimation(var0_28.action)
	end
end

function var0_0.PlayProcessAnimation(arg0_31, arg1_31)
	if not arg0_31.animator:GetCurrentAnimatorStateInfo(0):IsName(arg1_31) then
		local var0_31 = Animator.StringToHash(arg1_31)

		arg0_31:CrossFadeInFixedTime(var0_31, 0.2)

		arg0_31.executeProcessAnimation = {
			state = arg1_31
		}
	else
		arg0_31:ResumeMove()
	end
end

function var0_0.GetPrevWaypoint(arg0_32)
	if arg0_32.index == 1 then
		return arg0_32.waypoints[#arg0_32.waypoints]
	end

	return arg0_32.waypoints[arg0_32.index - 1]
end

function var0_0.GetCurrWaypoint(arg0_33)
	return arg0_33.waypoints[arg0_33.index]
end

function var0_0.OnDrawGizmosSelected(arg0_34)
	if not arg0_34:IsLegalPath() then
		return
	end

	local var0_34 = arg0_34.waypoints
	local var1_34 = var0_34[1].position

	for iter0_34 = 1, #var0_34 do
		if iter0_34 == #var0_34 then
			break
		end

		LuaHelper.DrawText("point" .. iter0_34, var1_34, Vector3(1, 0, 0))

		local var2_34 = var0_34[iter0_34 + 1].position

		LuaHelper.DrawLine(var1_34, var2_34, Vector3(1, 0, 0), 0)

		var1_34 = var2_34
	end

	LuaHelper.DrawText("point" .. #var0_34, var0_34[#var0_34].position, Vector3(1, 0, 0))
	LuaHelper.DrawLine(var0_34[#var0_34].position, var0_34[1].position, Vector3(1, 0, 0), 0)
end

function var0_0.CrossFadeInFixedTime(arg0_35, arg1_35, arg2_35)
	for iter0_35 = 1, arg0_35.animator.layerCount do
		arg0_35.animator:CrossFadeInFixedTime(arg1_35, 0.2, iter0_35 - 1)
	end
end

return var0_0
