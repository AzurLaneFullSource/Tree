local var0 = class("AttachmentLBDockCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("dock")
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Dockyard", "Tpl_Dockyard", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition3D = Vector3(0, 10, 0)
			arg0.dock = tf(arg0)

			arg0:Update()
		end)
	end

	if arg0.dock then
		local var1 = pg.land_based_template[var0.attachmentId]

		assert(var1, "land_based_template not exist: " .. var0.attachmentId)

		local var2 = arg0.chapter:getRoundNum()
		local var3 = arg0.dock:Find("text")
		local var4 = math.ceil(var0.data / 2)

		setActive(var3, var2 < var4)

		local var5 = arg0.dock:Find("Slider"):GetComponent(typeof(Slider))
		local var6 = var1.function_args[2]

		var5.value = math.max(var2 - var4 + var6, 0) / var6
	end

	setActive(arg0.tf, var0.flag == ChapterConst.CellFlagActive)
end

return var0
