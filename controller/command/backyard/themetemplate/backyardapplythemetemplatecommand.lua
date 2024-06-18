local var0_0 = class("BackYardApplyThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.template
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(DormProxy)

	local function var4_1(arg0_2, arg1_2)
		if #arg0_2 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_template_list_is_empty"))

			return
		end

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2) do
			var0_2[iter1_2.id] = iter1_2
		end

		local var1_2 = {}

		for iter2_2, iter3_2 in pairs(var0_2) do
			var1_2[iter3_2.id] = iter3_2:ToSaveData()
		end

		pg.m02:sendNotification(GAME.PUT_FURNITURE, {
			furnsPos = var1_2,
			floor = arg1_2,
			callback = function(arg0_3, arg1_3)
				if arg0_3 then
					arg0_1:sendNotification(GAME.BACKYARD_APPLY_THEME_TEMPLATE_DONE)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_apply_theme_template_erro"))
					print(arg1_3)
				end
			end
		})
	end

	local var5_1 = 1
	local var6_1 = var0_0.GetAllFloorFurnitures()
	local var7_1 = var1_1:IsOccupyed(var6_1, 1)
	local var8_1 = {}

	if var7_1 then
		var8_1 = var1_1:GetUsableFurnituresForFloor(var6_1, var5_1)
	else
		local var9_1 = var1_1:GetAllFurniture()

		for iter0_1, iter1_1 in pairs(var9_1) do
			table.insert(var8_1, iter1_1)
		end
	end

	var0_0.WarpList(var8_1)
	var4_1(var8_1, var5_1)

	if var2_1 then
		var2_1(not var7_1, var8_1)
	end
end

function var0_0.GetAllFloorFurnitures()
	local function var0_4(arg0_5, arg1_5)
		local var0_5 = getProxy(DormProxy):getRawData():GetTheme(arg0_5)
		local var1_5 = {}

		if var0_5 then
			var1_5 = var0_5:GetAllFurniture()
		end

		for iter0_5, iter1_5 in pairs(var1_5) do
			arg1_5[iter1_5.id] = iter1_5
		end
	end

	local var1_4 = {}

	var0_4(1, var1_4)
	var0_4(2, var1_4)

	return var1_4
end

function var0_0.WarpList(arg0_6)
	local var0_6 = getProxy(DormProxy):getRawData()
	local var1_6 = var0_6:GetMapSize()
	local var2_6 = var1_6.x
	local var3_6 = var1_6.y
	local var4_6 = var1_6.z
	local var5_6 = var1_6.w

	local function var6_6(arg0_7)
		assert(arg0_7.position, arg0_7.id)

		return not arg0_7:isPaper() and (arg0_7.position.x < var2_6 or arg0_7.position.y < var3_6)
	end

	local var7_6 = var0_6.level
	local var8_6 = var0_6:GetPurchasedFurnitures()

	for iter0_6 = #arg0_6, 1, -1 do
		local var9_6 = arg0_6[iter0_6]

		if not var9_6.position or not var8_6[var9_6.configId] or var6_6(var9_6) then
			table.remove(arg0_6, iter0_6)
		end
	end

	table.sort(arg0_6, function(arg0_8, arg1_8)
		if #arg0_8.child == #arg1_8.child then
			return arg0_8.parent > arg1_8.parent
		else
			return #arg0_8.child > #arg1_8.child
		end
	end)

	local var10_6 = {}

	for iter1_6, iter2_6 in ipairs(arg0_6) do
		var10_6[iter2_6.id] = iter2_6
	end

	local var11_6 = {}
	local var12_6 = {}
	local var13_6 = var0_6:GetMapSize()

	for iter3_6, iter4_6 in ipairs(arg0_6) do
		local var14_6, var15_6 = CourtYardRawDataChecker.CheckFurnitrue(iter4_6, var10_6, var13_6)

		if not var14_6 and not table.contains(var11_6, iter4_6.id) then
			for iter5_6, iter6_6 in pairs(iter4_6.child or {}) do
				table.insert(var11_6, iter5_6)
			end

			if iter4_6.parent ~= 0 then
				if not var12_6[iter4_6.parent] then
					var12_6[iter4_6.parent] = {}
				end

				table.insert(var12_6[iter4_6.parent], iter4_6.id)
			end

			table.insert(var11_6, iter4_6.id)
		end
	end

	for iter7_6 = #arg0_6, 1, -1 do
		local var16_6 = arg0_6[iter7_6]

		if table.contains(var11_6, var16_6.id) then
			table.remove(arg0_6, iter7_6)
		else
			local var17_6 = var12_6[var16_6.id]

			if var17_6 then
				for iter8_6, iter9_6 in pairs(var16_6.child or {}) do
					if table.contains(var17_6, iter8_6) then
						var16_6.child[iter8_6] = nil
					end
				end
			end
		end
	end

	GetCanBePutFurnituresForThemeCommand.SortListForPut(arg0_6)
end

return var0_0
