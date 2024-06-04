local var0 = class("WSCompass", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	scaleRate = "table",
	ROTATIONOFFSET = "number",
	cells = "table",
	anchor = "userdata",
	diameter = "number",
	gid = "number",
	border = "userdata",
	prevFleetPos = "table",
	marks = "table",
	tf = "userdata",
	pool = "table",
	rangeTF = "userdata",
	entrance = "table",
	fov = "number",
	normal = "number"
}
var0.Listeners = {
	onAdd = "OnAdd",
	onRemove = "OnRemove",
	onUpdateAttachment = "OnUpdateAttachment"
}

function var0.GetCompassTpl(arg0)
	if arg0 == WorldMapAttachment.CompassTypeBattle then
		return "compassBat_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeExploration then
		return "compassExp_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeTask then
		return "compassTask_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeBoss then
		return "compassBoss_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeGuidePost then
		return "compassGuidepost_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeTaskTrack then
		return "compassTask_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypePort then
		return "compassPort_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeSalvage then
		return "compassSalvage_tpl"
	elseif arg0 == WorldMapAttachment.CompassTypeFile then
		return "compassFile_tpl"
	end
end

function var0.Setup(arg0, arg1)
	arg0.ROTATIONOFFSET = 45
	arg0.rangeTF = arg0.tf:Find("range")
	arg0.anchor = arg0.rangeTF:Find("anchor")
	arg0.border = arg0.rangeTF:Find("mask/border")
	arg0.fov = WorldConst.GetFOVRadius() * 2
	arg0.diameter = arg0.fov * 2
	arg0.normal = arg0.rangeTF.sizeDelta.x / arg0.diameter
	arg0.marks = {}
	arg0.prevFleetPos = nil
	arg0.scaleRate = arg1 and Vector3.one or Vector3.New(0.7, 0.7, 1)
end

function var0.Update(arg0, arg1, arg2)
	local var0 = arg2:GetFleet()
	local var1, var2 = arg2:GetMapSize()
	local var3 = Vector2(var1 - 1, var2 - 1)

	if arg0.entrance ~= arg1 or arg0.map ~= arg2 or arg0.gid ~= arg2.gid then
		arg0.entrance = arg1
		arg0.map = arg2
		arg0.gid = arg2.gid

		arg0:InitCells(var3)
	end

	arg0:UpdateMarks(var3, var0.row, var0.column)
	arg0:UpdateBorder(var3, var0.row, var0.column)
	arg0:UpdateFleetPos(var0, var0.row, var0.column)
end

function var0.UpdateByViewer(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetFleet()
	local var1, var2 = arg1:GetMapSize()
	local var3 = Vector2(var1 - 1, var2 - 1)

	arg0:ClearMarks()
	arg0:UpdateMarks(var3, arg2, arg3)
	arg0:UpdateBorder(var3, arg2, arg3)
	arg0:UpdateFleetPos(var0, arg2, arg3)
end

function var0.InitCells(arg0, arg1)
	local var0 = arg0.map

	arg0:RemoveCellsListener()

	arg0.cells = {}

	for iter0 = 0, arg1.x do
		for iter1 = 0, arg1.y do
			local var1 = var0:GetCell(iter0, iter1)

			if var1 then
				arg0:AddCellListener(var1)
				table.insert(arg0.cells, var1)
			end
		end
	end
end

function var0.UpdateMarks(arg0, arg1, arg2, arg3)
	local var0 = arg0.map

	_.each(arg0.cells, function(arg0)
		if WorldConst.InFOVRange(arg2, arg3, arg0.row, arg0.column, arg0.fov) then
			arg0:UpdateInnerMark(arg0, arg2, arg3)
		else
			arg0:UpdateOutsideMark(arg0, arg2, arg3)
		end
	end)
end

function var0.UpdateFleetPos(arg0, arg1, arg2, arg3)
	local var0

	if WorldConst.InFOVRange(arg2, arg3, arg1.row, arg1.column, arg0.fov) then
		var0 = arg0:CalcInnerPos(arg1.row, arg1.column, arg2, arg3)
	else
		var0 = arg0:CalcOutsidePos(arg1.row, arg1.column, arg2, arg3)
	end

	setAnchoredPosition(arg0.anchor, var0)
end

function var0.AddCellListener(arg0, arg1)
	arg1:AddListener(WorldMapCell.EventAddAttachment, arg0.onAdd)
	arg1:AddListener(WorldMapCell.EventRemoveAttachment, arg0.onRemove)
	_.each(arg1.attachments, function(arg0)
		arg0:AddListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)
		arg0:AddListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
		arg0:AddListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	end)
