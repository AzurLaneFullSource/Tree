local var0_0 = class("CourtYardFeastStoreyModule", import(".CourtYardStoreyModule"))

function var0_0.GetDefaultBgm(arg0_1)
	return pg.voice_bgm.FeastScene.default_bgm
end

function var0_0.InitPedestalModule(arg0_2)
	arg0_2.pedestalModule = CourtYardFeastPedestalModule.New(arg0_2.data, arg0_2.bg)
end

return var0_0
