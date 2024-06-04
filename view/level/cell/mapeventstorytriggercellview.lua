local var0 = class("MapEventStoryTriggerCellView", import(".StaticCellView"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.chapter = nil
	arg0.triggerUpper = nil
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info
	local var1 = var0.flag == ChapterConst.CellFlagTriggerActive and var0.trait ~= ChapterConst.TraitLurk

	if IsNil(arg0.go) then
		local var2 = var0.row
		local var3 = var0.column
		local var4 = "story_" .. var2 .. "_" .. var3 .. "_" .. var0.attachmentId

		arg0:PrepareBase(var4)

		local var5 = pg.map_event_template[var0.attachmentId].icon

		if IsNil(arg0.triggerUpper) and var5 and #var5 > 0 and checkABExist("ui/" .. var5 .. "_1shangceng") then
			arg0.triggerUpper = HaloAttachmentView.New(arg0.parent, var2, var3)

			arg0.triggerUpper:SetLoader(arg0.loader)
		end
	end

	local var6 = pg.map_event_template[var0.attachmentId].icon
	local var7

	var7 = var6 and #var6 > 0 and var6 .. "_1" or nil

	local var8 = ItemCell.TransformItemAsset(arg0.chapter, var7)

	if arg0.assetName ~= var8 then
		if var8 == nil then
			arg0:GetLoader():ClearRequest("ItemAsset")

			arg0.assetName = var8
		else
			arg0:GetLoader():GetPrefab("ui/" .. var8, var8, function(arg0)
				setParent(arg0, arg0.tf)
				arg0:ResetCanvasOrder()

				arg0.assetName = var8
			end, "ItemAsset")
		end
	end

	setActive(arg0.tf, var1)

	if arg0.triggerUpper then
		arg0.triggerUpper.info = arg0.info

		arg0.triggerUpper:Update()
	end
end

function var0.DestroyGO(arg0)
	if arg0.triggerUpper then
		arg0.triggerUpper:Clear()
	end

	arg0.triggerUpper = nil

	var0.super.DestroyGO(arg0)
end

return var0
