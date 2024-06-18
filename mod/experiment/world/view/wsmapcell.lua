local var0_0 = class("WSMapCell", import("...BaseEntity"))

var0_0.Fields = {
	cell = "table",
	map = "table",
	maskTimer = "table",
	transform = "userdata",
	wsMapResource = "table",
	rtAttachments = "userdata",
	maskUid = "number",
	wsTimer = "table",
	rtFog = "userdata",
	fogTimer = "table",
	fogUid = "number",
	rtMask = "userdata"
}
var0_0.Listeners = {
	onUpdate = "Update",
	onUpdateFogImage = "UpdateFogImage"
}

function var0_0.GetResName()
	return "world_cell"
end

function var0_0.GetName(arg0_2, arg1_2)
	return "cell_" .. arg0_2 .. "_" .. arg1_2
end

function var0_0.Setup(arg0_3, arg1_3, arg2_3)
	assert(arg0_3.cell == nil)

	arg0_3.map = arg1_3
	arg0_3.cell = arg2_3

	arg0_3.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0_3.onUpdate)
	arg0_3.cell:AddListener(WorldMapCell.EventUpdateDiscovered, arg0_3.onUpdate)
	arg0_3.cell:AddListener(WorldMapCell.EventUpdateFog, arg0_3.onUpdate)
	arg0_3.cell:AddListener(WorldMapCell.EventUpdateFogImage, arg0_3.onUpdateFogImage)
	arg0_3:Init()
end

function var0_0.Dispose(arg0_4)
	if arg0_4.fogTimer then
		arg0_4.wsTimer:RemoveInMapTimer(arg0_4.fogTimer)

		arg0_4.fogTimer = nil
	end

	if arg0_4.fogUid then
		arg0_4.wsTimer:RemoveInMapTween(arg0_4.fogUid)

		arg0_4.fogUid = nil
	end

	if arg0_4.maskTimer then
		arg0_4.wsTimer:RemoveInMapTimer(arg0_4.maskTimer)

		arg0_4.maskTimer = nil
	end

	if arg0_4.maskUid then
		arg0_4.wsTimer:RemoveInMapTween(arg0_4.maskUid)

		arg0_4.maskUid = nil
	end

	clearImageSprite(arg0_4.rtFog:Find("dark_fog"))
	clearImageSprite(arg0_4.rtFog:Find("sairen_fog"))
	setCanvasGroupAlpha(arg0_4.rtFog, 1)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0_4.onUpdate)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateDiscovered, arg0_4.onUpdate)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateFog, arg0_4.onUpdate)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateFogImage, arg0_4.onUpdateFogImage)
	arg0_4:Clear()
end

