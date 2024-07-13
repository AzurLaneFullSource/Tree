local var0_0 = class("SubAIAction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.line = {
		row = arg1_1.ai_pos.row,
		column = arg1_1.ai_pos.column
	}

	if arg1_1.target_pos and arg1_1.target_pos.row < 9999 and arg1_1.target_pos.column < 9999 then
		arg0_1.target = {
			row = arg1_1.target_pos.row,
			column = arg1_1.target_pos.column
		}
	end

	arg0_1.movePath = _.map(arg1_1.move_path, function(arg0_2)
		return {
			row = arg0_2.row,
			column = arg0_2.column
		}
	end)
	arg0_1.cellUpdates = {}

	_.each(arg1_1.map_update, function(arg0_3)
		if arg0_3.item_type ~= ChapterConst.AttachNone and arg0_3.item_type ~= ChapterConst.AttachBorn and arg0_3.item_type ~= ChapterConst.AttachBorn_Sub and (arg0_3.item_type ~= ChapterConst.AttachStory or arg0_3.item_data ~= ChapterConst.StoryTrigger) then
			local var0_3 = arg0_3.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0_3) or ChapterCell.New(arg0_3)

			table.insert(arg0_1.cellUpdates, var0_3)
		end
	end)
end

function var0_0.applyTo(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:getFleet(FleetType.Submarine, arg0_4.line.row, arg0_4.line.column)

	if var0_4 then
		return arg0_4:applyToFleet(arg1_4, var0_4, arg2_4)
	end

	return false, "can not find any submarine at: [" .. arg0_4.line.row .. ", " .. arg0_4.line.column .. "]"
end

function var0_0.applyToFleet(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = 0

	if not arg2_5:isValid() then
		return false, "fleet " .. arg2_5.id .. " is invalid."
	end

	if arg0_5.target then
		if arg2_5.restAmmo <= 0 then
			return false, "lack ammo of fleet."
		end

		local var1_5 = _.detect(arg0_5.cellUpdates, function(arg0_6)
			return arg0_6.row == arg0_5.target.row and arg0_6.column == arg0_5.target.column
		end)

		if not var1_5 then
			return false, "can not find cell update at: [" .. arg0_5.target.row .. ", " .. arg0_5.target.column .. "]"
		end

		if not arg3_5 then
			if isa(var1_5, ChapterChampionPackage) then
				arg1_5:mergeChampion(var1_5)

				var0_5 = bit.bor(var0_5, ChapterConst.DirtyChampion)
			else
				arg1_5:mergeChapterCell(var1_5)

				var0_5 = bit.bor(var0_5, ChapterConst.DirtyAttachment)
			end

			arg2_5.restAmmo = arg2_5.restAmmo - 1
			var0_5 = bit.bor(var0_5, ChapterConst.DirtyFleet)
		end
	elseif #arg0_5.movePath > 0 then
		if _.any(arg0_5.movePath, function(arg0_7)
			local var0_7 = arg1_5:getChapterCell(arg0_7.row, arg0_7.column)

			return not var0_7 or not var0_7:IsWalkable()
		end) then
			return false, "invalide move path"
		end

		if not arg3_5 then
			local var2_5 = arg0_5.movePath[#arg0_5.movePath]

			arg2_5.line = {
				row = var2_5.row,
				column = var2_5.column
			}
			var0_5 = bit.bor(var0_5, ChapterConst.DirtyFleet)
		end
	end

	return true, var0_5
end

function var0_0.PlayAIAction(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg1_8:getFleetIndex(FleetType.Submarine, arg0_8.line.row, arg0_8.line.column)

	if var0_8 then
		if arg0_8.target then
			local var1_8 = arg1_8.fleets[var0_8]
			local var2_8 = _.detect(arg0_8.cellUpdates, function(arg0_9)
				return arg0_9.row == arg0_8.target.row and arg0_9.column == arg0_8.target.column
			end)
			local var3_8 = arg1_8:GetRawChapterCell(var2_8.row, var2_8.column)
			local var4_8 = var3_8 and var3_8.data or 0
			local var5_8 = "-" .. (var2_8.data - var4_8) / 100 .. "%"
			local var6_8 = var1_8:getShips(false)[1]

			arg2_8.viewComponent:doPlayStrikeAnim(var6_8, var6_8:GetMapStrikeAnim(), function()
				arg2_8.viewComponent:strikeEnemy(arg0_8.target, var5_8, arg3_8)
			end)
		elseif #arg0_8.movePath > 0 then
			arg2_8.viewComponent.grid:moveSub(var0_8, arg0_8.movePath, nil, arg3_8)
		else
			arg3_8()
		end
	end
end

return var0_0
