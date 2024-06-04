local var0 = class("GuildDynamicBgPathGrid")

function var0.Ctor(arg0, arg1)
	arg0.canWalk = arg1.canWalk
	arg0.position = arg1.position
	arg0.sizeDelta = arg1.sizeDelta
	arg0.startPosOffset = arg1.startPosOffset
	arg0.lockCnt = 0
	arg0.localPosition = arg0.startPosOffset + Vector3(arg0.position.x * arg0.sizeDelta.x, arg0.position.y * arg0.sizeDelta.y, 0)
	arg0.centerPosition = Vector3(arg0.localPosition.x + arg0.sizeDelta.x / 2, arg0.localPosition.y + arg0.sizeDelta.y / 2)
end

function var0.GetPosition(arg0)
	return arg0.position
end

function var0.GetLocalPosition(arg0)
	return arg0.localPosition
end

function var0.GetCenterPosition(arg0)
	return arg0.centerPosition
end

function var0.CanWalk(arg0)
	return arg0.canWalk and not arg0:IsLock()
end

function var0.Lock(arg0)
	arg0.lockCnt = arg0.lockCnt + 1
end

function var0.Unlock(arg0)
	if arg0.lockCnt > 0 then
		arg0.lockCnt = arg0.lockCnt - 1
	end
end

function var0.UnlockAll(arg0)
	arg0.lockCnt = 0
end

function var0.IsLock(arg0)
	return arg0.lockCnt > 0
end

function var0.GetAroundGrids(arg0)
	local var0 = arg0.position
	local var1 = Vector2(var0.x, var0.y + 1)
	local var2 = Vector2(var0.x, var0.y - 1)
	local var3 = Vector2(var0.x + 1, var0.y)
	local var4 = Vector2(var0.x - 1, var0.y)

	return {
		var1,
		var2,
		var3,
		var4
	}
end

return var0
