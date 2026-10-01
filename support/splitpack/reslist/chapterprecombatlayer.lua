ResList = ResList or {}
ResList.ChapterPreCombatLayer = {}

local var0_0 = ResList.ChapterPreCombatLayer

function var0_0.GetConstResource()
	return {
		"energy",
		"shiptype",
		"weaponframes",
		"ui/iconcolorful",
		"ui/msgbox"
	}
end

function var0_0.GetShipResList(arg0_2)
	local var0_2 = {}

	if not arg0_2 then
		return var0_2
	end

	local var1_2 = arg0_2:getPainting()

	if noEmptyStr(var1_2) then
		table.insertto(var0_2, ResPathSupport.GetPaintingSquareIconListByPaintingName(var1_2))
	end

	local var2_2 = arg0_2:getPrefab()

	if noEmptyStr(var2_2) then
		table.insertto(var0_2, ResPathSupport.GetSpineCharListByPrefabName(var2_2))
	end

	if arg0_2.equipments then
		for iter0_2, iter1_2 in pairs(arg0_2:getAttachmentPrefab()) do
			local var3_2 = iter1_2.config[SpineRole.ORBIT_KEY_UI]

			if noEmptyStr(var3_2) then
				table.insert(var0_2, ResPathSupport.CombinePath("orbit", var3_2))
			end
		end
	end

	return var0_2
end

function var0_0.GetDropResList(arg0_3)
	local var0_3 = {
		"weaponframes",
		"ui/iconcolorful"
	}

	Drop.Change(arg0_3)

	if arg0_3.type == DROP_TYPE_RESOURCE then
		table.insertto(var0_3, var0_0.GetDropResList({
			type = DROP_TYPE_ITEM,
			id = id2ItemId(arg0_3.id),
			count = arg0_3.count
		}))
	elseif arg0_3.type == DROP_TYPE_ITEM or arg0_3.type == DROP_TYPE_VITEM or arg0_3.type == DROP_TYPE_META_PT or arg0_3.type == DROP_TYPE_LOVE_LETTER then
		local var1_3 = arg0_3:getSubClass()
		local var2_3 = var1_3.icon or var1_3:getConfig("icon")

		if var1_3:getConfig("type") == Item.LOVE_LETTER_TYPE then
			local var3_3 = ShipGroup.getDefaultSkin(var1_3.extra)

			if var3_3 and noEmptyStr(var3_3.painting) then
				table.insertto(var0_3, ResPathSupport.GetPaintingSquareIconListByPaintingName(var3_3.painting))
			end

			var2_3 = nil
		end

		if noEmptyStr(var2_3) then
			table.insert(var0_3, var2_3)
		end
	elseif arg0_3.type == DROP_TYPE_EQUIP then
		local var4_3 = arg0_3:getSubClass()

		table.insert(var0_3, ResPathSupport.CombinePath(ResPathSupport.ConstPath.Equipment.Equip, var4_3:getConfig("icon")))
	elseif arg0_3.type == DROP_TYPE_SHIP or arg0_3.type == DROP_TYPE_OPERATION then
		table.insertto(var0_3, var0_0.GetShipResList(arg0_3.ship))
	elseif arg0_3.type == DROP_TYPE_SKIN or arg0_3.type == DROP_TYPE_SKIN_TIMELIMIT then
		table.insertto(var0_3, var0_0.GetShipResList(Ship.New({
			configId = tonumber(arg0_3:getConfig("ship_group") .. "1"),
			skin_id = arg0_3.id
		})))
	elseif arg0_3.type == DROP_TYPE_FURNITURE then
		table.insert(var0_3, ResPathSupport.CombinePath(ResPathSupport.ConstPath.FurnitureIcon, arg0_3:getIcon()))
	elseif arg0_3.type == DROP_TYPE_STRATEGY then
		table.insert(var0_3, ResPathSupport.CombinePath(arg0_3.isWorldBuff and "world/buff" or ResPathSupport.ConstPath.StrategyIcon, arg0_3:getIcon()))
	elseif arg0_3.type == DROP_TYPE_EQUIPMENT_SKIN then
		table.insert(var0_3, ResPathSupport.CombinePath(ResPathSupport.ConstPath.Equipment.Equip, arg0_3:getConfig("icon")))
	elseif arg0_3.type == DROP_TYPE_SPWEAPON then
		local var5_3 = SpWeapon.New({
			id = arg0_3.id
		})

		table.insert(var0_3, var5_3:GetIconPath())
	else
		local var6_3 = arg0_3:getIcon()

		if noEmptyStr(var6_3) then
			table.insert(var0_3, var6_3)
		end
	end

	return var0_3
