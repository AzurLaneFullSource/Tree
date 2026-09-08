local var0_0 = class("CourtYardReversePacmanStoreyModule", import(".CourtYardStoreyModule"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bg.localScale = Vector3(1, 1, 1)
end

function var0_0.GetDefaultBgm(arg0_2)
	return pg.voice_bgm.ReversePacmanHomeScene.default_bgm
end

function var0_0.InitPedestalModule(arg0_3)
	arg0_3.pedestalModule = CourtYardReversePacmanPedestalModule.New(arg0_3.data, arg0_3.bg)
end

return var0_0
