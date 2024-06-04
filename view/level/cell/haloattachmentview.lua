local var0 = class("HaloAttachmentView", import(".StaticCellView"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1)

	arg0.line = {
		row = arg2,
		column = arg3
	}
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityUpperEffect
end

function var0.Update(arg0)
	local var0 = arg0.info
	local var1 = var0.flag == ChapterConst.CellFlagTriggerActive and var0.trait ~= ChapterConst.TraitLurk

	if IsNil(arg0.go) then
		local var2 = arg0.line.row
		local var3 = arg0.line.column
		local var4 = "story_" .. var2 .. "_" .. var3 .. "_" .. var0.attachmentId .. "_upper"

		arg0:PrepareBase(var4)

		local var5 = pg.map_event_template[var0.attachmentId].icon

		if var5 and #var5 > 0 then
			local var6 = var5 .. "_1shangceng"
			local var7 = "ui/" .. var6
			local var8 = var6

			arg0:GetLoader():GetPrefab(var7, var8, function(arg0)
				tf(arg0):SetParent(arg0.tf, false)
				arg0:ResetCanvasOrder()
			end)
		end
	end

	setActive(arg0.tf, var1)
end

return var0
