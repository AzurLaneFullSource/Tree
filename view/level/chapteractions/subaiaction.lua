local var0 = class("SubAIAction")

function var0.Ctor(arg0, arg1)
	arg0.line = {
		row = arg1.ai_pos.row,
		column = arg1.ai_pos.column
	}

	if arg1.target_pos and arg1.target_pos.row < 9999 and arg1.target_pos.column < 9999 then
		arg0.target = {
			row = arg1.target_pos.row,
			column = arg1.target_pos.column
		}
	end

	arg0.movePath = _.map(arg1.move_path, function(arg0)
		return {
			row = arg0.row,
			column = arg0.column
		}
	end)
	arg0.cellUpdates = {}

	_.each(arg1.map_update, function(arg0)
		if arg0.item_type ~= ChapterConst.AttachNone and arg0.item_type ~= ChapterConst.AttachBorn and arg0.item_type ~= ChapterConst.AttachBorn_Sub and (arg0.item_type ~= ChapterConst.AttachStory or arg0.item_data ~= ChapterConst.StoryTrigger) then
			local var0 = arg0.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0) or ChapterCell.New(arg0)

			table.insert(arg0.cellUpdates, var0)
		end
	end)
end

function var0.applyTo(arg0, arg1, arg2)
	local var0 = arg1:getFleet(FleetType.Submarine, arg0.line.row, arg0.line.column)

	if var0 then
		return arg0:applyToFleet(arg1, var0, arg2)
	end

	return false, "can not find any submarine at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
end

function var0.applyToFleet(arg0, arg1, arg2, arg3)
	local var0 = 0

	if not arg2:isValid() then
		return false, "fleet " .. arg2.id .. " is invalid."
	end

	if arg0.target then
		if arg2.restAmmo <= 0 then
			return false, "lack ammo of fleet."
		end

		local var1 = _.detect(arg0.cellUpdates, function(arg0)
			return arg0.row == arg0.target.row and arg0.column == arg0.target.column
		end)

		if not var1 then
			return false, "can not find cell update at: [" .. arg0.target.row .. ", " .. arg0.target.column .. "]"
		end

		if not arg3 then
			if isa(var1, ChapterChampionPackage) then
				arg1:mergeChampion(var1)

				var0 = bit.bor(var0, ChapterConst.DirtyChampion)
			else
				arg1:mergeChapterCell(var1)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end

			arg2.restAmmo = arg2.restAmmo - 1
			var0 = bit.bor(var0, ChapterConst.DirtyFleet)
		end
	elseif #arg0.movePath > 0 then
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
			var0 = bit.bor(var0, ChapterConst.DirtyFleet)
		end
	end

	return true, var0
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	local var0 = arg1:getFleetIndex(FleetType.Submarine, arg0.line.row, arg0.line.column)

	if var0 then
		if arg0.target then
			local var1 = arg1.fleets[var0]
			local var2 = _.detect(arg0.cellUpdates, function(arg0)
				return arg0.row == arg0.target.row and arg0.column == arg0.target.column
			end)
			local var3 = arg1:GetRawChapterCell(var2.row, var2.column)
			local var4 = var3 and var3.data or 0
			local var5 = "-" .. (var2.data - var4) / 100 .. "%"
			local var6 = var1:getShips(false)[1]

			arg2.viewComponent:doPlayStrikeAnim(var6, var6:GetMapStrikeAnim(), function()
				arg2.viewComponent:strikeEnemy(arg0.target, var5, arg3)
			end)
		elseif #arg0.movePath > 0 then
			arg2.viewComponent.grid:moveSub(var0, arg0.movePath, nil, arg3)
		else
			arg3()
		end
	end
end

return var0
