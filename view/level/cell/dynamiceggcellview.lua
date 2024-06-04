local var0 = import(".DynamicCellView")
local var1 = import(".EggCellView")
local var2 = class("DynamicEggCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0, arg1)
	var0.Ctor(arg0, arg1)
	var1.Ctor(arg0)
	var1.InitEggCellTransform(arg0)
end

function var2.GetOrder(arg0)
	return ChapterConst.CellPriorityEnemy
end

function var2.SetActive(arg0, arg1)
	setActive(arg0.go, arg1)
end

function var2.LoadIcon(arg0, arg1, arg2, arg3)
	if arg0.lastPrefab == arg1 then
		existCall(arg3)

		return
	end

	arg0.lastPrefab = arg1

	var1.StartEggCellView(arg0, arg2, arg3)
end

function var2.UpdateChampionCell(arg0, arg1, arg2, arg3)
	var1.UpdateEggCell(arg0, arg1, arg2, arg2:getConfigTable(), arg3)
	arg0:RefreshLinePosition(arg1, arg2)
end

return var2
