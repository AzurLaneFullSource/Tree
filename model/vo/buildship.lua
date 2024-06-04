local var0 = class("BuildShip", import(".BaseVO"))

var0.INACTIVE = 1
var0.ACTIVE = 2
var0.FINISH = 3

function var0.Ctor(arg0, arg1)
	arg0.type = arg1.build_id
	arg0.time = arg1.time
	arg0.finishTime = arg1.finish_time
	arg0.state = arg0.INACTIVE
end

function var0.setId(arg0, arg1)
	arg0.id = arg1
end

function var0.setState(arg0, arg1)
	arg0.state = arg1
end

function var0.isFinish(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.finishTime
end

function var0.finish(arg0)
	arg0.time = 0
	arg0.finishTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0.state = arg0.FINISH
end

function var0.active(arg0)
	arg0.finishTime = pg.TimeMgr.GetInstance():GetServerTime() + arg0.time
	arg0.state = arg0.ACTIVE
end

function var0.setIsStart(arg0, arg1)
	arg0.isStart = arg1
end

function var0.getLeftTime(arg0)
	return arg0.finishTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.getBuildConsume(arg0, arg1, arg2)
	local var0 = pg.draw_data_template[arg0]
	local var1

	if arg1 == 1 then
		arg2 = math.min(arg2 + 1, #var0.use_gem_1)
		var1 = var0.use_gem_1[arg2]
	else
		arg2 = math.min(arg2 + 1, #var0.use_gem_10)
		var1 = var0.use_gem_10[arg2]
	end

	return var1
end

function var0.canBuildShipByBuildId(arg0, arg1, arg2)
	arg1 = arg1 or 1

	local var0 = pg.ship_data_create_material[arg0]

	if not var0 then
		return false, i18n("ship_buildShip_error_noTemplate", arg0)
	end

	local var1 = getProxy(BuildShipProxy):getData()

	if table.getCount(var1) + arg1 > MAX_BUILD_WORK_COUNT then
		return false, i18n("ship_buildShip_not_position")
	end

	if arg2 then
		local var2 = getProxy(ActivityProxy):getBuildFreeActivityByBuildId(arg0)
		local var3 = var2:getConfig("config_client")[1]
		local var4 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = var3
		}):getName()

		if not var2 or var2:isEnd() then
			return false, i18n("tip_build_ticket_expired", var4)
		elseif arg1 > var2.data1 then
			return false, i18n("tip_build_ticket_not_enough", var4)
		end
	else
		local var5 = {}
		local var6 = getProxy(PlayerProxy):getData()

		if var6.gold < var0.use_gold * arg1 then
			table.insert(var5, {
				59001,
				var0.use_gold * arg1 - var6.gold,
				var0.use_gold * arg1
			})
		end

		local var7 = getProxy(BagProxy):getData()

		if not var7[var0.use_item] or var7[var0.use_item].count < var0.number_1 * arg1 then
			local var8 = var0.number_1 * arg1
			local var9 = var0.use_item

			if var7[var0.use_item] then
				var8 = var0.number_1 * arg1 - var7[var9].count
			end

			table.insert(var5, {
				var9,
				var8,
				var0.number_1 * arg1
			})
		end

		if #var5 > 0 then
			return false, i18n("ship_buildShip_error_notEnoughItem"), var5
		end
	end

	return true
end

function var0.canQuickBuildShip(arg0)
	local var0 = getProxy(BuildShipProxy):getBuildShip(arg0)

	if not var0 then
		return false, i18n("ship_buildShipImmediately_error_noSHip")
	end

	if var0:isFinish() then
		return false, i18n("ship_buildShipImmediately_error_finished")
	end

	local var1 = getProxy(BagProxy):getItemById(ITEM_ID_EQUIP_QUICK_FINISH) or {
		count = 0
	}

	if var1.count <= 0 then
		local var2 = {
			{
				ITEM_ID_EQUIP_QUICK_FINISH,
				1 - var1.count,
				1
			}
		}

		return false, i18n("ship_buildShip_error_notEnoughItem"), var2
	end

	return true
end

function var0.getPageFromPoolType(arg0)
	local var0 = {
		[BuildShipScene.PAGE_BUILD] = {
			1,
			2,
			3,
			4,
			5
		},
		[BuildShipScene.PAGE_PRAY] = {
			6,
			7,
			8
		},
		[BuildShipScene.PAGE_NEWSERVER] = {
			11
		}
	}

	for iter0, iter1 in pairs(var0) do
		if table.contains(iter1, arg0) then
			return iter0
		end
	end
end

return var0
