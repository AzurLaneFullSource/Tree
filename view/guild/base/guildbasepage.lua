local var0 = class("GuildBasePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	local var0, var1 = arg0:getTargetUI()
	local var2 = getProxy(GuildProxy):getRawData()

	if not var2 then
		return arg0.uiname
	end

	local var3 = var2:getFaction()

	if var3 == GuildConst.FACTION_TYPE_BLHX then
		arg0.uiname = var0
	elseif var3 == GuildConst.FACTION_TYPE_CSZZ then
		arg0.uiname = var1
	end

	return arg0.uiname
end

function var0.getTargetUI(arg0)
	assert(false)
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
	arg0:OnDestroy()
	arg0:disposeEvent()
	arg0:cleanManagedTween()

	arg0._tf = nil

	local var0 = PoolMgr.GetInstance()
	local var1 = arg0.uiname

	if arg0._go ~= nil and var1 then
		var0:ReturnUI(var1, arg0._go)

		arg0._go = nil
	end
end

return var0
