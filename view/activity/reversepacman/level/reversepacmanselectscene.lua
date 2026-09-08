local var0_0 = class("ReversePacmanSelectScene", import("view.base.BaseUI"))

var0_0.LEVEL_TYPES = {
	EASY = 1,
	HARD = 2
}
var0_0.SHIP_TYPES = {
	ALL = 0,
	FOLLOW = 1,
	FLEXIBLE = 3,
	PREJUDGE = 2
}

local var1_0 = pg.activity_chasing_level
local var2_0 = pg.activity_chasing_character

function var0_0.getUIName(arg0_1)
	return "ReversePacmanSelectUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiDeployTipText, i18n("reverse_pacman_deploy_tip"))
	setText(arg0_2.uiLevelPanelTF:Find("left/title/Text"), i18n("reverse_pacman_select_level_title"))
	setText(arg0_2.uiShipPanelTF:Find("left/title/Text"), i18n("reverse_pacman_select_ship_title"))
	onButton(arg0_2, arg0_2.uiTopTF:Find("back"), function()
		arg0_2:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiTopTF:Find("home"), function()
		arg0_2:quickExitFunc()
	end, SOUND_BACK)
	setActive(arg0_2.uiLevelPanelTF, true)
	eachChild(arg0_2.uiLevelTogglesTF, function(arg0_5)
		local var0_5 = tonumber(arg0_5.name)

		setText(arg0_5:Find("Text"), i18n("reverse_pacman_level_type_" .. var0_5))
		onToggle(arg0_2, arg0_5, function(arg0_6)
			if arg0_6 then
				arg0_2:UpdateLevelList(var0_5)
			end
		end)
	end)

	arg0_2.levelUIList = UIItemList.New(arg0_2.uiLevelContentTF, arg0_2.uiLevelContentTF:Find("tpl"))

	arg0_2.levelUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_2:UpdateLevelTpl(arg1_7, arg2_7)
		end
	end)
	onButton(arg0_2, arg0_2.uiDeployBtn, function()
		arg0_2:SwitchShipView()
	end, SFX_PANEL)

	arg0_2.awardUIList = UIItemList.New(arg0_2.uiMapAwardTF, arg0_2.uiMapAwardTF:Find("tpl"))

	arg0_2.awardUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_2.awards[arg1_9 + 1]

			updateDrop(arg2_9, var0_9)
			onButton(arg0_2, arg2_9, function()
				arg0_2:emit(BaseUI.ON_DROP, var0_9)
			end, SFX_PANEL)

			local var1_9 = arg0_2.levelGradeRecords[arg0_2.selLevelId]

			setActive(arg2_9:Find("got"), var1_9)
		end
	end)
	setActive(arg0_2.uiShipPanelTF, false)
	eachChild(arg0_2.uiShipTogglesTF, function(arg0_11)
		local var0_11 = tonumber(arg0_11.name)

		setText(arg0_11:Find("Text"), var0_11)
		setText(arg0_11:Find("Text"), i18n("reverse_pacman_ship_type_" .. var0_11))
		onToggle(arg0_2, arg0_11, function(arg0_12)
			if arg0_12 then
				arg0_2:UpdateShipList(var0_11)
			end
		end)
	end)

	arg0_2.shipUIList = UIItemList.New(arg0_2.uiShipContentTF, arg0_2.uiShipContentTF:Find("tpl"))

	arg0_2.shipUIList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_2:UpdateShipTpl(arg1_13, arg2_13)
		end
	end)
	onButton(arg0_2, arg0_2.uiAutoBtn, function()
		arg0_2:ApplyAutoDeploy()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiStartBtn, function()
		if not underscore.any(arg0_2.slotShipIds, function(arg0_16)
			return arg0_16 ~= 0
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_deploy_empty"))

			return
		end

		local var0_15 = {}

		for iter0_15, iter1_15 in ipairs(arg0_2.buffIds) do
			if iter1_15 ~= 0 then
				local var1_15 = pg.activity_chasing_skill[iter1_15].item_id

				var0_15[iter0_15] = arg0_2.activity:GetVitemNumber(var1_15)
			else
				var0_15[iter0_15] = 0
			end
		end

		local var2_15 = pg.activity_chasing_skill[ReversePacmanConst.BUFF_EDU].item_id
		local var3_15 = arg0_2.activity:GetVitemNumber(var2_15)

		arg0_2:emit(ReversePacmanSelectMediator.GO_SCENE, SCENE.REVERSE_PACMAN_GAME, {
			levelId = arg0_2.selLevelId,
			slotShipIds = arg0_2.slotShipIds,
			buffIds = arg0_2.buffIds,
			buffCnts = var0_15,
			eduBuffCnt = var3_15
		})
	end, SFX_PANEL)

	arg0_2.buffSlotUIList = UIItemList.New(arg0_2.uiBuffSlotsTF, arg0_2.uiBuffSlotsTF:Find("tpl"))

	arg0_2.buffSlotUIList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg0_2.buffIds[arg1_17 + 1]
			local var1_17 = var0_17 == 0

			setActive(arg2_17:Find("empty"), var1_17)
			setActive(arg2_17:Find("icon"), not var1_17)

			if not var1_17 then
				LoadImageSpriteAsync(pg.activity_chasing_skill[var0_17].icon, arg2_17:Find("icon"))
			end

			setActive(arg2_17:Find("Text"), false)
			onButton(arg0_2, arg2_17, function()
				arg0_2.buffSubView:ExecuteAction("Show", arg0_2.mapData.skillSlotCount, function()
					arg0_2:UpdateShipViewWithBuff()
				end)
			end, SFX_PANEL)
		end
	end)

	arg0_2.buffSubView = ReversePacmanBuffSubView.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
