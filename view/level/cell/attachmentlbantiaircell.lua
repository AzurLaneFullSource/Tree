local var0_0 = class("AttachmentLBAntiAirCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("antiAir")

		local var1_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var1_2, "land_based_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_AntiAirGun", "Tpl_AntiAirGun", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition3D = Vector3(0, 10, 0)
			arg0_2.antiAirGun = arg0_3

			arg0_2:Update()
		end)
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_AntiAirGunArea", "Tpl_AntiAirGunArea", function(arg0_4)
			setParent(arg0_4, arg0_2.grid.restrictMap)

			arg0_4.name = "chapter_cell_mark_" .. var0_2.row .. "_" .. var0_2.column .. "#AntiAirGunArea"

			local var0_4 = arg0_2.chapter.theme
			local var1_4 = var0_4:GetLinePosition(arg0_2.line.row, arg0_2.line.column)
			local var2_4 = arg0_2.grid.restrictMap.anchoredPosition

			tf(arg0_4).anchoredPosition = Vector2(var1_4.x - var2_4.x, var1_4.y - var2_4.y)

			local var3_4 = var1_2.function_args[1]
			local var4_4 = (var3_4 * 2 + 1) * var0_4.cellSize.x + var3_4 * 2 * var0_4.cellSpace.x
			local var5_4 = (var3_4 * 2 + 1) * var0_4.cellSize.y + var3_4 * 2 * var0_4.cellSpace.y

			tf(arg0_4).sizeDelta = Vector2(var4_4, var5_4)
		end)
	end

	if arg0_2.antiAirGun and var0_2.flag ~= ChapterConst.CellFlagDisabled then
		local var2_2 = math.ceil(var0_2.data / 2)
		local var3_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var3_2, "land_based_template not exist: " .. var0_2.attachmentId)

		local var4_2 = var3_2.function_args[2]
		local var5_2 = arg0_2.chapter:getRoundNum()
		local var6_2 = tf(arg0_2.antiAirGun):Find("text")

		setActive(var6_2, var5_2 < var2_2)

		tf(arg0_2.antiAirGun):Find("Slider"):GetComponent(typeof(Slider)).value = math.max(var5_2 - var2_2 + var4_2, 0) / var4_2
	end

	setActive(arg0_2.tf, var0_2.flag ~= ChapterConst.CellFlagDisabled)
end

return var0_0
