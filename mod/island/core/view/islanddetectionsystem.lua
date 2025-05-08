local var0_0 = class("IslandDetectionSystem")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1
	arg0_1.isAreaDetection = false

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

function var0_0.SetAreaDetection(arg0_5, arg1_5)
	arg0_5.isAreaDetection = not arg0_5.isAreaDetection

	local var0_5 = arg0_5.isAreaDetection and "切换到3*3模式" or "切换到单块检测模式"

	pg.TipsMgr.GetInstance():ShowTips(i18n1(var0_5))

	if arg0_5.currentDate then
		arg0_5:CrossDetectionHandle(arg0_5.currentDate, true)
	end
end

function var0_0.GetNearArea(arg0_6, arg1_6)
	if arg1_6 == nil then
		return {}
	end

	local var0_6 = arg0_6.objectIdDic[arg1_6].array
	local var1_6 = {}

	if arg0_6.isAreaDetection then
		local function var2_6(arg0_7, arg1_7)
			return arg0_7 >= 1 and arg0_7 <= 6 and arg1_7 >= 1 and arg1_7 <= 6
		end

		for iter0_6 = -1, 1 do
			for iter1_6 = -1, 1 do
				local var3_6 = var0_6[1] + iter0_6
				local var4_6 = var0_6[2] + iter1_6

				if var2_6(var3_6, var4_6) then
					local var5_6 = arg0_6.objectArrDic[var3_6][var4_6]

					table.insert(var1_6, var5_6.objId)
				end
			end
		end
	else
		table.insert(var1_6, arg1_6)
	end

	return var1_6
end

function var0_0.CrossDetectionHandle(arg0_8, arg1_8, arg2_8)
	arg0_8.currentDate = arg1_8

	if arg1_8.displayTpye and arg1_8.displayTpye == "plant" then
		local var0_8 = arg1_8.targetNearId

		if var0_8 ~= arg0_8.pretargetNearId or arg2_8 then
			local var1_8 = arg0_8:GetNearArea(var0_8)

			local function var2_8(arg0_9)
				for iter0_9, iter1_9 in ipairs(var1_8) do
					if iter1_9 == arg0_9 then
						return true
					end
				end

				return false
			end

			for iter0_8, iter1_8 in pairs(arg0_8.lastHighlightDic) do
				if not var2_8(iter0_8) then
					arg0_8.lastHighlightDic[iter0_8] = nil

					local var3_8 = arg0_8:GetUnitModule(iter0_8)._go

					GetOrAddComponent(var3_8, "HighlightController"):HighlightOff()
				end
			end

			if var0_8 then
				for iter2_8, iter3_8 in ipairs(var1_8) do
					if not arg0_8.lastHighlightDic[iter3_8] then
						arg0_8.lastHighlightDic[iter3_8] = true

						local var4_8 = arg0_8:GetUnitModule(iter3_8)
						local var5_8 = arg0_8:GetUnitModule(iter3_8)._go

						GetOrAddComponent(var5_8, "HighlightController"):HighlightOn()
					end
				end
			end

			arg0_8.pretargetNearId = var0_8
		end
	end
end

function var0_0.GetUnitModule(arg0_10, arg1_10)
	return arg0_10.view:GetUnitModule(arg1_10)
end

function var0_0.OnPlayerPlant(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.lastHighlightDic) do
		arg0_11:GetUnitModule(iter0_11):DoPlant()
	end
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

return var0_0
