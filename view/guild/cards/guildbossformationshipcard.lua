local var0_0 = class("GuildBossFormationShipCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	tf(arg1_1).pivot = Vector2(0.5, 0)
	tf(arg1_1).sizeDelta = Vector2(200, 300)
	tf(arg1_1).localScale = Vector3(0.6, 0.6, 0.6)
end

function var0_0.RefreshPosition(arg0_2, arg1_2, arg2_2)
	arg0_2.soltIndex = arg1_2

	if arg2_2 then
		arg0_2:UpdateLocalPosition()
	end
end

function var0_0.UpdateLocalPosition(arg0_3)
	local var0_3 = arg0_3._go.transform.parent:Find(arg0_3.soltIndex).localPosition

	arg0_3:SetLocalPosition(var0_3)
end

function var0_0.SetLocalPosition(arg0_4, arg1_4)
	arg0_4._go.transform.localPosition = arg1_4
end

function var0_0.GetLocalPosition(arg0_5)
	return arg0_5._go.transform.localPosition
end

function var0_0.GetSoltIndex(arg0_6)
	return arg0_6.soltIndex
end

function var0_0.Update(arg0_7, arg1_7, arg2_7)
	arg0_7.shipId = arg1_7.id
	arg0_7.teamType = arg1_7:getTeamType()

	arg0_7:RefreshPosition(arg2_7, true)
end

function var0_0.Dispose(arg0_8)
	if arg0_8._go then
		tf(arg0_8._go).pivot = Vector2(0.5, 0.5)
	end

	ClearEventTrigger(GetOrAddComponent(arg0_8._go, "EventTriggerListener"))
	PoolMgr.GetInstance():ReturnSpineChar(arg0_8._go.name, arg0_8._go)
end

return var0_0
