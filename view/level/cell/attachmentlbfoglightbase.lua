local var0_0 = class("AttachmentLBFogLightBase", import("view.level.cell.StaticCellView"))

var0_0.StateLive = 1
var0_0.StateDead = 2

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("landbase_" .. var0_2.attachmentId)
	end

	local var1_2 = arg0_2.state

	if var0_2.flag == ChapterConst.CellFlagActive and arg0_2.state ~= var0_0.StateLive then
		arg0_2.state = var0_0.StateLive
		arg0_2.dead = nil

		arg0_2:ClearLoader()

		local var2_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var2_2, "land_based_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("chapter/" .. var2_2.prefab, "", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			arg0_2.enemy = arg0_3

			arg0_2:ResetCanvasOrder()
			arg0_2:Update()
		end)
	elseif var0_2.flag == ChapterConst.CellFlagDisabled and arg0_2.state ~= var0_0.StateDead then
		arg0_2.state = var0_0.StateDead
		arg0_2.enemy = nil

		arg0_2:ClearLoader()

		local var3_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var3_2, "land_based_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("chapter/" .. var3_2.prefab .. "_d_blue", "", function(arg0_4)
			setParent(arg0_4, arg0_2.tf)

			arg0_2.dead = arg0_4

			arg0_2:ResetCanvasOrder()
			arg0_2:Update()
		end)
	end
end

return var0_0
