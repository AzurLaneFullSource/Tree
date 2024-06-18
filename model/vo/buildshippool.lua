local var0_0 = class("BuildShipPool", import(".BaseVO"))

var0_0.BUILD_POOL_MARK_SPECIAL = "special"
var0_0.BUILD_POOL_MARK_LIGHT = "light"
var0_0.BUILD_POOL_MARK_HEAVY = "heavy"
var0_0.BUILD_POOL_MARK_NEW = "new"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id

	assert(arg1_1.mark)

	arg0_1.mark = arg1_1.mark
end

function var0_0.bindConfigTable(arg0_2)
	return pg.ship_data_create_material
end

function var0_0.GetPoolId(arg0_3)
	return arg0_3.configId
end

function var0_0.GetSortCode(arg0_4)
	if arg0_4.mark == var0_0.BUILD_POOL_MARK_SPECIAL then
		return 4
	elseif arg0_4.mark == var0_0.BUILD_POOL_MARK_LIGHT then
		return 2
	elseif arg0_4.mark == var0_0.BUILD_POOL_MARK_HEAVY then
		return 3
	elseif arg0_4.mark == var0_0.BUILD_POOL_MARK_NEW then
		return 1
	else
		return 5
	end
end

function var0_0.IsActivity(arg0_5)
	return false
end

function var0_0.GetMark(arg0_6)
	return arg0_6.mark
end

return var0_0
