local var0_0 = class("FleetAIAction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.actType = arg1_1.act_type
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

	arg0_1.shipUpdate = _.map(arg1_1.ship_update, function(arg0_2)
		return {
			id = arg0_2.id,
			hpRant = arg0_2.hp_rant
		}
	end)
	arg0_1.cellUpdates = {}

	_.each(arg1_1.map_update, function(arg0_3)
		if arg0_3.item_type ~= ChapterConst.AttachNone and arg0_3.item_type ~= ChapterConst.AttachBorn and arg0_3.item_type ~= ChapterConst.AttachBorn_Sub and (arg0_3.item_type ~= ChapterConst.AttachStory or arg0_3.item_data ~= ChapterConst.StoryTrigger) then
			local var0_3 = arg0_3.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0_3) or ChapterCell.New(arg0_3)

			table.insert(arg0_1.cellUpdates, var0_3)
		end
	end)

	arg0_1.commanderSkillEffectId = arg1_1.commander_skill_effect_id
end

function var0_0.applyTo(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:getFleet(FleetType.Normal, arg0_4.line.row, arg0_4.line.column)

	if var0_4 then
		return arg0_4:applyToFleet(arg1_4, var0_4, arg2_4)
	end

	return false, "can not find any fleet at: [" .. arg0_4.line.row .. ", " .. arg0_4.line.column .. "]"
end

function var0_0.applyToFleet(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg2_5:isValid() then
		return false, "fleet " .. arg2_5.id .. " is invalid."
	end

	local var0_5 = 0

	if arg1_5:isPlayingWithBombEnemy() then
		if not arg3_5 then
			_.each(arg0_5.cellUpdates, function(arg0_6)
				local var0_6 = arg1_5:getChapterCell(arg0_6.row, arg0_6.column)

				if var0_6.flag == ChapterConst.CellFlagActive and arg0_6.flag == ChapterConst.CellFlagDisabled then
					local var1_6 = pg.specialunit_template[var0_6.attachmentId]

					assert(var1_6, "specialunit_template not exist: " .. var0_6.attachmentId)

					arg1_5.modelCount = arg1_5.modelCount + var1_6.enemy_point
				end

				arg1_5:mergeChapterCell(arg0_6)

				var0_5 = bit.bor(var0_5, ChapterConst.DirtyAttachment)
			end)
		end
	elseif arg0_5.target then
		local var1_5 = _.detect(arg0_5.cellUpdates, function(arg0_7)
			return arg0_7.row == arg0_5.target.row and arg0_7.column == arg0_5.target.column
		end)

		if not arg3_5 then
			if arg0_5.shipUpdate then
				_.each(arg0_5.shipUpdate, function(arg0_8)
					arg1_5:updateFleetShipHp(arg0_8.id, arg0_8.hpRant)
				end)

				var0_5 = bit.bor(var0_5, ChapterConst.DirtyFleet)
			end

			if var1_5 then
				if isa(var1_5, ChapterChampionPackage) then
					arg1_5:mergeChampion(var1_5)

					var0_5 = bit.bor(var0_5, ChapterConst.DirtyChampion)
				else
					arg1_5:mergeChapterCell(var1_5)

					var0_5 = bit.bor(var0_5, ChapterConst.DirtyAttachment)
				end

				var0_5 = bit.bor(var0_5, ChapterConst.DirtyFleet)
			end
		end
	end

	return true, var0_5
end

function var0_0.PlayAIAction(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg1_9:getFleetIndex(FleetType.Normal, arg0_9.line.row, arg0_9.line.column)

	assert(var0_9)

	if arg1_9:isPlayingWithBombEnemy() then
		local var1_9 = arg1_9.fleets[var0_9]
		local var2_9 = arg1_9:getMapShip(var1_9)

		arg2_9.viewComponent:doPlayStrikeAnim(var2_9, var2_9:GetMapStrikeAnim(), arg3_9)
	elseif arg0_9.actType == ChapterConst.ActType_Poison then
		arg3_9()
	elseif arg0_9.target then
		local var3_9 = arg1_9.fleets[var0_9]
		local var4_9 = _.detect(arg0_9.cellUpdates, function(arg0_10)
			return arg0_10.row == arg0_9.target.row and arg0_10.column == arg0_9.target.column
		end)

		assert(var4_9, "can not find cell")

		if var4_9.attachment == ChapterConst.AttachLandbase then
			if pg.land_based_template[var4_9.attachmentId].type == ChapterConst.LBCoastalGun then
				local var5_9 = arg1_9:getMapShip(var3_9)

				arg2_9.viewComponent:doPlayStrikeAnim(var5_9, var5_9:GetMapStrikeAnim(), arg3_9)
			else
				assert(false)
			end

			return
		end

		local var6_9 = "-" .. var4_9.data / 100 .. "%"
		local var7_9 = arg0_9.commanderSkillEffectId
		local var8_9 = var3_9:getSkill(var7_9)

		assert(var8_9, "can not find skill: " .. var7_9)

		local var9_9 = var3_9:findCommanderBySkillId(var7_9)

		assert(var9_9, "command can not find by skill id: " .. var7_9)
		arg2_9.viewComponent:doPlayCommander(var9_9, function()
			if var8_9:GetType() == FleetSkill.TypeAirStrikeDodge then
				arg2_9.viewComponent:easeAvoid(arg2_9.viewComponent.grid.cellFleets[var3_9.id].tf.position, arg3_9)

				return
			elseif var8_9:GetType() == FleetSkill.TypeAttack then
				local var0_11 = var8_9:GetArgs()
				local var1_11

				switch(var0_11[1], {
					airfight = function()
						var1_11 = "AirStrikeUI"
					end,
					torpedo = function()
						var1_11 = "SubTorpedoUI"
					end,
					cannon = function()
						var1_11 = "CannonUI"
					end
				})
				assert(var1_11)
				arg2_9.viewComponent:doPlayStrikeAnim(arg1_9:getStrikeAnimShip(var3_9, var1_11), var1_11, function()
					arg2_9.viewComponent:strikeEnemy(arg0_9.target, var6_9, arg3_9)
				end)

				return
			else
				assert(false)
			end
		end)
	else
		arg3_9()
	end
end

return var0_0
