pg = pg or {}
pg.Live2DMgr = singletonClass("Live2DMgr")

local var0 = pg.Live2DMgr

function var0.Ctor(arg0)
	arg0.loader = AutoLoader.New()
end

function var0.GetLive2DModelAsync(arg0, arg1, arg2)
	return (arg0.loader:LoadLive2D(arg1, arg2))
end

function var0.StopLoadingLive2d(arg0, arg1)
	arg0.loader:ClearRequest(arg1)
end
