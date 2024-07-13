local var0_0 = class("MapEventStoryTriggerCellView", import(".StaticCellView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.chapter = nil
	arg0_1.triggerUpper = nil
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_3)
	local var0_3 = arg0_3.info
	local var1_3 = var0_3.flag == ChapterConst.CellFlagTriggerActive and var0_3.trait ~= ChapterConst.TraitLurk

	if IsNil(arg0_3.go) then
		local var2_3 = var0_3.row
		local var3_3 = var0_3.column
		local var4_3 = "story_" .. var2_3 .. "_" .. var3_3 .. "_" .. var0_3.attachmentId

		arg0_3:PrepareBase(var4_3)

		local var5_3 = pg.map_event_template[var0_3.attachmentId].icon

		if IsNil(arg0_3.triggerUpper) and var5_3 and #var5_3 > 0 and checkABExist("ui/" .. var5_3 .. "_1shangceng") then
			arg0_3.triggerUpper = HaloAttachmentView.New(arg0_3.parent, var2_3, var3_3)

			arg0_3.triggerUpper:SetLoader(arg0_3.loader)
		end
	end

	local var6_3 = pg.map_event_template[var0_3.attachmentId].icon
	local var7_3

	var7_3 = var6_3 and #var6_3 > 0 and var6_3 .. "_1" or nil

	local var8_3 = ItemCell.TransformItemAsset(arg0_3.chapter, var7_3)

	if arg0_3.assetName ~= var8_3 then
		if var8_3 == nil then
			arg0_3:GetLoader():ClearRequest("ItemAsset")

			arg0_3.assetName = var8_3
		else
			arg0_3:GetLoader():GetPrefab("ui/" .. var8_3, var8_3, function(arg0_4)
				setParent(arg0_4, arg0_3.tf)
				arg0_3:ResetCanvasOrder()

				arg0_3.assetName = var8_3
			end, "ItemAsset")
		end
	end

	setActive(arg0_3.tf, var1_3)

	if arg0_3.triggerUpper then
		arg0_3.triggerUpper.info = arg0_3.info

		arg0_3.triggerUpper:Update()
	end
end

function var0_0.DestroyGO(arg0_5)
	if arg0_5.triggerUpper then
		arg0_5.triggerUpper:Clear()
	end

	arg0_5.triggerUpper = nil

	var0_0.super.DestroyGO(arg0_5)
end

return var0_0
