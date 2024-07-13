local var0_0 = class("WSCompass", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onAdd = "OnAdd",
	onRemove = "OnRemove",
	onUpdateAttachment = "OnUpdateAttachment"
}

function var0_0.GetCompassTpl(arg0_1)
	if arg0_1 == WorldMapAttachment.CompassTypeBattle then
		return "compassBat_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeExploration then
		return "compassExp_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeTask then
		return "compassTask_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeBoss then
		return "compassBoss_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeGuidePost then
		return "compassGuidepost_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeTaskTrack then
		return "compassTask_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypePort then
		return "compassPort_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeSalvage then
		return "compassSalvage_tpl"
	elseif arg0_1 == WorldMapAttachment.CompassTypeFile then
		return "compassFile_tpl"
	end
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.ROTATIONOFFSET = 45
	arg0_2.rangeTF = arg0_2.tf:Find("range")
	arg0_2.anchor = arg0_2.rangeTF:Find("anchor")
	arg0_2.border = arg0_2.rangeTF:Find("mask/border")
	arg0_2.fov = WorldConst.GetFOVRadius() * 2
	arg0_2.diameter = arg0_2.fov * 2
	arg0_2.normal = arg0_2.rangeTF.sizeDelta.x / arg0_2.diameter
	arg0_2.marks = {}
	arg0_2.prevFleetPos = nil
	arg0_2.scaleRate = arg1_2 and Vector3.one or Vector3.New(0.7, 0.7, 1)
end

function var0_0.Update(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg2_3:GetFleet()
	local var1_3, var2_3 = arg2_3:GetMapSize()
	local var3_3 = Vector2(var1_3 - 1, var2_3 - 1)

	if arg0_3.entrance ~= arg1_3 or arg0_3.map ~= arg2_3 or arg0_3.gid ~= arg2_3.gid then
		arg0_3.entrance = arg1_3
		arg0_3.map = arg2_3
		arg0_3.gid = arg2_3.gid

		arg0_3:InitCells(var3_3)
	end

	arg0_3:UpdateMarks(var3_3, var0_3.row, var0_3.column)
	arg0_3:UpdateBorder(var3_3, var0_3.row, var0_3.column)
	arg0_3:UpdateFleetPos(var0_3, var0_3.row, var0_3.column)
end

function var0_0.UpdateByViewer(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg1_4:GetFleet()
	local var1_4, var2_4 = arg1_4:GetMapSize()
	local var3_4 = Vector2(var1_4 - 1, var2_4 - 1)

	arg0_4:ClearMarks()
	arg0_4:UpdateMarks(var3_4, arg2_4, arg3_4)
	arg0_4:UpdateBorder(var3_4, arg2_4, arg3_4)
	arg0_4:UpdateFleetPos(var0_4, arg2_4, arg3_4)
end

function var0_0.InitCells(arg0_5, arg1_5)
	local var0_5 = arg0_5.map

	arg0_5:RemoveCellsListener()

	arg0_5.cells = {}

	for iter0_5 = 0, arg1_5.x do
		for iter1_5 = 0, arg1_5.y do
			local var1_5 = var0_5:GetCell(iter0_5, iter1_5)

			if var1_5 then
				arg0_5:AddCellListener(var1_5)
				table.insert(arg0_5.cells, var1_5)
			end
		end
	end
end

function var0_0.UpdateMarks(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg0_6.map

	_.each(arg0_6.cells, function(arg0_7)
		if WorldConst.InFOVRange(arg2_6, arg3_6, arg0_7.row, arg0_7.column, arg0_6.fov) then
			arg0_6:UpdateInnerMark(arg0_7, arg2_6, arg3_6)
		else
			arg0_6:UpdateOutsideMark(arg0_7, arg2_6, arg3_6)
		end
	end)
end

function var0_0.UpdateFleetPos(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8

	if WorldConst.InFOVRange(arg2_8, arg3_8, arg1_8.row, arg1_8.column, arg0_8.fov) then
		var0_8 = arg0_8:CalcInnerPos(arg1_8.row, arg1_8.column, arg2_8, arg3_8)
	else
		var0_8 = arg0_8:CalcOutsidePos(arg1_8.row, arg1_8.column, arg2_8, arg3_8)
	end

	setAnchoredPosition(arg0_8.anchor, var0_8)
end

function var0_0.AddCellListener(arg0_9, arg1_9)
	arg1_9:AddListener(WorldMapCell.EventAddAttachment, arg0_9.onAdd)
	arg1_9:AddListener(WorldMapCell.EventRemoveAttachment, arg0_9.onRemove)
	_.each(arg1_9.attachments, function(arg0_10)
		arg0_10:AddListener(WorldMapAttachment.EventUpdateLurk, arg0_9.onUpdateAttachment)
		arg0_10:AddListener(WorldMapAttachment.EventUpdateData, arg0_9.onUpdateAttachment)
		arg0_10:AddListener(WorldMapAttachment.EventUpdateFlag, arg0_9.onUpdateAttachment)
	end)
end

function var0_0.RemoveCellsListener(arg0_11)
	_.each(arg0_11.cells or {}, function(arg0_12)
		arg0_12:RemoveListener(WorldMapCell.EventAddAttachment, arg0_11.onAdd)
		arg0_12:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0_11.onRemove)
		_.each(arg0_12.attachments, function(arg0_13)
			arg0_13:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0_11.onUpdateAttachment)
			arg0_13:RemoveListener(WorldMapAttachment.EventUpdateData, arg0_11.onUpdateAttachment)
			arg0_13:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0_11.onUpdateAttachment)
		end)
	end)
end

function var0_0.OnAdd(arg0_14, arg1_14, arg2_14, arg3_14)
	arg3_14:AddListener(WorldMapAttachment.EventUpdateLurk, arg0_14.onUpdateAttachment)
	arg3_14:AddListener(WorldMapAttachment.EventUpdateData, arg0_14.onUpdateAttachment)
	arg3_14:AddListener(WorldMapAttachment.EventUpdateFlag, arg0_14.onUpdateAttachment)
	arg0_14:ClearMarks()
	arg0_14:Update(arg0_14.entrance, arg0_14.map)
end

function var0_0.OnRemove(arg0_15, arg1_15, arg2_15, arg3_15)
	arg3_15:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0_15.onUpdateAttachment)
	arg3_15:RemoveListener(WorldMapAttachment.EventUpdateData, arg0_15.onUpdateAttachment)
	arg3_15:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0_15.onUpdateAttachment)
	arg0_15:ClearMarks()
	arg0_15:Update(arg0_15.entrance, arg0_15.map)
