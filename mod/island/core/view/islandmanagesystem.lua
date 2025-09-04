local var0_0 = class("IslandManageSystem", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scheduleList = {}
	arg0_1.isShowing = false
end

function var0_0.OnStart(arg0_2)
	if not arg0_2.behaviourTreeOwner then
		return
	end

	if arg0_2.data:GetStatus() == IslandRestaurant.STATUS.OPENING then
		arg0_2:StartManage(arg0_2.data)
	end
end

function var0_0.StartManage(arg0_3, arg1_3)
	if not arg0_3.behaviourTreeOwner then
		return
	end

	arg0_3.isShowing = true
	arg0_3.restId = arg0_3.data:GetRestId()
	arg0_3.postList = arg0_3.data:GetPostList()

	table.insert(arg0_3.scheduleList, arg1_3)
end

function var0_0.ExecuteManage(arg0_4, arg1_4)
	arg0_4.behaviourTreeOwner:SendEvent("manage_add_post", arg1_4:GetPostUnitNodeList(), nil)
	arg0_4.behaviourTreeOwner:SendEvent("manage_add_assistant", arg1_4:GetAssistantUnitNodeList(), nil)
	arg0_4.behaviourTreeOwner:SendEvent("manage_add_customer", arg1_4:GetCustomerUnitNodeList(), nil)
	LuaHelper.NodeCanvasSetIntVariableValue(arg0_4.behaviourTreeOwner, "systemId", arg1_4.id)

	for iter0_4, iter1_4 in ipairs(arg1_4:GetFoodUnitIds()) do
		local var0_4 = _IslandFindUnit(IslandConst.UNIT_LIST_MANAGE, iter1_4)

		if var0_4 then
			setActive(var0_4, true)
		end
	end
end

function var0_0.EndManage(arg0_5, arg1_5)
	arg0_5.isShowing = false

	for iter0_5, iter1_5 in ipairs(arg1_5:GetFoodUnitIds()) do
		local var0_5 = _IslandFindUnit(IslandConst.UNIT_LIST_MANAGE, iter1_5)

		if var0_5 then
			setActive(var0_5, false)
		end
	end
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = arg0_6.data:GetStatus()

	if arg0_6.isShowing and var0_6 ~= IslandRestaurant.STATUS.OPENING then
		getProxy(IslandProxy):GetIsland():DispatchEvent(IslandCloseRestaurantCommand.CLOSE_RESTAURANT, {
			restId = arg0_6.restId,
			postList = arg0_6.postList
		})
	end

	if #arg0_6.scheduleList == 0 then
		return
	end

	if not arg0_6:GetView():IsLoaded() then
		return
	end

	if not arg0_6._go:GetComponent(typeof(ParadoxNotion.Services.EventRouter)) then
		return
	end

	local var1_6 = arg0_6.scheduleList[1]
	local var2_6 = var1_6:GetUnits()

	for iter0_6, iter1_6 in ipairs(var2_6) do
		local var3_6 = arg0_6:GetView():GetUnitModuleWithType(IslandConst.UNIT_LIST_MANAGE, iter1_6.id)

		if not var3_6:IsLoaded() then
			return
		end

		if iter1_6.type == IslandConst.UNIT_TYPE_MANAGE_CHARA and not var3_6._go:GetComponent(typeof(ParadoxNotion.Services.EventRouter)) then
			return
		end
	end

	table.remove(arg0_6.scheduleList, 1)
	arg0_6:ExecuteManage(var1_6)
end

function var0_0.OnDestroy(arg0_7)
	table.clear(arg0_7.scheduleList)
end

return var0_0
