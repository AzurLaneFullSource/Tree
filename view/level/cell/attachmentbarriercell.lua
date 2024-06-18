local var0_0 = class("AttachmentBarrierCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("zulanwangheng")
		arg0_2:GetLoader():GetPrefab("chapter/zulanwangheng", "zulanwangheng", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)
			setActive(arg0_3, true)

			arg0_2.barrier = arg0_3

			arg0_2:Update()
		end)
	end

	setActive(arg0_2.tf, var0_2.flag == ChapterConst.CellFlagActive)
end

return var0_0
