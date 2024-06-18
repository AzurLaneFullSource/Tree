local var0_0 = class("AttachmentLBDockCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("dock")
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_Dockyard", "Tpl_Dockyard", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition3D = Vector3(0, 10, 0)
			arg0_2.dock = tf(arg0_3)

			arg0_2:Update()
		end)
	end

	if arg0_2.dock then
		local var1_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var1_2, "land_based_template not exist: " .. var0_2.attachmentId)

		local var2_2 = arg0_2.chapter:getRoundNum()
		local var3_2 = arg0_2.dock:Find("text")
		local var4_2 = math.ceil(var0_2.data / 2)

		setActive(var3_2, var2_2 < var4_2)

		local var5_2 = arg0_2.dock:Find("Slider"):GetComponent(typeof(Slider))
		local var6_2 = var1_2.function_args[2]

		var5_2.value = math.max(var2_2 - var4_2 + var6_2, 0) / var6_2
	end

	setActive(arg0_2.tf, var0_2.flag == ChapterConst.CellFlagActive)
end

return var0_0
