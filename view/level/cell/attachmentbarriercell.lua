local var0 = class("AttachmentBarrierCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("zulanwangheng")
		arg0:GetLoader():GetPrefab("chapter/zulanwangheng", "zulanwangheng", function(arg0)
			setParent(arg0, arg0.tf)
			setActive(arg0, true)

			arg0.barrier = arg0

			arg0:Update()
		end)
	end

	setActive(arg0.tf, var0.flag == ChapterConst.CellFlagActive)
end

return var0
