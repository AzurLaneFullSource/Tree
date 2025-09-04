local var0_0 = class("IslandDetectionSystem")
local var1_0 = 6

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1
	arg0_1.isAreaDetection = false
	arg0_1.areaListUnit = {}

	arg0_1:Init()
end

function var0_0.Emit(arg0_2, arg1_2, ...)
	arg0_2.view:Emit(arg1_2, ...)
end

function var0_0.Init(arg0_3)
	arg0_3.lastHighlightDic = {}

	arg0_3:InitProductionCfg()
end

function var0_0.InitProductionCfg(arg0_4)
	arg0_4.objectIdDic = {}
	arg0_4.objectArrDic = {}

	for iter0_4, iter1_4 in ipairs(pg.island_production_farm.all) do
		local var0_4 = pg.island_production_farm[iter1_4]

		if var0_4.objId ~= 0 then
			arg0_4.objectIdDic[var0_4.objId] = var0_4
		end

		local var1_4 = var0_4.array

		if var1_4 ~= "" then
			local var2_4 = var1_4[1]
			local var3_4 = var1_4[2]

			if not arg0_4.objectArrDic[var2_4] then
				arg0_4.objectArrDic[var2_4] = {}
			end

			arg0_4.objectArrDic[var2_4][var3_4] = var0_4
		end
	end
end

function var0_0.SetAreaDetection(arg0_5)
	arg0_5.isAreaDetection = not arg0_5.isAreaDetection

	local var0_5 = arg0_5.isAreaDetection and "island_dectect_mode3x3" or "island_dectect_mode1x1"

	pg.TipsMgr.GetInstance():ShowTips(i18n(var0_5))
	arg0_5:CheckHighLight()
end

function var0_0.GetNearArea(arg0_6, arg1_6)
	if arg1_6 == nil then
		return {}
	end

	local var0_6 = arg0_6.objectIdDic[arg1_6]
	local var1_6 = arg0_6:GetUnitModule(arg1_6)
	local var2_6 = var0_6.array
	local var3_6 = {}

	if not arg0_6.isAreaDetection then
		table.insert(var3_6, var1_6)

		return var3_6
	end

	local var4_6 = var1_6:GetPlantType()

	local function var5_6(arg0_7, arg1_7)
		return arg0_7 >= 1 and arg0_7 <= var1_0 and arg1_7 >= 1 and arg1_7 <= var1_0
	end

	for iter0_6 = -1, 1 do
		for iter1_6 = -1, 1 do
			local var6_6 = var2_6[1] + iter0_6
			local var7_6 = var2_6[2] + iter1_6

			if var5_6(var6_6, var7_6) then
				local var8_6 = arg0_6.objectArrDic[var6_6][var7_6].objId
				local var9_6 = arg0_6:GetUnitModule(var8_6)

				if var9_6:GetPlantType() == var4_6 then
					table.insert(var3_6, var9_6)
				end
			end
		end
	end

	return var3_6
end

function var0_0.CheckHighLight(arg0_8)
	local var0_8 = arg0_8.currentNearId
	local var1_8 = arg0_8:GetUnitModule(var0_8)
	local var2_8 = arg0_8:GetNearArea(var0_8)

	local function var3_8(arg0_9)
		for iter0_9, iter1_9 in ipairs(var2_8) do
			if iter1_9 == arg0_9 then
				return true
			end
		end

		return false
	end

	for iter0_8, iter1_8 in pairs(arg0_8.lastHighlightDic) do
		if not var3_8(iter0_8) then
			arg0_8.lastHighlightDic[iter0_8] = nil

			arg0_8:GetUnitModule(iter0_8):SetHighLight(false)
		end
	end

	for iter2_8, iter3_8 in ipairs(var2_8) do
		iter3_8:SetHighLight(true)

		arg0_8.lastHighlightDic[iter3_8.id] = true
	end
end

function var0_0.HighLightUnitHandle(arg0_10, arg1_10, arg2_10)
	if arg2_10 then
		arg0_10.currentNearId = arg1_10

		arg0_10:CheckHighLight()
	else
		for iter0_10, iter1_10 in pairs(arg0_10.lastHighlightDic) do
			arg0_10:GetUnitModule(iter0_10):SetHighLight(false)
		end

		arg0_10.lastHighlightDic = {}
	end
end

function var0_0.GetUnitModule(arg0_11, arg1_11)
	return arg0_11.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_11)
end

function var0_0.GetView(arg0_12)
	return arg0_12.view
end

function var0_0.Dispose(arg0_13)
	return
end

function var0_0.Update(arg0_14)
	return
end

function var0_0.GetAreaList(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in pairs(arg0_15.lastHighlightDic) do
		table.insert(var0_15, iter0_15)
	end

	return var0_15
end

return var0_0
