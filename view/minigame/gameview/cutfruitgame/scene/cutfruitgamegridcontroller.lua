local var0_0 = class("CutFruitGameGridController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._data = arg3_1
	arg0_1._gridTpl = findTF(arg1_1, "grids/grid_tpl")

	setActive(arg0_1._gridTpl, false)

	arg0_1._grids = {}
end

function var0_0.Prepare(arg0_2)
	arg0_2.boundsData = arg0_2._data:GetBoundsData(arg0_2._data:GetChapterConfig("bound"))
end

function var0_0.Start(arg0_3)
	return
end

function var0_0.Step(arg0_4)
	return
end

function var0_0.Stop(arg0_5)
	return
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0
