local var0_0 = class("SyncUnitMovable", import(".SyncUnit"))

var0_0.OWNER_TYPE_CLIENT = 1
var0_0.OWNER_TYPE_SERVER = 2
var0_0.OWNER_TYPE_NONE = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.sceneObject = arg2_1
	arg0_1.delayTime = 0
	arg0_1.syncData = nil
end

function var0_0.UpdateOwner(arg0_2, arg1_2)
	return
end

function var0_0.UpdateSyncData(arg0_3, arg1_3)
	arg0_3.syncData = arg1_3
	arg0_3.delayTime = IslandConst.SYNC_TIME_INTERVAL
end

function var0_0.SetTempSyncData(arg0_4, arg1_4)
	arg0_4.tempSyncData = arg1_4
end

function var0_0.RestoreTempSyncData(arg0_5)
	if not arg0_5.tempSyncData then
		return
	end

	arg0_5:UpdateSyncData(arg0_5.tempSyncData)

	arg0_5.tempSyncData = nil
end

function var0_0.CreateSyncData(arg0_6)
	return (SyncUnitData.New({
		id = arg0_6.id,
		pos = arg0_6:GetLocalPosition(),
		dir = arg0_6:GetRotation(),
		status = arg0_6:GetStatus()
	}))
end

function var0_0.GetStatus(arg0_7)
	return nil
end

function var0_0.Update(arg0_8)
	if arg0_8.delayTime == 0 then
		return
	end

	arg0_8:MoveHandle()
	arg0_8:AnimHandle()
end

function var0_0.MoveHandle(arg0_9)
	local var0_9 = arg0_9.delayTime - Time.deltaTime
	local var1_9 = Time.deltaTime / arg0_9.delayTime
	local var2_9
	local var3_9

	if var0_9 > 0 then
		var2_9 = Vector3.Lerp(arg0_9:GetLocalPosition(), arg0_9.syncData.pos, var1_9)
		var3_9 = Quaternion.Lerp(arg0_9:GetRotation(), arg0_9:GetSyncDataRotation(), var1_9)
		arg0_9.delayTime = var0_9
	else
		var2_9 = arg0_9.syncData.pos
		var3_9 = arg0_9:GetSyncDataRotation()
		arg0_9.delayTime = 0
	end

	local var4_9 = (var2_9 - arg0_9:GetLocalPosition()) / Time.deltaTime

	arg0_9.speed = Vector2(var4_9.x, var4_9.z).magnitude

	arg0_9:SetLocalPosition(var2_9)
	arg0_9:SetRotation(var3_9)
end

function var0_0.AnimHandle(arg0_10)
	return
end

function var0_0.IsClient(arg0_11)
	return arg0_11.ownerType == SyncUnitMovable.OWNER_TYPE_CLIENT
end

function var0_0.IsServer(arg0_12)
	return arg0_12.ownerType == SyncUnitMovable.OWNER_TYPE_SERVER
end

function var0_0.IsLoaded(arg0_13)
	return arg0_13.sceneObject and arg0_13.sceneObject:IsLoaded()
end

function var0_0.GetSyncDataRotation(arg0_14)
	return arg0_14.syncData.dir
end

function var0_0.GetLocalPosition(arg0_15)
	return arg0_15.sceneObject._go.transform.localPosition
end

function var0_0.GetRotation(arg0_16)
	return arg0_16.sceneObject._go.transform.rotation
end

function var0_0.SetLocalPosition(arg0_17, arg1_17)
	arg0_17.sceneObject._go.transform.localPosition = arg1_17
end

function var0_0.SetRotation(arg0_18, arg1_18)
	arg0_18.sceneObject._go.transform.rotation = arg1_18
end

return var0_0
