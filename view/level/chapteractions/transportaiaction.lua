local var0 = class("TransportAIAction")

function var0.Ctor(arg0, arg1)
	arg0.line = {
		row = arg1.ai_pos.row,
		column = arg1.ai_pos.column
	}
	arg0.movePath = _.map(arg1.move_path, function(arg0)
		return {
			row = arg0.row,
			column = arg0.column
		}
	end)

	local var0 = _.detect(arg1.map_update, function(arg0)
		return arg0.item_type == ChapterConst.AttachTransport
	end)

	arg0.hp = var0 and var0.item_data
end

function var0.applyTo(arg0, arg1, arg2)
	local var0 = arg1:getFleet(FleetType.Transport, arg0.line.row, arg0.line.column)

	if var0 then
		return arg0:applyToFleet(arg1, var0, arg2)
	end

	return false, "can not find any transport at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
end

function var0.applyToFleet(arg0, arg1, arg2, arg3)
	local var0 = 0

	if not arg2:isValid() then
		return false, "fleet " .. arg2.id .. " is invalid."
	end

	local var1 = 0

	if #arg0.movePath > 0 then
		if _.any(arg0.movePath, function(arg0)
			local var0 = arg1:getChapterCell(arg0.row, arg0.column)

			return not var0 or not var0:IsWalkable()
		end) then
			return false, "invalide move path"
		end

		if not arg3 then
			local var2 = arg0.movePath[#arg0.movePath]

			arg2.line = {
				row = var2.row,
				column = var2.column
			}
			var1 = bit.bor(var1, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition)
		end
	end

	if arg0.hp and not arg3 then
		arg2:setRestHp(arg0.hp)

		var1 = bit.bor(var1, ChapterConst.DirtyFleet)

		local var3 = arg1:getChapterCell(arg2.line.row, arg2.line.column)

		if var3 and var3.attachment == ChapterConst.AttachBox and var3.flag ~= ChapterConst.CellFlagDisabled and pg.box_data_template[var3.attachmentId].type == ChapterConst.BoxTorpedo then
			var3.flag = ChapterConst.CellFlagDisabled

			arg1:clearChapterCell(var3.row, var3.column)

			var1 = bit.bor(var1, ChapterConst.DirtyAttachment)
		end
	end

	return true, var1
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	local var0 = arg1:getFleetIndex(FleetType.Transport, arg0.line.row, arg0.line.column)

	if var0 then
		if #arg0.movePath > 0 then
			arg2.viewComponent.grid:moveTransport(var0, arg0.movePath, Clone(arg0.movePath), arg3)
		else
			local var1 = arg1.fleets[var0]
			local var2 = arg1:getChapterCell(var1.line.row, var1.line.column)

			if var2 and var2.attachment == ChapterConst.AttachBox and var2.flag ~= ChapterConst.CellFlagDisabled and pg.box_data_template[var2.attachmentId].type == ChapterConst.BoxTorpedo then
				arg2.viewComponent:doPlayTorpedo(arg3)

				return
			end

			arg3()
		end
	end
end

return var0
