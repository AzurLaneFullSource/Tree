local var0_0 = class("GuildDynamicBgPathGrid")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.canWalk = arg1_1.canWalk
	arg0_1.position = arg1_1.position
	arg0_1.sizeDelta = arg1_1.sizeDelta
	arg0_1.startPosOffset = arg1_1.startPosOffset
	arg0_1.lockCnt = 0
	arg0_1.localPosition = arg0_1.startPosOffset + Vector3(arg0_1.position.x * arg0_1.sizeDelta.x, arg0_1.position.y * arg0_1.sizeDelta.y, 0)
	arg0_1.centerPosition = Vector3(arg0_1.localPosition.x + arg0_1.sizeDelta.x / 2, arg0_1.localPosition.y + arg0_1.sizeDelta.y / 2)
end

function var0_0.GetPosition(arg0_2)
	return arg0_2.position
end

function var0_0.GetLocalPosition(arg0_3)
	return arg0_3.localPosition
end

function var0_0.GetCenterPosition(arg0_4)
	return arg0_4.centerPosition
end

function var0_0.CanWalk(arg0_5)
	return arg0_5.canWalk and not arg0_5:IsLock()
end

function var0_0.Lock(arg0_6)
	arg0_6.lockCnt = arg0_6.lockCnt + 1
end

function var0_0.Unlock(arg0_7)
	if arg0_7.lockCnt > 0 then
		arg0_7.lockCnt = arg0_7.lockCnt - 1
	end
end

function var0_0.UnlockAll(arg0_8)
	arg0_8.lockCnt = 0
end

function var0_0.IsLock(arg0_9)
	return arg0_9.lockCnt > 0
end

function var0_0.GetAroundGrids(arg0_10)
	local var0_10 = arg0_10.position
	local var1_10 = Vector2(var0_10.x, var0_10.y + 1)
	local var2_10 = Vector2(var0_10.x, var0_10.y - 1)
	local var3_10 = Vector2(var0_10.x + 1, var0_10.y)
	local var4_10 = Vector2(var0_10.x - 1, var0_10.y)

	return {
		var1_10,
		var2_10,
		var3_10,
		var4_10
	}
end

return var0_0
