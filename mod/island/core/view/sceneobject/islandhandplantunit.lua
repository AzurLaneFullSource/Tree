local var0_0 = class("IslandHandPlantUnit", import(".IslandSlotBaseUnit"))
local var1_0 = {
	Planting = 4,
	Locked = 1,
	Delegate = 5,
	CanHarvest = 3,
	CanPlant = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:BindSlotData()

	arg0_1.emptyName = pg.island_set.farm_empty_state_info.key_value_varchar[1]
	arg0_1.emptyIcon = pg.island_set.farm_empty_state_info.key_value_varchar[2]
end

function var0_0.BindSlotData(arg0_2)
	arg0_2.handDate = arg0_2.data.slotData
	arg0_2.slotType = arg0_2.data.slotType
end

function var0_0.CanCheckByPlayer(arg0_3)
	return arg0_3.data.slotType == IslandProductSystemVO.SlotType.HandPlant and arg0_3.data.slotData ~= nil
end

function var0_0.OnInit(arg0_4, arg1_4, arg2_4)
	var0_0.super.OnInit(arg0_4, arg1_4, arg2_4)
	arg0_4:HighLightDisPlayHandle()
end

function var0_0.SetHighLight(arg0_5, arg1_5)
	arg0_5.data:SetHighLight(arg1_5)

	if not arg0_5._go then
		return
	end

	local var0_5 = GetOrAddComponent(arg0_5._go, "HighlightController")

	if arg1_5 then
		var0_5:HighlightOn()
	else
		var0_5:HighlightOff()
	end
end

function var0_0.HighLightDisPlayHandle(arg0_6)
	if arg0_6.data:GetHighLight() then
		GetOrAddComponent(arg0_6._go, "HighlightController"):HighlightOn()
	end
end

function var0_0.GetHudInfo(arg0_7)
	local var0_7 = {}

	if not arg0_7.handDate then
		var0_7.needShowHud = false

		return var0_7
	end

	if arg0_7.slotType ~= IslandProductSystemVO.SlotType.HandPlant then
		return var0_7
	end

	var0_7.needShowHud = true

	local var1_7 = arg0_7.handDate:GetPlantFormulaId()

	if not var1_7 then
		var0_7.name = arg0_7.emptyName
		var0_7.itemIcon = "island/" .. arg0_7.emptyIcon
	else
		local var2_7 = pg.island_formula[var1_7]

		var0_7.name = var2_7.name
		var0_7.itemIcon = "island/" .. pg.island_item_data_template[var2_7.item_id].icon
	end

	var0_7.hudState = {}

	if arg0_7:CanPlant() then
		var0_7.hudState.stateText = "可种植"
	elseif arg0_7:CanHarvest() then
		var0_7.hudState.stateText = "可收获"
	else
		var0_7.hudState.stateEndTime = arg0_7.handDate.end_time
		var0_7.hudState.stateEndText = "可收获"
	end

	return var0_7
end

function var0_0.CanPlant(arg0_8)
	if arg0_8.handDate.state == 0 then
		return true
	end

	return false
end

function var0_0.CanHarvest(arg0_9)
	if arg0_9.handDate.state == 0 then
		return false
	end

	local var0_9 = pg.TimeMgr.GetInstance()

	return arg0_9.handDate.end_time - var0_9:GetServerTime() < 0
end

function var0_0.GetPlantType(arg0_10)
	if arg0_10.data.slotType ~= IslandProductSystemVO.SlotType.HandPlant then
		return var1_0.Delegate
	end

	if not arg0_10.handDate then
		return var1_0.Locked
	end

	if arg0_10:CanPlant() then
		return var1_0.CanPlant
	elseif arg0_10:CanHarvest() then
		return var1_0.CanHarvest
	else
		return var1_0.Planting
	end
end

function var0_0.OnUpdate(arg0_11)
	var0_0.super.OnUpdate(arg0_11)
	arg0_11:UpdateEffect()
end

function var0_0.UpdateEffect(arg0_12)
	if not arg0_12.handDate then
		return
	end

	if arg0_12.slotType ~= IslandProductSystemVO.SlotType.HandPlant then
		return
	end

	if arg0_12:CanHarvest() then
		if not arg0_12.hasEffect then
			arg0_12.hasEffect = true

			local var0_12 = arg0_12.handDate.formula_id
			local var1_12 = pg.island_formula[var0_12].collectable_vfx

			arg0_12.effectPath = pg.island_unit_item[var1_12].model

			local function var2_12(arg0_13)
				setParent(arg0_13, arg0_12:GetView().root)

				arg0_12.effectGo = arg0_13

				if not arg0_12.hasEffect then
					arg0_12:UnLoadEffectItemRes()

					return
				end

				arg0_12.effectGo.transform.position = arg0_12.position
				arg0_12.effectGo.transform.eulerAngles = arg0_12.rotation
			end

			arg0_12:LoadEffectItemRes(var2_12)
		end
	elseif arg0_12.hasEffect then
		arg0_12.hasEffect = false

		arg0_12:UnLoadEffectItemRes()
	end
end

function var0_0.OnDispose(arg0_14)
	var0_0.super.OnDispose(arg0_14)

	if arg0_14.effectGo then
		arg0_14:UnLoadEffectItemRes()
	end
end

function var0_0.DelegateSlotStartPerform(arg0_15)
	arg0_15:GetDataVO():StartDelegateSlotPerform()
	arg0_15:LoadProductItem()
end

return var0_0
