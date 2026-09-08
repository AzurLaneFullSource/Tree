local var0_0 = class("ReversePacmanInterviewScene", import("view.base.BaseUI"))

var0_0.ON_SELECTED_ROLE = "ReversePacmanInterviewScene::ON_SELECTED_ROLE"
var0_0.ON_CLOSE_RESUME = "ReversePacmanInterviewScene::ON_CLOSE_RESUME"

function var0_0.getUIName(arg0_1)
	return "ReversePacmanInterviewUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiHomeBtn, function()
		arg0_2:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["20260908gameplay_hire"].tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiShopBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiResumeBtn, function()
		arg0_2:ShowRoleListPanel(false)

		if arg0_2.resumeView == nil then
			arg0_2.resumeView = ReversePacmanResumeScene.New(arg0_2.uiResumePanel, arg0_2)
		end

		arg0_2.resumeView:didEnter(arg0_2.selectedID)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiGetCurrencyBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanTaskScene,
			mediator = ReversePacmanTaskMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiUnlockBtn, function()
		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanTaskScene,
			mediator = ReversePacmanTaskMediator
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiHireBtn, function()
		if not ReversePacmanTools.IsHireRole(arg0_2.selectedID) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("reverse_pacman_hire_tip"),
				onYes = function()
					arg0_2:emit(ReversePacmanInterviewMediator.CMD_HIRE, arg0_2.selectedID)
				end
			})

			return
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCurrencyBtn, function()
		local var0_12 = ReversePacmanTools.GetInterviewItemID()

		arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = ReversePacmanItemPopScene,
			mediator = ReversePacmanItemPopMediator,
			data = {
				dropType = DROP_TYPE_VITEM,
				dropID = var0_12,
				count = ReversePacmanTools.GetItemCnt(var0_12),
				limitItemGuideID = ReversePacmanTools.GetActivity():getConfig("config_client").invite_link or 238
			}
		}))
	end, SFX_PANEL)

	arg0_2.interviewList = ReversePacmanInterviewRoleList.New(arg0_2.uiRolePanel, arg0_2)
	arg0_2.nameView = ReversePacmanInterviewRoleName.New(arg0_2.uiNamePanel, arg0_2)

	setText(arg0_2.uiFrontText, i18n("reverse_pacman_owned"))

	local var0_2 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = ReversePacmanTools.GetInterviewItemID()
	})

	setImageSprite(arg0_2.uiCurrencyImage, GetSpriteFromAtlas(var0_2:getIcon(), ""))
end

function var0_0.didEnter(arg0_13)
	arg0_13:BlurPanel(arg0_13._tf)

	arg0_13.eventIDList = {
		arg0_13:bind(var0_0.ON_SELECTED_ROLE, handler(arg0_13, arg0_13.OnSelectedRole)),
		arg0_13:bind(var0_0.ON_CLOSE_RESUME, handler(arg0_13, arg0_13.OnCloseResume))
	}

	arg0_13.interviewList:didEnter()
	arg0_13:ShowRoleListPanel(true)
	arg0_13:RefreshCurrency()

	local var0_13 = ReversePacmanTools.GetUnreadyHireStory()

	if #var0_13 > 0 then
		local var1_13 = {}

		for iter0_13, iter1_13 in ipairs(var0_13) do
			table.insert(var1_13, function(arg0_14)
				arg0_13:OnRoleHireSuccess(iter1_13, arg0_14)
			end)
		end

		seriesAsync(var1_13, function()
			return
		end)
	end

	arg0_13:RefreshTips()
end

function var0_0.RefreshCurrency(arg0_16)
	local var0_16 = ReversePacmanTools.GetInterviewItemID()

	setText(arg0_16.uiInterviewCntText, i18n("reverse_pacman_count", ReversePacmanTools.GetItemCnt(var0_16)))
end

function var0_0.RefreshPainting(arg0_17)
	arg0_17.paintingDefaultAngle = arg0_17.uiPaintingTf.localEulerAngles

	if arg0_17.shipVO then
		retPaintingPrefab(arg0_17.uiPaintingTf, arg0_17.shipVO:getPainting())
	end

	local var0_17 = arg0_17.selectedID
	local var1_17 = pg.activity_chasing_character[var0_17]
	local var2_17 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var1_17.skin_id].ship_group).id
	local var3_17 = Ship.New({
		id = var2_17,
		configId = var2_17,
		skin_id = var1_17.skin_id
	})

	setPaintingPrefabAsync(arg0_17.uiPaintingTf, var3_17:getPainting(), "chuanwu", function()
		arg0_17:RefreshPaintingColor()
	end, {
		skinID = var3_17:getSkinId(),
		rotateZ = arg0_17.paintingDefaultAngle.z
	})
end

function var0_0.RefreshPaintingColor(arg0_19)
	return
end

function var0_0.RefreshName(arg0_20)
	arg0_20.nameView:RefreshUI(arg0_20.selectedID)
end

