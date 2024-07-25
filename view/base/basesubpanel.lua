local var0_0 = class("BaseSubPanel", import("view.base.BaseSubView"))
local var1_0 = import("view.util.FuncBuffer")
local var2_0 = import("view.util.AutoLoader")

function var0_0.Ctor(arg0_1, arg1_1)
	assert(arg1_1, "NIL Parent View")

	local var0_1 = arg1_1 and arg1_1._tf
	local var1_1 = arg1_1 and isa(arg1_1, BaseEventLogic) and arg1_1.event or nil
	local var2_1 = {}

	var0_0.super.Ctor(arg0_1, var0_1, var1_1, var2_1)

	arg0_1.buffer = var1_0.New()
	arg0_1.loader = var2_0.New()
	arg0_1.viewParent = arg1_1
end

function var0_0.Init(arg0_2)
	if arg0_2._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_2._state = var0_0.STATES.INITED

	arg0_2:OnInit()
	arg0_2:Show()
	arg0_2:HandleFuncQueue()
	arg0_2.buffer:SetNotifier(arg0_2)
	arg0_2.buffer:ExcuteAll()
end

function var0_0.Destroy(arg0_3)
	if arg0_3._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_3:GetLoaded() then
		arg0_3._state = var0_0.STATES.DESTROY

		return
	end

	arg0_3._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_3)
	arg0_3:Hide()
	arg0_3:OnDestroy()
	arg0_3.loader:Clear()
	arg0_3.buffer:Clear()
	arg0_3:disposeEvent()
	arg0_3:cleanManagedTween()

	arg0_3._tf = nil

	local var0_3 = PoolMgr.GetInstance()
	local var1_3 = arg0_3:getUIName()

	if arg0_3._go ~= nil and var1_3 then
		var0_3:ReturnUI(var1_3, arg0_3._go)

		arg0_3._go = nil
	end
end

function var0_0.Hide(arg0_4)
	arg0_4:OnHide()
	var0_0.super.Hide(arg0_4)
end

function var0_0.RawHide(arg0_5)
	var0_0.super.Hide(arg0_5)
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)
	arg0_6:OnShow()
end

function var0_0.RawShow(arg0_7)
	var0_0.super.Show(arg0_7)
end

function var0_0.IsShowing(arg0_8)
	return arg0_8:GetLoaded() and isActive(arg0_8._go)
end

function var0_0.IsHiding(arg0_9)
	return arg0_9:GetLoaded() and not isActive(arg0_9._go)
end

function var0_0.SetParent(arg0_10, arg1_10, ...)
	setParent(arg0_10._tf, arg1_10, ...)
end

function var0_0.OnShow(arg0_11)
	return
end

function var0_0.OnHide(arg0_12)
	return
end

return var0_0
