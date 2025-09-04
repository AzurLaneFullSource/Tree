local var0_0 = class("IslandCharacterSystem", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scheduleList = {}
	arg0_1.workerCnt = arg0_1.data:GetWorkerCnt()
end

function var0_0.OnStart(arg0_2)
	if arg0_2.behaviourTreeOwner then
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_2.behaviourTreeOwner, "worker", arg0_2.workerCnt)

		local var0_2 = {
			IslandProductSystemVO.FellingPlaceId,
			IslandProductSystemVO.MilkTeaPlaceId,
			IslandProductSystemVO.MealPlaceId,
			IslandProductSystemVO.TechnologyPlaceId,
			IslandProductSystemVO.PasturePlaceId,
			IslandProductSystemVO.FarmlandPlaceId,
			IslandProductSystemVO.CoffeePlaceId
		}
		local var1_2 = {
			IslandProductSystemVO.FarmlandPlaceId
		}

		if table.contains(var0_2, arg0_2.data.id) then
			local var2_2 = arg0_2.data:GetWorkerList() or {}

			for iter0_2, iter1_2 in ipairs(var2_2) do
				iter1_2.nextIn = table.contains(var1_2, arg0_2.data.id)

				arg0_2:StartDelegation(iter1_2)
			end
		end
	end
end

function var0_0.StartDelegation(arg0_3, arg1_3)
	if not arg0_3.behaviourTreeOwner then
		return
	end

	table.insert(arg0_3.scheduleList, arg1_3)
end

function var0_0.ExecuteDelegation(arg0_4, arg1_4)
	arg0_4.workerCnt = arg0_4.workerCnt + 1

	local var0_4 = arg0_4:GetView():GetSystemUnitModule(arg1_4.ship_id)
	local var1_4 = arg0_4.data:GetperformanceObjidList(arg1_4.area_id)
	local var2_4 = System.Collections.Generic.List_IslandUnitNode()

	if var0_4 then
		local var3_4 = IslandUnitNode.New()

		var3_4.unitId = arg1_4.ship_id
		var3_4.unitType = IslandConst.UNIT_LIST_DELEGATION

		var2_4:Add(var3_4)
	end

	for iter0_4, iter1_4 in ipairs(var1_4) do
		local var4_4 = IslandUnitNode.New()

		var4_4.unitId = iter1_4.unitId
		var4_4.unitType = iter1_4.unitType

		var2_4:Add(var4_4)
	end

	if arg1_4.nextIn then
		arg0_4.behaviourTreeOwner:SendEvent("system_unit_add_nextIn", var2_4, nil)
	else
		arg0_4.behaviourTreeOwner:SendEvent("system_unit_add", var2_4, nil)
	end
end

function var0_0.EndDelegation(arg0_5, arg1_5)
	if not arg0_5.behaviourTreeOwner then
		return
	end

	arg0_5.workerCnt = arg0_5.workerCnt - 1

	LuaHelper.NodeCanvasSetIntVariableValue(arg0_5.behaviourTreeOwner, "worker", arg0_5.workerCnt)

	local var0_5 = IslandUnitNode.New()

	var0_5.unitId = arg1_5.ship_id
	var0_5.unitType = IslandConst.UNIT_LIST_DELEGATION

	arg0_5.behaviourTreeOwner:SendEvent("system_unit_remove", var0_5, nil)
end

function var0_0.OnUpdate(arg0_6)
	if #arg0_6.scheduleList <= 0 then
		return
	end

	if not arg0_6:GetView():IsLoaded() then
		return
	end

	if not arg0_6._go:GetComponent(typeof(ParadoxNotion.Services.EventRouter)) then
		return
	end

	local var0_6 = table.remove(arg0_6.scheduleList, 1)

	arg0_6:ExecuteDelegation(var0_6)
end

function var0_0.OnDestroy(arg0_7)
	table.clear(arg0_7.scheduleList)
end

return var0_0
