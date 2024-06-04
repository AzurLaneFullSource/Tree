local var0 = class("BuildShipPool", import(".BaseVO"))

var0.BUILD_POOL_MARK_SPECIAL = "special"
var0.BUILD_POOL_MARK_LIGHT = "light"
var0.BUILD_POOL_MARK_HEAVY = "heavy"
var0.BUILD_POOL_MARK_NEW = "new"

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id

	assert(arg1.mark)

	arg0.mark = arg1.mark
end

function var0.bindConfigTable(arg0)
	return pg.ship_data_create_material
end

function var0.GetPoolId(arg0)
	return arg0.configId
end

function var0.GetSortCode(arg0)
	if arg0.mark == var0.BUILD_POOL_MARK_SPECIAL then
		return 4
	elseif arg0.mark == var0.BUILD_POOL_MARK_LIGHT then
		return 2
	elseif arg0.mark == var0.BUILD_POOL_MARK_HEAVY then
		return 3
	elseif arg0.mark == var0.BUILD_POOL_MARK_NEW then
		return 1
	else
		return 5
	end
end

function var0.IsActivity(arg0)
	return false
end

function var0.GetMark(arg0)
	return arg0.mark
end

return var0
