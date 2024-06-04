local var0 = class("CourtYardBasePanel", import("...base.BasePanel"))
local var1 = 0.5
local var2 = 0
local var3 = 1

function var0.Ctor(arg0, arg1)
	arg0.state = var2

	local var0 = arg0:GetUIName()
	local var1 = arg1._tf:Find(var0)

	arg0._go = var1.gameObject
	arg0._tf = var1
	arg0.contextData = arg1.contextData

	arg0:Attach(arg1)
end

function var0.Attach(arg0, arg1)
	var0.super.attach(arg0, arg1)
	arg0:init()
	arg0:Active()

	arg0.state = var3
end

function var0.Active(arg0)
	if arg0:IsVisit() then
		arg0:OnVisitRegister()
	else
		arg0:OnRegister()
	end
end

function var0.Detach(arg0)
	if arg0.state == var3 then
		arg0.state = var2

		var0.super.detach(arg0)
	end

	arg0:OnDispose()
end

function var0.Fold(arg0, arg1)
	local var0 = arg0:GetMoveX()
	local var1 = arg0:GetMoveY()

	if _.any(var1, function(arg0)
		return LeanTween.isTweening(go(arg0[1]))
	end) or _.any(var0, function(arg0)
		return LeanTween.isTweening(go(arg0[1]))
	end) then
		return
	end

	_.each(var0, function(arg0)
		local var0 = 0

		if arg1 then
			var0 = arg0[1].anchoredPosition3D.x + arg0[1].rect.width * arg0[2]
		end

		arg0:Tween("moveX", arg1, arg0[1], var0)
	end)
	_.each(var1, function(arg0)
		local var0 = 0

		if arg1 then
			var0 = arg0[1].anchoredPosition3D.y + arg0[1].rect.height * arg0[2]
		end

		arg0:Tween("moveY", arg1, arg0[1], var0)
	end)
end

function var0.Flush(arg0, arg1, arg2)
	if arg0.state == var3 then
		arg0.dorm = arg1

		if arg0:IsVisit() then
			arg0:OnVisitFlush()
		else
			arg0:OnFlush(arg2)
		end
	end
end

function var0.GetMoveX(arg0)
	return {}
end

function var0.GetMoveY(arg0)
	return {}
end

function var0.Tween(arg0, arg1, arg2, arg3, arg4)
	LeanTween[arg1](arg3, arg4, var1):setOnComplete(System.Action(function()
		if arg2 then
			setActive(arg3, false)
		end
	end)):setOnStart(System.Action(function()
		if not arg2 then
			setActive(arg3, true)
		end
	end))
end

function var0.IsInner(arg0)
	local var0 = arg0.contextData.floor

	return var0 == 1 or var0 == 2
end

function var0.OnEnterOrExitEdit(arg0, arg1)
	if arg1 then
		arg0:OnEnterEditMode()
	else
		arg0:OnExitEditMode()
	end
end

function var0.IsVisit(arg0)
	return arg0.contextData.mode == CourtYardConst.SYSTEM_VISIT
end

function var0.OnEnterEditMode(arg0)
	setActive(arg0._tf, false)
end

function var0.OnExitEditMode(arg0)
	setActive(arg0._tf, true)
end

function var0.GetUIName(arg0)
	assert(false)
end

function var0.OnRegister(arg0)
	return
end

function var0.OnVisitRegister(arg0)
	return
end

function var0.OnDispose(arg0)
	return
end

function var0.OnVisitFlush(arg0)
	return
end

function var0.OnFlush(arg0, arg1)
	return
end

function var0.OnRemoveLayer(arg0, arg1)
	return
end

function var0.onBackPressed(arg0)
	return false
end

function var0.UpdateFloor(arg0)
	return
end

function var0.SetActive(arg0, arg1, arg2)
	setActiveViaCG(arg1, arg2)
end

return var0
