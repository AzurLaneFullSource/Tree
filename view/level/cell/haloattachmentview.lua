local var0_0 = class("HaloAttachmentView", import(".StaticCellView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.line = {
		row = arg2_1,
		column = arg3_1
	}
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityUpperEffect
end

function var0_0.Update(arg0_3)
	local var0_3 = arg0_3.info
	local var1_3 = var0_3.flag == ChapterConst.CellFlagTriggerActive and var0_3.trait ~= ChapterConst.TraitLurk

	if IsNil(arg0_3.go) then
		local var2_3 = arg0_3.line.row
		local var3_3 = arg0_3.line.column
		local var4_3 = "story_" .. var2_3 .. "_" .. var3_3 .. "_" .. var0_3.attachmentId .. "_upper"

		arg0_3:PrepareBase(var4_3)

		local var5_3 = pg.map_event_template[var0_3.attachmentId].icon

		if var5_3 and #var5_3 > 0 then
			local var6_3 = var5_3 .. "_1shangceng"
			local var7_3 = "ui/" .. var6_3
			local var8_3 = var6_3

			arg0_3:GetLoader():GetPrefab(var7_3, var8_3, function(arg0_4)
				tf(arg0_4):SetParent(arg0_3.tf, false)
				arg0_3:ResetCanvasOrder()
			end)
		end
	end

	setActive(arg0_3.tf, var1_3)
end

return var0_0
