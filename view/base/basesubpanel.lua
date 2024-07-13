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

function var0_0.InvokeParent(arg0_2, arg1_2, ...)
	if arg0_2.viewParent then
		arg0_2.viewParent[arg1_2](arg0_2.viewParent, ...)
	end
end

function var0_0.Init(arg0_3)
	if arg0_3._state ~= var0_0.STATES.LOADED then
		return
	end

	arg0_3._state = var0_0.STATES.INITED

	arg0_3:OnInit()
	arg0_3:Show()
	arg0_3:HandleFuncQueue()
	arg0_3.buffer:SetNotifier(arg0_3)
	arg0_3.buffer:ExcuteAll()
end

function var0_0.Destroy(arg0_4)
	if arg0_4._state == var0_0.STATES.DESTROY then
		return
	end

	if not arg0_4:GetLoaded() then
		arg0_4._state = var0_0.STATES.DESTROY

		return
	end

	arg0_4._state = var0_0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0_4)
	arg0_4:Hide()
	arg0_4:OnDestroy()
	arg0_4.loader:Clear()
	arg0_4.buffer:Clear()
	arg0_4:disposeEvent()
	arg0_4:cleanManagedTween()

	arg0_4._tf = nil

	local var0_4 = PoolMgr.GetInstance()
	local var1_4 = arg0_4:getUIName()

	if arg0_4._go ~= nil and var1_4 then
		var0_4:ReturnUI(var1_4, arg0_4._go)

		arg0_4._go = nil
	end
end

function var0_0.Hide(arg0_5)
	arg0_5:OnHide()
	var0_0.super.Hide(arg0_5)
end

function var0_0.RawHide(arg0_6)
	var0_0.super.Hide(arg0_6)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)
	arg0_7:OnShow()
end

function var0_0.RawShow(arg0_8)
	var0_0.super.Show(arg0_8)
end

function var0_0.IsShowing(arg0_9)
	return arg0_9:GetLoaded() and isActive(arg0_9._go)
end

function var0_0.IsHiding(arg0_10)
	return arg0_10:GetLoaded() and not isActive(arg0_10._go)
end

function var0_0.SetParent(arg0_11, arg1_11, ...)
	setParent(arg0_11._tf, arg1_11, ...)
end

function var0_0.OnShow(arg0_12)
	return
end

function var0_0.OnHide(arg0_13)
	return
end

return var0_0
