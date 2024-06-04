local var0 = class("BackYardSelfThemeTemplate", import(".BackYardBaseThemeTemplate"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1)

	arg0.floor = arg2 or 1
end

function var0.GetAllFurniture(arg0)
	if not arg0.furnitruesByIds then
		local var0 = arg0:GetRawPutList()

		arg0.furnitruesByIds = arg0:InitFurnitures({
			mapSize = arg0:GetMapSize(),
			floor = arg0.floor,
			furniture_put_list = var0
		})
	end

	return arg0.furnitruesByIds
end

function var0.AddFurniture(arg0, arg1, arg2)
	local var0 = arg0:GetAllFurniture()
	local var1 = {}

	for iter0, iter1 in pairs(arg1.child) do
		var1[iter0] = iter1
	end

	local var2 = BackyardThemeFurniture.New({
		isNewStyle = true,
		id = arg1.id,
		configId = arg1.configId,
		position = Vector2(arg1.x, arg1.y),
		dir = arg1.dir,
		child = var1,
		parent = arg1.parent,
		floor = arg2
	})

	var0[arg1.id] = var2

	return var2
end

function var0.DeleteFurniture(arg0, arg1)
	local var0 = arg0:GetAllFurniture()

	if var0[arg1] then
		var0[arg1] = nil
	end
end

function var0.GetFurniture(arg0, arg1)
	return arg0:GetAllFurniture()[arg1]
end

function var0.GetType(arg0)
	return BackYardConst.THEME_TEMPLATE_USAGE_TYPE_SELF
end

function var0.IsSystem(arg0)
	return false
end

function var0.IsCollected(arg0)
	return true
end

function var0.IsLiked(arg0)
	return true
end

function var0.UnLoad(arg0)
	arg0.time = 0
end

function var0.Upload(arg0)
	arg0.time = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.CanDispaly(arg0)
	local var0 = arg0:IsPushed()

	return var0 or not var0 and arg0:ExistLocalImage()
end

function var0.IsUsing(arg0, arg1)
	local var0 = arg0:GetWarpFurnitures()
	local var1 = table.getCount(arg1)
	local var2 = table.getCount(var0)

	if var1 ~= var2 then
		return false, Vector2(var1, var2)
	end

	local var3 = {}

	for iter0, iter1 in pairs(arg1) do
		if arg0:IsSystem() and iter1:getConfig("themeId") ~= arg0.id then
			return false, 0
		end

		local var4 = iter1:getConfig("id")

		if not var3[var4] then
			var3[var4] = {}
		end

		table.insert(var3[var4], iter1)
	end

	for iter2, iter3 in pairs(var0) do
		local var5 = arg1[iter3.id]

		if not var5 then
			return false, 1
		end

		if not var5:isPaper() then
			if not var5.position then
				return false, 2
			end

			local var6 = var3[iter3.id] or {}
			local var7 = false

			for iter4, iter5 in ipairs(var6) do
				if iter5:isSame(iter3) then
					var7 = true

					break
				end
			end

			if not var7 then
				return false, 3
			end
		end
	end

	return true
end

function var0.GetMissFurnitures(arg0, arg1)
	local var0 = arg0:GetWarpFurnitures()

	if #arg1 == #var0 then
		return
	end

	local var1 = {}

	local function var2(arg0, arg1)
		for iter0, iter1 in ipairs(arg0) do
			if not arg1[iter1.id] then
				arg1[iter1.id] = 0
			else
				arg1[iter1.id] = arg1[iter1.id] + 1
			end
		end
	end

	local var3 = {}
	local var4 = {}

	var2(var0, var3)
	var2(arg1, var4)

	local function var5(arg0)
		local var0 = pg.furniture_data_template[arg0]

		return {
			count = 1,
			name = var0.name
		}
	end

	for iter0, iter1 in pairs(var3) do
		if not var4[iter0] then
			var1[iter0] = var5(iter0)
		elseif var4[iter0] and iter1 > var4[iter0] then
			if not var1[iter0] then
				var1[iter0] = var5(iter0)
			end

			var1[iter0].count = iter1 - var4[iter0]
		end
	end

	return var1
end

function var0.getName(arg0)
	return arg0:GetName()
end

function var0.getIcon(arg0)
	return "themeicon"
end

return var0