end

function var0_0.SetData(arg0_20)
	arg0_20.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN)

	assert(arg0_20.activity and not arg0_20.activity:isEnd(), "not exist act, type: " .. ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN)

	arg0_20.mapDataDic = {}

	for iter0_20, iter1_20 in ipairs(var1_0.all) do
		local var0_20 = var1_0[iter1_20].map_json

		arg0_20.mapDataDic[iter1_20] = require("view.activity.ReversePacman.Maps." .. var0_20)
	end

	arg0_20.gridType2tpl = {
		[ReversePacmanConst.GRID.BLOCK] = arg0_20.uiMapTpls:Find("block"),
		[ReversePacmanConst.GRID.ROAD] = arg0_20.uiMapTpls:Find("road"),
		[ReversePacmanConst.GRID.SPAWN] = arg0_20.uiMapTpls:Find("spawn"),
		[ReversePacmanConst.GRID.DEPLOY] = arg0_20.uiMapTpls:Find("deploy")
	}
	arg0_20.levelTimeRecords = arg0_20.activity:GetStageDataList()

	local var1_20 = underscore.keys(arg0_20.levelTimeRecords)

	arg0_20.unlockHard = #var1_20 > 0
	arg0_20.levelGradeRecords = {}

	for iter2_20, iter3_20 in ipairs(var1_20) do
		local var2_20 = arg0_20.levelTimeRecords[iter3_20]
		local var3_20 = arg0_20.mapDataDic[iter3_20].duration
		local var4_20 = arg0_20.mapDataDic[iter3_20].ratingThresholds
		local var5_20 = ReversePacmanConst.GetGrade(var3_20 - var2_20, var3_20, var4_20)

		arg0_20.levelGradeRecords[iter3_20] = var5_20
	end

	arg0_20.allSortShipIds = arg0_20.activity:GetRoleIds()

	table.sort(arg0_20.allSortShipIds, CompareFuncs({
		function(arg0_21)
			return -var2_0[arg0_21].base_speed
		end,
		function(arg0_22)
			return arg0_22
		end
	}))
end

function var0_0.didEnter(arg0_23)
	arg0_23:SetData()

	local var0_23 = arg0_23.uiLevelTogglesTF:Find(tostring(var0_0.LEVEL_TYPES.HARD))

	setActive(var0_23:Find("lock"), not arg0_23.unlockHard)
	onButton(arg0_23, var0_23:Find("lock"), function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_select_level_lock_tip"))
	end, SFX_PANEL)
	arg0_23:UpdateLevelToggleTips()
	setToggleEnabled(var0_23, arg0_23.unlockHard)

	local var1_23 = arg0_23.contextData.levelType or var0_0.LEVEL_TYPES.EASY

	triggerToggle(arg0_23.uiLevelTogglesTF:Find(tostring(var1_23)), true)
end

