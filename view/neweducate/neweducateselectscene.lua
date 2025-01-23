local var0_0 = class("NewEducateSelectScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.bgTF = arg0_2.rootTF:Find("bg")
	arg0_2.sureBtn = arg0_2.rootTF:Find("window/sure_btn")

	setText(arg0_2.sureBtn:Find("Text"), i18n("child2_enter"))

	local var0_2 = arg0_2.rootTF:Find("window/info")

	arg0_2.nameTF = var0_2:Find("name")
	arg0_2.progressTF = var0_2:Find("progress")
	arg0_2.gameTF = var0_2:Find("game")
	arg0_2.topTF = arg0_2.rootTF:Find("top")
	arg0_2.contentTF = arg0_2.rootTF:Find("window/view/content")

	eachChild(arg0_2.contentTF, function(arg0_3)
		onToggle(arg0_2, arg0_3, function(arg0_4)
			local var0_4 = tonumber(arg0_3.name)

			if arg0_4 then
				PlayerPrefs.SetInt(arg0_2:GetSelectedLocalKey(), var0_4)

				arg0_2.selectedId = var0_4

				arg0_2:UpdataInfo()
				arg0_3:SetAsLastSibling()
			end
		end, SFX_PANEL)
	end)
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
		arg0_6:emit(NewEducateBaseUI.ON_HOME)
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
		if arg0_6.selectedId == 0 then
			arg0_6:emit(NewEducateSelectMediator.GO_SCENE, SCENE.EDUCATE, {
				isMainEnter = true
			})
		else
			arg0_6:emit(NewEducateSelectMediator.GO_SCENE, SCENE.NEW_EDUCATE, {
				isMainEnter = true,
				id = arg0_6.selectedId
			})
		end
	end, SFX_PANEL)
	arg0_6:InitData()

	local var0_6 = arg0_6.newId or PlayerPrefs.GetInt(arg0_6:GetSelectedLocalKey()) or 0

	triggerToggle(arg0_6.contentTF:Find(tostring(var0_6)), true)
end

function var0_0.GetSelectedLocalKey(arg0_10)
	return NewEducateConst.NEW_EDUCATE_SELECT_ID .. "_" .. arg0_10.playerID
end

function var0_0.UpdataInfo(arg0_11)
	local var0_11 = arg0_11.infos[arg0_11.selectedId]

	setText(arg0_11.nameTF, var0_11.name)
	setText(arg0_11.progressTF, i18n("child2_game_cnt", var0_11.gameCnt))
	setText(arg0_11.gameTF, var0_11.progressStr)
	setImageSprite(arg0_11.bgTF, LoadSprite("bg/" .. var0_11.bg), false)
end

function var0_0.onBackPressed(arg0_12)
	arg0_12:emit(NewEducateBaseUI.ON_HOME)
end

return var0_0
