local var0_0 = class("FeastMakeTicketPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FeastPuzzlePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.back = arg0_2:findTF("back")
	arg0_2.finishTr = arg0_2:findTF("finish")
	arg0_2.envelopesAnim = arg0_2.finishTr:Find("envelopes"):GetComponent(typeof(SpineAnimUI))
	arg0_2.sendBtn = arg0_2.finishTr:Find("send")
	arg0_2.titleTr = arg0_2.finishTr:Find("label1")
	arg0_2.failedTip = arg0_2:findTF("failed_tip")
	arg0_2.descTr = arg0_2:findTF("desc_panel")
	arg0_2.descTxt = arg0_2.descTr:Find("frame/Text"):GetComponent(typeof(Text))
	arg0_2.homeBtn = arg0_2:findTF("home")
	arg0_2.helpBtn = arg0_2:findTF("help")
	arg0_2.tipTopTr = arg0_2:findTF("tip")

	setText(arg0_2:findTF("tip/Text"), i18n("feast_label_make_ticket_tip"))
	setText(arg0_2:findTF("tip/label"), i18n("feast_label_make_ticket_click_tip"))
	setText(arg0_2:findTF("failed_tip/Text"), i18n("feast_label_make_ticket_failed_tip"))
end

function var0_0.OnInit(arg0_3)
	arg0_3:bind(FeastScene.ON_MAKE_TICKET, function(arg0_4, arg1_4)
		arg0_3:OnMakeTicket(arg1_4)
	end)
end

function var0_0.OnMakeTicket(arg0_5, arg1_5)
	if arg0_5.feastShip and arg0_5.feastShip.id == arg1_5 then
		setActive(arg0_5.finishTr, true)
		setActive(arg0_5.tipTopTr, false)

		arg0_5.sendBtn.localScale = Vector3.zero
		arg0_5.titleTr.localScale = Vector3.zero

		arg0_5.envelopesAnim:SetActionCallBack(function(arg0_6)
			if arg0_6 == "finish" then
				LeanTween.scale(arg0_5.sendBtn, Vector3(1, 1, 1), 0.3)
				LeanTween.scale(arg0_5.titleTr, Vector3(1, 1, 1), 0.3)
				arg0_5.envelopesAnim:SetActionCallBack(nil)
				arg0_5.envelopesAnim:SetAction("action2", 0)
			end
		end)
		arg0_5.envelopesAnim:SetAction("action1", 0)
	end
end

function var0_0.Show(arg0_7, arg1_7)
	Input.multiTouchEnabled = false

	var0_0.super.Show(arg0_7)
	arg0_7:CloseTip()
	setActive(arg0_7.tipTopTr, true)
	setActive(arg0_7.finishTr, false)

	arg0_7.feastShip = arg1_7

	seriesAsync({
		function(arg0_8)
			arg0_7:LoadPuzzleRes(arg1_7:GetPrefab(), arg0_8)
		end
	}, function()
		arg0_7:InitPuzzle()
		arg0_7:RegisterEvent()
	end)
end

function var0_0.LoadPuzzleRes(arg0_10, arg1_10, arg2_10)
	ResourceMgr.Inst:getAssetAsync("FeastPuzzle/" .. arg1_10, arg1_10, typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_11)
		if arg0_10.exited then
			return
		end

		arg0_10.puzzleGo = Object.Instantiate(arg0_11, arg0_10._tf:Find("container"))
		arg0_10.rect = arg0_10.puzzleGo.transform:Find("nodes")
		arg0_10.items = {}

		eachChild(arg0_10.rect, function(arg0_12)
			local var0_12 = tonumber(arg0_12.name)
			local var1_12 = var0_12 == 1

			table.insert(arg0_10.items, {
				level = var0_12,
				tr = arg0_12,
				isCompletion = var1_12
			})
		end)
		arg2_10()
	end), true, true)
end

local function var1_0(arg0_13, arg1_13)
	local var0_13 = pg.UIMgr.GetInstance().overlayCameraComp
	local var1_13 = arg0_13:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_13, arg1_13, var0_13))
end

function var0_0.InitPuzzle(arg0_14, arg1_14)
	arg0_14.dragging = false

	for iter0_14, iter1_14 in ipairs(arg0_14.items) do
		local var0_14 = iter1_14.tr:GetComponent(typeof(EventTriggerListener))
		local var1_14 = Vector3.zero

		var0_14:AddBeginDragFunc(function(arg0_15, arg1_15)
			arg0_14.dragging = true
			var1_14 = iter1_14.tr.localPosition

			iter1_14.tr:SetAsLastSibling()
		end)
		var0_14:AddDragFunc(function(arg0_16, arg1_16)
			local var0_16 = var1_0(arg0_14.rect, arg1_16.position)

			iter1_14.tr.localPosition = var0_16
		end)
		var0_14:AddDragEndFunc(function(arg0_17, arg1_17)
			arg0_14.dragging = false

			local var0_17 = arg0_14:FindMatcher(iter1_14)

			if var0_17 then
				arg0_14:Merge(iter1_14, var0_17, var1_14)

				if arg0_14:CheckFinish() then
					arg0_14:OnPass()
				end
			else
				arg0_14:ShowTip()

				iter1_14.tr.localPosition = var1_14
			end
		end)
		var0_14:AddPointUpFunc(function(arg0_18, arg1_18)
			if arg0_14.dragging then
				return
			end

			arg0_14:ShowDesc(iter1_14)
		end)
	end
end

