local var0_0 = class("SofmapPTPage", import(".TemplatePage.PtTemplatePage"))

var0_0.FADE_TIME = 0.5
var0_0.SHOW_TIME = 1
var0_0.FADE_OUT_TIME = 0.5
var0_0.SpineActionByStep = {
	4,
	8,
	12,
	16,
	20
}

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	arg0_1.shop = arg0_1:findTF("shop", arg0_1.bg)
	arg0_1.shopAnim = GetComponent(arg0_1.shop, "SpineAnimUI")
	arg0_1.sdContainer = arg0_1:findTF("sdcontainer", arg0_1.bg)
	arg0_1.spine = nil
	arg0_1.spineLRQ = GetSpineRequestPackage.New("mingshi_5", function(arg0_2)
		SetParent(arg0_2, arg0_1.sdContainer)

		arg0_1.spine = arg0_2
		arg0_1.spine.transform.localScale = Vector3.one

		local var0_2 = arg0_1.spine:GetComponent("SpineAnimUI")

		if var0_2 then
			var0_2:SetAction("stand", 0)
		end

		arg0_1.spineLRQ = nil
	end):Start()

	onButton(arg0_1, arg0_1:findTF("sdBtn", arg0_1.bg), function()
		arg0_1:showBubble()
	end, SFX_PANEL)

	arg0_1.levelBtn = arg0_1:findTF("level_btn", arg0_1.bg)
	arg0_1.ptBtn = arg0_1:findTF("pt_btn", arg0_1.bg)
	arg0_1.bubble = arg0_1:findTF("bubble", arg0_1.bg)
	arg0_1.bubbleText = arg0_1:findTF("Text", arg0_1.bubble)
	arg0_1.bubbleCG = GetComponent(arg0_1.bubble, "CanvasGroup")
	arg0_1.showBubbleTag = false

	onButton(arg0_1, arg0_1.getBtn, function()
		local var0_4, var1_4 = arg0_1.ptData:GetResProgress()

		arg0_1:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_1.ptData:GetId(),
			arg1 = var1_4,
			callback = function()
				arg0_1:showBubble(i18n("sofmapsd_3"))
			end
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.levelBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.sofmap_attention.tip
		})
	end, SFX_PANEL)

	local var0_1 = {
		count = 0,
		type = DROP_TYPE_RESOURCE,
		id = arg0_1.ptData.resId
	}

	onButton(arg0_1, arg0_1.ptBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = var0_1
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_8)
	var0_0.super.OnUpdateFlush(arg0_8)

	local var0_8, var1_8, var2_8 = arg0_8.ptData:GetResProgress()

	setText(arg0_8.progress, (var2_8 >= 1 and setColorStr(var0_8, "#68E9F4FF") or var0_8) .. "/" .. var1_8)

	local var3_8, var4_8, var5_8 = arg0_8.ptData:GetLevelProgress()

	if var3_8 <= var0_0.SpineActionByStep[1] then
		arg0_8.shopAnim:SetAction("stand2", 0)
	elseif var3_8 <= var0_0.SpineActionByStep[2] then
		arg0_8.shopAnim:SetAction("stand1", 0)
	elseif var3_8 <= var0_0.SpineActionByStep[3] then
		arg0_8.shopAnim:SetAction("stand1x2", 0)
	elseif var3_8 <= var0_0.SpineActionByStep[4] then
		arg0_8.shopAnim:SetAction("stand1x4", 0)
	elseif var3_8 <= var0_0.SpineActionByStep[5] then
		arg0_8.shopAnim:SetAction("stand1x8", 0)
	end

	if not arg0_8.showBubbleTag then
		arg0_8:showBubble()

		arg0_8.showBubbleTag = true
	end
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9.spineLRQ then
		arg0_9.spineLRQ:Stop()

		arg0_9.spineLRQ = nil
	end

	if arg0_9.spine then
		arg0_9.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("mingshi_5", arg0_9.spine)

		arg0_9.spine = nil
	end
end

function var0_0.showBubble(arg0_10, arg1_10)
	local var0_10

	if not arg1_10 then
		if isActive(arg0_10.battleBtn) then
			var0_10 = i18n("sofmapsd_1")
		elseif isActive(arg0_10.getBtn) then
			var0_10 = i18n("sofmapsd_2")
		elseif isActive(arg0_10.gotBtn) then
			var0_10 = i18n("sofmapsd_4")
		end
	else
		var0_10 = arg1_10
	end

	setText(arg0_10.bubbleText, var0_10)

	local function var1_10(arg0_11)
		arg0_10.bubbleCG.alpha = arg0_11

		setLocalScale(arg0_10.bubble, Vector3.one * arg0_11)
	end

	local function var2_10()
		LeanTween.value(go(arg0_10.bubble), 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1_10)):setOnComplete(System.Action(function()
			setActive(arg0_10.bubble, false)
		end))
	end

	LeanTween.cancel(go(arg0_10.bubble))
	setActive(arg0_10.bubble, true)
	LeanTween.value(go(arg0_10.bubble), 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var1_10)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(go(arg0_10.bubble), var0_0.SHOW_TIME, System.Action(var2_10))
	end))
end

return var0_0
