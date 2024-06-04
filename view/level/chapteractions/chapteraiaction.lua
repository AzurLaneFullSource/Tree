local var0 = class("ChapterAIAction")

function var0.Ctor(arg0, arg1)
	arg0.line = {
		row = arg1.ai_pos.row,
		column = arg1.ai_pos.column
	}
	arg0.stgId = arg1.strategy_id

	if arg1.target_pos then
		arg0.stgTarget = {
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
	arg0.shipUpdate = _.map(arg1.ship_update, function(arg0)
		return {
			id = arg0.id,
			hpRant = arg0.hp_rant
		}
	end)
	arg0.cellUpdates = {}

	_.each(arg1.map_update, function(arg0)
		if arg0.item_type ~= ChapterConst.AttachNone and arg0.item_type ~= ChapterConst.AttachBorn and arg0.item_type ~= ChapterConst.AttachBorn_Sub and (arg0.item_type ~= ChapterConst.AttachStory or arg0.item_data ~= ChapterConst.StoryTrigger) then
			local var0 = arg0.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0) or ChapterCell.New(arg0)

			table.insert(arg0.cellUpdates, var0)
		end
	end)

	arg0.actType = arg1.act_type
	arg0.hp_del = arg1.hp_del
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	local var0 = arg1:getChapterCell(arg0.line.row, arg0.line.column)

	if var0 and var0.attachment == ChapterConst.AttachLandbase and not table.equal(arg0.stgTarget, {
		row = 9999,
		columns = 9999
	}) then
		local var1 = pg.land_based_template[var0.attachmentId]

		if var1.type == ChapterConst.LBCoastalGun then
			arg2.viewComponent:doPlayAnim("coastalgun", function(arg0)
				setActive(arg0, false)
				arg3()
			end)
		elseif var1.type == ChapterConst.LBHarbor then
			if not arg0.hp_del or arg0.hp_del <= 0 then
				arg3()
			end

			arg2.viewComponent.grid:PlayAttachmentEffect(var0.row, var0.column, "huoqiubaozha", Vector2.zero)
			arg3()
		elseif var1.type == ChapterConst.LBDock then
			arg3()
		elseif var1.type == ChapterConst.LBAntiAir then
			arg2.viewComponent:doPlayAnim("AntiAirFire", function(arg0)
				setActive(arg0, false)
				arg2.viewComponent.grid:PlayAttachmentEffect(arg0.stgTarget.row, arg0.stgTarget.column, "huoqiubaozha", Vector2.zero, arg3)
			end)
		else
			assert(false)
		end

		return
	end

	if arg0.stgId > 0 then
		if arg0.stgId == ChapterConst.StrategySonarDetect then
			local var2 = {}

			_.each(arg0.cellUpdates, function(arg0)
				if isa(arg0, ChapterChampionPackage) then
					table.insert(var2, arg0)
				end
			end)
			arg2.viewComponent.grid:PlaySonarDetectAnim(var2, arg3)
		else
			assert(false)
		end

		return
	end

	local var3 = arg1:getChampion(arg0.line.row, arg0.line.column)
	local var4 = arg1:getChampionIndex(arg0.line.row, arg0.line.column)
	local var5 = arg0.movePath[#arg0.movePath] or arg0.line

	if var4 then
		seriesAsync({
			function(arg0)
				if #arg0.movePath > 0 then
					arg2.viewComponent.grid:moveChampion(var4, arg0.movePath, Clone(arg0.movePath), arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				if #arg0.shipUpdate > 0 then
					arg2.viewComponent:doPlayEnemyAnim(var3, "SubSairenTorpedoUI", arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				local var0 = false

				if arg0.actType == ChapterConst.ActType_SubmarineHunting and #arg0.cellUpdates > 0 then
					_.each(arg0.cellUpdates, function(arg0)
						if var5.row == arg0.row and var5.column == arg0.column and isa(arg0, ChapterChampionPackage) then
							arg0:TryPlayChampionSubAnim(arg2, arg0, var3, arg0)

							var0 = true
						end
					end)
				end

				if not var0 then
					arg0()
				end
			end,
			function(arg0)
				arg3()
			end
		})

		return
	end

	assert(false)
end

function var0.TryPlayChampionSubAnim(arg0, arg1, arg2, arg3, arg4)
	if (arg2.flag == ChapterConst.CellFlagDiving or arg3.flag == ChapterConst.CellFlagDiving) and (arg2.flag == ChapterConst.CellFlagActive or arg3.flag == ChapterConst.CellFlagActive) then
		local var0 = arg2.flag == ChapterConst.CellFlagDiving

		arg1.viewComponent.grid:PlayChampionSubmarineAnimation(arg3, var0, arg4)

		return
	end

	arg4()
end

function var0.applyTo(arg0, arg1, arg2)
	local var0 = arg1:getChapterCell(arg0.line.row, arg0.line.column)

	if var0 and var0.attachment == ChapterConst.AttachLandbase and not table.equal(arg0.stgTarget, {
		row = 9999,
		column = 9999
	}) then
		local var1 = pg.land_based_template[var0.attachmentId]

		if var1.type == ChapterConst.LBCoastalGun then
			return arg0:applyToCoastalGun(arg1, var0, arg2)
		elseif var1.type == ChapterConst.LBHarbor then
			return arg0:applyToHarbor(arg1, var0, arg2)
		elseif var1.type == ChapterConst.LBDock then
			return arg0:applyToDock(arg1, var0, arg2)
		elseif var1.type == ChapterConst.LBAntiAir then
			return arg0:applyToAntiAir(arg1, var0, arg2)
		else
			return false, "Trouble with Attach LandBased"
		end
	end

	if arg0.stgId > 0 then
		return arg0:applyToStrategy(arg1, arg0.stgId, arg2)
	end

	local var2 = arg1:getChampion(arg0.line.row, arg0.line.column)

	if var2 then
		return arg0:applyToChampion(arg1, var2, arg2)
	end

	return false, "can not find any object at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
end

function var0.applyToChampion(arg0, arg1, arg2, arg3)
	if arg2.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead champion at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
	end

	local var0 = 0
	local var1 = 0
	local var2 = arg0.line

	if arg0.stgId > 0 and not pg.strategy_data_template[arg0.stgId] then
		return false, "can not find strategy: " .. arg0.stgId
	end

	if #arg0.movePath > 0 then
		var2 = arg0.movePath[#arg0.movePath]

		if _.any(arg0.movePath, function(arg0)
			local var0 = arg1:getChapterCell(arg0.row, arg0.column)

			return not var0 or not var0:IsWalkable()
		end) then
			return false, "invalide move path"
		end
	end

	if #arg0.shipUpdate > 0 and not arg1:getFleet(FleetType.Normal, var2.row, var2.column) then
		return false, "can not find fleet at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
	end

	if not arg3 then
		if #arg0.movePath > 0 then
			arg2.row = var2.row
			arg2.column = var2.column
			var0 = bit.bor(var0, ChapterConst.DirtyChampionPosition)
		end

		if arg1:existFleet(FleetType.Submarine, arg2.row, arg2.column) then
			var0 = bit.bor(var0, ChapterConst.DirtyFleet)
		end

		if arg0.actType == ChapterConst.ActType_SubmarineHunting then
			local var3 = arg1:getChapterCell(var2.row, var2.column)

			if var3 and var3.attachment == ChapterConst.AttachBarrier then
				var3.flag = ChapterConst.CellFlagDisabled

				arg1:mergeChapterCell(var3)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end
		end

		if #arg0.shipUpdate > 0 then
			_.each(arg0.shipUpdate, function(arg0)
				arg1:updateFleetShipHp(arg0.id, arg0.hpRant)
			end)

			var0 = bit.bor(var0, ChapterConst.DirtyFleet)
		end

		if #arg0.cellUpdates > 0 then
			_.each(arg0.cellUpdates, function(arg0)
				if isa(arg0, ChapterChampionPackage) then
					local var0 = arg1:mergeChampion(arg0) and ChapterConst.DirtyChampionPosition or ChapterConst.DirtyChampion

					var0 = bit.bor(var0, var0)
				else
					arg1:mergeChapterCell(arg0)

					var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
				end
			end)

			var1 = bit.bor(var1, ChapterConst.DirtyAutoAction)
		end
	end

	return true, var0, var1
end

function var0.applyToStrategy(arg0, arg1, arg2, arg3)
	if not pg.strategy_data_template[arg2] then
		return false, "can not find strategy: " .. arg2
	end

	local var0 = 0

	if not arg3 and arg0.stgId == ChapterConst.StrategySonarDetect then
		_.each(arg0.cellUpdates, function(arg0)
			if isa(arg0, ChapterChampionPackage) then
				arg1:mergeChampion(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyChampion)
			else
				arg1:mergeChapterCell(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end
		end)
	end

	return true, var0
end

function var0.applyToCoastalGun(arg0, arg1, arg2, arg3)
	if arg2.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead coastalgun at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
	end

	local var0 = 0
	local var1 = 0
	local var2 = arg1:getFleet(FleetType.Normal, arg0.stgTarget.row, arg0.stgTarget.column)

	if not var2 then
		return false, "can not find fleet at: [" .. arg0.stgTarget.row .. ", " .. arg0.stgTarget.column .. "]"
	end

	if not arg3 then
		var2:increaseSlowSpeedFactor()

		var0 = bit.bor(var0, ChapterConst.DirtyFleet)

		_.each(arg0.cellUpdates, function(arg0)
			if isa(arg0, ChapterChampionPackage) then
				arg1:mergeChampion(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyChampion)
			else
				arg1:mergeChapterCell(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end
		end)

		if #arg0.cellUpdates > 0 then
			var1 = bit.bor(var1, ChapterConst.DirtyAutoAction)
		end
	end

	return true, var0, var1
end

function var0.applyToHarbor(arg0, arg1, arg2, arg3)
	if arg2.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead Harbor at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
	end

	local var0 = 0
	local var1 = 0
	local var2 = arg1:getChampion(arg0.stgTarget.row, arg0.stgTarget.column)

	if not var2 then
		return false, "can not find champion at: [" .. arg0.stgTarget.row .. ", " .. arg0.stgTarget.column .. "]"
	end

	if not arg3 then
		arg1.BaseHP = math.max(arg1.BaseHP - arg0.hp_del, 0)

		arg1:RemoveChampion(var2)

		var0 = bit.bor(var0, ChapterConst.DirtyBase, ChapterConst.DirtyChampion)
		var1 = bit.bor(var1, ChapterConst.DirtyAutoAction)

		if #arg0.cellUpdates > 0 then
			_.each(arg0.cellUpdates, function(arg0)
				if isa(arg0, ChapterChampionPackage) then
					local var0 = arg1:mergeChampion(arg0)

					var0 = bit.bor(var0, ChapterConst.DirtyChampion)
				else
					arg1:mergeChapterCell(arg0)

					var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
				end
			end)
		end
	end

	return true, var0, var1
end

function var0.applyToDock(arg0, arg1, arg2, arg3)
	if arg2.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead Dock at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
	end

	local var0 = 0
	local var1 = 0

	if not arg1:getFleet(FleetType.Normal, arg0.stgTarget.row, arg0.stgTarget.column) then
		return false, "can not find fleet at: [" .. arg0.stgTarget.row .. ", " .. arg0.stgTarget.column .. "]"
	end

	if not arg3 then
		_.each(arg0.cellUpdates, function(arg0)
			if isa(arg0, ChapterCell) then
				arg1:mergeChapterCell(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end
		end)
		_.each(arg0.shipUpdate, function(arg0)
			arg1:updateFleetShipHp(arg0.id, arg0.hpRant)
		end)

		var0 = bit.bor(var0, ChapterConst.DirtyFleet)
	end

	return true, var0
end

function var0.applyToAntiAir(arg0, arg1, arg2, arg3)
	if arg2.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead antiairGun at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
	end

	local var0 = 0
	local var1 = 0
	local var2 = arg1:getChampion(arg0.stgTarget.row, arg0.stgTarget.column)

	if not var2 then
		return false, "can not find champion at: [" .. arg0.stgTarget.row .. ", " .. arg0.stgTarget.column .. "]"
	end

	if not arg3 then
		arg1:RemoveChampion(var2)

		var0 = bit.bor(var0, ChapterConst.DirtyChampion, ChapterConst.DirtyAttachment)

		_.each(arg0.cellUpdates, function(arg0)
			if isa(arg0, ChapterChampionPackage) then
				local var0 = arg1:mergeChampion(arg0)
			else
				arg1:mergeChapterCell(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end
		end)
	end

	return true, var0, var1
end

return var0
