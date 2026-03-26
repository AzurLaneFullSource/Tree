local var0_0 = class("NewEducateSelectScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSelectUI"
end

function var0_0.preload(arg0_2, arg1_2)
	pg.PerformMgr.GetInstance():CheckLoad(function()
		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	arg0_4.rootTF = arg0_4._tf:Find("root")
	arg0_4.bgTF = arg0_4.rootTF:Find("bg")
	arg0_4.sureBtn = arg0_4.rootTF:Find("window/sure_btn")

	setText(arg0_4.sureBtn:Find("Text"), i18n("child2_enter"))

	arg0_4.hardSureBtn = arg0_4.rootTF:Find("window/hard_sure_btn")

	setText(arg0_4.hardSureBtn:Find("Text"), i18n("child2_hard_enter"))

	local var0_4 = arg0_4.rootTF:Find("window/info")

	arg0_4.hardTF = var0_4:Find("hard")

	setText(arg0_4.hardTF:Find("Text"), i18n("child2_hard"))

	arg0_4.hardToggle = var0_4:Find("hard/toggle")
	arg0_4.nameTF = var0_4:Find("name")
	arg0_4.progressTF = var0_4:Find("progress")
	arg0_4.gameTF = var0_4:Find("game")
	arg0_4.topTF = arg0_4.rootTF:Find("top")
	arg0_4.contentTF = arg0_4.rootTF:Find("window/view/content")
end

function var0_0.InitData(arg0_5)
	arg0_5.infos = {}
	arg0_5.infos[0] = getProxy(EducateProxy):GetSelectInfo()

	local var0_5 = getProxy(NewEducateProxy)

	for iter0_5, iter1_5 in ipairs(pg.child2_data.all) do
		arg0_5.infos[iter1_5] = var0_5:GetChar(iter1_5):GetSelectInfo()
	end

	arg0_5.playerID = getProxy(PlayerProxy):getRawData().id

	if NewEducateHelper.IsShowNewChildTip() then
		arg0_5.newId = pg.child2_data.all[#pg.child2_data.all]

		NewEducateHelper.ClearShowNewChildTip()
	end
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.topTF:Find("return_btn"), function()
		arg0_6:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.topTF:Find("btns/collect"), function()
		arg0_6:emit(NewEducateSelectMediator.GO_SUBLAYER, Context.New({
			mediator = NewEducateCollectEntranceMediator,
			viewComponent = NewEducateCollectEntranceLayer,
			data = {
				isSelect = true,
				id = arg0_6.selectedId
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.sureBtn, function()
		arg0_6:EnterEasyMode()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.hardSureBtn, function()
		arg0_6:EnterHardMode()
	end, SFX_PANEL)
	eachChild(arg0_6.contentTF, function(arg0_11)
		onToggle(arg0_6, arg0_11, function(arg0_12)
			local var0_12 = tonumber(arg0_11.name)

			if arg0_12 then
				PlayerPrefs.SetInt(arg0_6:GetSelectedLocalKey(), var0_12)

				arg0_6.selectedId = var0_12

				arg0_6:UpdataInfo()
				arg0_11:SetAsLastSibling()
			end
		end, SFX_PANEL)
	end)
	onToggle(arg0_6, arg0_6.hardToggle, function(arg0_13)
		local var0_13 = arg0_13 and "anim_educate_select_chage" or "anim_educate_select_chage2"

		quickPlayAnimation(arg0_6._tf:Find("root/window"), var0_13)
		setActive(arg0_6.hardSureBtn, arg0_13)
		setActive(arg0_6.sureBtn, not arg0_13)

		local var1_13 = arg0_6.infos[arg0_6.selectedId]

		setText(arg0_6.gameTF, (arg0_13 and i18n("child2_hard") or "") .. i18n("child2_game_cnt", var1_13.gameCnt))
	end, SFX_PANEL)
	arg0_6:InitData()

	local var0_6 = arg0_6.newId or PlayerPrefs.GetInt(arg0_6:GetSelectedLocalKey()) or 0

	triggerToggle(arg0_6.contentTF:Find(tostring(var0_6)), true)
end

function var0_0.GetSelectedLocalKey(arg0_14)
	return NewEducateConst.NEW_EDUCATE_SELECT_ID .. "_" .. arg0_14.playerID
end

function var0_0.UpdataInfo(arg0_15)
	local var0_15 = arg0_15.infos[arg0_15.selectedId]

	setText(arg0_15.nameTF, var0_15.name)
	setText(arg0_15.progressTF, var0_15.progressStr)
	setImageSprite(arg0_15.bgTF, LoadSprite("bg/" .. var0_15.bg), false)

	local var1_15 = arg0_15.selectedId > 1 and var0_15.gameCnt > 1

	setActive(arg0_15.hardTF, var1_15)
	triggerToggle(arg0_15.hardToggle, var1_15 and var0_15.isHard)
	arg0_15:CheckGuide(var1_15)
end

function var0_0.EnterEasyMode(arg0_16)
	if arg0_16.selectedId == 0 then
		arg0_16:EnterScene()

		return
	end

	local var0_16 = {}

	if arg0_16.infos[arg0_16.selectedId].isHard then
		table.insert(var0_16, function(arg0_17)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
				contentText = i18n("child2_switch_sure"),
				onConfirm = arg0_17
			})
		end)
		table.insert(var0_16, function(arg0_18)
			arg0_16:emit(NewEducateSelectMediator.SWITCH_DIFFICULTY, {
				id = arg0_16.selectedId,
				difficulty = NewEducateChar.DIFFICULTY.EASY,
				callback = arg0_18
			})
		end)
	end

	seriesAsync(var0_16, function()
		arg0_16:EnterScene()
	end)
end

function var0_0.EnterHardMode(arg0_20)
	if arg0_20.selectedId == 0 then
		return
	end

	local var0_20 = {}

	if not arg0_20.infos[arg0_20.selectedId].isHard then
		table.insert(var0_20, function(arg0_21)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
				contentText = i18n("child2_switch_sure"),
				onConfirm = arg0_21
			})
		end)
		table.insert(var0_20, function(arg0_22)
			arg0_20:emit(NewEducateSelectMediator.SWITCH_DIFFICULTY, {
				id = arg0_20.selectedId,
				difficulty = NewEducateChar.DIFFICULTY.HARD,
				callback = arg0_22
			})
		end)
	end

	seriesAsync(var0_20, function()
		arg0_20:EnterScene()
	end)
end

function var0_0.EnterScene(arg0_24)
	if arg0_24.selectedId == 0 then
		arg0_24:emit(NewEducateSelectMediator.GO_SCENE, SCENE.EDUCATE, {
			isMainEnter = true
		})
	else
		arg0_24:emit(NewEducateSelectMediator.GO_SCENE, SCENE.NEW_EDUCATE, {
			isMainEnter = true,
			id = arg0_24.selectedId
		})
	end
end

function var0_0.CheckGuide(arg0_25, arg1_25)
	if arg1_25 and not pg.NewStoryMgr.GetInstance():IsPlayed("tb2_19") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "tb2_19"
		})
		pg.NewGuideMgr.GetInstance():Play("tb2_19", {
			arg0_25.selectedId
		})
	end
end

function var0_0.onBackPressed(arg0_26)
	if arg0_26.contextData.isTb1 then
		arg0_26:emit(NewEducateBaseUI.ON_HOME)
	else
		var0_0.super.onBackPressed(arg0_26)
	end
end

return var0_0
