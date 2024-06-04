local var0 = class("CourtYardFeastStoreyModule", import(".CourtYardStoreyModule"))

function var0.GetDefaultBgm(arg0)
	return pg.voice_bgm.FeastScene.default_bgm
end

function var0.InitPedestalModule(arg0)
	arg0.pedestalModule = CourtYardFeastPedestalModule.New(arg0.data, arg0.bg)
end

return var0
