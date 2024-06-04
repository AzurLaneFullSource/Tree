local var0 = class("FeastMakeTicketPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "FeastPuzzlePage"
end

function var0.OnLoaded(arg0)
	arg0.back = arg0:findTF("back")
	arg0.finishTr = arg0:findTF("finish")
	arg0.envelopesAnim = arg0.finishTr:Find("envelopes"):GetComponent(typeof(SpineAnimUI))
	arg0.sendBtn = arg0.finishTr:Find("send")
	arg0.titleTr = arg0.finishTr:Find("label1")
	arg0.failedTip = arg0:findTF("failed_tip")
	arg0.descTr = arg0:findTF("desc_panel")
	arg0.descTxt = arg0.descTr:Find("frame/Text"):GetComponent(typeof(Text))
	arg0.homeBtn = arg0:findTF("home")
	arg0.helpBtn = arg0:findTF("help")
	arg0.tipTopTr = arg0:findTF("tip")

	setText(arg0:findTF("tip/Text"), i18n("feast_label_make_ticket_tip"))
	setText(arg0:findTF("tip/label"), i18n("feast_label_make_ticket_click_tip"))
	setText(arg0:findTF("failed_tip/Text"), i18n("feast_label_make_ticket_failed_tip"))
end

function var0.OnInit(arg0)
	arg0:bind(FeastScene.ON_MAKE_TICKET, function(arg0, arg1)
		arg0:OnMakeTicket(arg1)
	end)
end

function var0.OnMakeTicket(arg0, arg1)
	if arg0.feastShip and arg0.feastShip.id == arg1 then
		setActive(arg0.finishTr, true)
		setActive(arg0.tipTopTr, false)

		arg0.sendBtn.localScale = Vector3.zero
		arg0.titleTr.localScale = Vector3.zero

		arg0.envelopesAnim:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				LeanTween.scale(arg0.sendBtn, Vector3(1, 1, 1), 0.3)
				LeanTween.scale(arg0.titleTr, Vector3(1, 1, 1), 0.3)
				arg0.envelopesAnim:SetActionCallBack(nil)
				arg0.envelopesAnim:SetAction("action2", 0)
			end
		end)
		arg0.envelopesAnim:SetAction("action1", 0)
	end
end

function var0.Show(arg0, arg1)
	Input.multiTouchEnabled = false

	var0.super.Show(arg0)
	arg0:CloseTip()
	setActive(arg0.tipTopTr, true)
	setActive(arg0.finishTr, false)

	arg0.feastShip = arg1

	seriesAsync({
		function(arg0)
			arg0:LoadPuzzleRes(arg1:GetPrefab(), arg0)
		end
	}, function()
		arg0:InitPuzzle()
		arg0:RegisterEvent()
	end)
end

function var0.LoadPuzzleRes(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync("FeastPuzzle/" .. arg1, arg1, typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited then
			return
		end

		arg0.puzzleGo = Object.Instantiate(arg0, arg0._tf:Find("container"))
		arg0.rect = arg0.puzzleGo.transform:Find("nodes")
		arg0.items = {}

		eachChild(arg0.rect, function(arg0)
			local var0 = tonumber(arg0.name)
			local var1 = var0 == 1

			table.insert(arg0.items, {
				level = var0,
				tr = arg0,
				isCompletion = var1
			})
		end)
		arg2()
	end), true, true)
end

