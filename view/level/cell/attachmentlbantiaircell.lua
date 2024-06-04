local var0 = class("AttachmentLBAntiAirCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("antiAir")

		local var1 = pg.land_based_template[var0.attachmentId]

		assert(var1, "land_based_template not exist: " .. var0.attachmentId)
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_AntiAirGun", "Tpl_AntiAirGun", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition3D = Vector3(0, 10, 0)
			arg0.antiAirGun = arg0

			arg0:Update()
		end)
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_AntiAirGunArea", "Tpl_AntiAirGunArea", function(arg0)
			setParent(arg0, arg0.grid.restrictMap)

			arg0.name = "chapter_cell_mark_" .. var0.row .. "_" .. var0.column .. "#AntiAirGunArea"

			local var0 = arg0.chapter.theme
			local var1 = var0:GetLinePosition(arg0.line.row, arg0.line.column)
			local var2 = arg0.grid.restrictMap.anchoredPosition

			tf(arg0).anchoredPosition = Vector2(var1.x - var2.x, var1.y - var2.y)

			local var3 = var1.function_args[1]
			local var4 = (var3 * 2 + 1) * var0.cellSize.x + var3 * 2 * var0.cellSpace.x
			local var5 = (var3 * 2 + 1) * var0.cellSize.y + var3 * 2 * var0.cellSpace.y

			tf(arg0).sizeDelta = Vector2(var4, var5)
		end)
	end

	if arg0.antiAirGun and var0.flag ~= ChapterConst.CellFlagDisabled then
		local var2 = math.ceil(var0.data / 2)
		local var3 = pg.land_based_template[var0.attachmentId]

		assert(var3, "land_based_template not exist: " .. var0.attachmentId)

		local var4 = var3.function_args[2]
		local var5 = arg0.chapter:getRoundNum()
		local var6 = tf(arg0.antiAirGun):Find("text")

		setActive(var6, var5 < var2)

		tf(arg0.antiAirGun):Find("Slider"):GetComponent(typeof(Slider)).value = math.max(var5 - var2 + var4, 0) / var4
	end

	setActive(arg0.tf, var0.flag ~= ChapterConst.CellFlagDisabled)
end

return var0
