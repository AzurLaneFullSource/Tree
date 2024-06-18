local var0_0 = class("CourtYardBasePanel", import("...base.BasePanel"))
local var1_0 = 0.5
local var2_0 = 0
local var3_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.state = var2_0

	local var0_1 = arg0_1:GetUIName()
	local var1_1 = arg1_1._tf:Find(var0_1)

	arg0_1._go = var1_1.gameObject
	arg0_1._tf = var1_1
	arg0_1.contextData = arg1_1.contextData

	arg0_1:Attach(arg1_1)
end

function var0_0.Attach(arg0_2, arg1_2)
	var0_0.super.attach(arg0_2, arg1_2)
	arg0_2:init()
	arg0_2:Active()

	arg0_2.state = var3_0
end

function var0_0.Active(arg0_3)
	if arg0_3:IsVisit() then
		arg0_3:OnVisitRegister()
	else
		arg0_3:OnRegister()
	end
end

function var0_0.Detach(arg0_4)
	if arg0_4.state == var3_0 then
		arg0_4.state = var2_0

		var0_0.super.detach(arg0_4)
	end

	arg0_4:OnDispose()
end

function var0_0.Fold(arg0_5, arg1_5)
	local var0_5 = arg0_5:GetMoveX()
	local var1_5 = arg0_5:GetMoveY()

	if _.any(var1_5, function(arg0_6)
		return LeanTween.isTweening(go(arg0_6[1]))
	end) or _.any(var0_5, function(arg0_7)
		return LeanTween.isTweening(go(arg0_7[1]))
	end) then
		return
	end

	_.each(var0_5, function(arg0_8)
		local var0_8 = 0

		if arg1_5 then
			var0_8 = arg0_8[1].anchoredPosition3D.x + arg0_8[1].rect.width * arg0_8[2]
		end

		arg0_5:Tween("moveX", arg1_5, arg0_8[1], var0_8)
	end)
	_.each(var1_5, function(arg0_9)
		local var0_9 = 0

		if arg1_5 then
			var0_9 = arg0_9[1].anchoredPosition3D.y + arg0_9[1].rect.height * arg0_9[2]
		end

		arg0_5:Tween("moveY", arg1_5, arg0_9[1], var0_9)
	end)
end

function var0_0.Flush(arg0_10, arg1_10, arg2_10)
	if arg0_10.state == var3_0 then
		arg0_10.dorm = arg1_10

		if arg0_10:IsVisit() then
			arg0_10:OnVisitFlush()
		else
			arg0_10:OnFlush(arg2_10)
		end
	end
end

function var0_0.GetMoveX(arg0_11)
	return {}
end

function var0_0.GetMoveY(arg0_12)
	return {}
end

function var0_0.Tween(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	LeanTween[arg1_13](arg3_13, arg4_13, var1_0):setOnComplete(System.Action(function()
		if arg2_13 then
			setActive(arg3_13, false)
		end
	end)):setOnStart(System.Action(function()
		if not arg2_13 then
			setActive(arg3_13, true)
		end
	end))
end

function var0_0.IsInner(arg0_16)
	local var0_16 = arg0_16.contextData.floor

	return var0_16 == 1 or var0_16 == 2
end

function var0_0.OnEnterOrExitEdit(arg0_17, arg1_17)
	if arg1_17 then
		arg0_17:OnEnterEditMode()
	else
		arg0_17:OnExitEditMode()
	end
end

function var0_0.IsVisit(arg0_18)
	return arg0_18.contextData.mode == CourtYardConst.SYSTEM_VISIT
end

function var0_0.OnEnterEditMode(arg0_19)
	setActive(arg0_19._tf, false)
end

function var0_0.OnExitEditMode(arg0_20)
	setActive(arg0_20._tf, true)
end

function var0_0.GetUIName(arg0_21)
	assert(false)
end

function var0_0.OnRegister(arg0_22)
	return
end

function var0_0.OnVisitRegister(arg0_23)
	return
end

function var0_0.OnDispose(arg0_24)
	return
end

function var0_0.OnVisitFlush(arg0_25)
	return
end

function var0_0.OnFlush(arg0_26, arg1_26)
	return
end

function var0_0.OnRemoveLayer(arg0_27, arg1_27)
	return
end

function var0_0.onBackPressed(arg0_28)
	return false
end

function var0_0.UpdateFloor(arg0_29)
	return
end

function var0_0.SetActive(arg0_30, arg1_30, arg2_30)
	setActiveViaCG(arg1_30, arg2_30)
end

return var0_0
