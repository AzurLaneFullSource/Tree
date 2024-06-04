local var0 = class("AttachmentLBAirport", import("view.level.cell.StaticCellView"))

var0.StateOutControl = 1
var0.StateUnderControl = 2

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.extraFlagList

	if IsNil(arg0.go) then
		arg0:PrepareBase("airport")
	end

	if table.contains(var0, ChapterConst.StatusAirportOutControl) and arg0.state ~= var0.StateOutControl then
		arg0.state = var0.StateOutControl

		arg0:GetLoader():ClearRequest("Dead", AutoLoader.PartLoading)
		arg0:GetLoader():GetPrefab("chapter/dexiv3_2x2_2", "dexiv3_2x2_2", function(arg0)
			arg0:GetLoader():ClearRequest("Dead")
			setParent(arg0, arg0.tf)
		end, "Enemy")
	elseif table.contains(var0, ChapterConst.StatusAirportUnderControl) and arg0.state ~= var0.StateUnderControl then
		arg0.state = var0.StateUnderControl

		arg0:GetLoader():ClearRequest("Enemy", AutoLoader.PartLoading)
		arg0:GetLoader():GetPrefab("chapter/dexiv3_2x2_1", "dexiv3_2x2_1", function(arg0)
			arg0:GetLoader():ClearRequest("Enemy")
			setParent(arg0, arg0.tf)
		end, "Dead")
	end
end

return var0
