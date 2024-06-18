local var0_0 = import(".DynamicCellView")
local var1_0 = import(".EggCellView")
local var2_0 = class("DynamicEggCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1, arg1_1)
	var0_0.Ctor(arg0_1, arg1_1)
	var1_0.Ctor(arg0_1)
	var1_0.InitEggCellTransform(arg0_1)
end

function var2_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityEnemy
end

function var2_0.SetActive(arg0_3, arg1_3)
	setActive(arg0_3.go, arg1_3)
end

function var2_0.LoadIcon(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg0_4.lastPrefab == arg1_4 then
		existCall(arg3_4)

		return
	end

	arg0_4.lastPrefab = arg1_4

	var1_0.StartEggCellView(arg0_4, arg2_4, arg3_4)
end

function var2_0.UpdateChampionCell(arg0_5, arg1_5, arg2_5, arg3_5)
	var1_0.UpdateEggCell(arg0_5, arg1_5, arg2_5, arg2_5:getConfigTable(), arg3_5)
	arg0_5:RefreshLinePosition(arg1_5, arg2_5)
end

return var2_0