local function var1_0(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5.anchoredPosition = arg1_5.anchoredPosition + Vector2((arg2_5.column % 3 - 1) * -arg3_5.x, (arg2_5.row % 3 - 1) * arg3_5.y)
	arg0_5.localScale = arg1_5.localScale

	setImageSprite(arg0_5, getImageSprite(arg1_5), true)
end

function var0_0.Init(arg0_6)
	local var0_6 = arg0_6.map.theme
	local var1_6 = arg0_6.cell
	local var2_6 = arg0_6.transform

	var2_6.name = var0_0.GetName(var1_6.row, var1_6.column)
	var2_6.anchoredPosition = var0_6:GetLinePosition(var1_6.row, var1_6.column)
	var2_6.sizeDelta = var0_6.cellSize
	arg0_6.rtAttachments = var2_6:Find("attachments")
	arg0_6.rtAttachments.localEulerAngles = Vector3(-var0_6.angle, 0, 0)
	arg0_6.rtMask = var2_6:Find("mask")
	arg0_6.rtMask.sizeDelta = var0_6.cellSize + Vector2(WorldConst.LineCross * 2, WorldConst.LineCross * 2)
	arg0_6.rtFog = var2_6:Find("fog")

	local var3_6 = arg0_6.map.theme
	local var4_6 = var3_6.cellSize + var3_6.cellSpace

	var1_0(arg0_6.rtFog:Find("dark_fog"), arg0_6.wsMapResource.rtDarkFog:Find(WorldConst.Pos2FogRes(var1_6.row, var1_6.column)), var1_6, var4_6)
	var1_0(arg0_6.rtFog:Find("sairen_fog"), arg0_6.wsMapResource.rtSairenFog:Find(WorldConst.Pos2FogRes(var1_6.row, var1_6.column)), var1_6, var4_6)
	arg0_6:Update()
	arg0_6:UpdateFogImage()
end

function var0_0.Update(arg0_7, arg1_7)
	local var0_7 = arg0_7.cell
	local var1_7 = arg0_7.map.centerCellFOV
	local var2_7 = 0
	local var3_7 = 0
	local var4_7 = 0

	if var1_7 then
		var3_7 = math.sqrt((var1_7.row - var0_7.row) * (var1_7.row - var0_7.row) + (var1_7.column - var0_7.column) * (var1_7.column - var0_7.column)) * 0.1
		var4_7 = 0.2
	end

	if arg1_7 == nil or arg1_7 == WorldMapCell.EventUpdateInFov or arg1_7 == WorldMapCell.EventUpdateFog then
		setActive(arg0_7.rtAttachments, var0_7:GetInFOV() and not var0_7:InFog())
	end

	if arg1_7 == nil or arg1_7 == WorldMapCell.EventUpdateFog then
		if arg0_7.fogTimer then
			arg0_7.wsTimer:RemoveInMapTimer(arg0_7.fogTimer)

			arg0_7.fogTimer = nil
		end

		if arg0_7.fogUid then
			arg0_7.wsTimer:RemoveInMapTween(arg0_7.fogUid)

			arg0_7.fogUid = nil
		end

		if var0_7:InFog() then
			if arg1_7 and var3_7 > 0 then
				setCanvasGroupAlpha(arg0_7.rtFog, 0)

				arg0_7.fogTimer = arg0_7.wsTimer:AddInMapTimer(function()
					arg0_7.fogUid = LeanTween.alphaCanvas(GetComponent(arg0_7.rtFog, typeof(CanvasGroup)), 1, var4_7).uniqueId

					arg0_7.wsTimer:AddInMapTween(arg0_7.fogUid)
				end, var3_7)

				arg0_7.fogTimer:Start()
			else
				setCanvasGroupAlpha(arg0_7.rtFog, 1)
			end
		elseif arg1_7 and var3_7 > 0 then
			arg0_7.fogTimer = arg0_7.wsTimer:AddInMapTimer(function()
				arg0_7.fogUid = LeanTween.alphaCanvas(GetComponent(arg0_7.rtFog, typeof(CanvasGroup)), 0, var4_7).uniqueId

				arg0_7.wsTimer:AddInMapTween(arg0_7.fogUid)
			end, var3_7)

			arg0_7.fogTimer:Start()
		else
			setCanvasGroupAlpha(arg0_7.rtFog, 0)
		end
	end

	if arg1_7 == nil or arg1_7 == WorldMapCell.EventUpdateInFov or arg1_7 == WorldMapCell.EventUpdateDiscovered then
		if arg0_7.maskTimer then
			arg0_7.wsTimer:RemoveInMapTimer(arg0_7.maskTimer)

			arg0_7.maskTimer = nil
		end

		if arg0_7.maskUid then
			arg0_7.wsTimer:RemoveInMapTween(arg0_7.maskUid)

			arg0_7.maskUid = nil
		end

		if var0_7:GetInFOV() then
			if arg1_7 and var3_7 > 0 then
				arg0_7.maskTimer = arg0_7.wsTimer:AddInMapTimer(function()
					arg0_7.maskUid = LeanTween.alpha(arg0_7.rtMask, 0, var4_7).uniqueId

					arg0_7.wsTimer:AddInMapTween(arg0_7.maskUid)
				end, var3_7)

				arg0_7.maskTimer:Start()
			else
				setImageAlpha(arg0_7.rtMask, 0)
			end
		else
			local var5_7 = var0_7.discovered and 0.3 or 0.8

			if arg1_7 and var3_7 > 0 then
				arg0_7.maskTimer = arg0_7.wsTimer:AddInMapTimer(function()
					arg0_7.maskUid = LeanTween.alpha(arg0_7.rtMask, var5_7, var4_7).uniqueId

					arg0_7.wsTimer:AddInMapTween(arg0_7.maskUid)
				end, var3_7)

				arg0_7.maskTimer:Start()
			else
				setImageAlpha(arg0_7.rtMask, var5_7)
			end
		end
	end
end

function var0_0.UpdateFogImage(arg0_12)
	local var0_12 = arg0_12.cell:LookSairenFog()

	setImageAlpha(arg0_12.rtFog:Find("dark_fog"), var0_12 and 0 or 1)
	setImageAlpha(arg0_12.rtFog:Find("sairen_fog"), var0_12 and 1 or 0)
end

function var0_0.GetWorldPos(arg0_13)
	local var0_13 = Vector3.New(arg0_13.transform.localPosition.x, arg0_13.transform.localPosition.y, 0)

	return arg0_13.transform.parent:TransformPoint(var0_13)
end

return var0_0
