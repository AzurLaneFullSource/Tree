local var0_0 = class("BackYardSystemTheme", import(".BackYardSelfThemeTemplate"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.level = 1
	arg0_1.order = arg0_1:getConfig("order")
end

function var0_0.GetRawPutList(arg0_2)
	arg0_2:CheckLevel()

	local var0_2 = getProxy(DormProxy):getRawData().level

	if not arg0_2.putInfo then
		local var1_2

		pcall(function()
			var1_2 = require("GameCfg.backyardTheme.theme_" .. arg0_2.id)
		end)

		var1_2 = var1_2 or require("GameCfg.backyardTheme.theme_empty")

		local var2_2 = var1_2["furnitures_" .. var0_2] or {}

		arg0_2.putInfo = _.select(var2_2, function(arg0_4)
			return pg.furniture_data_template[arg0_4.id]
		end)
	end

	return arg0_2.putInfo
end

function var0_0.CheckLevel(arg0_5)
	local var0_5 = getProxy(DormProxy):getRawData().level

	if arg0_5.level ~= var0_5 then
		arg0_5.furnitruesByIds = nil
		arg0_5.putInfo = nil
		arg0_5.level = var0_5
	end
end

function var0_0.GetAllFurniture(arg0_6)
	arg0_6:CheckLevel()

	local var0_6 = not arg0_6.furnitruesByIds

	var0_0.super.GetAllFurniture(arg0_6)

	if var0_6 then
		arg0_6:CheckData()
	end

	return arg0_6.furnitruesByIds
end

function var0_0.GetWarpFurnitures(arg0_7)
	arg0_7:CheckLevel()

	return var0_0.super.GetWarpFurnitures(arg0_7)
end

function var0_0.CheckData(arg0_8)
	local var0_8 = getProxy(DormProxy):getRawData()
	local var1_8 = {}
	local var2_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.furnitruesByIds) do
		if not var0_8:IsPurchasedFurniture(iter1_8.configId) then
			if iter1_8.parent ~= 0 then
				table.insert(var2_8, {
					pid = iter1_8.parent,
					id = iter0_8
				})
			elseif table.getCount(iter1_8.child) > 0 then
				for iter2_8, iter3_8 in pairs(iter1_8.child) do
					table.insert(var1_8, iter2_8)
				end
			end

			table.insert(var1_8, iter0_8)
		end
	end

	local var3_8 = #var1_8 > 0 or #var2_8 > 0

	for iter4_8, iter5_8 in ipairs(var1_8) do
		arg0_8.furnitruesByIds[iter5_8] = nil
	end

	for iter6_8, iter7_8 in pairs(var2_8) do
		local var4_8 = arg0_8.furnitruesByIds[iter7_8.pid]

		if var4_8 then
			for iter8_8, iter9_8 in pairs(var4_8.child) do
				if iter8_8 == iter7_8.id then
					var4_8.child[iter7_8.id] = nil

					break
				end
			end
		end
	end

	return var3_8
end

function var0_0.bindConfigTable(arg0_9)
	return pg.backyard_theme_template
end

function var0_0.IsOverTime(arg0_10)
	local var0_10 = pg.furniture_shop_template
	local var1_10 = arg0_10:getConfig("ids")

	return _.all(var1_10, function(arg0_11)
		return not var0_10[arg0_11] or not pg.TimeMgr.GetInstance():inTime(var0_10[arg0_11].time)
	end)
end

function var0_0.GetFurnitures(arg0_12)
	return arg0_12:getConfig("ids")
end

function var0_0.HasDiscount(arg0_13)
	local var0_13 = arg0_13:GetFurnitures()

	return _.any(var0_13, function(arg0_14)
		local var0_14 = Furniture.New({
			id = arg0_14
		})

		return var0_14:getConfig("dorm_icon_price") > var0_14:getPrice(PlayerConst.ResDormMoney)
	end)
end

function var0_0.GetDiscount(arg0_15)
	local var0_15 = arg0_15:GetFurnitures()
	local var1_15 = _.map(var0_15, function(arg0_16)
		return Furniture.New({
			id = arg0_16
		})
	end)
	local var2_15 = _.reduce(var1_15, 0, function(arg0_17, arg1_17)
		return arg0_17 + arg1_17:getPrice(PlayerConst.ResDormMoney)
	end)
	local var3_15 = _.reduce(var1_15, 0, function(arg0_18, arg1_18)
		return arg0_18 + arg1_18:getConfig("dorm_icon_price")
	end)

	return (var3_15 - var2_15) / var3_15 * 100
end

function var0_0.IsPurchased(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19:getConfig("ids")) do
		if not arg1_19[iter1_19] then
			return false
		end
	end

	return true
end

function var0_0.GetName(arg0_20)
	return arg0_20:getConfig("name")
end

function var0_0.GetDesc(arg0_21)
	return arg0_21:getConfig("desc")
end

function var0_0.IsSystem(arg0_22)
	return true
end

function var0_0.getName(arg0_23)
	return arg0_23:GetName()
end

function var0_0.getIcon(arg0_24)
	return arg0_24:getConfig("icon")
end

function var0_0.isUnLock(arg0_25, arg1_25)
	return arg0_25:getConfig("deblocking") <= arg1_25.level
end

return var0_0
