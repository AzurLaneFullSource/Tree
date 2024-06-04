local var0 = class("MapEventStoryObstacleCellView", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		local var1 = var0.row
		local var2 = var0.column
		local var3 = "story_" .. var1 .. "_" .. var2 .. "_" .. var0.attachmentId

		arg0:PrepareBase(var3)
	end

	local var4 = pg.map_event_template[var0.attachmentId].icon
	local var5

	var5 = var4 and #var4 > 0 and var4 .. "_2" or nil

	local var6 = ItemCell.TransformItemAsset(arg0.chapter, var5)

	if arg0.assetName ~= var6 then
		if var6 == nil then
			arg0:GetLoader():ClearRequest("ItemAsset")

			arg0.assetName = var6
		else
			arg0:GetLoader():GetPrefab("ui/" .. var6, var6, function(arg0)
				setParent(arg0, arg0.tf)
				arg0:ResetCanvasOrder()

				arg0.assetName = var6
			end, "ItemAsset")
		end
	end

	local var7 = var0.flag == ChapterConst.CellFlagTriggerActive
	local var8 = pg.map_event_template[var0.attachmentId]

	if not var7 and var8 and var8.animation and not arg0.disappearAnim then
		local var9 = var8.animation

		if var9 and #var9 > 0 then
			arg0:GetLoader():GetPrefab("ui/" .. var9, var9, function(arg0)
				setParent(arg0.transform, arg0.tf, false)
				arg0:ResetCanvasOrder()

				local var0 = arg0:GetComponent(typeof(ParticleSystemEvent))

				if not IsNil(var0) then
					var0:SetEndEvent(function()
						arg0:GetLoader():ClearRequest("DisapperAnim")

						arg0.playingAnim = false

						arg0:Update()
					end)
				end
			end, "DisapperAnim")

			arg0.disappearAnim = true
			arg0.playingAnim = true
		end
	end

	setActive(arg0.tf, var7 or arg0.playingAnim)
end

return var0