end

function var0_0.GetStageDropResList(arg0_4)
	local var0_4 = {}
	local var1_4 = pg.expedition_data_template[arg0_4]

	if not var1_4 then
		return var0_4
	end

	local var2_4 = Clone(var1_4.award_display)
	local var3_4 = checkExist(pg.expedition_activity_template[arg0_4], {
		"pt_drop_display"
	})

	if var3_4 and type(var3_4) == "table" then
		local var4_4 = getProxy(ActivityProxy)

		for iter0_4 = #var3_4, 1, -1 do
			local var5_4 = var4_4:getActivityById(var3_4[iter0_4][1])

			if var5_4 and not var5_4:isEnd() then
				table.insert(var2_4, 1, {
					2,
					id2ItemId(var3_4[iter0_4][2])
				})
			end
		end
	end

	for iter1_4 = 1, math.min(#var2_4, 6) do
		local var6_4 = var2_4[iter1_4]

		table.insertto(var0_4, var0_0.GetDropResList({
			type = var6_4[1],
			id = var6_4[2],
			count = var6_4[3]
		}))
	end

	return var0_4
end

function var0_0.GetBattleFleetResList(arg0_5)
	local var0_5 = {}

	local function var1_5(arg0_6)
		for iter0_6, iter1_6 in ipairs(arg0_6) do
			table.insertto(var0_5, var0_0.GetShipResList(iter1_6))
		end
	end

	var1_5(arg0_5:getShipsByTeam(TeamType.Main, true))
	var1_5(arg0_5:getShipsByTeam(TeamType.Vanguard, true))

	return var0_5
end

function var0_0.GetStrategyResList(arg0_7)
	local var0_7 = {}
	local var1_7 = arg0_7:getStrategies()
	local var2_7 = _.detect(var1_7, function(arg0_8)
		return arg0_8.id == ChapterConst.StrategyRepair
	end)

	if var2_7 then
		local var3_7 = pg.strategy_data_template[var2_7.id]

		if var3_7 and noEmptyStr(var3_7.icon) then
			table.insert(var0_7, ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var3_7.icon))
		end
	end

	local var4_7 = arg0_7:getFormationStg()
	local var5_7 = pg.strategy_data_template[var4_7]

	if var5_7 and noEmptyStr(var5_7.icon) then
		table.insert(var0_7, ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var5_7.icon))
	end

	return var0_7
end

function var0_0.GetExtraCostBuffResList(arg0_9)
	local var0_9 = {}
	local var1_9, var2_9 = arg0_9:GetExtraCostRate()

	for iter0_9, iter1_9 in ipairs(var2_9) do
		if iter1_9.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			local var3_9 = ActivityBuff.GetBenefitCondition(iter1_9.benefit_condition)

			if var3_9[1] == "item" then
				table.insertto(var0_9, var0_0.GetDropResList({
					count = 1,
					type = DROP_TYPE_ITEM,
					id = var3_9[2]
				}))
			end
		end
	end

	return var0_9
end

function var0_0.GetResource(arg0_10)
	local var0_10 = {}
	local var1_10 = arg0_10.fleet
	local var2_10 = arg0_10:getStageId(var1_10.line.row, var1_10.line.column)

	table.insertto(var0_10, var0_0.GetStageDropResList(var2_10))
	table.insertto(var0_10, var0_0.GetBattleFleetResList(var1_10))
	table.insertto(var0_10, var0_0.GetStrategyResList(var1_10))
	table.insertto(var0_10, var0_0.GetExtraCostBuffResList(arg0_10))

	return var0_10
end

return var0_0
