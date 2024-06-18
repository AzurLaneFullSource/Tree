local var0_0 = class("MapEventStoryObstacleCellView", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		local var1_2 = var0_2.row
		local var2_2 = var0_2.column
		local var3_2 = "story_" .. var1_2 .. "_" .. var2_2 .. "_" .. var0_2.attachmentId

		arg0_2:PrepareBase(var3_2)
	end

	local var4_2 = pg.map_event_template[var0_2.attachmentId].icon
	local var5_2

	var5_2 = var4_2 and #var4_2 > 0 and var4_2 .. "_2" or nil

	local var6_2 = ItemCell.TransformItemAsset(arg0_2.chapter, var5_2)

	if arg0_2.assetName ~= var6_2 then
		if var6_2 == nil then
			arg0_2:GetLoader():ClearRequest("ItemAsset")

			arg0_2.assetName = var6_2
		else
			arg0_2:GetLoader():GetPrefab("ui/" .. var6_2, var6_2, function(arg0_3)
				setParent(arg0_3, arg0_2.tf)
				arg0_2:ResetCanvasOrder()

				arg0_2.assetName = var6_2
			end, "ItemAsset")
		end
	end

	local var7_2 = var0_2.flag == ChapterConst.CellFlagTriggerActive
	local var8_2 = pg.map_event_template[var0_2.attachmentId]

	if not var7_2 and var8_2 and var8_2.animation and not arg0_2.disappearAnim then
		local var9_2 = var8_2.animation

		if var9_2 and #var9_2 > 0 then
			arg0_2:GetLoader():GetPrefab("ui/" .. var9_2, var9_2, function(arg0_4)
				setParent(arg0_4.transform, arg0_2.tf, false)
				arg0_2:ResetCanvasOrder()

				local var0_4 = arg0_4:GetComponent(typeof(ParticleSystemEvent))

				if not IsNil(var0_4) then
					var0_4:SetEndEvent(function()
						arg0_2:GetLoader():ClearRequest("DisapperAnim")

						arg0_2.playingAnim = false

						arg0_2:Update()
					end)
				end
			end, "DisapperAnim")

			arg0_2.disappearAnim = true
			arg0_2.playingAnim = true
		end
	end

	setActive(arg0_2.tf, var7_2 or arg0_2.playingAnim)
end

return var0_0
