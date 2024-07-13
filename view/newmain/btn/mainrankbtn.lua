local var0_0 = class("MainRankBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.BILLBOARD, {
		index = PowerRank.TYPE_POWER
	})
end

function var0_0.Flush(arg0_2)
	local var0_2 = arg0_2:IsActive()

	setActive(arg0_2._tf, var0_2)
end

function var0_0.IsActive(arg0_3)
	return getProxy(PlayerProxy):getRawData().level >= pg.open_systems_limited[6].level
end

return var0_0
