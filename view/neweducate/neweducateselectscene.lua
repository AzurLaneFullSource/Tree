local var0_0 = class("NewEducateSelectScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.bgTF = arg0_2.rootTF:Find("bg")
	arg0_2.sureBtn = arg0_2.rootTF:Find("window/sure_btn")

	setText(arg0_2.sureBtn:Find("Text"), i18n("child2_enter"))

	arg0_2.hardSureBtn = arg0_2.rootTF:Find("window/hard_sure_btn")

	setText(arg0_2.hardSureBtn:Find("Text"), i18n("child2_hard_enter"))

	local var0_2 = arg0_2.rootTF:Find("window/info")

	arg0_2.hardTF = var0_2:Find("hard")

	setText(arg0_2.hardTF:Find("Text"), i18n("child2_hard"))

	arg0_2.hardToggle = var0_2:Find("hard/toggle")
	arg0_2.nameTF = var0_2:Find("name")
	arg0_2.progressTF = var0_2:Find("progress")
	arg0_2.gameTF = var0_2:Find("game")
	arg0_2.topTF = arg0_2.rootTF:Find("top")
	arg0_2.contentTF = arg0_2.rootTF:Find("window/view/content")
end

function var0_0.InitData(arg0_3)
	arg0_3.infos = {}
	arg0_3.infos[0] = getProxy(EducateProxy):GetSelectInfo()

	local var0_3 = getProxy(NewEducateProxy)

	for iter0_3, iter1_3 in ipairs(pg.child2_data.all) do
		arg0_3.infos[iter1_3] = var0_3:GetChar(iter1_3):GetSelectInfo()
	end

	arg0_3.playerID = getProxy(PlayerProxy):getRawData().id

	if NewEducateHelper.IsShowNewChildTip() then
		arg0_3.newId = pg.child2_data.all[#pg.child2_data.all]

		NewEducateHelper.ClearShowNewChildTip()
	end
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.topTF:Find("return_btn"), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.topTF:Find("btns/collect"), function()
		arg0_4:emit(NewEducateSelectMediator.GO_SUBLAYER, Context.New({
			mediator = NewEducateCollectEntranceMediator,
			viewComponent = NewEducateCollectEntranceLayer,
			data = {
				isSelect = true,
				id = arg0_4.selectedId
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.sureBtn, function()
		arg0_4:EnterEasyMode()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.hardSureBtn, function()
		arg0_4:EnterHardMode()
	end, SFX_PANEL)
	eachChild(arg0_4.contentTF, function(arg0_9)
		onToggle(arg0_4, arg0_9, function(arg0_10)
			local var0_10 = tonumber(arg0_9.name)

			if arg0_10 then
				PlayerPrefs.SetInt(arg0_4:GetSelectedLocalKey(), var0_10)

				arg0_4.selectedId = var0_10

				arg0_4:UpdataInfo()
				arg0_9:SetAsLastSibling()
			end
		end, SFX_PANEL)
	end)
	onToggle(arg0_4, arg0_4.hardToggle, function(arg0_11)
		local var0_11 = arg0_11 and "anim_educate_select_chage" or "anim_educate_select_chage2"

		quickPlayAnimation(arg0_4._tf:Find("root/window"), var0_11)
		setActive(arg0_4.hardSureBtn, arg0_11)
		setActive(arg0_4.sureBtn, not arg0_11)

		local var1_11 = arg0_4.infos[arg0_4.selectedId]

		setText(arg0_4.gameTF, (arg0_11 and i18n("child2_hard") or "") .. i18n("child2_game_cnt", var1_11.gameCnt))
	end, SFX_PANEL)
	arg0_4:InitData()

	local var0_4 = arg0_4.newId or PlayerPrefs.GetInt(arg0_4:GetSelectedLocalKey()) or 0

	triggerToggle(arg0_4.contentTF:Find(tostring(var0_4)), true)
end

function var0_0.GetSelectedLocalKey(arg0_12)
	return NewEducateConst.NEW_EDUCATE_SELECT_ID .. "_" .. arg0_12.playerID
end

function var0_0.UpdataInfo(arg0_13)
	local var0_13 = arg0_13.infos[arg0_13.selectedId]

	setText(arg0_13.nameTF, var0_13.name)
	setText(arg0_13.progressTF, var0_13.progressStr)
	setImageSprite(arg0_13.bgTF, LoadSprite("bg/" .. var0_13.bg), false)

	local var1_13 = arg0_13.selectedId > 1 and var0_13.gameCnt > 1

	setActive(arg0_13.hardTF, var1_13)
	triggerToggle(arg0_13.hardToggle, var1_13 and var0_13.isHard)
	arg0_13:CheckGuide(var1_13)
end

function var0_0.EnterEasyMode(arg0_14)
	if arg0_14.selectedId == 0 then
		arg0_14:EnterScene()

		return
	end

	local var0_14 = {}

	if arg0_14.infos[arg0_14.selectedId].isHard then
		table.insert(var0_14, function(arg0_15)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
				contentText = i18n("child2_switch_sure"),
				onConfirm = arg0_15
			})
		end)
		table.insert(var0_14, function(arg0_16)
			arg0_14:emit(NewEducateSelectMediator.SWITCH_DIFFICULTY, {
				id = arg0_14.selectedId,
				difficulty = NewEducateChar.DIFFICULTY.EASY,
				callback = arg0_16
			})
		end)
	end

	seriesAsync(var0_14, function()
		arg0_14:EnterScene()
	end)
end

function var0_0.EnterHardMode(arg0_18)
	if arg0_18.selectedId == 0 then
		return
	end

	local var0_18 = {}

	if not arg0_18.infos[arg0_18.selectedId].isHard then
		table.insert(var0_18, function(arg0_19)
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
				contentText = i18n("child2_switch_sure"),
				onConfirm = arg0_19
			})
		end)
		table.insert(var0_18, function(arg0_20)
			arg0_18:emit(NewEducateSelectMediator.SWITCH_DIFFICULTY, {
				id = arg0_18.selectedId,
				difficulty = NewEducateChar.DIFFICULTY.HARD,
				callback = arg0_20
			})
		end)
	end

	seriesAsync(var0_18, function()
		arg0_18:EnterScene()
	end)
end

function var0_0.EnterScene(arg0_22)
	if arg0_22.selectedId == 0 then
		arg0_22:emit(NewEducateSelectMediator.GO_SCENE, SCENE.EDUCATE, {
			isMainEnter = true
		})
	else
		arg0_22:emit(NewEducateSelectMediator.GO_SCENE, SCENE.NEW_EDUCATE, {
			isMainEnter = true,
			id = arg0_22.selectedId
		})
	end
end

function var0_0.CheckGuide(arg0_23, arg1_23)
	if arg1_23 and not pg.NewStoryMgr.GetInstance():IsPlayed("tb2_19") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "tb2_19"
		})
		pg.NewGuideMgr.GetInstance():Play("tb2_19", {
			arg0_23.selectedId
		})
	end
end

function var0_0.onBackPressed(arg0_24)
	if arg0_24.contextData.isTb1 then
		arg0_24:emit(NewEducateBaseUI.ON_HOME)
	else
		var0_0.super.onBackPressed(arg0_24)
	end
end

return var0_0
