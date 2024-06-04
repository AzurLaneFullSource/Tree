local var0 = class("FleetAIAction")

function var0.Ctor(arg0, arg1)
	arg0.actType = arg1.act_type
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

	arg0.commanderSkillEffectId = arg1.commander_skill_effect_id
end

function var0.applyTo(arg0, arg1, arg2)
	local var0 = arg1:getFleet(FleetType.Normal, arg0.line.row, arg0.line.column)

	if var0 then
		return arg0:applyToFleet(arg1, var0, arg2)
	end

	return false, "can not find any fleet at: [" .. arg0.line.row .. ", " .. arg0.line.column .. "]"
end

function var0.applyToFleet(arg0, arg1, arg2, arg3)
	if not arg2:isValid() then
		return false, "fleet " .. arg2.id .. " is invalid."
	end

	local var0 = 0

	if arg1:isPlayingWithBombEnemy() then
		if not arg3 then
			_.each(arg0.cellUpdates, function(arg0)
				local var0 = arg1:getChapterCell(arg0.row, arg0.column)

				if var0.flag == ChapterConst.CellFlagActive and arg0.flag == ChapterConst.CellFlagDisabled then
					local var1 = pg.specialunit_template[var0.attachmentId]

					assert(var1, "specialunit_template not exist: " .. var0.attachmentId)

					arg1.modelCount = arg1.modelCount + var1.enemy_point
				end

				arg1:mergeChapterCell(arg0)

				var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			end)
		end
	elseif arg0.target then
		local var1 = _.detect(arg0.cellUpdates, function(arg0)
			return arg0.row == arg0.target.row and arg0.column == arg0.target.column
		end)

		if not arg3 then
			if arg0.shipUpdate then
				_.each(arg0.shipUpdate, function(arg0)
					arg1:updateFleetShipHp(arg0.id, arg0.hpRant)
				end)

				var0 = bit.bor(var0, ChapterConst.DirtyFleet)
			end

			if var1 then
				if isa(var1, ChapterChampionPackage) then
					arg1:mergeChampion(var1)

					var0 = bit.bor(var0, ChapterConst.DirtyChampion)
				else
					arg1:mergeChapterCell(var1)

					var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
				end

				var0 = bit.bor(var0, ChapterConst.DirtyFleet)
			end
		end
	end

	return true, var0
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	local var0 = arg1:getFleetIndex(FleetType.Normal, arg0.line.row, arg0.line.column)

	assert(var0)

	if arg1:isPlayingWithBombEnemy() then
		local var1 = arg1.fleets[var0]
		local var2 = arg1:getMapShip(var1)

		arg2.viewComponent:doPlayStrikeAnim(var2, var2:GetMapStrikeAnim(), arg3)
	elseif arg0.actType == ChapterConst.ActType_Poison then
		arg3()
	elseif arg0.target then
		local var3 = arg1.fleets[var0]
		local var4 = _.detect(arg0.cellUpdates, function(arg0)
			return arg0.row == arg0.target.row and arg0.column == arg0.target.column
		end)

		assert(var4, "can not find cell")

		if var4.attachment == ChapterConst.AttachLandbase then
			if pg.land_based_template[var4.attachmentId].type == ChapterConst.LBCoastalGun then
				local var5 = arg1:getMapShip(var3)

				arg2.viewComponent:doPlayStrikeAnim(var5, var5:GetMapStrikeAnim(), arg3)
			else
				assert(false)
			end

			return
		end

		local var6 = "-" .. var4.data / 100 .. "%"
		local var7 = arg0.commanderSkillEffectId
		local var8 = var3:getSkill(var7)

		assert(var8, "can not find skill: " .. var7)

		local var9 = var3:findCommanderBySkillId(var7)

		assert(var9, "command can not find by skill id: " .. var7)
		arg2.viewComponent:doPlayCommander(var9, function()
			if var8:GetType() == FleetSkill.TypeAirStrikeDodge then
				arg2.viewComponent:easeAvoid(arg2.viewComponent.grid.cellFleets[var3.id].tf.position, arg3)

				return
			elseif var8:GetType() == FleetSkill.TypeAttack then
				local var0 = var8:GetArgs()
				local var1

				switch(var0[1], {
					airfight = function()
						var1 = "AirStrikeUI"
					end,
					torpedo = function()
						var1 = "SubTorpedoUI"
					end,
					cannon = function()
						var1 = "CannonUI"
					end
				})
				assert(var1)
				arg2.viewComponent:doPlayStrikeAnim(arg1:getStrikeAnimShip(var3, var1), var1, function()
					arg2.viewComponent:strikeEnemy(arg0.target, var6, arg3)
				end)

				return
			else
				assert(false)
			end
		end)
	else
		arg3()
	end
end

return var0
