local var0 = class("WSMapCell", import("...BaseEntity"))

var0.Fields = {
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
var0.Listeners = {
	onUpdate = "Update",
	onUpdateFogImage = "UpdateFogImage"
}

function var0.GetResName()
	return "world_cell"
end

function var0.GetName(arg0, arg1)
	return "cell_" .. arg0 .. "_" .. arg1
end

function var0.Setup(arg0, arg1, arg2)
	assert(arg0.cell == nil)

	arg0.map = arg1
	arg0.cell = arg2

	arg0.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:AddListener(WorldMapCell.EventUpdateDiscovered, arg0.onUpdate)
	arg0.cell:AddListener(WorldMapCell.EventUpdateFog, arg0.onUpdate)
	arg0.cell:AddListener(WorldMapCell.EventUpdateFogImage, arg0.onUpdateFogImage)
	arg0:Init()
end

function var0.Dispose(arg0)
	if arg0.fogTimer then
		arg0.wsTimer:RemoveInMapTimer(arg0.fogTimer)

		arg0.fogTimer = nil
	end

	if arg0.fogUid then
		arg0.wsTimer:RemoveInMapTween(arg0.fogUid)

		arg0.fogUid = nil
	end

	if arg0.maskTimer then
		arg0.wsTimer:RemoveInMapTimer(arg0.maskTimer)

		arg0.maskTimer = nil
	end

	if arg0.maskUid then
		arg0.wsTimer:RemoveInMapTween(arg0.maskUid)

		arg0.maskUid = nil
	end

	clearImageSprite(arg0.rtFog:Find("dark_fog"))
	clearImageSprite(arg0.rtFog:Find("sairen_fog"))
	setCanvasGroupAlpha(arg0.rtFog, 1)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateDiscovered, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateFog, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateFogImage, arg0.onUpdateFogImage)
	arg0:Clear()
end

local function var1(arg0, arg1, arg2, arg3)
	arg0.anchoredPosition = arg1.anchoredPosition + Vector2((arg2.column % 3 - 1) * -arg3.x, (arg2.row % 3 - 1) * arg3.y)
	arg0.localScale = arg1.localScale

	setImageSprite(arg0, getImageSprite(arg1), true)
end

function var0.Init(arg0)
	local var0 = arg0.map.theme
	local var1 = arg0.cell
	local var2 = arg0.transform

	var2.name = var0.GetName(var1.row, var1.column)
	var2.anchoredPosition = var0:GetLinePosition(var1.row, var1.column)
	var2.sizeDelta = var0.cellSize
	arg0.rtAttachments = var2:Find("attachments")
	arg0.rtAttachments.localEulerAngles = Vector3(-var0.angle, 0, 0)
	arg0.rtMask = var2:Find("mask")
	arg0.rtMask.sizeDelta = var0.cellSize + Vector2(WorldConst.LineCross * 2, WorldConst.LineCross * 2)
	arg0.rtFog = var2:Find("fog")

	local var3 = arg0.map.theme
	local var4 = var3.cellSize + var3.cellSpace

	var1(arg0.rtFog:Find("dark_fog"), arg0.wsMapResource.rtDarkFog:Find(WorldConst.Pos2FogRes(var1.row, var1.column)), var1, var4)
	var1(arg0.rtFog:Find("sairen_fog"), arg0.wsMapResource.rtSairenFog:Find(WorldConst.Pos2FogRes(var1.row, var1.column)), var1, var4)
	arg0:Update()
	arg0:UpdateFogImage()
end

function var0.Update(arg0, arg1)
	local var0 = arg0.cell
	local var1 = arg0.map.centerCellFOV
	local var2 = 0
	local var3 = 0
	local var4 = 0

	if var1 then
		var3 = math.sqrt((var1.row - var0.row) * (var1.row - var0.row) + (var1.column - var0.column) * (var1.column - var0.column)) * 0.1
		var4 = 0.2
	end

	if arg1 == nil or arg1 == WorldMapCell.EventUpdateInFov or arg1 == WorldMapCell.EventUpdateFog then
		setActive(arg0.rtAttachments, var0:GetInFOV() and not var0:InFog())
	end

	if arg1 == nil or arg1 == WorldMapCell.EventUpdateFog then
		if arg0.fogTimer then
			arg0.wsTimer:RemoveInMapTimer(arg0.fogTimer)

			arg0.fogTimer = nil
		end

		if arg0.fogUid then
			arg0.wsTimer:RemoveInMapTween(arg0.fogUid)

			arg0.fogUid = nil
		end

		if var0:InFog() then
			if arg1 and var3 > 0 then
				setCanvasGroupAlpha(arg0.rtFog, 0)

				arg0.fogTimer = arg0.wsTimer:AddInMapTimer(function()
					arg0.fogUid = LeanTween.alphaCanvas(GetComponent(arg0.rtFog, typeof(CanvasGroup)), 1, var4).uniqueId

					arg0.wsTimer:AddInMapTween(arg0.fogUid)
				end, var3)

				arg0.fogTimer:Start()
			else
				setCanvasGroupAlpha(arg0.rtFog, 1)
			end
		elseif arg1 and var3 > 0 then
			arg0.fogTimer = arg0.wsTimer:AddInMapTimer(function()
				arg0.fogUid = LeanTween.alphaCanvas(GetComponent(arg0.rtFog, typeof(CanvasGroup)), 0, var4).uniqueId

				arg0.wsTimer:AddInMapTween(arg0.fogUid)
			end, var3)

			arg0.fogTimer:Start()
		else
			setCanvasGroupAlpha(arg0.rtFog, 0)
		end
	end

	if arg1 == nil or arg1 == WorldMapCell.EventUpdateInFov or arg1 == WorldMapCell.EventUpdateDiscovered then
		if arg0.maskTimer then
			arg0.wsTimer:RemoveInMapTimer(arg0.maskTimer)

			arg0.maskTimer = nil
		end

		if arg0.maskUid then
			arg0.wsTimer:RemoveInMapTween(arg0.maskUid)

			arg0.maskUid = nil
		end

		if var0:GetInFOV() then
			if arg1 and var3 > 0 then
				arg0.maskTimer = arg0.wsTimer:AddInMapTimer(function()
					arg0.maskUid = LeanTween.alpha(arg0.rtMask, 0, var4).uniqueId

					arg0.wsTimer:AddInMapTween(arg0.maskUid)
				end, var3)

				arg0.maskTimer:Start()
			else
				setImageAlpha(arg0.rtMask, 0)
			end
		else
			local var5 = var0.discovered and 0.3 or 0.8

			if arg1 and var3 > 0 then
				arg0.maskTimer = arg0.wsTimer:AddInMapTimer(function()
					arg0.maskUid = LeanTween.alpha(arg0.rtMask, var5, var4).uniqueId

					arg0.wsTimer:AddInMapTween(arg0.maskUid)
				end, var3)

				arg0.maskTimer:Start()
			else
				setImageAlpha(arg0.rtMask, var5)
			end
		end
	end
end

function var0.UpdateFogImage(arg0)
	local var0 = arg0.cell:LookSairenFog()

	setImageAlpha(arg0.rtFog:Find("dark_fog"), var0 and 0 or 1)
	setImageAlpha(arg0.rtFog:Find("sairen_fog"), var0 and 1 or 0)
end

function var0.GetWorldPos(arg0)
	local var0 = Vector3.New(arg0.transform.localPosition.x, arg0.transform.localPosition.y, 0)

	return arg0.transform.parent:TransformPoint(var0)
end

return var0