function var0_0.RefreshBtns(arg0_21)
	local var0_21 = arg0_21.selectedID
	local var1_21 = pg.activity_chasing_character[var0_21]
	local var2_21 = ReversePacmanTools.IsUnlockRole(var0_21)

	setActive(arg0_21.uiUnlockBtn, not var2_21)
	setActive(arg0_21.uiResumeBtn, var2_21)

	if not var2_21 then
		setActive(arg0_21.uiGetCurrencyBtn, false)
		setActive(arg0_21.uiAlreadyHireGo, false)
		setActive(arg0_21.uiHireBtn, false)

		return
	end

	local var3_21 = ReversePacmanTools.IsHireRole(var0_21)

	setActive(arg0_21.uiAlreadyHireGo, var3_21)

	if var3_21 then
		setActive(arg0_21.uiGetCurrencyBtn, false)
		setActive(arg0_21.uiHireBtn, false)

		return
	end

	local var4_21 = ReversePacmanTools.GetItemCnt(var1_21.need[1]) < var1_21.need[2]

	setActive(arg0_21.uiGetCurrencyBtn, var4_21)

	if var4_21 then
		setActive(arg0_21.uiHireBtn, false)

		return
	end

	setActive(arg0_21.uiHireBtn, not var3_21)
end

function var0_0.RefreshShopBtn(arg0_22)
	local var0_22 = arg0_22:GetShopGoodsID()

	if var0_22 == nil then
		setActive(arg0_22.uiShopBtn, false)

		return
	end

	local var1_22 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[var0_22].time)

	setActive(arg0_22.uiShopBtn, var1_22)
end

function var0_0.GetShopGoodsID(arg0_23)
	local var0_23 = ReversePacmanTools.GetActivity():getConfig("config_client").skin_shop_showtime or {}

	for iter0_23, iter1_23 in ipairs(var0_23) do
		if pg.shop_template[iter1_23].effect_args[1] == arg0_23.selectedID then
			return iter1_23
		end
	end
end

function var0_0.ShowRoleListPanel(arg0_24, arg1_24)
	setActive(arg0_24.uiRolePanel, arg1_24)

	local var0_24 = ReversePacmanTools.IsUnlockRole(arg0_24.selectedID)

	setActive(arg0_24.uiResumeBtn, arg1_24 and var0_24)
	setActive(arg0_24.uiResumePanel, not arg1_24)
end

function var0_0.RefreshTips(arg0_25)
	return
end

function var0_0.OnSelectedRole(arg0_26, arg1_26, arg2_26)
	arg0_26.selectedID = arg2_26

	arg0_26:RefreshPainting()
	arg0_26:RefreshName()
	arg0_26:RefreshBtns()
	arg0_26:RefreshShopBtn()
end

function var0_0.OnCloseResume(arg0_27)
	arg0_27:ShowRoleListPanel(true)
end

function var0_0.OnRoleHireSuccess(arg0_28, arg1_28, arg2_28)
	arg0_28:RefreshTips()
	arg0_28:RefreshCurrency()

	local var0_28 = pg.activity_chasing_character[arg1_28].love_level_show[1][1]

	arg0_28:ShowHireProcess()
	pg.NewStoryMgr.GetInstance():Play(var0_28, function()
		arg0_28:HideHireProcess(arg1_28)
		arg0_28:RefreshPaintingColor()
		existCall(arg2_28)
	end, true)
end

function var0_0.OnSelectedOption(arg0_30)
	return
end

function var0_0.ShowHireProcess(arg0_31)
	return
end

function var0_0.HideHireProcess(arg0_32, arg1_32)
	setActive(arg0_32.uiStoryAdaptTf, false)
	arg0_32:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = ReversePacmanHireSuccessScene,
		mediator = ReversePacmanHireSuccessMediator,
		data = {
			roleID = arg1_32
		}
	}))
	arg0_32.interviewList:OnClickToggle(nil, nil, arg0_32.selectedID)
end

function var0_0.willExit(arg0_33)
	if arg0_33.shipVO then
		retPaintingPrefab(arg0_33.uiPaintingTf, arg0_33.shipVO:getPainting())
	end

	for iter0_33, iter1_33 in ipairs(arg0_33.eventIDList) do
		arg0_33:disconnect(iter1_33)
	end

	arg0_33.eventIDList = nil

	arg0_33:UnOverlayPanel(arg0_33._tf)
	arg0_33.interviewList:willExit()

	arg0_33.interviewList = nil

	arg0_33.nameView:willExit()

	arg0_33.nameView = nil

	if arg0_33.resumeView then
		arg0_33.resumeView:willExit()

		arg0_33.resumeView = nil
	end
end

function var0_0.onBackPressed(arg0_34)
	if not arg0_34.uiRolePanel.gameObject.activeSelf then
		arg0_34:ShowRoleListPanel(true)
	else
		var0_0.super.onBackPressed(arg0_34)
	end
end

return var0_0
