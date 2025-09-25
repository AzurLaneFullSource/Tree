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

		arg0_6:StopEffectTimer()

		local var0_6 = arg0_6.slotData:GetCanCollectTimeStamps() - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_6:StartEffectTimer(var0_6)
	end

	;(function()
		local var0_7 = arg0_6.slotData:GetCanCollectTimeStamps()

		if var0_7 ~= 0 then
			local var1_7 = var0_7 - pg.TimeMgr.GetInstance():GetServerTime()

			arg0_6.delayInfoTimer = Timer.New(function()
				arg0_6:NotifiyCore(ISLAND_EVT.UPDATE_HUD, tonumber(arg0_6.id))
			end, var1_7, 1)

			arg0_6.delayInfoTimer:Start()
		end
	end)()
end

function var0_0.StartEffectTimer(arg0_9, arg1_9)
	arg0_9.effectTimer = Timer.New(function()
		arg0_9.hasEffect = true

		arg0_9:LoadEffectItem()
	end, arg1_9, 1)

	arg0_9.effectTimer:Start()
end

function var0_0.StopEffectTimer(arg0_11)
	if arg0_11.effectTimer ~= nil then
		arg0_11.effectTimer:Stop()

		arg0_11.effectTimer = nil
	end
end

function var0_0.StopUpdateInfoTimer(arg0_12)
	if arg0_12.delayInfoTimer ~= nil then
		arg0_12.delayInfoTimer:Stop()

		arg0_12.delayInfoTimer = nil
	end
end

function var0_0.GetToolId(arg0_13)
	local var0_13 = pg.island_production_slot[arg0_13.slotData.configId].place
	local var1_13 = pg.island_production_place[var0_13].tool_list
	local var2_13
	local var3_13 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_13, iter1_13 in ipairs(var1_13) do
		if pg.island_animation_attachments[iter1_13].unlock == 0 then
			var2_13 = iter1_13
		end

		if var3_13:IsUnlockCollectTool(iter1_13) then
			var2_13 = iter1_13
		end
	end

	return var2_13
end

function var0_0.GetAnimatorTrigger(arg0_14)
	if pg.island_production_slot[arg0_14.slotData.configId].place == IslandProductConst.MinePlaceId then
		return IslandConst.MINING_FLAG
	else
		return IslandConst.LOP_FLAG
	end
end

function var0_0.TakeDamage(arg0_15, arg1_15)
	if arg0_15.currentHp then
		arg0_15.currentHp = arg0_15.currentHp - arg1_15
	end
end

function var0_0.ResetHp(arg0_16)
	arg0_16.currentHp = arg0_16.maxHp
end

function var0_0.CheckCanStartColloct(arg0_17)
	if not (arg0_17.slotData:GetCanCollectTimeStamps() == 0) then
		local var0_17 = arg0_17.slotData:GetCanCollectTimeStamps()
		local var1_17 = var0_17 - pg.TimeMgr.GetInstance():GetServerTime()
		local var2_17

		if var1_17 > 86400 then
			var2_17 = pg.TimeMgr.GetInstance():STimeDescC(var0_17 or 0)
		else
			var2_17 = os.date("%H:%M:%S", var0_17 or 0)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_log_recover", var2_17))

		return false
	end

	return true
end

function var0_0.GetHudInfo(arg0_18)
	local var0_18 = {}

	if not arg0_18.slotData then
		var0_18.needShowHud = false

		return var0_18
	end

	var0_18.needShowHud = true

	local var1_18 = pg.island_formula[arg0_18.formulaId]

	var0_18.name = var1_18.name

	local var2_18 = arg0_18.slotData:GetCanCollectTimeStamps() == 0 and 1 or 0

	var0_18.numProcess = string.format("%d/%d", var2_18, 1)
	var0_18.itemIcon = "island/" .. pg.island_item_data_template[var1_18.item_id].icon

	if var2_18 == 0 then
		var0_18.process = 0
	elseif arg0_18.maxHp ~= 0 then
		var0_18.process = arg0_18.currentHp / arg0_18.maxHp
	end

	return var0_18
end

function var0_0.TakeAttack(arg0_19)
	local var0_19 = pg.island_formula[arg0_19.formulaId]
	local var1_19 = var0_19.affected_vfx[1]

	arg0_19:NotifiyIsland(IslandProxy.GEN_RECYCLEITEM, {
		id = arg0_19.id,
		unitId = var1_19,
		position = arg0_19.position,
		rotation = arg0_19.rotation,
		recycleAssetType = IslandDelayRecycleUnitBuilder.RecycleType.ProductEffect,
		delayRecycleTime = var0_19.affected_vfx[2],
		behaviourTree = {}
	})

	if arg0_19.maxHp ~= 0 then
		local var2_19 = arg0_19:GetToolId()
		local var3_19 = pg.island_animation_attachments[var2_19].attack

		arg0_19:TakeDamage(var3_19)
		arg0_19:NotifiyCore(ISLAND_EVT.UPDATE_HUD, tonumber(arg0_19.id))

		if arg0_19.currentHp < 0 then
			arg0_19.slotData:StartColloct()
		end
	else
		arg0_19.slotData:StartColloct()
	end
end

function var0_0.OnDispose(arg0_20)
	var0_0.super.OnDispose(arg0_20)

	if arg0_20.effectGo then
		arg0_20:UnLoadSceneItemRes(arg0_20.effectPath, arg0_20.effectGo)
	end

	arg0_20:StopUpdateInfoTimer()
	arg0_20:StopEffectTimer()

	arg0_20.hasEffect = false

	if arg0_20.modelDelayTimer then
		arg0_20.modelDelayTimer:Stop()

		arg0_20.modelDelayTimer = nil
	end
end

return var0_0
