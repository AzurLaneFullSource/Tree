local var0 = class("GuildBossFormationShipCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	tf(arg1).pivot = Vector2(0.5, 0)
	tf(arg1).sizeDelta = Vector2(200, 300)
	tf(arg1).localScale = Vector3(0.6, 0.6, 0.6)
end

function var0.RefreshPosition(arg0, arg1, arg2)
	arg0.soltIndex = arg1

	if arg2 then
		arg0:UpdateLocalPosition()
	end
end

function var0.UpdateLocalPosition(arg0)
	local var0 = arg0._go.transform.parent:Find(arg0.soltIndex).localPosition

	arg0:SetLocalPosition(var0)
end

function var0.SetLocalPosition(arg0, arg1)
	arg0._go.transform.localPosition = arg1
end

function var0.GetLocalPosition(arg0)
	return arg0._go.transform.localPosition
end

function var0.GetSoltIndex(arg0)
	return arg0.soltIndex
end

function var0.Update(arg0, arg1, arg2)
	arg0.shipId = arg1.id
	arg0.teamType = arg1:getTeamType()

	arg0:RefreshPosition(arg2, true)
end

function var0.Dispose(arg0)
	if arg0._go then
		tf(arg0._go).pivot = Vector2(0.5, 0.5)
	end

	ClearEventTrigger(GetOrAddComponent(arg0._go, "EventTriggerListener"))
	PoolMgr.GetInstance():ReturnSpineChar(arg0._go.name, arg0._go)
end

return var0
