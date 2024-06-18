pg = pg or {}
pg.Live2DMgr = singletonClass("Live2DMgr")

local var0_0 = pg.Live2DMgr

function var0_0.Ctor(arg0_1)
	arg0_1.loader = AutoLoader.New()
end

function var0_0.GetLive2DModelAsync(arg0_2, arg1_2, arg2_2)
	return (arg0_2.loader:LoadLive2D(arg1_2, arg2_2))
end

function var0_0.StopLoadingLive2d(arg0_3, arg1_3)
	arg0_3.loader:ClearRequest(arg1_3)
end