end

function var0.RemoveCellsListener(arg0)
	_.each(arg0.cells or {}, function(arg0)
		arg0:RemoveListener(WorldMapCell.EventAddAttachment, arg0.onAdd)
		arg0:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0.onRemove)
		_.each(arg0.attachments, function(arg0)
			arg0:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)
			arg0:RemoveListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
			arg0:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
		end)
	end)
end

function var0.OnAdd(arg0, arg1, arg2, arg3)
	arg3:AddListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)
	arg3:AddListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
	arg3:AddListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	arg0:ClearMarks()
	arg0:Update(arg0.entrance, arg0.map)
end

function var0.OnRemove(arg0, arg1, arg2, arg3)
	arg3:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)
	arg3:RemoveListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
	arg3:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	arg0:ClearMarks()
	arg0:Update(arg0.entrance, arg0.map)
end

function var0.OnUpdateAttachment(arg0)
	if arg0.map and arg0.map.active then
		arg0:ClearMarks()
		arg0:Update(arg0.entrance, arg0.map)
	end
end

function var0.UpdateCompassRotation(arg0, arg1)
	local var0 = Vector2(arg1.column, arg1.row)

	if arg0.prevFleetPos == var0 then
		return
	end

	if arg0.prevFleetPos then
		local var1 = calcPositionAngle(arg0.prevFleetPos.x - var0.x, arg0.prevFleetPos.y - var0.y)

		arg0.anchor.localEulerAngles = Vector3(0, 0, arg0.ROTATIONOFFSET + var1)
	else
		arg0.anchor.localEulerAngles = Vector3(0, 0, arg0.ROTATIONOFFSET)
	end

	arg0.prevFleetPos = Vector2(arg1.column, arg1.row)

	arg0.anchor:SetAsLastSibling()
end

function var0.GetAnchorEulerAngles(arg0)
	return arg0.anchor.localEulerAngles
end

function var0.SetAnchorEulerAngles(arg0, arg1)
	arg0.anchor.localEulerAngles = arg1
end

function var0.UpdateBorder(arg0, arg1, arg2, arg3)
	local var0 = arg1.x
	local var1 = arg1.y * arg0.normal
	local var2 = var0 * arg0.normal

	arg0.border.sizeDelta = Vector2(var1, var2)
	arg0.border.anchoredPosition = Vector2(-arg3 * arg0.normal, arg2 * arg0.normal)
end

function var0.getVector(arg0, arg1)
	return Vector2(arg1.config.area_pos[1], arg1.config.area_pos[2])
end

function var0.CalcTaskMarkPos(arg0, arg1)
	local var0 = calcPositionAngle(arg1.x, arg1.y)
	local var1 = arg0.normal * (arg0.fov + 1)
	local var2 = math.sin(math.rad(var0)) * var1
	local var3 = math.cos(math.rad(var0)) * var1

	return Vector3(var2, var3, 0)
end

function var0.UpdateInnerMark(arg0, arg1, arg2, arg3)
	local var0 = arg0.map
	local var1 = arg1:GetCompassAttachment()

	if var1 then
		local var2 = var1:GetCompassType()

		if var2 and var2 ~= WorldMapAttachment.CompassTypeNone then
			local var3 = arg0:CalcInnerPos(arg1.row, arg1.column, arg2, arg3)

			arg0:NewMark(var2, var3, var1.config.id)
		end
	elseif #var0.ports > 0 then
		local var4, var5 = unpack(var0.config.port_id[2])

		if var4 == arg1.row and var5 == arg1.column then
			local var6 = arg0:CalcInnerPos(arg1.row, arg1.column, arg2, arg3)

			arg0:NewMark(WorldMapAttachment.CompassTypePort, var6)
		end
	end
end

