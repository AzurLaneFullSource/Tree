local var0_0 = class("BuildShip", import(".BaseVO"))

var0_0.INACTIVE = 1
var0_0.ACTIVE = 2
var0_0.FINISH = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.type = arg1_1.build_id
	arg0_1.time = arg1_1.time
	arg0_1.finishTime = arg1_1.finish_time
	arg0_1.state = arg0_1.INACTIVE
end

function var0_0.setId(arg0_2, arg1_2)
	arg0_2.id = arg1_2
end

function var0_0.setState(arg0_3, arg1_3)
	arg0_3.state = arg1_3
end

function var0_0.isFinish(arg0_4)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_4.finishTime
end

function var0_0.finish(arg0_5)
	arg0_5.time = 0
	arg0_5.finishTime = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_5.state = arg0_5.FINISH
end

function var0_0.active(arg0_6)
	arg0_6.finishTime = pg.TimeMgr.GetInstance():GetServerTime() + arg0_6.time
	arg0_6.state = arg0_6.ACTIVE
end

function var0_0.setIsStart(arg0_7, arg1_7)
	arg0_7.isStart = arg1_7
end

function var0_0.getLeftTime(arg0_8)
	return arg0_8.finishTime - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.getBuildConsume(arg0_9, arg1_9, arg2_9)
	local var0_9 = pg.draw_data_template[arg0_9]
	local var1_9

	if arg1_9 == 1 then
		arg2_9 = math.min(arg2_9 + 1, #var0_9.use_gem_1)
		var1_9 = var0_9.use_gem_1[arg2_9]
	else
		arg2_9 = math.min(arg2_9 + 1, #var0_9.use_gem_10)
		var1_9 = var0_9.use_gem_10[arg2_9]
	end

	return var1_9
end

function var0_0.canBuildShipByBuildId(arg0_10, arg1_10, arg2_10)
	arg1_10 = arg1_10 or 1

	local var0_10 = pg.ship_data_create_material[arg0_10]

	if not var0_10 then
		return false, i18n("ship_buildShip_error_noTemplate", arg0_10)
	end

	local var1_10 = getProxy(BuildShipProxy):getData()

	if table.getCount(var1_10) + arg1_10 > MAX_BUILD_WORK_COUNT then
		return false, i18n("ship_buildShip_not_position")
	end

	if arg2_10 then
		local var2_10 = getProxy(ActivityProxy):getBuildFreeActivityByBuildId(arg0_10)
		local var3_10 = var2_10:getConfig("config_client")[1]
		local var4_10 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = var3_10
		}):getName()

		if not var2_10 or var2_10:isEnd() then
			return false, i18n("tip_build_ticket_expired", var4_10)
		elseif arg1_10 > var2_10.data1 then
			return false, i18n("tip_build_ticket_not_enough", var4_10)
		end
	else
		local var5_10 = {}
		local var6_10 = getProxy(PlayerProxy):getData()

		if var6_10.gold < var0_10.use_gold * arg1_10 then
			table.insert(var5_10, {
				59001,
				var0_10.use_gold * arg1_10 - var6_10.gold,
				var0_10.use_gold * arg1_10
			})
		end

		local var7_10 = getProxy(BagProxy):getData()

		if not var7_10[var0_10.use_item] or var7_10[var0_10.use_item].count < var0_10.number_1 * arg1_10 then
			local var8_10 = var0_10.number_1 * arg1_10
			local var9_10 = var0_10.use_item

			if var7_10[var0_10.use_item] then
				var8_10 = var0_10.number_1 * arg1_10 - var7_10[var9_10].count
			end

			table.insert(var5_10, {
				var9_10,
				var8_10,
				var0_10.number_1 * arg1_10
			})
		end

		if #var5_10 > 0 then
			return false, i18n("ship_buildShip_error_notEnoughItem"), var5_10
		end
	end

	return true
end

function var0_0.canQuickBuildShip(arg0_11)
	local var0_11 = getProxy(BuildShipProxy):getBuildShip(arg0_11)

	if not var0_11 then
		return false, i18n("ship_buildShipImmediately_error_noSHip")
	end

	if var0_11:isFinish() then
		return false, i18n("ship_buildShipImmediately_error_finished")
	end

	local var1_11 = getProxy(BagProxy):getItemById(ITEM_ID_EQUIP_QUICK_FINISH) or {
		count = 0
	}

	if var1_11.count <= 0 then
		local var2_11 = {
			{
				ITEM_ID_EQUIP_QUICK_FINISH,
				1 - var1_11.count,
				1
			}
		}

		return false, i18n("ship_buildShip_error_notEnoughItem"), var2_11
	end

	return true
end

function var0_0.getPageFromPoolType(arg0_12)
	local var0_12 = {
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

	for iter0_12, iter1_12 in pairs(var0_12) do
		if table.contains(iter1_12, arg0_12) then
			return iter0_12
		end
	end
end

return var0_0
