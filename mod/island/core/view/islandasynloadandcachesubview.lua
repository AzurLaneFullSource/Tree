local var0_0 = class("IslandASynLoadAndCacheSubView", import(".IslandASynLoadSubView"))

function var0_0.LoadUI(arg0_1, arg1_1)
	arg0_1:GetPoolMgr():GetUI(arg0_1:GetUIName(), function(arg0_2)
		local var0_2 = arg0_1:SetUIParent()

		setParent(arg0_2, var0_2)
		arg1_1(arg0_2)
	end)
end

function var0_0.UnloadUI(arg0_3)
	if not arg0_3._go then
		return
	end

	arg0_3:GetPoolMgr():ReturnUI(arg0_3:GetUIName(), arg0_3._go)
end

return var0_0
