local var0_0 = class("NewEducateSelectScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSelectUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/PerformUI",
		"cue/qe-ova-10.b",
		"painting/linghangyuan1_1",
		"storyicon/zhihuiguan",
		"ui/neweducatecommonui_atlas",
		"ui/neweducatescheduleui_atlas",
		"cue/story-richang-quiet.b"
	}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	for iter0_2, iter1_2 in ipairs(pg.secretary_special_ship.all) do
		local var2_2 = pg.secretary_special_ship[iter1_2].prefab

		if noEmptyStr(var2_2) and not table.contains(var0_2, "painting/" .. var2_2) then
			var1_2("painting/" .. var2_2)
			var1_2("paintingface/" .. var2_2)
			var1_2("squareicon/" .. var2_2)
			var1_2("qicon/" .. var2_2)
		end
	end

	for iter2_2, iter3_2 in ipairs(pg.child2_benefit_list.all) do
		local var3_2 = pg.child2_benefit_list[iter3_2].item_icon
		local var4_2 = pg.child2_benefit_list[iter3_2].item_icon_little

		if noEmptyStr(var3_2) and not table.contains(var0_2, "neweducateicon/" .. var3_2) then
			var1_2("neweducateicon/" .. var3_2)
		end

		if noEmptyStr(var4_2) and not table.contains(var0_2, "neweducateicon/" .. var4_2) then
			var1_2("neweducateicon/" .. var4_2)
		end
	end

	for iter4_2, iter5_2 in ipairs(pg.child2_resource.all) do
		local var5_2 = pg.child2_resource[iter5_2].icon
		local var6_2 = pg.child2_resource[iter5_2].item_icon

		if noEmptyStr(var5_2) and not table.contains(var0_2, "neweducateicon/" .. var5_2) then
			var1_2("neweducateicon/" .. var5_2)
		end

		if noEmptyStr(var6_2) and not table.contains(var0_2, "neweducateicon/" .. var6_2) then
			var1_2("neweducateicon/" .. var6_2)
		end
	end

	for iter6_2, iter7_2 in ipairs(pg.child2_attr.all) do
		local var7_2 = pg.child2_attr[iter7_2].icon
		local var8_2 = pg.child2_attr[iter7_2].item_icon

		if noEmptyStr(var7_2) and not table.contains(var0_2, "neweducateicon/" .. var7_2) then
			var1_2("neweducateicon/" .. var7_2)
		end

		if noEmptyStr(var8_2) and not table.contains(var0_2, "neweducateicon/" .. var8_2) then
			var1_2("neweducateicon/" .. var8_2)
		end
	end

	for iter8_2, iter9_2 in ipairs(pg.child2_memory.all) do
		local var9_2 = pg.child2_memory[iter9_2].pic

		if noEmptyStr(var9_2) and not table.contains(var0_2, "neweducateicon/" .. var9_2) then
			var1_2("neweducateicon/" .. var9_2)
		end
	end

	for iter10_2, iter11_2 in ipairs(pg.child2_plan.all) do
		local var10_2 = pg.child2_plan[iter11_2].icon_square
		local var11_2 = pg.child2_plan[iter11_2].plan_rectangle_2

		if noEmptyStr(var10_2) and not table.contains(var0_2, "neweducateicon/" .. var10_2) then
			var1_2("neweducateicon/" .. var10_2)
		end

		if noEmptyStr(var11_2) and not table.contains(var0_2, "neweducateicon/" .. var11_2) then
			var1_2("neweducateicon/" .. var11_2)
		end
	end

	for iter12_2, iter13_2 in ipairs(pg.child2_site_display.all) do
		local var12_2 = pg.child2_site_display[iter13_2].event_icon
		local var13_2 = pg.child2_site_display[iter13_2].event_title

		if noEmptyStr(var12_2) and not table.contains(var0_2, "neweducateicon/" .. var12_2) then
			var1_2("neweducateicon/" .. var12_2)
		end

		if noEmptyStr(var13_2) and not table.contains(var0_2, "neweducateicon/" .. var13_2) then
			var1_2("neweducateicon/" .. var13_2)
		end
	end

	local var14_2 = getProxy(EducateProxy):GetSelectInfo()

	if var14_2 and var14_2.bg then
		var1_2("bg/" .. var14_2.bg)
	end

	local var15_2 = getProxy(NewEducateProxy)

	for iter14_2, iter15_2 in ipairs(pg.child2_data.all) do
		local var16_2 = var15_2:GetChar(iter15_2)

		if var16_2 then
			local var17_2 = var16_2:GetSelectInfo()

			if var17_2 and var17_2.bg then
				var1_2("bg/" .. var17_2.bg)
			end
		end

		local var18_2 = pg.child2_data[iter15_2]

		if var18_2 then
			if var18_2.child2_data_personality_icon and #var18_2.child2_data_personality_icon > 0 then
				for iter16_2, iter17_2 in ipairs(var18_2.child2_data_personality_icon) do
					var1_2("neweducateicon/" .. iter17_2)
				end
			end

			if noEmptyStr(var18_2.personality_bar_icon) then
				var1_2("neweducateicon/" .. var18_2.personality_bar_icon)
			end

			if var18_2.personality_tag_icon and #var18_2.personality_tag_icon > 0 then
				for iter18_2, iter19_2 in ipairs(var18_2.personality_tag_icon) do
					for iter20_2, iter21_2 in ipairs(iter19_2) do
						var1_2("neweducateicon/" .. iter21_2)
					end
				end
			end

			if var18_2.spine_char then
				for iter22_2, iter23_2 in pairs(var18_2.spine_char) do
					var1_2("char/" .. iter23_2)
				end
			end
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.preload(arg0_4, arg1_4)
	pg.PerformMgr.GetInstance():CheckLoad(function()
		arg1_4()
	end)