local function var1(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance().overlayCameraComp
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

function var0.InitPuzzle(arg0, arg1)
	arg0.dragging = false

	for iter0, iter1 in ipairs(arg0.items) do
		local var0 = iter1.tr:GetComponent(typeof(EventTriggerListener))
		local var1 = Vector3.zero

		var0:AddBeginDragFunc(function(arg0, arg1)
			arg0.dragging = true
			var1 = iter1.tr.localPosition

			iter1.tr:SetAsLastSibling()
		end)
		var0:AddDragFunc(function(arg0, arg1)
			local var0 = var1(arg0.rect, arg1.position)

			iter1.tr.localPosition = var0
		end)
		var0:AddDragEndFunc(function(arg0, arg1)
			arg0.dragging = false

			local var0 = arg0:FindMatcher(iter1)

			if var0 then
				arg0:Merge(iter1, var0, var1)

				if arg0:CheckFinish() then
					arg0:OnPass()
				end
			else
				arg0:ShowTip()

				iter1.tr.localPosition = var1
			end
		end)
		var0:AddPointUpFunc(function(arg0, arg1)
			if arg0.dragging then
				return
			end

			arg0:ShowDesc(iter1)
		end)
	end
end

function var0.ShowTip(arg0)
	arg0:CloseTip()
	setActive(arg0.failedTip, true)

	arg0.timer = Timer.New(function()
		arg0:CloseTip()
	end, 2, 1)

	arg0.timer:Start()
end

function var0.CloseTip(arg0)
	if arg0.timer then
		setActive(arg0.failedTip, false)
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.CheckFinish(arg0)
	return arg0.rect.childCount == 1
end

function var0.Merge(arg0, arg1, arg2, arg3)
	if arg2.level < arg1.level then
		arg1.tr.localPosition = arg3

		setParent(arg2.tr, arg1.tr:Find("slot"))

		arg2.tr.localPosition = Vector3.zero

		arg0:ClearEvent(arg2.tr)

		arg1.isCompletion = true
	else
		setParent(arg1.tr, arg2.tr:Find("slot"))

		arg1.tr.localPosition = Vector3.zero

		arg0:ClearEvent(arg1.tr)

		arg2.isCompletion = true
	end
end

local function var2(arg0, arg1)
	local var0 = getBounds(arg0.tr)
	local var1 = getBounds(arg1.tr)

	return var0:Intersects(var1)
end

local function var3(arg0, arg1)
	if arg0.level < arg1.level then
		return arg0.isCompletion
	else
		return arg1.isCompletion
	end
end

function var0.FindMatcher(arg0, arg1)
	for iter0, iter1 in pairs(arg0.items) do
		if (arg1.level + 1 == iter1.level or arg1.level - 1 == iter1.level) and var3(arg1, iter1) and var2(arg1, iter1) then
			return iter1
		end
	end

	return nil
end

function var0.OnPass(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		arg0:ClearEvent(iter1.tr)
	end

	setActive(arg0.rect, false)
	arg0:emit(FeastMediator.MAKE_TICKET, arg0.feastShip.tid)
end

function var0.RegisterEvent(arg0, arg1)
	onButton(arg0, arg0.back, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.sendBtn, function()
		arg0:Hide()
		arg0:emit(FeastScene.ON_SKIP_GIVE_GIFT, arg0.feastShip)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.feast_make_invitation_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0.ShowDesc(arg0, arg1)
	arg0.isShowDesc = true

	pg.UIMgr.GetInstance():BlurPanel(arg0.descTr)
	setActive(arg0.descTr, true)

	arg0.descNode = Object.Instantiate(arg1.tr.gameObject, arg0.descTr)
	arg0.descNode.transform.localPosition = Vector3(0, 100, 0)
	arg0.descTxt.text = i18n("feast_invitation_part" .. arg1.level)

	onButton(arg0, arg0.descTr, function()
		arg0:HideDesc()
	end, SFX_PANEL)
end

function var0.HideDesc(arg0)
	if not arg0.isShowDesc then
		return
	end

	arg0.isShowDesc = false

	pg.UIMgr.GetInstance():UnblurPanel(arg0.descTr, arg0._tf)

	if arg0.descNode then
		Object.Destroy(arg0.descNode.gameObject)

		arg0.descNode = nil
	end

	setActive(arg0.descTr, false)
end

function var0.Clear(arg0)
	arg0.envelopesAnim:SetActionCallBack(nil)
	arg0:CloseTip()

	for iter0, iter1 in ipairs(arg0.items) do
		arg0:ClearEvent(iter1.tr)
	end

	arg0.items = {}

	if arg0.puzzleGo then
		Object.Destroy(arg0.puzzleGo)

		arg0.puzzleGo = nil
	end

	removeOnButton(arg0.back)

	if LeanTween.isTweening(arg0.sendBtn.gameObject) then
		LeanTween.cancel(arg0.sendBtn.gameObject)
	end

	if LeanTween.isTweening(arg0.titleTr.gameObject) then
		LeanTween.cancel(arg0.titleTr.gameObject)
	end

	arg0:HideDesc()
end

function var0.ClearEvent(arg0, arg1)
	local var0 = arg1:GetComponent(typeof(EventTriggerListener))

	var0:AddBeginDragFunc(nil)
	var0:AddDragFunc(nil)
	var0:AddDragEndFunc(nil)
	var0:AddPointUpFunc(nil)

	local var1 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 1, var1.Length do
		var1[iter0 - 1].raycastTarget = false
	end
end

function var0.Hide(arg0)
	Input.multiTouchEnabled = true

	var0.super.Hide(arg0)
	arg0:Clear()
end

function var0.OnDestroy(arg0)
	arg0.exited = true

	arg0:Clear()

	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
