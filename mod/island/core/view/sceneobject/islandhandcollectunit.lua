local var0_0 = class("IslandHandCollectUnit", import(".IslandSlotBaseUnit"))
local var1_0 = require("Framework.toLua.UnityEngine.Vector3")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.slotData = arg0_1.data.slotData
	arg0_1.formulaId = pg.island_production_slot[arg0_1.slotData.configId].formula[1]
	arg0_1.maxHp = pg.island_formula[arg0_1.formulaId].hitpoint
	arg0_1.currentHp = arg0_1.maxHp
end

function var0_0.OnAttach(arg0_2, arg1_2)
	var0_0.super.OnAttach(arg0_2, arg1_2)

	arg0_2._tf = arg0_2._go.transform
end

function var0_0.OnStart(arg0_3)
	arg0_3:UpdateHandCollet()
end

function var0_0.LoadEffectItem(arg0_4)
	local var0_4 = pg.island_formula[arg0_4.formulaId]
	local var1_4 = var0_4.collectable_vfx
	local var2_4 = var1_0(var0_4.vfx_offset[1][1], var0_4.vfx_offset[1][2], var0_4.vfx_offset[1][3])
	local var3_4 = Quaternion.Euler(var0_4.vfx_offset[2][1], var0_4.vfx_offset[2][2], var0_4.vfx_offset[2][3])

	arg0_4.effectPath = pg.island_unit_item[var1_4].model

	local function var4_4(arg0_5)
		setParent(arg0_5, arg0_4:GetView().root)

		arg0_4.effectGo = arg0_5
		arg0_4.effectGo.transform.position = arg0_4._tf:TransformPoint(var2_4)
		arg0_4.effectGo.transform.rotation = arg0_4._tf.rotation * var3_4
	end

	arg0_4:LoadSceneEffectItemRes(arg0_4.effectPath, var4_4)
end

function var0_0.UpdateHandCollet(arg0_6)
	if arg0_6.slotData:GetCanCollectTimeStamps() <= 0 then
		arg0_6.hasEffect = true

		arg0_6:LoadEffectItem()
	else
		if arg0_6.hasEffect and arg0_6.effectGo then
			arg0_6:UnLoadSceneItemRes(arg0_6.effectPath, arg0_6.effectGo)
		end

		arg0_6.hasEffect = false
	end
end

function var0_0.GetToolId(arg0_7)
	local var0_7 = pg.island_production_slot[arg0_7.slotData.configId].place
	local var1_7 = pg.island_production_place[var0_7].tool_list
	local var2_7
	local var3_7 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_7, iter1_7 in ipairs(var1_7) do
		if pg.island_animation_attachments[iter1_7].unlock == 0 then
			var2_7 = iter1_7
		end

		if var3_7:IsUnlockCollectTool(iter1_7) then
			var2_7 = iter1_7
		end
	end

	return var2_7
end

function var0_0.GetAnimatorTrigger(arg0_8)
	if pg.island_production_slot[arg0_8.slotData.configId].place == IslandProductConst.MinePlaceId then
		return IslandConst.MINING_FLAG
	else
		return IslandConst.LOP_FLAG
	end
end

function var0_0.TakeDamage(arg0_9, arg1_9)
	if arg0_9.currentHp then
		arg0_9.currentHp = arg0_9.currentHp - arg1_9
	end
end

function var0_0.ResetHp(arg0_10)
	arg0_10.currentHp = arg0_10.maxHp
end

function var0_0.CheckCanStartColloct(arg0_11)
	if not (arg0_11.slotData:GetCanCollectTimeStamps() == 0) then
		local var0_11 = arg0_11.slotData:GetCanCollectTimeStamps() - pg.TimeMgr.GetInstance():GetServerTime()
		local var1_11 = (function(arg0_12)
			local var0_12 = math.floor(arg0_12 / 3600)
			local var1_12 = math.floor(arg0_12 % 3600 / 60)
			local var2_12 = arg0_12 % 60

			return string.format("%02d:%02d:%02d", var0_12, var1_12, var2_12)
		end)(var0_11)

		pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_log_recover", var1_11))

		return false
	end

	return true
end

function var0_0.GetHudInfo(arg0_13)
	local var0_13 = {}

	if not arg0_13.slotData then
		var0_13.needShowHud = false

		return var0_13
	end

	var0_13.needShowHud = true

	local var1_13 = pg.island_formula[arg0_13.formulaId]

	var0_13.name = var1_13.name

	local var2_13 = arg0_13.slotData:GetCanCollectTimeStamps() == 0 and 1 or 0

	var0_13.numProcess = string.format("%d/%d", var2_13, 1)
	var0_13.itemIcon = "island/" .. pg.island_item_data_template[var1_13.item_id].icon

	if var2_13 == 0 then
		var0_13.process = 0
	elseif arg0_13.maxHp ~= 0 then
		var0_13.process = arg0_13.currentHp / arg0_13.maxHp
	end

	return var0_13
end

function var0_0.TakeAttack(arg0_14)
	local var0_14 = pg.island_formula[arg0_14.formulaId]
	local var1_14 = var0_14.affected_vfx[1]

	arg0_14:NotifiyIsland(IslandProxy.GEN_RECYCLEITEM, {
		id = arg0_14.id,
		unitId = var1_14,
		position = arg0_14.position,
		rotation = arg0_14.rotation,
		recycleAssetType = IslandDelayRecycleUnitBuilder.RecycleType.ProductEffect,
		delayRecycleTime = var0_14.affected_vfx[2],
		behaviourTree = {}
	})

	if arg0_14.maxHp ~= 0 then
		local var2_14 = arg0_14:GetToolId()
		local var3_14 = pg.island_animation_attachments[var2_14].attack

		arg0_14:TakeDamage(var3_14)
		arg0_14:NotifiyCore(ISLAND_EVT.UPDATE_HUD, tonumber(arg0_14.id))

		if arg0_14.currentHp < 0 then
			arg0_14.slotData:StartColloct()
		end
	else
		arg0_14.slotData:StartColloct()
	end
end

function var0_0.OnDispose(arg0_15)
	var0_0.super.OnDispose(arg0_15)

	if arg0_15.effectGo then
		arg0_15:UnLoadSceneItemRes(arg0_15.effectPath, arg0_15.effectGo)
	end

	arg0_15.hasEffect = false
end

return var0_0
