local var0 = class("BaseSubPanel", import("view.base.BaseSubView"))
local var1 = import("view.util.FuncBuffer")
local var2 = import("view.util.AutoLoader")

function var0.Ctor(arg0, arg1)
	assert(arg1, "NIL Parent View")

	local var0 = arg1 and arg1._tf
	local var1 = arg1 and isa(arg1, BaseEventLogic) and arg1.event or nil
	local var2 = {}

	var0.super.Ctor(arg0, var0, var1, var2)

	arg0.buffer = var1.New()
	arg0.loader = var2.New()
	arg0.viewParent = arg1
end

function var0.InvokeParent(arg0, arg1, ...)
	if arg0.viewParent then
		arg0.viewParent[arg1](arg0.viewParent, ...)
	end
end

function var0.Init(arg0)
	if arg0._state ~= var0.STATES.LOADED then
		return
	end

	arg0._state = var0.STATES.INITED

	arg0:OnInit()
	arg0:Show()
	arg0:HandleFuncQueue()
	arg0.buffer:SetNotifier(arg0)
	arg0.buffer:ExcuteAll()
end

function var0.Destroy(arg0)
	if arg0._state == var0.STATES.DESTROY then
		return
	end

	if not arg0:GetLoaded() then
		arg0._state = var0.STATES.DESTROY

		return
	end

	arg0._state = var0.STATES.DESTROY

	pg.DelegateInfo.Dispose(arg0)
	arg0:Hide()
	arg0:OnDestroy()
	arg0.loader:Clear()
	arg0.buffer:Clear()
	arg0:disposeEvent()
	arg0:cleanManagedTween()

	arg0._tf = nil

	local var0 = PoolMgr.GetInstance()
	local var1 = arg0:getUIName()

	if arg0._go ~= nil and var1 then
		var0:ReturnUI(var1, arg0._go)

		arg0._go = nil
	end
end

function var0.Hide(arg0)
	arg0:OnHide()
	var0.super.Hide(arg0)
end

function var0.RawHide(arg0)
	var0.super.Hide(arg0)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:OnShow()
end

function var0.RawShow(arg0)
	var0.super.Show(arg0)
end

function var0.IsShowing(arg0)
	return arg0:GetLoaded() and isActive(arg0._go)
end

function var0.IsHiding(arg0)
	return arg0:GetLoaded() and not isActive(arg0._go)
end

function var0.SetParent(arg0, arg1, ...)
	setParent(arg0._tf, arg1, ...)
end

function var0.OnShow(arg0)
	return
end

function var0.OnHide(arg0)
	return
end

return var0
