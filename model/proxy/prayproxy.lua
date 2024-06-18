local var0_0 = class("Prayproxy", import(".NetProxy"))

var0_0.STATE_HOME = 1
var0_0.STATE_SELECT_POOL = 2
var0_0.STAGE_SELECT_SHIP = 3
var0_0.STAGE_BUILD_SUCCESS = 4

function var0_0.register(arg0_1)
	arg0_1.selectedPoolType = nil
	arg0_1.selectedShipCount = 0
	arg0_1.needSelectShipCount = nil
	arg0_1.selectedShipIDList = {}
	arg0_1.pageState = var0_0.STATE_HOME
	arg0_1.tagConstructed = false
end

function var0_0.setSelectedPoolNum(arg0_2, arg1_2)
	arg0_2.selectedPoolType = arg1_2
end

function var0_0.setSelectedShipList(arg0_3, arg1_3)
	arg0_3.selectedShipIDList = arg1_3
end

function var0_0.updateSelectedPool(arg0_4, arg1_4)
	arg0_4.selectedPoolType = arg1_4
	arg0_4.needSelectShipCount = pg.activity_ship_create[arg1_4].pickup_num
	arg0_4.selectedShipCount = 0
	arg0_4.selectedShipIDList = {}
end

function var0_0.updatePageState(arg0_5, arg1_5)
	if arg1_5 ~= var0_0.STATE_HOME and arg1_5 ~= var0_0.STATE_SELECT_POOL and arg1_5 ~= var0_0.STAGE_SELECT_SHIP and arg1_5 ~= var0_0.STAGE_BUILD_SUCCESS then
		assert(false, "没有定义的pageState参数" .. arg1_5)
	end

	arg0_5.pageState = arg1_5
end

function var0_0.insertSelectedShipIDList(arg0_6, arg1_6)
	if arg0_6.selectedShipCount == arg0_6.needSelectShipCount then
		assert(false, "已选舰娘已经达到上限,不允许插入")
	end

	arg0_6.selectedShipIDList[#arg0_6.selectedShipIDList + 1] = arg1_6
	arg0_6.selectedShipCount = arg0_6.selectedShipCount + 1
end

function var0_0.removeSelectedShipIDList(arg0_7, arg1_7)
	if arg0_7.selectedShipCount == 0 then
		assert(false, "没有已选舰娘,不允许删除")
	end

	local var0_7

	for iter0_7, iter1_7 in ipairs(arg0_7.selectedShipIDList) do
		if iter1_7 == arg1_7 then
			var0_7 = iter0_7

			table.remove(arg0_7.selectedShipIDList, iter0_7)

			arg0_7.selectedShipCount = arg0_7.selectedShipCount - 1
		end
	end

	if not var0_7 then
		assert(false, "已选列表不存在该ID的舰娘")
	end
end

function var0_0.getPageState(arg0_8)
	return arg0_8.pageState
end

function var0_0.getSelectedPoolType(arg0_9)
	return arg0_9.selectedPoolType
end

function var0_0.getSelectedShipIDList(arg0_10)
	return arg0_10.selectedShipIDList
end

function var0_0.getSelectedShipCount(arg0_11)
	return arg0_11.selectedShipCount
end

return var0_0
