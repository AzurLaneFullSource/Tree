local var0_0 = class("IslandVisitorUnit", import(".IslandNavigableUnit"))

function var0_0.OnUpdate(arg0_1)
	if arg0_1.delayTime == 0 then
		return
	end

	if arg0_1.isSleeping then
		return
	end

	arg0_1:MoveHandle()
	arg0_1:AnimHandle()
end

function var0_0.OnStart(arg0_2)
	arg0_2.behaviourTreeOwner.graph.blackboard:SetVariableValue("playerId", tostring(arg0_2.id))
end

function var0_0.OnLaterAttach(arg0_3, arg1_3)
	var0_0.super.OnLaterAttach(arg0_3, arg1_3)

	arg0_3.delayTime = 0
	arg0_3.syncData = nil
end

function var0_0.UpdateSyncData(arg0_4, arg1_4)
	arg0_4.syncData = arg1_4
	arg0_4.delayTime = IslandConst.SYNC_TIME_INTERVAL
end

function var0_0.Sleep(arg0_5)
	arg0_5.isSleeping = true
end

function var0_0.WakeUp(arg0_6)
	arg0_6.isSleeping = false
end

function var0_0.MoveHandle(arg0_7)
	local var0_7 = arg0_7.delayTime - Time.deltaTime
	local var1_7 = Time.deltaTime / arg0_7.delayTime
	local var2_7
	local var3_7

	if var0_7 > 0 then
		var2_7 = Vector3.Lerp(arg0_7:GetLocalPosition(), arg0_7.syncData.pos, var1_7)
		var3_7 = Quaternion.Lerp(arg0_7:GetRotation(), arg0_7:GetSyncDataRotation(), var1_7)
		arg0_7.delayTime = var0_7
	else
		var2_7 = arg0_7.syncData.pos
		var3_7 = arg0_7:GetSyncDataRotation()
		arg0_7.delayTime = 0
	end

	local var4_7 = (var2_7 - arg0_7:GetLocalPosition()) / Time.deltaTime

	arg0_7.speed = Vector2(var4_7.x, var4_7.z).magnitude

	arg0_7:SetLocalPosition(var2_7)
	arg0_7:SetRotation(var3_7)
end

function var0_0.AnimHandle(arg0_8)
	if arg0_8.speed > 0 then
		arg0_8.speed = 5
	end

	local var0_8 = arg0_8:GetAnimator()

	var0_8:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_8.speed)

	for iter0_8 = 1, var0_8.layerCount do
		local var1_8 = iter0_8 - 1

		if not var0_8:IsInTransition(var1_8) then
			local var2_8 = arg0_8.syncData.status[iter0_8]

			if var0_8:GetCurrentAnimatorStateInfo(var1_8).shortNameHash ~= var2_8 then
				var0_8:CrossFadeInFixedTime(var2_8, 0.25, var1_8)
			end
		end
	end
end

function var0_0.GetSyncDataRotation(arg0_9)
	return arg0_9.syncData.dir
end

function var0_0.GetLocalPosition(arg0_10)
	return arg0_10._go.transform.localPosition
end

function var0_0.GetRotation(arg0_11)
	return arg0_11._go.transform.rotation
end

function var0_0.SetLocalPosition(arg0_12, arg1_12)
	arg0_12._go.transform.localPosition = arg1_12
end

function var0_0.SetRotation(arg0_13, arg1_13)
	arg0_13._go.transform.rotation = arg1_13
end

function var0_0.SetShipDressHelper(arg0_14, arg1_14)
	arg0_14.shipDressHelper = arg1_14
end

function var0_0.OnDetach(arg0_15)
	if arg0_15.shipDressHelper then
		arg0_15.shipDressHelper:Destroy()
	end
end

function var0_0.OnChangeDress(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg1_16) do
		if iter1_16.changedDressColorId then
			if not iter1_16.changeedDressId then
				arg0_16.shipDressHelper:ChangeCommanderPartColor(iter0_16, iter1_16.changedDressColorId)
			else
				arg0_16.shipDressHelper:ChangeDressByType(iter0_16, {
					id = iter1_16.changeedDressId,
					colorId = iter1_16.changedDressColorId
				})
			end
		end
	end
end

return var0_0