end

function var0_0.OnUpdateAttachment(arg0_16)
	if arg0_16.map and arg0_16.map.active then
		arg0_16:ClearMarks()
		arg0_16:Update(arg0_16.entrance, arg0_16.map)
	end
end

function var0_0.UpdateCompassRotation(arg0_17, arg1_17)
	local var0_17 = Vector2(arg1_17.column, arg1_17.row)

	if arg0_17.prevFleetPos == var0_17 then
		return
	end

	if arg0_17.prevFleetPos then
		local var1_17 = calcPositionAngle(arg0_17.prevFleetPos.x - var0_17.x, arg0_17.prevFleetPos.y - var0_17.y)

		arg0_17.anchor.localEulerAngles = Vector3(0, 0, arg0_17.ROTATIONOFFSET + var1_17)
	else
		arg0_17.anchor.localEulerAngles = Vector3(0, 0, arg0_17.ROTATIONOFFSET)
	end

	arg0_17.prevFleetPos = Vector2(arg1_17.column, arg1_17.row)

	arg0_17.anchor:SetAsLastSibling()
end

function var0_0.GetAnchorEulerAngles(arg0_18)
	return arg0_18.anchor.localEulerAngles
end

function var0_0.SetAnchorEulerAngles(arg0_19, arg1_19)
	arg0_19.anchor.localEulerAngles = arg1_19
end

