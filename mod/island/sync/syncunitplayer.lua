local var0_0 = class("SyncUnitPlayer", import(".SyncUnitMovable"))

var0_0.ANIM_HASH = {
	IslandConst.ANIM_JUMP_HASH,
	IslandConst.ANIM_MOVE_HASH
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:UpdateOwner(arg1_1.tid)

	arg0_1.inTimeline = false
end

function var0_0.UpdateOwner(arg0_2, arg1_2)
	local var0_2 = getProxy(PlayerProxy):getPlayerId()

	arg0_2.owner = arg1_2

	if arg0_2.owner == var0_2 then
		arg0_2.ownerType = SyncUnitMovable.OWNER_TYPE_CLIENT
	else
		arg0_2.ownerType = SyncUnitMovable.OWNER_TYPE_SERVER
	end
end

function var0_0.GetStatus(arg0_3)
	local var0_3 = arg0_3.sceneObject.animator:GetCurrentAnimatorStateInfo(0)

	return table.indexof(var0_0.ANIM_HASH, var0_3.shortNameHash) or 0
end

function var0_0.AnimHandle(arg0_4)
	local var0_4 = var0_0.ANIM_HASH[arg0_4.syncData.status]
	local var1_4 = arg0_4.sceneObject.animator:GetCurrentAnimatorStateInfo(0)

	if arg0_4.speed < 7.5 and arg0_4.speed > 5 then
		arg0_4.speed = 5
	end

	arg0_4.sceneObject.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_4.speed)

	if var1_4.shortNameHash ~= var0_4 then
		arg0_4.sceneObject.animator:Play(var0_4)
	end
end

function var0_0.SetInTimeline(arg0_5, arg1_5)
	arg0_5.inTimeline = arg1_5
end

function var0_0.InTimeline(arg0_6)
	return arg0_6.inTimeline
end

return var0_0
