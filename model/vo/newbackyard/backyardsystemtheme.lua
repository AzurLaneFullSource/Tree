local var0 = class("BackYardSystemTheme", import(".BackYardSelfThemeTemplate"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.level = 1
	arg0.order = arg0:getConfig("order")
end

function var0.GetRawPutList(arg0)
	arg0:CheckLevel()

	local var0 = getProxy(DormProxy):getRawData().level

	if not arg0.putInfo then
		local var1

		pcall(function()
			var1 = require("GameCfg.backyardTheme.theme_" .. arg0.id)
		end)

		var1 = var1 or require("GameCfg.backyardTheme.theme_empty")

		local var2 = var1["furnitures_" .. var0] or {}

		arg0.putInfo = _.select(var2, function(arg0)
			return pg.furniture_data_template[arg0.id]
		end)
	end

	return arg0.putInfo
end

function var0.CheckLevel(arg0)
	local var0 = getProxy(DormProxy):getRawData().level

	if arg0.level ~= var0 then
		arg0.furnitruesByIds = nil
		arg0.putInfo = nil
		arg0.level = var0
	end
end

function var0.GetAllFurniture(arg0)
	arg0:CheckLevel()

	local var0 = not arg0.furnitruesByIds

	var0.super.GetAllFurniture(arg0)

	if var0 then
		arg0:CheckData()
	end

	return arg0.furnitruesByIds
end

function var0.GetWarpFurnitures(arg0)
	arg0:CheckLevel()

	return var0.super.GetWarpFurnitures(arg0)
end

function var0.CheckData(arg0)
	local var0 = getProxy(DormProxy):getRawData()
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in pairs(arg0.furnitruesByIds) do
		if not var0:IsPurchasedFurniture(iter1.configId) then
			if iter1.parent ~= 0 then
				table.insert(var2, {
					pid = iter1.parent,
					id = iter0
				})
			elseif table.getCount(iter1.child) > 0 then
				for iter2, iter3 in pairs(iter1.child) do
					table.insert(var1, iter2)
				end
			end

			table.insert(var1, iter0)
		end
	end

	local var3 = #var1 > 0 or #var2 > 0

	for iter4, iter5 in ipairs(var1) do
		arg0.furnitruesByIds[iter5] = nil
	end

	for iter6, iter7 in pairs(var2) do
		local var4 = arg0.furnitruesByIds[iter7.pid]

		if var4 then
			for iter8, iter9 in pairs(var4.child) do
				if iter8 == iter7.id then
					var4.child[iter7.id] = nil

					break
				end
			end
		end
	end

	return var3
end

function var0.bindConfigTable(arg0)
	return pg.backyard_theme_template
end

function var0.IsOverTime(arg0)
	local var0 = pg.furniture_shop_template
	local var1 = arg0:getConfig("ids")

	return _.all(var1, function(arg0)
		return not var0[arg0] or not pg.TimeMgr.GetInstance():inTime(var0[arg0].time)
	end)
end

function var0.GetFurnitures(arg0)
	return arg0:getConfig("ids")
end

function var0.HasDiscount(arg0)
	local var0 = arg0:GetFurnitures()

	return _.any(var0, function(arg0)
		local var0 = Furniture.New({
			id = arg0
		})

		return var0:getConfig("dorm_icon_price") > var0:getPrice(PlayerConst.ResDormMoney)
	end)
end

function var0.GetDiscount(arg0)
	local var0 = arg0:GetFurnitures()
	local var1 = _.map(var0, function(arg0)
		return Furniture.New({
			id = arg0
		})
	end)
	local var2 = _.reduce(var1, 0, function(arg0, arg1)
		return arg0 + arg1:getPrice(PlayerConst.ResDormMoney)
	end)
	local var3 = _.reduce(var1, 0, function(arg0, arg1)
		return arg0 + arg1:getConfig("dorm_icon_price")
	end)

	return (var3 - var2) / var3 * 100
end

function var0.IsPurchased(arg0, arg1)
	for iter0, iter1 in ipairs(arg0:getConfig("ids")) do
		if not arg1[iter1] then
			return false
		end
	end

	return true
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("desc")
end

function var0.IsSystem(arg0)
	return true
end

function var0.getName(arg0)
	return arg0:GetName()
end

function var0.getIcon(arg0)
	return arg0:getConfig("icon")
end

function var0.isUnLock(arg0, arg1)
	return arg0:getConfig("deblocking") <= arg1.level
end

return var0
