local var0 = class("Prayproxy", import(".NetProxy"))

var0.STATE_HOME = 1
var0.STATE_SELECT_POOL = 2
var0.STAGE_SELECT_SHIP = 3
var0.STAGE_BUILD_SUCCESS = 4

function var0.register(arg0)
	arg0.selectedPoolType = nil
	arg0.selectedShipCount = 0
	arg0.needSelectShipCount = nil
	arg0.selectedShipIDList = {}
	arg0.pageState = var0.STATE_HOME
	arg0.tagConstructed = false
end

function var0.setSelectedPoolNum(arg0, arg1)
	arg0.selectedPoolType = arg1
end

function var0.setSelectedShipList(arg0, arg1)
	arg0.selectedShipIDList = arg1
end

function var0.updateSelectedPool(arg0, arg1)
	arg0.selectedPoolType = arg1
	arg0.needSelectShipCount = pg.activity_ship_create[arg1].pickup_num
	arg0.selectedShipCount = 0
	arg0.selectedShipIDList = {}
end

function var0.updatePageState(arg0, arg1)
	if arg1 ~= var0.STATE_HOME and arg1 ~= var0.STATE_SELECT_POOL and arg1 ~= var0.STAGE_SELECT_SHIP and arg1 ~= var0.STAGE_BUILD_SUCCESS then
		assert(false, "没有定义的pageState参数" .. arg1)
	end

	arg0.pageState = arg1
end

function var0.insertSelectedShipIDList(arg0, arg1)
	if arg0.selectedShipCount == arg0.needSelectShipCount then
		assert(false, "已选舰娘已经达到上限,不允许插入")
	end

	arg0.selectedShipIDList[#arg0.selectedShipIDList + 1] = arg1
	arg0.selectedShipCount = arg0.selectedShipCount + 1
end

function var0.removeSelectedShipIDList(arg0, arg1)
	if arg0.selectedShipCount == 0 then
		assert(false, "没有已选舰娘,不允许删除")
	end

	local var0

	for iter0, iter1 in ipairs(arg0.selectedShipIDList) do
		if iter1 == arg1 then
			var0 = iter0

			table.remove(arg0.selectedShipIDList, iter0)

			arg0.selectedShipCount = arg0.selectedShipCount - 1
		end
	end

	if not var0 then
		assert(false, "已选列表不存在该ID的舰娘")
	end
end

function var0.getPageState(arg0)
	return arg0.pageState
end

function var0.getSelectedPoolType(arg0)
	return arg0.selectedPoolType
end

function var0.getSelectedShipIDList(arg0)
	return arg0.selectedShipIDList
end

function var0.getSelectedShipCount(arg0)
	return arg0.selectedShipCount
end

return var0