function var0_0.UpdateLevelToggleTips(arg0_25)
	local var0_25 = underscore.any(var1_0.all, function(arg0_26)
		local var0_26 = arg0_25.activity:IsUnlockStage(arg0_26)
		local var1_26 = arg0_25.levelGradeRecords[arg0_26]

		return var1_0[arg0_26].difficulty == var0_0.LEVEL_TYPES.EASY and var0_26 and not var1_26 and arg0_25.activity:IsLevelTip(arg0_26)
	end)

	setActive(arg0_25.uiLevelTogglesTF:Find(tostring(var0_0.LEVEL_TYPES.EASY) .. "/tip"), var0_25)

	local var1_25 = underscore.any(var1_0.all, function(arg0_27)
		local var0_27 = arg0_25.activity:IsUnlockStage(arg0_27)
		local var1_27 = arg0_25.levelGradeRecords[arg0_27]

		return var1_0[arg0_27].difficulty == var0_0.LEVEL_TYPES.HARD and var0_27 and not var1_27 and arg0_25.activity:IsLevelTip(arg0_27)
	end)

	setActive(arg0_25.uiLevelTogglesTF:Find(tostring(var0_0.LEVEL_TYPES.HARD) .. "/tip"), var1_25)
end

function var0_0.SwitchLevelView(arg0_28)
	setActive(arg0_28.uiLevelPanelTF, true)
	setActive(arg0_28.uiDeployBtn, true)
	setActive(arg0_28._tf:Find("right/awards"), true)
	setActive(arg0_28.uiShipPanelTF, false)
	arg0_28:SetDeployVisibility(false)
end

