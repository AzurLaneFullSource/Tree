local var0_0 = class("GuildBasePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	local var0_1, var1_1 = arg0_1:getTargetUI()
	local var2_1 = getProxy(GuildProxy):getRawData()

	if not var2_1 then
		return arg0_1.uiname
	end

	local var3_1 = var2_1:getFaction()

	if var3_1 == GuildConst.FACTION_TYPE_BLHX then
		arg0_1.uiname = var0_1
	elseif var3_1 == GuildConst.FACTION_TYPE_CSZZ then
		arg0_1.uiname = var1_1
	end

	return arg0_1.uiname
end

function var0_0.getTargetUI(arg0_2)
	assert(false)
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
	arg0_3:OnDestroy()
	arg0_3:disposeEvent()
	arg0_3:cleanManagedTween()

	arg0_3._tf = nil

	local var0_3 = PoolMgr.GetInstance()
	local var1_3 = arg0_3.uiname

	if arg0_3._go ~= nil and var1_3 then
		var0_3:ReturnUI(var1_3, arg0_3._go)

		arg0_3._go = nil
	end
end

return var0_0