end

function var0_0.init(arg0_6)
	arg0_6.rootTF = arg0_6._tf:Find("root")
	arg0_6.bgTF = arg0_6.rootTF:Find("bg")
	arg0_6.sureBtn = arg0_6.rootTF:Find("window/sure_btn")

	setText(arg0_6.sureBtn:Find("Text"), i18n("child2_enter"))

	arg0_6.hardSureBtn = arg0_6.rootTF:Find("window/hard_sure_btn")

	setText(arg0_6.hardSureBtn:Find("Text"), i18n("child2_hard_enter"))

	local var0_6 = arg0_6.rootTF:Find("window/info")

	arg0_6.hardTF = var0_6:Find("hard")

	setText(arg0_6.hardTF:Find("Text"), i18n("child2_hard"))

	arg0_6.hardToggle = var0_6:Find("hard/toggle")
	arg0_6.nameTF = var0_6:Find("name")
	arg0_6.progressTF = var0_6:Find("progress")
	arg0_6.gameTF = var0_6:Find("game")
	arg0_6.topTF = arg0_6.rootTF:Find("top")
	arg0_6.contentTF = arg0_6.rootTF:Find("window/view/content")
end

function var0_0.InitData(arg0_7)
	arg0_7.infos = {}
	arg0_7.infos[0] = getProxy(EducateProxy):GetSelectInfo()

	local var0_7 = getProxy(NewEducateProxy)

	for iter0_7, iter1_7 in ipairs(pg.child2_data.all) do
		arg0_7.infos[iter1_7] = var0_7:GetChar(iter1_7):GetSelectInfo()
	end

	arg0_7.playerID = getProxy(PlayerProxy):getRawData().id

	if NewEducateHelper.IsShowNewChildTip() then
		arg0_7.newId = pg.child2_data.all[#pg.child2_data.all]

		NewEducateHelper.ClearShowNewChildTip()
	end
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.topTF:Find("return_btn"), function()
		arg0_8:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.topTF:Find("btns/collect"), function()
		arg0_8:emit(NewEducateSelectMediator.GO_SUBLAYER, Context.New({
			mediator = NewEducateCollectEntranceMediator,
			viewComponent = NewEducateCollectEntranceLayer,
			data = {
				isSelect = true,
				id = arg0_8.selectedId
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.sureBtn, function()
		arg0_8:EnterEasyMode()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.hardSureBtn, function()
		arg0_8:EnterHardMode()
	end, SFX_PANEL)
	eachChild(arg0_8.contentTF, function(arg0_13)
		onToggle(arg0_8, arg0_13, function(arg0_14)
			local var0_14 = tonumber(arg0_13.name)

			if arg0_14 then
				PlayerPrefs.SetInt(arg0_8:GetSelectedLocalKey(), var0_14)

				arg0_8.selectedId = var0_14

				arg0_8:UpdataInfo()
				arg0_13:SetAsLastSibling()
			end
		end, SFX_PANEL)
	end)
	onToggle(arg0_8, arg0_8.hardToggle, function(arg0_15)
		local var0_15 = arg0_15 and "anim_educate_select_chage" or "anim_educate_select_chage2"

		quickPlayAnimation(arg0_8._tf:Find("root/window"), var0_15)
		setActive(arg0_8.hardSureBtn, arg0_15)
		setActive(arg0_8.sureBtn, not arg0_15)

		local var1_15 = arg0_8.infos[arg0_8.selectedId]

		setText(arg0_8.gameTF, (arg0_15 and i18n("child2_hard") or "") .. i18n("child2_game_cnt", var1_15.gameCnt))
	end, SFX_PANEL)
	arg0_8:InitData()

	local var0_8 = arg0_8.newId or PlayerPrefs.GetInt(arg0_8:GetSelectedLocalKey()) or 0

	triggerToggle(arg0_8.contentTF:Find(tostring(var0_8)), true)
end

function var0_0.GetSelectedLocalKey(arg0_16)
	return NewEducateConst.NEW_EDUCATE_SELECT_ID .. "_" .. arg0_16.playerID
end

function var0_0.UpdataInfo(arg0_17)
	local var0_17 = arg0_17.infos[arg0_17.selectedId]

	setText(arg0_17.nameTF, var0_17.name)
	setText(arg0_17.progressTF, var0_17.progressStr)
	setImageSprite(arg0_17.bgTF, LoadSprite("bg/" .. var0_17.bg), false)

	local var1_17 = arg0_17.selectedId > 1 and var0_17.gameCnt > 1

	setActive(arg0_17.hardTF, var1_17)
	triggerToggle(arg0_17.hardToggle, var1_17 and var0_17.isHard)
	arg0_17:CheckGuide(var1_17)
end

function var0_0.EnterEasyMode(arg0_18)
	if arg0_18.selectedId == 0 then
		arg0_18:EnterScene()

		return
	end

	local var0_18 = {}

	if arg0_18.infos[arg0_18.selectedId].isHard then
		table.insert(var0_18, function(arg0_19)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
				contentText = i18n("child2_switch_sure"),
				onConfirm = arg0_19
			})
		end)
		table.insert(var0_18, function(arg0_20)
			arg0_18:emit(NewEducateSelectMediator.SWITCH_DIFFICULTY, {
				id = arg0_18.selectedId,
				difficulty = NewEducateChar.DIFFICULTY.EASY,
				callback = arg0_20
			})
		end)
	end

	seriesAsync(var0_18, function()
		arg0_18:EnterScene()
	end)
end

function var0_0.EnterHardMode(arg0_22)
	if arg0_22.selectedId == 0 then
		return
	end

	local var0_22 = {}

	if not arg0_22.infos[arg0_22.selectedId].isHard then
		table.insert(var0_22, function(arg0_23)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
				contentText = i18n("child2_switch_sure"),
				onConfirm = arg0_23
			})
		end)
		table.insert(var0_22, function(arg0_24)
			arg0_22:emit(NewEducateSelectMediator.SWITCH_DIFFICULTY, {
				id = arg0_22.selectedId,
				difficulty = NewEducateChar.DIFFICULTY.HARD,
				callback = arg0_24
			})
		end)
	end

	seriesAsync(var0_22, function()
		arg0_22:EnterScene()
	end)
end

function var0_0.EnterScene(arg0_26)
	if arg0_26.selectedId == 0 then
		arg0_26:emit(NewEducateSelectMediator.GO_SCENE, SCENE.EDUCATE, {
			isMainEnter = true
		})
	else
		arg0_26:emit(NewEducateSelectMediator.GO_SCENE, SCENE.NEW_EDUCATE, {
			isMainEnter = true,
			id = arg0_26.selectedId
		})
	end
end

function var0_0.CheckGuide(arg0_27, arg1_27)
	if arg1_27 and not pg.NewStoryMgr.GetInstance():IsPlayed("tb2_19") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "tb2_19"
		})
		pg.NewGuideMgr.GetInstance():Play("tb2_19", {
			arg0_27.selectedId
		})
	end
end

function var0_0.onBackPressed(arg0_28)
	if arg0_28.contextData.isTb1 then
		arg0_28:emit(NewEducateBaseUI.ON_HOME)
	else
		var0_0.super.onBackPressed(arg0_28)
	end
end

return var0_0
