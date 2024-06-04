local var0 = class("WSCarryItem", import(".WSMapTransform"))

var0.Fields = {
	wsMapPath = "table",
	active = "boolean",
	followList = "table",
	theme = "table",
	fleet = "table",
	carryItem = "table"
}
var0.Listeners = {
	onUpdate = "Update",
	onMoveEnd = "OnMoveEnd"
}

function var0.GetResName(arg0)
	return "event_tpl"
end

function var0.Setup(arg0, arg1, arg2, arg3)
	arg0.fleet = arg1

	arg0.fleet:AddListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdate)

	arg0.carryItem = arg2

	arg0.carryItem:AddListener(WorldCarryItem.EventUpdateOffset, arg0.onUpdate)

	arg0.theme = arg3

	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.fleet:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdate)
	arg0.carryItem:RemoveListener(WorldCarryItem.EventUpdateOffset, arg0.onUpdate)

	if arg0.wsMapPath then
		arg0.wsMapPath:RemoveListener(WSMapPath.EventArrived, arg0.onMoveEnd)
		arg0.wsMapPath:Dispose()
	end

	var0.super.Dispose(arg0)
end

function var0.Init(arg0)
	local var0 = arg0.transform

	var0.name = "carry_item_" .. arg0.carryItem.id
	var0.localEulerAngles = Vector3(-arg0.theme.angle, 0, 0)

	arg0:Update()
	arg0:UpdateActive(arg0.active or true)
	arg0:UpdateModelScale(arg0.carryItem:GetScale())
end

function var0.Update(arg0, arg1)
	local var0 = arg0.transform
	local var1 = arg0.fleet
	local var2 = arg0.carryItem
	local var3, var4 = arg0:GetLocation()

	if not arg0.isMoving and (arg1 == nil or arg1 == WorldMapFleet.EventUpdateLocation or arg1 == WorldCarryItem.EventUpdateOffset) then
		var0.anchoredPosition3D = arg0.theme:GetLinePosition(var3, var4)
	end

	if arg1 == nil or arg1 == WorldMapFleet.EventUpdateLocation or arg1 == WorldCarryItem.EventUpdateOffset then
		arg0:SetModelOrder(WorldConst.LOFleet, var3)
	end

	if arg1 == nil then
		local var5 = var2:IsAvatar()
		local var6 = var0:Find("char")
		local var7 = var0:Find("icon")

		setActive(var6, var5)
		setActive(var7, not var5)

		if var5 then
			arg0:LoadModel(WorldConst.ModelSpine, var2.config.icon, nil, true, function()
				arg0.model:SetParent(var6:Find("ship"), false)
			end)
		else
			arg0:LoadModel(WorldConst.ModelPrefab, WorldConst.ResBoxPrefab .. var2.config.icon, var2.config.icon, true, function()
				arg0.model:SetParent(var7, false)
			end)
		end

		setActive(var0:Find("buffs"), false)
		setActive(var0:Find("map_buff"), false)
	end
end

function var0.UpdateActive(arg0, arg1)
	if arg0.active ~= arg1 then
		arg0.active = arg1

		setActive(arg0.transform, arg0.active)
	end
end

function var0.FollowPath(arg0, arg1)
	if not arg0.wsMapPath then
		arg0.wsMapPath = WSMapPath.New()

		arg0.wsMapPath:Setup(arg0.theme)
		arg0.wsMapPath:AddListener(WSMapPath.EventArrived, arg0.onMoveEnd)
	end

	arg0.followList = arg0.followList or {}

	table.insert(arg0.followList, function()
		local var0, var1 = arg0:GetLocation()
		local var2 = {
			row = var0,
			column = var1
		}

		arg0.wsMapPath:UpdateObject(arg0)
		arg0.wsMapPath:UpdateAction(WorldConst.ActionMove)
		arg0.wsMapPath:UpdateDirType(WorldConst.DirType2)
		arg0.wsMapPath:StartMove(var2, arg1)
	end)

	if not arg0.isMoving then
		arg0:OnMoveEnd()
	end

	return arg0.wsMapPath
end

function var0.OnMoveEnd(arg0, arg1)
	if #arg0.followList > 0 then
		table.remove(arg0.followList, 1)()
	end
end

function var0.GetLocation(arg0)
	return arg0.fleet.row + arg0.carryItem.offsetRow, arg0.fleet.column + arg0.carryItem.offsetColumn
end

return var0
