local var0_0 = class("IslandHandCollectUnit", import(".IslandSlotBaseUnit"))
local var1_0 = require("Framework.toLua.UnityEngine.Vector3")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.slotData = arg0_1.data.slotData

	if arg0_1.data.formula_id then
		arg0_1.maxHp = pg.island_formula[arg0_1.data.formula_id].hitpoint
		arg0_1.currentHp = arg0_1.maxHp
	end
end

function var0_0.GetToolId(arg0_2)
	local var0_2 = pg.island_production_slot[arg0_2.slotData.configId].place
	local var1_2 = pg.island_production_place[var0_2].tool_list
	local var2_2
	local var3_2 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_2, iter1_2 in ipairs(var1_2) do
		if pg.island_animation_attachments[iter1_2].unlock == 0 then
			var2_2 = iter1_2
		end

		if var3_2:IsUnlockCollectTool(iter1_2) then
			var2_2 = iter1_2
		end
	end

	return var2_2
end

function var0_0.GetAnimatorTrigger(arg0_3)
	if pg.island_production_slot[arg0_3.slotData.configId].place == 401 then
		return IslandConst.MINING_FLAG
	else
		return IslandConst.LOP_FLAG
	end
end

function var0_0.TakeDamage(arg0_4, arg1_4)
	if arg0_4.currentHp then
		arg0_4.currentHp = arg0_4.currentHp - arg1_4
	end
end

function var0_0.ResetHp(arg0_5)
	arg0_5.currentHp = arg0_5.maxHp
end

function var0_0.StartColloct(arg0_6, arg1_6)
	if arg0_6.slotData:GetCanCollectTime() <= 0 then
		pg.TipsMgr.GetInstance():ShowTips("可采集次数为0,等会再来")

		return 0
	end

	if arg0_6.maxHp ~= 0 then
		local var0_6 = pg.island_animation_attachments[arg1_6].attack

		arg0_6:TakeDamage(var0_6)

		if arg0_6.currentHp < 0 then
			arg0_6.slotData:StartColloct()

			return 3
		end

		return 2
	else
		arg0_6.slotData:StartColloct()

		return 3
	end
end

function var0_0.GetHudInfo(arg0_7)
	local var0_7 = {}

	if not arg0_7.slotData then
		var0_7.needShowHud = false

		return var0_7
	end

	var0_7.needShowHud = true

	local var1_7 = pg.island_formula[arg0_7.data.formula_id]

	var0_7.name = var1_7.name
	var0_7.numProcess = string.format("%d/%d", arg0_7.slotData:GetCanCollectTime(), arg0_7.slotData:GetCollectMaxTime())
	var0_7.itemIcon = "island/" .. pg.island_item_data_template[var1_7.item_id].icon

	if arg0_7.slotData:GetCanCollectTime() == 0 then
		var0_7.process = 0
	elseif arg0_7.maxHp ~= 0 then
		var0_7.process = arg0_7.currentHp / arg0_7.maxHp
	end

	return var0_7
end

function var0_0.UpdateEffect(arg0_8)
	if not arg0_8.slotData then
		return
	end

	if arg0_8.slotData:GetCanCollectTime() > 0 then
		if not arg0_8.hasEffect then
			arg0_8.hasEffect = true

			local var0_8 = arg0_8.data.formula_id
			local var1_8 = pg.island_formula[var0_8]
			local var2_8 = var1_8.collectable_vfx

			arg0_8.effectPath = pg.island_unit_item[var2_8].model

			local function var3_8(arg0_9)
				setParent(arg0_9, arg0_8:GetView().root)

				arg0_8.effectGo = arg0_9

				if not arg0_8.hasEffect then
					arg0_8:UnLoadEffectItemRes()

					return
				end

				local var0_9 = arg0_8.position

				if var1_8.vfx_offset then
					var0_9 = arg0_8.position + var1_0.New(var1_8.vfx_offset[1], var1_8.vfx_offset[2], var1_8.vfx_offset[3])
				end

				arg0_8.effectGo.transform.position = var0_9
				arg0_8.effectGo.transform.eulerAngles = arg0_8.rotation
			end

			arg0_8:LoadEffectItemRes(var3_8)
		end
	elseif arg0_8.hasEffect then
		arg0_8.hasEffect = false

		arg0_8:UnLoadEffectItemRes()
	end
end

function var0_0.OnUpdate(arg0_10)
	var0_0.super.OnUpdate(arg0_10)
	arg0_10:UpdateEffect()
end

function var0_0.OnDispose(arg0_11)
	var0_0.super.OnDispose(arg0_11)

	if arg0_11.effectGo then
		arg0_11:UnLoadEffectItemRes()
	end
end

return var0_0
