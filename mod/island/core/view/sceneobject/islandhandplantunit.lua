local var0_0 = class("IslandHandPlantUnit", import(".IslandSlotBaseUnit"))

PlantStateType = {
	Planting = 3,
	Locked = 1,
	Delegate = 5,
	CanHarvest = 4,
	CanPlant = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:InitData()

	arg0_1.emptyName = pg.island_set.farm_empty_state_info.key_value_varchar[1]
	arg0_1.emptyIcon = pg.island_set.farm_empty_state_info.key_value_varchar[2]
end

function var0_0.InitData(arg0_2)
	arg0_2.handDate = arg0_2.data.slotData
	arg0_2.slotType = arg0_2.data.slotType
	arg0_2.slotState = arg0_2:GetPlantStateType()

	local var0_2 = (arg0_2.data:GetEndProductEndTime() or 0) - pg.TimeMgr.GetInstance():GetServerTime()

	if var0_2 > 0 then
		arg0_2.stateTimer = Timer.New(function()
			arg0_2.slotState = arg0_2:GetPlantStateType()

			arg0_2:NotifiyCore(ISLAND_EVT.UPDATE_HUD, tonumber(arg0_2.id))
		end, var0_2, 1)

		arg0_2.stateTimer:Start()
	end
end

function var0_0.GetPlantType(arg0_4)
	return arg0_4.slotState
end

function var0_0.LoadProductItemByPath(arg0_5, arg1_5)
	if arg0_5.productItemGo then
		arg0_5:UnLoadSceneItemRes(arg0_5.productItemPath, arg0_5.productItemGo)
	end

	arg0_5.productItemPath = arg1_5

	local function var0_5(arg0_6)
		setParent(arg0_6, arg0_5:GetView().root)

		arg0_6.transform.position = arg0_5.position
		arg0_6.transform.eulerAngles = arg0_5.rotation
		arg0_5.productItemGo = arg0_6
	end

	arg0_5:LoadSceneItemRes(arg0_5.productItemPath, var0_5)
end

function var0_0.InitProductItem(arg0_7)
	local var0_7 = arg0_7.data:GetProductProcess()

	if not var0_7 or #var0_7 == 0 then
		return
	end

	local var1_7 = #var0_7

	local function var2_7()
		local var0_8 = var0_7[arg0_7.processIndex].model
		local var1_8 = pg.island_unit_item[var0_8].model

		arg0_7:LoadProductItemByPath(var1_8)

		if arg0_7.processIndex < var1_7 then
			local var2_8 = var0_7[arg0_7.processIndex + 1].startTime - pg.TimeMgr.GetInstance():GetServerTime()

			arg0_7.delayTimer = Timer.New(function()
				arg0_7.processIndex = arg0_7.processIndex + 1

				var2_7()
			end, var2_8, 1)

			arg0_7.delayTimer:Start()
		end
	end

	local var3_7 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_7 = var1_7, 1, -1 do
		if var3_7 >= var0_7[iter0_7].startTime or iter0_7 == 1 then
			arg0_7.processIndex = iter0_7

			var2_7()

			break
		end
	end
end

function var0_0.CanCheckByPlayer(arg0_10)
	return arg0_10.data.slotType == IslandProductConst.ProductSlotType.HandPlant and arg0_10.data.slotData ~= nil
end

function var0_0.OnStart(arg0_11)
	arg0_11:HighLightDisPlayHandle()
	arg0_11:InitProductItem()
	arg0_11:InitEffectItem()
end

function var0_0.InitEffectItem(arg0_12)
	if arg0_12.slotState ~= PlantStateType.Planting and arg0_12.slotState ~= PlantStateType.CanHarvest then
		return
	end

	local function var0_12()
		local var0_13 = arg0_12.handDate.formula_id
		local var1_13 = pg.island_formula[var0_13].collectable_vfx

		arg0_12.effectPath = pg.island_unit_item[var1_13].model

		local function var2_13(arg0_14)
			setParent(arg0_14, arg0_12:GetView().root)

			arg0_12.effectGo = arg0_14
			arg0_12.effectGo.transform.position = arg0_12.position
			arg0_12.effectGo.transform.eulerAngles = arg0_12.rotation
		end

		arg0_12:LoadSceneEffectItemRes(arg0_12.effectPath, var2_13)
	end

	local var1_12 = (arg0_12.data:GetEndProductEndTime() or 0) - pg.TimeMgr.GetInstance():GetServerTime()

	if var1_12 > 0 then
		arg0_12.effectTimer = Timer.New(function()
			var0_12()
		end, var1_12, 1)

		arg0_12.effectTimer:Start()
	else
		var0_12()
	end
end

function var0_0.SetHighLight(arg0_16, arg1_16)
	arg0_16.data:SetHighLight(arg1_16)

	if not arg0_16._go then
		return
	end

	local var0_16 = GetOrAddComponent(arg0_16._go, "HighlightController")

	if arg1_16 then
		var0_16:HighlightOn()
	else
		var0_16:HighlightOff()
	end
end

function var0_0.HighLightDisPlayHandle(arg0_17)
	if arg0_17.data:GetHighLight() then
		GetOrAddComponent(arg0_17._go, "HighlightController"):HighlightOn()
	end
end

function var0_0.CanPlant(arg0_18)
	return arg0_18.slotState == PlantStateType.CanPlant
end

function var0_0.CanHarvest(arg0_19)
	return arg0_19.slotState == PlantStateType.CanHarvest
end

function var0_0.GetHudInfo(arg0_20)
	local var0_20 = {}
	local var1_20 = {
		PlantStateType.Locked,
		PlantStateType.Delegate
	}

	if table.contains(var1_20, arg0_20.slotState) then
		var0_20.needShowHud = false

		return var0_20
	end

	var0_20.needShowHud = true

	local var2_20 = arg0_20.handDate:GetPlantFormulaId()

	if not var2_20 then
		var0_20.name = arg0_20.emptyName
		var0_20.itemIcon = "island/" .. arg0_20.emptyIcon
	else
		local var3_20 = pg.island_formula[var2_20]

		var0_20.name = var3_20.name
		var0_20.itemIcon = "island/" .. pg.island_item_data_template[var3_20.item_id].icon
	end

	var0_20.hudState = {}

	if arg0_20.slotState == PlantStateType.CanPlant then
		var0_20.hudState.stateText = i18n("island_production_plantable")
	elseif arg0_20.slotState == PlantStateType.Planting then
		var0_20.hudState.stateEndTime = arg0_20.handDate.end_time
	else
		var0_20.hudState.stateText = i18n("island_production_harvestable")
	end

	return var0_20
end

function var0_0.GetPlantStateType(arg0_21)
	if arg0_21.data.slotType ~= IslandProductConst.ProductSlotType.HandPlant then
		return PlantStateType.Delegate
	end

	if not arg0_21.handDate then
		return PlantStateType.Locked
	end

	if arg0_21.handDate.state == 0 then
		return PlantStateType.CanPlant
	elseif arg0_21.handDate.end_time - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		return PlantStateType.CanHarvest
	else
		return PlantStateType.Planting
	end
end

function var0_0.OnDispose(arg0_22)
	var0_0.super.OnDispose(arg0_22)

	if arg0_22.effectGo then
		arg0_22:UnLoadSceneItemRes(arg0_22.effectPath, arg0_22.effectGo)
	end

	if arg0_22.productItemGo then
		arg0_22:UnLoadSceneItemRes(arg0_22.productItemPath, arg0_22.productItemGo)
	end

	if arg0_22.delayTimer then
		arg0_22.delayTimer:Stop()

		arg0_22.delayTimer = nil
	end

	if arg0_22.effectTimer then
		arg0_22.effectTimer:Stop()

		arg0_22.effectTimer = nil
	end

	if arg0_22.stateTimer then
		arg0_22.stateTimer:Stop()

		arg0_22.stateTimer = nil
	end
end

function var0_0.DelegateSlotStartPerform(arg0_23)
	arg0_23.data:StartDelegateSlotPerform()
	arg0_23:InitProductItem()
end

return var0_0
