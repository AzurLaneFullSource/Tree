local var0 = class("SofmapPTPage", import(".TemplatePage.PtTemplatePage"))

var0.FADE_TIME = 0.5
var0.SHOW_TIME = 1
var0.FADE_OUT_TIME = 0.5
var0.SpineActionByStep = {
	4,
	8,
	12,
	16,
	20
}

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.shop = arg0:findTF("shop", arg0.bg)
	arg0.shopAnim = GetComponent(arg0.shop, "SpineAnimUI")
	arg0.sdContainer = arg0:findTF("sdcontainer", arg0.bg)
	arg0.spine = nil
	arg0.spineLRQ = GetSpineRequestPackage.New("mingshi_5", function(arg0)
		SetParent(arg0, arg0.sdContainer)

		arg0.spine = arg0
		arg0.spine.transform.localScale = Vector3.one

		local var0 = arg0.spine:GetComponent("SpineAnimUI")

		if var0 then
			var0:SetAction("stand", 0)
		end

		arg0.spineLRQ = nil
	end):Start()

	onButton(arg0, arg0:findTF("sdBtn", arg0.bg), function()
		arg0:showBubble()
	end, SFX_PANEL)

	arg0.levelBtn = arg0:findTF("level_btn", arg0.bg)
	arg0.ptBtn = arg0:findTF("pt_btn", arg0.bg)
	arg0.bubble = arg0:findTF("bubble", arg0.bg)
	arg0.bubbleText = arg0:findTF("Text", arg0.bubble)
	arg0.bubbleCG = GetComponent(arg0.bubble, "CanvasGroup")
	arg0.showBubbleTag = false

	onButton(arg0, arg0.getBtn, function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1,
			callback = function()
				arg0:showBubble(i18n("sofmapsd_3"))
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.levelBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.sofmap_attention.tip
		})
	end, SFX_PANEL)

	local var0 = {
		count = 0,
		type = DROP_TYPE_RESOURCE,
		id = arg0.ptData.resId
	}

	onButton(arg0, arg0.ptBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = var0
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#68E9F4FF") or var0) .. "/" .. var1)

	local var3, var4, var5 = arg0.ptData:GetLevelProgress()

	if var3 <= var0.SpineActionByStep[1] then
		arg0.shopAnim:SetAction("stand2", 0)
	elseif var3 <= var0.SpineActionByStep[2] then
		arg0.shopAnim:SetAction("stand1", 0)
	elseif var3 <= var0.SpineActionByStep[3] then
		arg0.shopAnim:SetAction("stand1x2", 0)
	elseif var3 <= var0.SpineActionByStep[4] then
		arg0.shopAnim:SetAction("stand1x4", 0)
	elseif var3 <= var0.SpineActionByStep[5] then
		arg0.shopAnim:SetAction("stand1x8", 0)
	end

	if not arg0.showBubbleTag then
		arg0:showBubble()

		arg0.showBubbleTag = true
	end
end

function var0.OnDestroy(arg0)
	if arg0.spineLRQ then
		arg0.spineLRQ:Stop()

		arg0.spineLRQ = nil
	end

	if arg0.spine then
		arg0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("mingshi_5", arg0.spine)

		arg0.spine = nil
	end
end

function var0.showBubble(arg0, arg1)
	local var0

	if not arg1 then
		if isActive(arg0.battleBtn) then
			var0 = i18n("sofmapsd_1")
		elseif isActive(arg0.getBtn) then
			var0 = i18n("sofmapsd_2")
		elseif isActive(arg0.gotBtn) then
			var0 = i18n("sofmapsd_4")
		end
	else
		var0 = arg1
	end

	setText(arg0.bubbleText, var0)

	local function var1(arg0)
		arg0.bubbleCG.alpha = arg0

		setLocalScale(arg0.bubble, Vector3.one * arg0)
	end

	local function var2()
		LeanTween.value(go(arg0.bubble), 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
			setActive(arg0.bubble, false)
		end))
	end

	LeanTween.cancel(go(arg0.bubble))
	setActive(arg0.bubble, true)
	LeanTween.value(go(arg0.bubble), 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(go(arg0.bubble), var0.SHOW_TIME, System.Action(var2))
	end))
end

return var0