function var0_0.UpdateBorder(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg1_20.x
	local var1_20 = arg1_20.y * arg0_20.normal
	local var2_20 = var0_20 * arg0_20.normal

	arg0_20.border.sizeDelta = Vector2(var1_20, var2_20)
	arg0_20.border.anchoredPosition = Vector2(-arg3_20 * arg0_20.normal, arg2_20 * arg0_20.normal)
end

function var0_0.getVector(arg0_21, arg1_21)
	return Vector2(arg1_21.config.area_pos[1], arg1_21.config.area_pos[2])
end

function var0_0.CalcTaskMarkPos(arg0_22, arg1_22)
	local var0_22 = calcPositionAngle(arg1_22.x, arg1_22.y)
	local var1_22 = arg0_22.normal * (arg0_22.fov + 1)
	local var2_22 = math.sin(math.rad(var0_22)) * var1_22
	local var3_22 = math.cos(math.rad(var0_22)) * var1_22

	return Vector3(var2_22, var3_22, 0)
end

function var0_0.UpdateInnerMark(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg0_23.map
	local var1_23 = arg1_23:GetCompassAttachment()

	if var1_23 then
		local var2_23 = var1_23:GetCompassType()

		if var2_23 and var2_23 ~= WorldMapAttachment.CompassTypeNone then
			local var3_23 = arg0_23:CalcInnerPos(arg1_23.row, arg1_23.column, arg2_23, arg3_23)

			arg0_23:NewMark(var2_23, var3_23, var1_23.config.id)
		end
	elseif #var0_23.ports > 0 then
		local var4_23, var5_23 = unpack(var0_23.config.port_id[2])

		if var4_23 == arg1_23.row and var5_23 == arg1_23.column then
			local var6_23 = arg0_23:CalcInnerPos(arg1_23.row, arg1_23.column, arg2_23, arg3_23)

			arg0_23:NewMark(WorldMapAttachment.CompassTypePort, var6_23)
		end
	end
end

function var0_0.CalcInnerPos(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	local var0_24 = Vector2(arg2_24 - arg4_24, -1 * (arg1_24 - arg3_24))

	return Vector3(arg0_24.normal * var0_24.x, arg0_24.normal * var0_24.y, 0)
end

function var0_0.UpdateOutsideMark(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg0_25.map
	local var1_25 = arg1_25:GetCompassAttachment()

	if var1_25 then
		local var2_25 = var1_25:GetCompassType()

		if var2_25 == WorldMapAttachment.CompassTypeBoss or var2_25 == WorldMapAttachment.CompassTypeTask or var2_25 == WorldMapAttachment.CompassTypePort then
			local var3_25 = arg0_25:CalcOutsidePos(arg1_25.row, arg1_25.column, arg2_25, arg3_25)

			arg0_25:NewMark(var2_25, var3_25)
		end
	elseif #var0_25.ports > 0 then
		local var4_25, var5_25 = unpack(var0_25.config.port_id[2])

		if var4_25 == arg1_25.row and var5_25 == arg1_25.column then
			local var6_25 = arg0_25:CalcOutsidePos(arg1_25.row, arg1_25.column, arg2_25, arg3_25)

			arg0_25:NewMark(WorldMapAttachment.CompassTypePort, var6_25)
		end
	end
end

function var0_0.CalcOutsidePos(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = Vector2.Angle(Vector2(arg1_26 - arg3_26, arg2_26 - arg4_26), Vector2.up)
	local var1_26 = math.abs(var0_26 - 90)
	local var2_26 = Vector2(arg2_26 - arg4_26, arg3_26 - arg1_26)
	local var3_26 = arg0_26.normal * (arg0_26.fov + 0.5)
	local var4_26 = math.sin(math.rad(var1_26)) * var3_26 * Mathf.Sign(var2_26.x)
	local var5_26 = math.cos(math.rad(var1_26)) * var3_26 * Mathf.Sign(var2_26.y)

	return Vector3(var4_26, var5_26, 0)
end

function var0_0.NewMark(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = var0_0.GetCompassTpl(arg1_27)
	local var1_27 = arg0_27.pool:Get(var0_27)

	var1_27.transform.localScale = arg0_27.scaleRate
	var1_27.name = arg3_27 or "mark"

	setParent(var1_27, arg0_27.rangeTF)

	tf(var1_27).localPosition = arg2_27

	table.insert(arg0_27.marks, {
		name = var0_27,
		go = var1_27
	})
end

function var0_0.NewTransportMark(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.pool:Get(arg1_28)

	setParent(var0_28, arg0_28.border)

	var0_28.transform.localScale = arg0_28.scaleRate

	local var1_28 = Vector3(arg2_28.y * arg0_28.normal, -arg2_28.x * arg0_28.normal, 0)

	var0_28.transform.anchorMin = Vector2(0, 1)
	var0_28.transform.anchorMax = Vector2(0, 1)
	var0_28.transform.anchoredPosition3D = var1_28

	table.insert(arg0_28.marks, {
		name = arg1_28,
		go = var0_28
	})
end

function var0_0.ClearMarks(arg0_29)
	_.each(arg0_29.marks, function(arg0_30)
		arg0_30.go.transform.localScale = Vector3.one

		arg0_29.pool:Return(arg0_30.name, arg0_30.go)
	end)

	arg0_29.marks = {}
end

function var0_0.GetMarkPosition(arg0_31, arg1_31, arg2_31)
	assert(arg0_31.map)

	local var0_31 = arg0_31.map:GetFleet()
	local var1_31

	if WorldConst.InFOVRange(var0_31.row, var0_31.column, arg1_31, arg2_31, arg0_31.fov) then
		var1_31 = arg0_31:CalcInnerPos(arg1_31, arg2_31, var0_31.row, var0_31.column)
	else
		var1_31 = arg0_31:CalcOutsidePos(arg1_31, arg2_31, var0_31.row, var0_31.column)
	end

	return arg0_31.rangeTF:TransformPoint(var1_31)
end

function var0_0.GetEntranceTrackMark(arg0_32, arg1_32)
	assert(arg0_32.entrance)

	local var0_32 = nowWorld():GetMap(arg1_32)
	local var1_32, var2_32 = arg0_32:getVector(var0_32)
	local var3_32, var4_32 = arg0_32:getVector(arg0_32.entrance)
	local var5_32 = arg0_32:CalcTaskMarkPos(var1_32, var2_32, var3_32, var4_32)

	return arg0_32.rangeTF:TransformPoint(var5_32)
end

function var0_0.Dispose(arg0_33)
	arg0_33:RemoveCellsListener()
	arg0_33:ClearMarks()
	arg0_33:Clear()
end

return var0_0
