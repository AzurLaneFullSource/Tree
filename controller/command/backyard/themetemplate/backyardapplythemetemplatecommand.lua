local var0 = class("BackYardApplyThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.template
	local var2 = var0.callback
	local var3 = getProxy(DormProxy)

	local function var4(arg0, arg1)
		if #arg0 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_template_list_is_empty"))

			return
		end

		local var0 = {}

		for iter0, iter1 in ipairs(arg0) do
			var0[iter1.id] = iter1
		end

		local var1 = {}

		for iter2, iter3 in pairs(var0) do
			var1[iter3.id] = iter3:ToSaveData()
		end

		pg.m02:sendNotification(GAME.PUT_FURNITURE, {
			furnsPos = var1,
			floor = arg1,
			callback = function(arg0, arg1)
				if arg0 then
					arg0:sendNotification(GAME.BACKYARD_APPLY_THEME_TEMPLATE_DONE)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_apply_theme_template_erro"))
					print(arg1)
				end
			end
		})
	end

	local var5 = 1
	local var6 = var0.GetAllFloorFurnitures()
	local var7 = var1:IsOccupyed(var6, 1)
	local var8 = {}

	if var7 then
		var8 = var1:GetUsableFurnituresForFloor(var6, var5)
	else
		local var9 = var1:GetAllFurniture()

		for iter0, iter1 in pairs(var9) do
			table.insert(var8, iter1)
		end
	end

	var0.WarpList(var8)
	var4(var8, var5)

	if var2 then
		var2(not var7, var8)
	end
end

function var0.GetAllFloorFurnitures()
	local function var0(arg0, arg1)
		local var0 = getProxy(DormProxy):getRawData():GetTheme(arg0)
		local var1 = {}

		if var0 then
			var1 = var0:GetAllFurniture()
		end

		for iter0, iter1 in pairs(var1) do
			arg1[iter1.id] = iter1
		end
	end

	local var1 = {}

	var0(1, var1)
	var0(2, var1)

	return var1
end

function var0.WarpList(arg0)
	local var0 = getProxy(DormProxy):getRawData()
	local var1 = var0:GetMapSize()
	local var2 = var1.x
	local var3 = var1.y
	local var4 = var1.z
	local var5 = var1.w

	local function var6(arg0)
		assert(arg0.position, arg0.id)

		return not arg0:isPaper() and (arg0.position.x < var2 or arg0.position.y < var3)
	end

	local var7 = var0.level
	local var8 = var0:GetPurchasedFurnitures()

	for iter0 = #arg0, 1, -1 do
		local var9 = arg0[iter0]

		if not var9.position or not var8[var9.configId] or var6(var9) then
			table.remove(arg0, iter0)
		end
	end

	table.sort(arg0, function(arg0, arg1)
		if #arg0.child == #arg1.child then
			return arg0.parent > arg1.parent
		else
			return #arg0.child > #arg1.child
		end
	end)

	local var10 = {}

	for iter1, iter2 in ipairs(arg0) do
		var10[iter2.id] = iter2
	end

	local var11 = {}
	local var12 = {}
	local var13 = var0:GetMapSize()

	for iter3, iter4 in ipairs(arg0) do
		local var14, var15 = CourtYardRawDataChecker.CheckFurnitrue(iter4, var10, var13)

		if not var14 and not table.contains(var11, iter4.id) then
			for iter5, iter6 in pairs(iter4.child or {}) do
				table.insert(var11, iter5)
			end

			if iter4.parent ~= 0 then
				if not var12[iter4.parent] then
					var12[iter4.parent] = {}
				end

				table.insert(var12[iter4.parent], iter4.id)
			end

			table.insert(var11, iter4.id)
		end
	end

	for iter7 = #arg0, 1, -1 do
		local var16 = arg0[iter7]

		if table.contains(var11, var16.id) then
			table.remove(arg0, iter7)
		else
			local var17 = var12[var16.id]

			if var17 then
				for iter8, iter9 in pairs(var16.child or {}) do
					if table.contains(var17, iter8) then
						var16.child[iter8] = nil
					end
				end
			end
		end
	end

	GetCanBePutFurnituresForThemeCommand.SortListForPut(arg0)
end

return var0
