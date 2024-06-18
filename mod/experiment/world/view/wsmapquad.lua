local var0_0 = class("WSMapQuad", import("...BaseEntity"))

var0_0.Fields = {
	static = "boolean",
	rtWalkQuad = "userdata",
	twId = "number",
	transform = "userdata",
	cell = "table",
	twTimer = "userdata",
	theme = "table",
	rtQuad = "userdata"
}

function var0_0.GetResName()
	return "world_cell_quad"
end

var0_0.Listeners = {
	onAddAttachment = "OnAddAttachment",
	onUpdate = "Update",
	onRemoveAttachment = "OnRemoveAttachment",
	onUpdateAttachment = "OnUpdateAttachment"
}

function var0_0.GetName(arg0_2, arg1_2)
	return "world_quad_" .. arg0_2 .. "_" .. arg1_2
end

function var0_0.Setup(arg0_3, arg1_3, arg2_3)
	arg0_3.cell = arg1_3

	arg0_3.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0_3.onUpdate)
	arg0_3.cell:AddListener(WorldMapCell.EventAddAttachment, arg0_3.onAddAttachment)
	arg0_3.cell:AddListener(WorldMapCell.EventRemoveAttachment, arg0_3.onRemoveAttachment)
	arg0_3.cell:AddListener(WorldMapCell.EventUpdateFog, arg0_3.onUpdate)
	_.each(arg0_3.cell.attachments, function(arg0_4)
		arg0_3:OnAddAttachment(nil, arg0_3.cell, arg0_4)
	end)

	arg0_3.theme = arg2_3

	arg0_3:Init()
end

function var0_0.Dispose(arg0_5)
	if arg0_5.twId then
		LeanTween.cancel(arg0_5.twId)
	end

	arg0_5.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0_5.onUpdate)
	arg0_5.cell:RemoveListener(WorldMapCell.EventAddAttachment, arg0_5.onAddAttachment)
	arg0_5.cell:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0_5.onRemoveAttachment)
	arg0_5.cell:RemoveListener(WorldMapCell.EventUpdateFog, arg0_5.onUpdate)
	_.each(arg0_5.cell.attachments, function(arg0_6)
		arg0_5:OnRemoveAttachment(nil, arg0_5.cell, arg0_6)
	end)
	arg0_5:Clear()
end

function var0_0.Init(arg0_7)
	local var0_7 = arg0_7.cell
	local var1_7 = arg0_7.transform

	arg0_7.rtQuad = var1_7:Find("quad")
	var1_7.name = var0_0.GetName(var0_7.row, var0_7.column)
	var1_7.anchoredPosition = arg0_7.theme:GetLinePosition(var0_7.row, var0_7.column)
	arg0_7.rtQuad.sizeDelta = arg0_7.theme.cellSize
	arg0_7.rtWalkQuad = var1_7:Find("walk_quad") or cloneTplTo(arg0_7.rtQuad, var1_7, "walk_quad")

	arg0_7.rtWalkQuad:SetSiblingIndex(arg0_7.rtQuad:GetSiblingIndex())
	setImageAlpha(arg0_7.rtWalkQuad, 0)
	GetImageSpriteFromAtlasAsync("world/cell/base", WorldConst.QuadSpriteWhite, arg0_7.rtWalkQuad)
	arg0_7:Update()
end

function var0_0.Update(arg0_8, arg1_8)
	local var0_8 = arg0_8.cell

	if arg1_8 == nil or arg1_8 == WorldMapCell.EventUpdateInFov or arg1_8 == WorldMapCell.EventUpdateFog then
		arg0_8:OnUpdateAttachment()
	end
end

function var0_0.OnAddAttachment(arg0_9, arg1_9, arg2_9, arg3_9)
	arg3_9:AddListener(WorldMapAttachment.EventUpdateFlag, arg0_9.onUpdateAttachment)
	arg3_9:AddListener(WorldMapAttachment.EventUpdateData, arg0_9.onUpdateAttachment)
	arg3_9:AddListener(WorldMapAttachment.EventUpdateLurk, arg0_9.onUpdateAttachment)

	if arg1_9 then
		arg0_9:OnUpdateAttachment()
	end
end

function var0_0.OnRemoveAttachment(arg0_10, arg1_10, arg2_10, arg3_10)
	arg3_10:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0_10.onUpdateAttachment)
	arg3_10:RemoveListener(WorldMapAttachment.EventUpdateData, arg0_10.onUpdateAttachment)
	arg3_10:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0_10.onUpdateAttachment)

	if arg1_10 then
		arg0_10:OnUpdateAttachment()
	end
end

function var0_0.UpdateStatic(arg0_11, arg1_11, arg2_11)
	if arg0_11.static ~= arg1_11 then
		arg0_11.static = arg1_11

		if arg2_11 then
			arg0_11:UpdateScannerQuad()
		else
			arg0_11:OnUpdateAttachment()
		end
	end
end

function var0_0.OnUpdateAttachment(arg0_12)
	if arg0_12.twId then
		LeanTween.cancel(arg0_12.twId)

		arg0_12.twId = nil
	end

	local var0_12 = arg0_12.cell:GetDisplayQuad()

	if arg0_12.cell:GetInFOV() and not arg0_12.static and var0_12 and not arg0_12.cell:InFog() then
		local var1_12 = var0_12[2] or WorldConst.QuadBlinkDuration
		local var2_12 = var0_12[3] and var0_12[3] / 100 or 1
		local var3_12 = var0_12[4] and var0_12[4] / 100 or 0

		GetImageSpriteFromAtlasAsync("world/cell/base", var0_12[1], arg0_12.rtQuad)
		setLocalScale(arg0_12.rtQuad, Vector3.one)

		local var4_12 = LeanTween.alpha(arg0_12.rtQuad, var3_12, var1_12):setFrom(var2_12):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		var4_12.passed = arg0_12.twTimer.passed
		var4_12.direction = arg0_12.twTimer.direction
		arg0_12.twId = var4_12.uniqueId

		local var5_12 = var4_12.passed / var1_12 * (var2_12 - var3_12) + var3_12

		setImageAlpha(arg0_12.rtQuad, var4_12.direction > 0 and var5_12 or 1 - var5_12)
	else
		setImageAlpha(arg0_12.rtQuad, 0)
	end
end

function var0_0.UpdateScannerQuad(arg0_13)
	if arg0_13.twId then
		LeanTween.cancel(arg0_13.twId)

		arg0_13.twId = nil
	end

	if arg0_13.cell:GetInFOV() and arg0_13.cell:GetScannerAttachment() then
		local var0_13 = "cell_yellow"

		setImageAlpha(arg0_13.rtQuad, 1)
		GetImageSpriteFromAtlasAsync("world/cell/base", var0_13, arg0_13.rtQuad)
	else
		setImageAlpha(arg0_13.rtQuad, 0)
	end
end

return var0_0