function var0.CalcInnerPos(arg0, arg1, arg2, arg3, arg4)
	local var0 = Vector2(arg2 - arg4, -1 * (arg1 - arg3))

	return Vector3(arg0.normal * var0.x, arg0.normal * var0.y, 0)
end

function var0.UpdateOutsideMark(arg0, arg1, arg2, arg3)
	local var0 = arg0.map
	local var1 = arg1:GetCompassAttachment()

	if var1 then
		local var2 = var1:GetCompassType()

		if var2 == WorldMapAttachment.CompassTypeBoss or var2 == WorldMapAttachment.CompassTypeTask or var2 == WorldMapAttachment.CompassTypePort then
			local var3 = arg0:CalcOutsidePos(arg1.row, arg1.column, arg2, arg3)

			arg0:NewMark(var2, var3)
		end
	elseif #var0.ports > 0 then
		local var4, var5 = unpack(var0.config.port_id[2])

		if var4 == arg1.row and var5 == arg1.column then
			local var6 = arg0:CalcOutsidePos(arg1.row, arg1.column, arg2, arg3)

			arg0:NewMark(WorldMapAttachment.CompassTypePort, var6)
		end
	end
end

function var0.CalcOutsidePos(arg0, arg1, arg2, arg3, arg4)
	local var0 = Vector2.Angle(Vector2(arg1 - arg3, arg2 - arg4), Vector2.up)
	local var1 = math.abs(var0 - 90)
	local var2 = Vector2(arg2 - arg4, arg3 - arg1)
	local var3 = arg0.normal * (arg0.fov + 0.5)
	local var4 = math.sin(math.rad(var1)) * var3 * Mathf.Sign(var2.x)
	local var5 = math.cos(math.rad(var1)) * var3 * Mathf.Sign(var2.y)

	return Vector3(var4, var5, 0)
end

function var0.NewMark(arg0, arg1, arg2, arg3)
	local var0 = var0.GetCompassTpl(arg1)
	local var1 = arg0.pool:Get(var0)

	var1.transform.localScale = arg0.scaleRate
	var1.name = arg3 or "mark"

	setParent(var1, arg0.rangeTF)

	tf(var1).localPosition = arg2

	table.insert(arg0.marks, {
		name = var0,
		go = var1
	})
end

function var0.NewTransportMark(arg0, arg1, arg2)
	local var0 = arg0.pool:Get(arg1)

	setParent(var0, arg0.border)

	var0.transform.localScale = arg0.scaleRate

	local var1 = Vector3(arg2.y * arg0.normal, -arg2.x * arg0.normal, 0)

	var0.transform.anchorMin = Vector2(0, 1)
	var0.transform.anchorMax = Vector2(0, 1)
	var0.transform.anchoredPosition3D = var1

	table.insert(arg0.marks, {
		name = arg1,
		go = var0
	})
end

function var0.ClearMarks(arg0)
	_.each(arg0.marks, function(arg0)
		arg0.go.transform.localScale = Vector3.one

		arg0.pool:Return(arg0.name, arg0.go)
	end)

	arg0.marks = {}
end

function var0.GetMarkPosition(arg0, arg1, arg2)
	assert(arg0.map)

	local var0 = arg0.map:GetFleet()
	local var1

	if WorldConst.InFOVRange(var0.row, var0.column, arg1, arg2, arg0.fov) then
		var1 = arg0:CalcInnerPos(arg1, arg2, var0.row, var0.column)
	else
		var1 = arg0:CalcOutsidePos(arg1, arg2, var0.row, var0.column)
	end

	return arg0.rangeTF:TransformPoint(var1)
end

function var0.GetEntranceTrackMark(arg0, arg1)
	assert(arg0.entrance)

	local var0 = nowWorld():GetMap(arg1)
	local var1, var2 = arg0:getVector(var0)
	local var3, var4 = arg0:getVector(arg0.entrance)
	local var5 = arg0:CalcTaskMarkPos(var1, var2, var3, var4)

	return arg0.rangeTF:TransformPoint(var5)
end

function var0.Dispose(arg0)
	arg0:RemoveCellsListener()
	arg0:ClearMarks()
	arg0:Clear()
end

return var0
