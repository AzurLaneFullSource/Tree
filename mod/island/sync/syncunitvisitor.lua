local var0_0 = class("SyncUnitVisitor")

var0_0.ANIMATOR_LAYER = {
	0,
	1,
	2
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.sceneObject = arg1_1
	arg0_1.animHash = {}
	arg0_1.animator = arg1_1:GetAnimator()
	arg0_1.delayTime = 0
	arg0_1.syncData = nil
end

function var0_0.RecordLastInteract(arg0_2, arg1_2, arg2_2)
	arg0_2.lastInteract = {
		type = arg2_2,
		id = arg1_2
	}
end

function var0_0.ClearLastInteract(arg0_3)
	arg0_3.lastInteract = nil
end

function var0_0.GetLastInteract(arg0_4)
	return arg0_4.lastInteract
end

function var0_0.UpdateSyncData(arg0_5, arg1_5)
	arg0_5.syncData = arg1_5
	arg0_5.delayTime = IslandConst.SYNC_TIME_INTERVAL
end

function var0_0.Update(arg0_6)
	if arg0_6.delayTime == 0 then
		return
	end

	arg0_6:MoveHandle()
	arg0_6:AnimHandle()
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
	if arg0_8.speed < 7.5 and arg0_8.speed > 5 then
		arg0_8.speed = 5
	end

	arg0_8.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_8.speed)

	for iter0_8, iter1_8 in ipairs(arg0_8.ANIMATOR_LAYER) do
		if not arg0_8.animator:IsInTransition(iter1_8) then
			local var0_8 = arg0_8.syncData.status[iter0_8]

			if arg0_8.animator:GetCurrentAnimatorStateInfo(iter1_8).shortNameHash ~= var0_8 then
				arg0_8.animator:Play(var0_8, iter1_8)
			end
		end
	end
end

function var0_0.IsLoaded(arg0_9)
	return arg0_9.sceneObject and arg0_9.sceneObject:IsLoaded()
end

function var0_0.GetSyncDataRotation(arg0_10)
	return arg0_10.syncData.dir
end

function var0_0.GetLocalPosition(arg0_11)
	return arg0_11.sceneObject._go.transform.localPosition
end

function var0_0.GetRotation(arg0_12)
	return arg0_12.sceneObject._go.transform.rotation
end

function var0_0.SetLocalPosition(arg0_13, arg1_13)
	arg0_13.sceneObject._go.transform.localPosition = arg1_13
end

function var0_0.SetRotation(arg0_14, arg1_14)
	arg0_14.sceneObject._go.transform.rotation = arg1_14
end

function var0_0.Dispose(arg0_15)
	return
end

return var0_0
