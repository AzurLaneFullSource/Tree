local var0 = class("MainRankBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.BILLBOARD, {
		index = PowerRank.TYPE_POWER
	})
end

function var0.Flush(arg0)
	local var0 = arg0:IsActive()

	setActive(arg0._tf, var0)
end

function var0.IsActive(arg0)
	return getProxy(PlayerProxy):getRawData().level >= pg.open_systems_limited[6].level
end

return var0
