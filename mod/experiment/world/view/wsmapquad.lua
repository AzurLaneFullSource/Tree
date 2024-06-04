local var0 = class("WSMapQuad", import("...BaseEntity"))

var0.Fields = {
	static = "boolean",
	rtWalkQuad = "userdata",
	twId = "number",
	transform = "userdata",
	cell = "table",
	twTimer = "userdata",
	theme = "table",
	rtQuad = "userdata"
}

function var0.GetResName()
	return "world_cell_quad"
end

var0.Listeners = {
	onAddAttachment = "OnAddAttachment",
	onUpdate = "Update",
	onRemoveAttachment = "OnRemoveAttachment",
	onUpdateAttachment = "OnUpdateAttachment"
}

function var0.GetName(arg0, arg1)
	return "world_quad_" .. arg0 .. "_" .. arg1
end

function var0.Setup(arg0, arg1, arg2)
	arg0.cell = arg1

	arg0.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:AddListener(WorldMapCell.EventAddAttachment, arg0.onAddAttachment)
	arg0.cell:AddListener(WorldMapCell.EventRemoveAttachment, arg0.onRemoveAttachment)
	arg0.cell:AddListener(WorldMapCell.EventUpdateFog, arg0.onUpdate)
	_.each(arg0.cell.attachments, function(arg0)
		arg0:OnAddAttachment(nil, arg0.cell, arg0)
	end)

	arg0.theme = arg2

	arg0:Init()
end

function var0.Dispose(arg0)
	if arg0.twId then
		LeanTween.cancel(arg0.twId)
	end

	arg0.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMapCell.EventAddAttachment, arg0.onAddAttachment)
	arg0.cell:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0.onRemoveAttachment)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateFog, arg0.onUpdate)
	_.each(arg0.cell.attachments, function(arg0)
		arg0:OnRemoveAttachment(nil, arg0.cell, arg0)
	end)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.cell
	local var1 = arg0.transform

	arg0.rtQuad = var1:Find("quad")
	var1.name = var0.GetName(var0.row, var0.column)
	var1.anchoredPosition = arg0.theme:GetLinePosition(var0.row, var0.column)
	arg0.rtQuad.sizeDelta = arg0.theme.cellSize
	arg0.rtWalkQuad = var1:Find("walk_quad") or cloneTplTo(arg0.rtQuad, var1, "walk_quad")

	arg0.rtWalkQuad:SetSiblingIndex(arg0.rtQuad:GetSiblingIndex())
	setImageAlpha(arg0.rtWalkQuad, 0)
	GetImageSpriteFromAtlasAsync("world/cell/base", WorldConst.QuadSpriteWhite, arg0.rtWalkQuad)
	arg0:Update()
end

function var0.Update(arg0, arg1)
	local var0 = arg0.cell

	if arg1 == nil or arg1 == WorldMapCell.EventUpdateInFov or arg1 == WorldMapCell.EventUpdateFog then
		arg0:OnUpdateAttachment()
	end
end

function var0.OnAddAttachment(arg0, arg1, arg2, arg3)
	arg3:AddListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	arg3:AddListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
	arg3:AddListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)

	if arg1 then
		arg0:OnUpdateAttachment()
	end
end

function var0.OnRemoveAttachment(arg0, arg1, arg2, arg3)
	arg3:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	arg3:RemoveListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
	arg3:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)

	if arg1 then
		arg0:OnUpdateAttachment()
	end
end

function var0.UpdateStatic(arg0, arg1, arg2)
	if arg0.static ~= arg1 then
		arg0.static = arg1

		if arg2 then
			arg0:UpdateScannerQuad()
		else
			arg0:OnUpdateAttachment()
		end
	end
end

function var0.OnUpdateAttachment(arg0)
	if arg0.twId then
		LeanTween.cancel(arg0.twId)

		arg0.twId = nil
	end

	local var0 = arg0.cell:GetDisplayQuad()

	if arg0.cell:GetInFOV() and not arg0.static and var0 and not arg0.cell:InFog() then
		local var1 = var0[2] or WorldConst.QuadBlinkDuration
		local var2 = var0[3] and var0[3] / 100 or 1
		local var3 = var0[4] and var0[4] / 100 or 0

		GetImageSpriteFromAtlasAsync("world/cell/base", var0[1], arg0.rtQuad)
		setLocalScale(arg0.rtQuad, Vector3.one)

		local var4 = LeanTween.alpha(arg0.rtQuad, var3, var1):setFrom(var2):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		var4.passed = arg0.twTimer.passed
		var4.direction = arg0.twTimer.direction
		arg0.twId = var4.uniqueId

		local var5 = var4.passed / var1 * (var2 - var3) + var3

		setImageAlpha(arg0.rtQuad, var4.direction > 0 and var5 or 1 - var5)
	else
		setImageAlpha(arg0.rtQuad, 0)
	end
end

function var0.UpdateScannerQuad(arg0)
	if arg0.twId then
		LeanTween.cancel(arg0.twId)

		arg0.twId = nil
	end

	if arg0.cell:GetInFOV() and arg0.cell:GetScannerAttachment() then
		local var0 = "cell_yellow"

		setImageAlpha(arg0.rtQuad, 1)
		GetImageSpriteFromAtlasAsync("world/cell/base", var0, arg0.rtQuad)
	else
		setImageAlpha(arg0.rtQuad, 0)
	end
end

return var0