function var0_0.UpdateLevelList(arg0_29, arg1_29)
	arg0_29.levelType = arg1_29
	arg0_29.contextData.levelType = arg1_29
	arg0_29.showLevelIds = {}

	for iter0_29, iter1_29 in ipairs(var1_0.all) do
		if var1_0[iter1_29].difficulty == arg1_29 then
			table.insert(arg0_29.showLevelIds, iter1_29)
		end
	end

	arg0_29.levelUIList:align(#arg0_29.showLevelIds)

	local var0_29 = (function()
		for iter0_30, iter1_30 in ipairs(arg0_29.showLevelIds) do
			if not arg0_29.levelGradeRecords[iter1_30] and arg0_29.activity:IsUnlockStage(iter1_30) then
				return iter1_30
			end
		end

		return arg0_29.showLevelIds[1]
	end)()

	triggerButton(arg0_29.uiLevelContentTF:Find(tostring(var0_29)))

	local var1_29 = table.indexof(arg0_29.showLevelIds, var0_29)

	scrollToIndex(arg0_29.levelUIList.container, var1_29)
end

function var0_0.UpdateLevelTpl(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.showLevelIds[arg1_31 + 1]

	arg2_31.name = tostring(var0_31)

	local var1_31 = var1_0[var0_31]

	setText(arg2_31:Find("unsel/Text"), var1_31.name)
	setText(arg2_31:Find("sel/Text"), var1_31.name)

	local var2_31 = arg0_31.levelGradeRecords[var0_31]

	setActive(arg2_31:Find("sel/grade"), var2_31)
	setActive(arg2_31:Find("unsel/grade"), var2_31)

	if var2_31 then
		LoadImageSpriteAtlasAsync("ui/reversepacmanui_atlas", "level_" .. var2_31, arg2_31:Find("sel/grade/Image"))
		LoadImageSpriteAtlasAsync("ui/reversepacmanui_atlas", "level_" .. var2_31 .. "_1", arg2_31:Find("unsel/grade/Image"))
	end

	local var3_31 = arg0_31.activity:IsUnlockStage(var0_31)
	local var4_31 = arg0_31.selLevelId == var0_31

	setActive(arg2_31:Find("lock"), not var3_31)
	setActive(arg2_31:Find("sel"), var3_31 and var4_31)
	setActive(arg2_31:Find("unsel"), var3_31 and not var4_31)
	setActive(arg2_31:Find("tip"), var3_31 and not var2_31 and arg0_31.activity:IsLevelTip(var0_31))

	if not var3_31 then
		local var5_31 = var1_31.unlock_date

		setText(arg2_31:Find("lock/Text"), var1_31.unlock_date)

		local var6_31 = pg.TimeMgr.GetInstance()
		local var7_31 = var6_31:parseTimeFromConfig(var5_31[1])
		local var8_31 = var6_31:STimeDescS(var7_31, "%m")
		local var9_31 = var6_31:STimeDescS(var7_31, "%d")

		setText(arg2_31:Find("lock/Text"), i18n("reverse_pacman_unlock_date_tip", var8_31, var9_31))
	end

	onButton(arg0_31, arg2_31, function()
		if not var3_31 then
			return
		end

		if arg0_31.selLevelId and var0_31 == arg0_31.selLevelId then
			return
		end

		if not var2_31 then
			arg0_31.activity:SetLevelTip(var0_31)
			setActive(arg2_31:Find("tip"), false)
			arg0_31:UpdateLevelToggleTips()
		end

		arg0_31.selLevelId = var0_31

		arg0_31.levelUIList:align(#arg0_31.showLevelIds)
		arg0_31:UpdateLevelView()
	end, SFX_PANEL)
end

function var0_0.UpdateLevelView(arg0_33)
	local var0_33 = var1_0[arg0_33.selLevelId]

	arg0_33.mapData = arg0_33.mapDataDic[arg0_33.selLevelId]

	setText(arg0_33.uiMapInfosTF:Find("terrain"), var0_33.terrain_tags)
	setText(arg0_33.uiMapInfosTF:Find("time"), arg0_33.mapData.duration .. "s")
	setText(arg0_33.uiMapInfosTF:Find("monster_cnt"), #arg0_33.mapData.spawnPoints)
	setText(arg0_33.uiMapInfosTF:Find("monster_speed"), var0_33.monster_speed_rating)

	local var1_33 = arg0_33.levelGradeRecords[arg0_33.selLevelId]

	setActive(arg0_33.uiMapGradeExistTF, var1_33)
	setActive(arg0_33.uiMapGradeNoTF, not var1_33)

	if var1_33 then
		LoadImageSpriteAtlasAsync("ui/reversepacmanui_atlas", "level_" .. var1_33, arg0_33.uiMapGradeExistTF:Find("Image"), true)
	end

	local var2_33 = var0_33.first_clear_reward

	arg0_33.awards = {}

	if var2_33 and type(var2_33) == "table" then
		arg0_33.awards = underscore.map(var2_33, function(arg0_34)
			return Drop.Create(arg0_34)
		end)
	end

	arg0_33.awardUIList:align(#arg0_33.awards)
	arg0_33:UpdateMap()
	arg0_33:SetDeployVisibility(false)
end

function var0_0.UpdateMap(arg0_35)
	removeAllChildren(arg0_35.uiMapGridsTF)
	removeAllChildren(arg0_35.uiMapRolesTF)

	local var0_35 = ReversePacmanConst.GRID_SIZE_2
	local var1_35 = {
		x = arg0_35.mapData.width * var0_35.x,
		y = arg0_35.mapData.height * var0_35.y
	}

	setSizeDelta(arg0_35.uiMapGridsTF, var1_35)
	setSizeDelta(arg0_35.uiMapRolesTF, var1_35)

	arg0_35.deployTFs = {}
	arg0_35.deployPosList = {}
	arg0_35.monsterPosList = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.mapData.grid) do
		for iter2_35, iter3_35 in ipairs(iter1_35) do
			local var2_35 = iter3_35 ~= ReversePacmanConst.GRID.BLOCK and ReversePacmanConst.GRID.ROAD or ReversePacmanConst.GRID.BLOCK
			local var3_35 = cloneTplTo(arg0_35.gridType2tpl[var2_35], arg0_35.uiMapGridsTF)

			var3_35.name = iter2_35 .. "_" .. iter0_35

			setActive(var3_35, true)

			local var4_35 = (iter2_35 - 1) * var0_35.x - var1_35.x / 2 + var0_35.x / 2
			local var5_35 = var1_35.y / 2 - (iter0_35 - 1) * var0_35.y - var0_35.y / 2

			setLocalPosition(var3_35, Vector2(var4_35, var5_35))

			if iter3_35 == ReversePacmanConst.GRID.DEPLOY then
				local var6_35 = cloneTplTo(arg0_35.gridType2tpl[iter3_35], arg0_35.uiMapRolesTF)

				table.insert(arg0_35.deployTFs, var6_35)
				table.insert(arg0_35.deployPosList, {
					x = iter2_35,
					y = iter0_35
				})
				setLocalPosition(var6_35, Vector2(var4_35, var5_35))
			elseif iter3_35 == ReversePacmanConst.GRID.SPAWN then
				local var7_35 = cloneTplTo(arg0_35.gridType2tpl[iter3_35], arg0_35.uiMapRolesTF)

				table.insert(arg0_35.monsterPosList, {
					x = iter2_35,
					y = iter0_35
				})
				setLocalPosition(var7_35, Vector2(var4_35, var5_35))
			end
		end
	end

	for iter4_35, iter5_35 in ipairs(arg0_35.deployTFs) do
		onButton(arg0_35, iter5_35, function()
			if arg0_35.selSlot and arg0_35.selSlot == iter4_35 then
				return
			end

			arg0_35.selSlot = iter4_35

			arg0_35:UpdateShipViewWithShipOrSlot()
		end, SFX_PANEL)
	end
end

function var0_0.SetDeployVisibility(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.deployTFs) do
		setActive(iter1_37, arg1_37)
	end
end

function var0_0.SwitchShipView(arg0_38)
	setActive(arg0_38.uiLevelPanelTF, false)
	setActive(arg0_38.uiDeployBtn, false)
	setActive(arg0_38._tf:Find("right/awards"), false)
	setActive(arg0_38.uiShipPanelTF, true)
	arg0_38:SetDeployVisibility(true)

	arg0_38.slotShipIds = {}

	for iter0_38 = 1, #arg0_38.deployTFs do
		table.insert(arg0_38.slotShipIds, 0)
	end

	arg0_38.selSlot = 1

	if not arg0_38.shipType then
		triggerToggle(arg0_38.uiShipTogglesTF:Find(tostring(var0_0.SHIP_TYPES.ALL)), true)
	end

	arg0_38:UpdateShipView()
end

function var0_0.UpdateShipView(arg0_39)
	arg0_39:UpdateShipViewWithShipOrSlot()
	arg0_39:UpdateShipViewWithBuff()
end

function var0_0.UpdateShipList(arg0_40, arg1_40)
	arg0_40.shipType = arg1_40
	arg0_40.showShipIds = {}

	for iter0_40, iter1_40 in ipairs(arg0_40.allSortShipIds) do
		if arg1_40 == var0_0.SHIP_TYPES.ALL or var2_0[iter1_40].ai_type == arg1_40 then
			table.insert(arg0_40.showShipIds, iter1_40)
		end
	end

	arg0_40.shipUIList:align(#arg0_40.showShipIds)
end

function var0_0.UpdateShipTpl(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.showShipIds[arg1_41 + 1]

	arg2_41.name = tostring(var0_41)

	local var1_41 = var2_0[var0_41]

	setText(arg2_41:Find("name"), HXSet.hxLan(var1_41.name))
	setActive(arg2_41:Find("recommend"), table.contains(arg0_41.recommendIds, var0_41))
	setActive(arg2_41:Find("sel"), var0_41 == arg0_41.slotShipIds[arg0_41.selSlot])
	setActive(arg2_41:Find("occupy"), table.contains(arg0_41.slotShipIds, var0_41))
	LoadImageSpriteAsync(var1_41.sd_avatar, arg2_41:Find("icon"))

	local var2_41 = ReversePacmanHomeConst.GetSpeedLevel(var1_41.base_speed)
	local var3_41 = arg2_41:Find("speed/Text")

	setTextColor(var3_41, Color.white)
	setScrollText(var3_41, i18n("reverse_pacman_select_ship_speed", var2_41.value))
	setScrollText(arg2_41:Find("tags/resume/Text"), var1_41.resume_text)
	setScrollText(arg2_41:Find("tags/trait/Text"), var1_41.trait_text)
	onButton(arg0_41, arg2_41, function()
		local var0_42 = var0_41

		if arg0_41.slotShipIds[arg0_41.selSlot] == var0_41 then
			var0_42 = 0
		end

		for iter0_42, iter1_42 in ipairs(arg0_41.slotShipIds) do
			if iter1_42 == var0_41 then
				arg0_41.slotShipIds[iter0_42] = 0
			end
		end

		arg0_41.slotShipIds[arg0_41.selSlot] = var0_42

		arg0_41:UpdateShipViewWithShipOrSlot()
		arg0_41:AutoSelEmotySlot()
	end, SOUND_BACK)
end

function var0_0.AutoSelEmotySlot(arg0_43)
	local var0_43 = (function()
		for iter0_44, iter1_44 in ipairs(arg0_43.slotShipIds) do
			if iter1_44 == 0 then
				return iter0_44
			end
		end
	end)()

	if var0_43 and var0_43 ~= arg0_43.selSlot then
		arg0_43.selSlot = var0_43

		arg0_43:UpdateShipViewWithShipOrSlot()
	end
end

function var0_0.UpdateShipViewWithShipOrSlot(arg0_45)
	arg0_45.recommendIds = arg0_45.mapData.deployPoints[arg0_45.selSlot].recommendedRoleIds

	table.sort(arg0_45.showShipIds, CompareFuncs({
		function(arg0_46)
			return table.contains(arg0_45.recommendIds, arg0_46) and 0 or 1
		end,
		function(arg0_47)
			return arg0_47
		end
	}))
	arg0_45.shipUIList:align(#arg0_45.showShipIds)

	for iter0_45, iter1_45 in ipairs(arg0_45.deployTFs) do
		setActive(iter1_45:Find("selected"), arg0_45.selSlot == iter0_45)
		setActive(iter1_45:Find("ship"), arg0_45.slotShipIds[iter0_45] ~= 0)

		if arg0_45.slotShipIds[iter0_45] ~= 0 then
			local var0_45 = arg0_45.slotShipIds[iter0_45]

			LoadImageSpriteAsync(var2_0[var0_45].sd_avatar, iter1_45:Find("ship/Image"))
		end
	end
end

function var0_0.UpdateShipViewWithBuff(arg0_48)
	local var0_48 = arg0_48.mapData.skillSlotCount

	arg0_48.buffIds = ReversePacmanBuffSubView.GetSelBuffIds(var0_48)

	arg0_48.buffSlotUIList:align(var0_48)
end

function var0_0.ApplyAutoDeploy(arg0_49)
	local var0_49 = {}
	local var1_49 = {}
	local var2_49 = {}

	for iter0_49, iter1_49 in ipairs(arg0_49.allSortShipIds) do
		var0_49[iter1_49] = true
	end

	for iter2_49 = 1, #arg0_49.deployTFs do
		local var3_49 = 0
		local var4_49 = arg0_49.mapData.deployPoints[iter2_49]
		local var5_49 = var4_49 and var4_49.recommendedRoleIds or {}

		for iter3_49, iter4_49 in ipairs(var5_49) do
			if var0_49[iter4_49] and not var1_49[iter4_49] then
				var3_49 = iter4_49
				var1_49[iter4_49] = true

				break
			end
		end

		arg0_49.slotShipIds[iter2_49] = var3_49

		if var3_49 == 0 then
			table.insert(var2_49, iter2_49)
		end
	end

	table.sort(var2_49, CompareFuncs({
		function(arg0_50)
			return arg0_49:_GetNeaestDis(arg0_50)
		end,
		function(arg0_51)
			return arg0_51
		end
	}))

	local var6_49 = 1

	for iter5_49, iter6_49 in ipairs(var2_49) do
		while var6_49 <= #arg0_49.allSortShipIds and var1_49[arg0_49.allSortShipIds[var6_49]] do
			var6_49 = var6_49 + 1
		end

		local var7_49 = arg0_49.allSortShipIds[var6_49]

		if not var7_49 then
			break
		end

		arg0_49.slotShipIds[iter6_49] = var7_49
		var1_49[var7_49] = true
		var6_49 = var6_49 + 1
	end

	arg0_49:UpdateShipViewWithShipOrSlot()
end

function var0_0._GetNeaestDis(arg0_52, arg1_52)
	local var0_52 = 0
	local var1_52 = arg0_52.deployPosList[arg1_52]

	for iter0_52, iter1_52 in ipairs(arg0_52.monsterPosList) do
		local var2_52 = math.abs(iter1_52.x - var1_52.x) + math.abs(iter1_52.y - var1_52.y)

		var0_52 = var0_52 == 0 and var2_52 or math.min(var0_52, var2_52)
	end

	return var0_52
end

function var0_0.onBackPressed(arg0_53)
	if arg0_53.buffSubView and arg0_53.buffSubView:isShowing() then
		arg0_53.buffSubView:ExecuteAction("Hide")

		return
	end

	if isActive(arg0_53.uiShipPanelTF) then
		arg0_53:SwitchLevelView()

		return
	end

	var0_0.super.onBackPressed(arg0_53)
end

function var0_0.willExit(arg0_54)
	if arg0_54.buffSubView then
		arg0_54.buffSubView:Destroy()

		arg0_54.buffSubView = nil
	end
end

return var0_0
