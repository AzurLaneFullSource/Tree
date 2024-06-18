local var0_0 = class("WSCarryItem", import(".WSMapTransform"))

var0_0.Fields = {
	wsMapPath = "table",
	active = "boolean",
	followList = "table",
	theme = "table",
	fleet = "table",
	carryItem = "table"
}
var0_0.Listeners = {
	onUpdate = "Update",
	onMoveEnd = "OnMoveEnd"
}

function var0_0.GetResName(arg0_1)
	return "event_tpl"
end

function var0_0.Setup(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.fleet = arg1_2

	arg0_2.fleet:AddListener(WorldMapFleet.EventUpdateLocation, arg0_2.onUpdate)

	arg0_2.carryItem = arg2_2

	arg0_2.carryItem:AddListener(WorldCarryItem.EventUpdateOffset, arg0_2.onUpdate)

	arg0_2.theme = arg3_2

	arg0_2:Init()
end

function var0_0.Dispose(arg0_3)
	arg0_3.fleet:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0_3.onUpdate)
	arg0_3.carryItem:RemoveListener(WorldCarryItem.EventUpdateOffset, arg0_3.onUpdate)

	if arg0_3.wsMapPath then
		arg0_3.wsMapPath:RemoveListener(WSMapPath.EventArrived, arg0_3.onMoveEnd)
		arg0_3.wsMapPath:Dispose()
	end

	var0_0.super.Dispose(arg0_3)
end

function var0_0.Init(arg0_4)
	local var0_4 = arg0_4.transform

	var0_4.name = "carry_item_" .. arg0_4.carryItem.id
	var0_4.localEulerAngles = Vector3(-arg0_4.theme.angle, 0, 0)

	arg0_4:Update()
	arg0_4:UpdateActive(arg0_4.active or true)
	arg0_4:UpdateModelScale(arg0_4.carryItem:GetScale())
end

function var0_0.Update(arg0_5, arg1_5)
	local var0_5 = arg0_5.transform
	local var1_5 = arg0_5.fleet
	local var2_5 = arg0_5.carryItem
	local var3_5, var4_5 = arg0_5:GetLocation()

	if not arg0_5.isMoving and (arg1_5 == nil or arg1_5 == WorldMapFleet.EventUpdateLocation or arg1_5 == WorldCarryItem.EventUpdateOffset) then
		var0_5.anchoredPosition3D = arg0_5.theme:GetLinePosition(var3_5, var4_5)
	end

	if arg1_5 == nil or arg1_5 == WorldMapFleet.EventUpdateLocation or arg1_5 == WorldCarryItem.EventUpdateOffset then
		arg0_5:SetModelOrder(WorldConst.LOFleet, var3_5)
	end

	if arg1_5 == nil then
		local var5_5 = var2_5:IsAvatar()
		local var6_5 = var0_5:Find("char")
		local var7_5 = var0_5:Find("icon")

		setActive(var6_5, var5_5)
		setActive(var7_5, not var5_5)

		if var5_5 then
			arg0_5:LoadModel(WorldConst.ModelSpine, var2_5.config.icon, nil, true, function()
				arg0_5.model:SetParent(var6_5:Find("ship"), false)
			end)
		else
			arg0_5:LoadModel(WorldConst.ModelPrefab, WorldConst.ResBoxPrefab .. var2_5.config.icon, var2_5.config.icon, true, function()
				arg0_5.model:SetParent(var7_5, false)
			end)
		end

		setActive(var0_5:Find("buffs"), false)
		setActive(var0_5:Find("map_buff"), false)
	end
end

function var0_0.UpdateActive(arg0_8, arg1_8)
	if arg0_8.active ~= arg1_8 then
		arg0_8.active = arg1_8

		setActive(arg0_8.transform, arg0_8.active)
	end
end

function var0_0.FollowPath(arg0_9, arg1_9)
	if not arg0_9.wsMapPath then
		arg0_9.wsMapPath = WSMapPath.New()

		arg0_9.wsMapPath:Setup(arg0_9.theme)
		arg0_9.wsMapPath:AddListener(WSMapPath.EventArrived, arg0_9.onMoveEnd)
	end

	arg0_9.followList = arg0_9.followList or {}

	table.insert(arg0_9.followList, function()
		local var0_10, var1_10 = arg0_9:GetLocation()
		local var2_10 = {
			row = var0_10,
			column = var1_10
		}

		arg0_9.wsMapPath:UpdateObject(arg0_9)
		arg0_9.wsMapPath:UpdateAction(WorldConst.ActionMove)
		arg0_9.wsMapPath:UpdateDirType(WorldConst.DirType2)
		arg0_9.wsMapPath:StartMove(var2_10, arg1_9)
	end)

	if not arg0_9.isMoving then
		arg0_9:OnMoveEnd()
	end

	return arg0_9.wsMapPath
end

function var0_0.OnMoveEnd(arg0_11, arg1_11)
	if #arg0_11.followList > 0 then
		table.remove(arg0_11.followList, 1)()
	end
end

function var0_0.GetLocation(arg0_12)
	return arg0_12.fleet.row + arg0_12.carryItem.offsetRow, arg0_12.fleet.column + arg0_12.carryItem.offsetColumn
end

return var0_0
