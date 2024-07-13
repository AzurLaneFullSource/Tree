local var0_0 = class("TransportAIAction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.line = {
		row = arg1_1.ai_pos.row,
		column = arg1_1.ai_pos.column
	}
	arg0_1.movePath = _.map(arg1_1.move_path, function(arg0_2)
		return {
			row = arg0_2.row,
			column = arg0_2.column
		}
	end)

	local var0_1 = _.detect(arg1_1.map_update, function(arg0_3)
		return arg0_3.item_type == ChapterConst.AttachTransport
	end)

	arg0_1.hp = var0_1 and var0_1.item_data
end

function var0_0.applyTo(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:getFleet(FleetType.Transport, arg0_4.line.row, arg0_4.line.column)

	if var0_4 then
		return arg0_4:applyToFleet(arg1_4, var0_4, arg2_4)
	end

	return false, "can not find any transport at: [" .. arg0_4.line.row .. ", " .. arg0_4.line.column .. "]"
end

function var0_0.applyToFleet(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = 0

	if not arg2_5:isValid() then
		return false, "fleet " .. arg2_5.id .. " is invalid."
	end

	local var1_5 = 0

	if #arg0_5.movePath > 0 then
		if _.any(arg0_5.movePath, function(arg0_6)
			local var0_6 = arg1_5:getChapterCell(arg0_6.row, arg0_6.column)

			return not var0_6 or not var0_6:IsWalkable()
		end) then
			return false, "invalide move path"
		end

		if not arg3_5 then
			local var2_5 = arg0_5.movePath[#arg0_5.movePath]

			arg2_5.line = {
				row = var2_5.row,
				column = var2_5.column
			}
			var1_5 = bit.bor(var1_5, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)
		end
	end

	if arg0_5.hp and not arg3_5 then
		arg2_5:setRestHp(arg0_5.hp)

		var1_5 = bit.bor(var1_5, ChapterConst.DirtyFleet)

		local var3_5 = arg1_5:getChapterCell(arg2_5.line.row, arg2_5.line.column)

		if var3_5 and var3_5.attachment == ChapterConst.AttachBox and var3_5.flag ~= ChapterConst.CellFlagDisabled and pg.box_data_template[var3_5.attachmentId].type == ChapterConst.BoxTorpedo then
			var3_5.flag = ChapterConst.CellFlagDisabled

			arg1_5:clearChapterCell(var3_5.row, var3_5.column)

			var1_5 = bit.bor(var1_5, ChapterConst.DirtyAttachment)
		end
	end

	return true, var1_5
end

function var0_0.PlayAIAction(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg1_7:getFleetIndex(FleetType.Transport, arg0_7.line.row, arg0_7.line.column)

	if var0_7 then
		if #arg0_7.movePath > 0 then
			arg2_7.viewComponent.grid:moveTransport(var0_7, arg0_7.movePath, Clone(arg0_7.movePath), arg3_7)
		else
			local var1_7 = arg1_7.fleets[var0_7]
			local var2_7 = arg1_7:getChapterCell(var1_7.line.row, var1_7.line.column)

			if var2_7 and var2_7.attachment == ChapterConst.AttachBox and var2_7.flag ~= ChapterConst.CellFlagDisabled and pg.box_data_template[var2_7.attachmentId].type == ChapterConst.BoxTorpedo then
				arg2_7.viewComponent:doPlayTorpedo(arg3_7)

				return
			end

			arg3_7()
		end
	end
end

return var0_0