function var0_0.ShowTip(arg0_19)
	arg0_19:CloseTip()
	setActive(arg0_19.failedTip, true)

	arg0_19.timer = Timer.New(function()
		arg0_19:CloseTip()
	end, 2, 1)

	arg0_19.timer:Start()
end

function var0_0.CloseTip(arg0_21)
	if arg0_21.timer then
		setActive(arg0_21.failedTip, false)
		arg0_21.timer:Stop()

		arg0_21.timer = nil
	end
end

function var0_0.CheckFinish(arg0_22)
	return arg0_22.rect.childCount == 1
end

function var0_0.Merge(arg0_23, arg1_23, arg2_23, arg3_23)
	if arg2_23.level < arg1_23.level then
		arg1_23.tr.localPosition = arg3_23

		setParent(arg2_23.tr, arg1_23.tr:Find("slot"))

		arg2_23.tr.localPosition = Vector3.zero

		arg0_23:ClearEvent(arg2_23.tr)

		arg1_23.isCompletion = true
	else
		setParent(arg1_23.tr, arg2_23.tr:Find("slot"))

		arg1_23.tr.localPosition = Vector3.zero

		arg0_23:ClearEvent(arg1_23.tr)

		arg2_23.isCompletion = true
	end
end

local function var2_0(arg0_24, arg1_24)
	local var0_24 = getBounds(arg0_24.tr)
	local var1_24 = getBounds(arg1_24.tr)

	return var0_24:Intersects(var1_24)
end

local function var3_0(arg0_25, arg1_25)
	if arg0_25.level < arg1_25.level then
		return arg0_25.isCompletion
	else
		return arg1_25.isCompletion
	end
end

function var0_0.FindMatcher(arg0_26, arg1_26)
	for iter0_26, iter1_26 in pairs(arg0_26.items) do
		if (arg1_26.level + 1 == iter1_26.level or arg1_26.level - 1 == iter1_26.level) and var3_0(arg1_26, iter1_26) and var2_0(arg1_26, iter1_26) then
			return iter1_26
		end
	end

	return nil
end

function var0_0.OnPass(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.items) do
		arg0_27:ClearEvent(iter1_27.tr)
	end

	setActive(arg0_27.rect, false)
	arg0_27:emit(FeastMediator.MAKE_TICKET, arg0_27.feastShip.tid)
end

function var0_0.RegisterEvent(arg0_28, arg1_28)
	onButton(arg0_28, arg0_28.back, function()
		arg0_28:Hide()
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.sendBtn, function()
		arg0_28:Hide()
		arg0_28:emit(FeastScene.ON_SKIP_GIVE_GIFT, arg0_28.feastShip)
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.feast_make_invitation_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.homeBtn, function()
		arg0_28:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0_0.ShowDesc(arg0_33, arg1_33)
	arg0_33.isShowDesc = true

	pg.UIMgr.GetInstance():BlurPanel(arg0_33.descTr)
	setActive(arg0_33.descTr, true)

	arg0_33.descNode = Object.Instantiate(arg1_33.tr.gameObject, arg0_33.descTr)
	arg0_33.descNode.transform.localPosition = Vector3(0, 100, 0)
	arg0_33.descTxt.text = i18n("feast_invitation_part" .. arg1_33.level)

	onButton(arg0_33, arg0_33.descTr, function()
		arg0_33:HideDesc()
	end, SFX_PANEL)
end

function var0_0.HideDesc(arg0_35)
	if not arg0_35.isShowDesc then
		return
	end

	arg0_35.isShowDesc = false

	pg.UIMgr.GetInstance():UnblurPanel(arg0_35.descTr, arg0_35._tf)

	if arg0_35.descNode then
		Object.Destroy(arg0_35.descNode.gameObject)

		arg0_35.descNode = nil
	end

	setActive(arg0_35.descTr, false)
end

function var0_0.Clear(arg0_36)
	arg0_36.envelopesAnim:SetActionCallBack(nil)
	arg0_36:CloseTip()

	for iter0_36, iter1_36 in ipairs(arg0_36.items) do
		arg0_36:ClearEvent(iter1_36.tr)
	end

	arg0_36.items = {}

	if arg0_36.puzzleGo then
		Object.Destroy(arg0_36.puzzleGo)

		arg0_36.puzzleGo = nil
	end

	removeOnButton(arg0_36.back)

	if LeanTween.isTweening(arg0_36.sendBtn.gameObject) then
		LeanTween.cancel(arg0_36.sendBtn.gameObject)
	end

	if LeanTween.isTweening(arg0_36.titleTr.gameObject) then
		LeanTween.cancel(arg0_36.titleTr.gameObject)
	end

	arg0_36:HideDesc()
end

function var0_0.ClearEvent(arg0_37, arg1_37)
	local var0_37 = arg1_37:GetComponent(typeof(EventTriggerListener))

	var0_37:AddBeginDragFunc(nil)
	var0_37:AddDragFunc(nil)
	var0_37:AddDragEndFunc(nil)
	var0_37:AddPointUpFunc(nil)

	local var1_37 = arg1_37:GetComponentsInChildren(typeof(Image))

	for iter0_37 = 1, var1_37.Length do
		var1_37[iter0_37 - 1].raycastTarget = false
	end
end

function var0_0.Hide(arg0_38)
	Input.multiTouchEnabled = true

	var0_0.super.Hide(arg0_38)
	arg0_38:Clear()
end

function var0_0.OnDestroy(arg0_39)
	arg0_39.exited = true

	arg0_39:Clear()

	if arg0_39:isShowing() then
		arg0_39:Hide()
	end
end

return var0_0
