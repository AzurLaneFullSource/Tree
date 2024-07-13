local var0_0 = class("BackYardSelfThemeTemplate", import(".BackYardBaseThemeTemplate"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.floor = arg2_1 or 1
end

function var0_0.GetAllFurniture(arg0_2)
	if not arg0_2.furnitruesByIds then
		local var0_2 = arg0_2:GetRawPutList()

		arg0_2.furnitruesByIds = arg0_2:InitFurnitures({
			mapSize = arg0_2:GetMapSize(),
			floor = arg0_2.floor,
			furniture_put_list = var0_2
		})
	end

	return arg0_2.furnitruesByIds
end

function var0_0.AddFurniture(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:GetAllFurniture()
	local var1_3 = {}

	for iter0_3, iter1_3 in pairs(arg1_3.child) do
		var1_3[iter0_3] = iter1_3
	end

	local var2_3 = BackyardThemeFurniture.New({
		isNewStyle = true,
		id = arg1_3.id,
		configId = arg1_3.configId,
		position = Vector2(arg1_3.x, arg1_3.y),
		dir = arg1_3.dir,
		child = var1_3,
		parent = arg1_3.parent,
		floor = arg2_3
	})

	var0_3[arg1_3.id] = var2_3

	return var2_3
end

function var0_0.DeleteFurniture(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetAllFurniture()

	if var0_4[arg1_4] then
		var0_4[arg1_4] = nil
	end
end

function var0_0.GetFurniture(arg0_5, arg1_5)
	return arg0_5:GetAllFurniture()[arg1_5]
end

function var0_0.GetType(arg0_6)
	return BackYardConst.THEME_TEMPLATE_USAGE_TYPE_SELF
end

function var0_0.IsSystem(arg0_7)
	return false
end

function var0_0.IsCollected(arg0_8)
	return true
end

function var0_0.IsLiked(arg0_9)
	return true
end

function var0_0.UnLoad(arg0_10)
	arg0_10.time = 0
end

function var0_0.Upload(arg0_11)
	arg0_11.time = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.CanDispaly(arg0_12)
	local var0_12 = arg0_12:IsPushed()

	return var0_12 or not var0_12 and arg0_12:ExistLocalImage()
end

function var0_0.IsUsing(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetWarpFurnitures()
	local var1_13 = table.getCount(arg1_13)
	local var2_13 = table.getCount(var0_13)

	if var1_13 ~= var2_13 then
		return false, Vector2(var1_13, var2_13)
	end

	local var3_13 = {}

	for iter0_13, iter1_13 in pairs(arg1_13) do
		if arg0_13:IsSystem() and iter1_13:getConfig("themeId") ~= arg0_13.id then
			return false, 0
		end

		local var4_13 = iter1_13:getConfig("id")

		if not var3_13[var4_13] then
			var3_13[var4_13] = {}
		end

		table.insert(var3_13[var4_13], iter1_13)
	end

	for iter2_13, iter3_13 in pairs(var0_13) do
		local var5_13 = arg1_13[iter3_13.id]

		if not var5_13 then
			return false, 1
		end

		if not var5_13:isPaper() then
			if not var5_13.position then
				return false, 2
			end

			local var6_13 = var3_13[iter3_13.id] or {}
			local var7_13 = false

			for iter4_13, iter5_13 in ipairs(var6_13) do
				if iter5_13:isSame(iter3_13) then
					var7_13 = true

					break
				end
			end

			if not var7_13 then
				return false, 3
			end
		end
	end

	return true
end

function var0_0.GetMissFurnitures(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetWarpFurnitures()

	if #arg1_14 == #var0_14 then
		return
	end

	local var1_14 = {}

	local function var2_14(arg0_15, arg1_15)
		for iter0_15, iter1_15 in ipairs(arg0_15) do
			if not arg1_15[iter1_15.id] then
				arg1_15[iter1_15.id] = 0
			else
				arg1_15[iter1_15.id] = arg1_15[iter1_15.id] + 1
			end
		end
	end

	local var3_14 = {}
	local var4_14 = {}

	var2_14(var0_14, var3_14)
	var2_14(arg1_14, var4_14)

	local function var5_14(arg0_16)
		local var0_16 = pg.furniture_data_template[arg0_16]

		return {
			count = 1,
			name = var0_16.name
		}
	end

	for iter0_14, iter1_14 in pairs(var3_14) do
		if not var4_14[iter0_14] then
			var1_14[iter0_14] = var5_14(iter0_14)
		elseif var4_14[iter0_14] and iter1_14 > var4_14[iter0_14] then
			if not var1_14[iter0_14] then
				var1_14[iter0_14] = var5_14(iter0_14)
			end

			var1_14[iter0_14].count = iter1_14 - var4_14[iter0_14]
		end
	end

	return var1_14
end

function var0_0.getName(arg0_17)
	return arg0_17:GetName()
end

function var0_0.getIcon(arg0_18)
	return "themeicon"
end

return var0_0
