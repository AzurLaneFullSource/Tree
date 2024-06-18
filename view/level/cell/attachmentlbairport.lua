local var0_0 = class("AttachmentLBAirport", import("view.level.cell.StaticCellView"))

var0_0.StateOutControl = 1
var0_0.StateUnderControl = 2

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.extraFlagList

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("airport")
	end

	if table.contains(var0_2, ChapterConst.StatusAirportOutControl) and arg0_2.state ~= var0_0.StateOutControl then
		arg0_2.state = var0_0.StateOutControl

		arg0_2:GetLoader():ClearRequest("Dead", AutoLoader.PartLoading)
		arg0_2:GetLoader():GetPrefab("chapter/dexiv3_2x2_2", "dexiv3_2x2_2", function(arg0_3)
			arg0_2:GetLoader():ClearRequest("Dead")
			setParent(arg0_3, arg0_2.tf)
		end, "Enemy")
	elseif table.contains(var0_2, ChapterConst.StatusAirportUnderControl) and arg0_2.state ~= var0_0.StateUnderControl then
		arg0_2.state = var0_0.StateUnderControl

		arg0_2:GetLoader():ClearRequest("Enemy", AutoLoader.PartLoading)
		arg0_2:GetLoader():GetPrefab("chapter/dexiv3_2x2_1", "dexiv3_2x2_1", function(arg0_4)
			arg0_2:GetLoader():ClearRequest("Enemy")
			setParent(arg0_4, arg0_2.tf)
		end, "Dead")
	end
end

return var0_0
