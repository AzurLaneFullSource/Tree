local var0_0 = class("IslandProductSystem", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scheduleList = {}
end

function var0_0.OnStart(arg0_2)
	local var0_2 = arg0_2.data:GetDelegateSlotUnits()

	for iter0_2, iter1_2 in pairs(var0_2) do
		local var1_2 = {
			commissionSlotId = iter0_2,
			unitIds = iter1_2
		}

		arg0_2:StartDelegation(var1_2)
	end
end

function var0_0.StartDelegation(arg0_3, arg1_3)
	table.insert(arg0_3.scheduleList, arg1_3)
end

function var0_0.ExecuteDelegation(arg0_4, arg1_4)
	switch(arg0_4.data.productPlaceId, {
		[IslandProductConst.FisheryPlaceId] = function()
			arg0_4:ExecuteDelegateFish(arg1_4)
		end
	})
end

function var0_0.ExecuteDelegateFish(arg0_6, arg1_6)
	local var0_6 = arg1_6.commissionSlotId
	local var1_6 = pg.island_production_commission[var0_6].performanceObjid
	local var2_6 = arg1_6.unitIds

	for iter0_6, iter1_6 in ipairs(var2_6) do
		local var3_6 = arg0_6:GetView():GetUnitModuleWithType(IslandConst.UNIT_LIST_DELEGATE_UNIT, iter1_6)

		if var3_6 then
			var3_6:SetFishPonds(var1_6)
			var3_6:StartFishing()
		end
	end
end

function var0_0.EndDelegation(arg0_7, arg1_7)
	return
end

function var0_0.OnUpdate(arg0_8)
	if #arg0_8.scheduleList <= 0 then
		return
	end

	if not arg0_8:GetView():IsLoaded() then
		return
	end

	local var0_8 = table.remove(arg0_8.scheduleList, 1)

	arg0_8:ExecuteDelegation(var0_8)
end

function var0_0.OnDestroy(arg0_9)
	table.clear(arg0_9.scheduleList)
end

return var0_0
