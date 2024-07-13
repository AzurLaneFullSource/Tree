local var0_0 = class("CommanderReservePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderReserveUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg1 = arg0_2._tf:Find("frame/bg1")

	setActive(arg0_2.bg1, true)

	arg0_2.minusBtn = arg0_2.bg1:Find("count/min")
	arg0_2.addBtn = arg0_2.bg1:Find("count/add")
	arg0_2.countTxt = arg0_2.bg1:Find("count/Text"):GetComponent(typeof(Text))
	arg0_2.consumeTxt = arg0_2.bg1:Find("price/Text"):GetComponent(typeof(Text))
	arg0_2.totalTxt = arg0_2.bg1:Find("price_all/Text"):GetComponent(typeof(Text))
	arg0_2.firstTip = arg0_2.bg1:Find("firstTip")
	arg0_2.confirmBtn = arg0_2.bg1:Find("Button")
	arg0_2.maxBtn = arg0_2.bg1:Find("max")
	arg0_2.bg2 = arg0_2._tf:Find("frame/bg2")
	arg0_2.box1 = arg0_2.bg2:Find("boxes/1"):GetComponent(typeof(Image))
	arg0_2.box2 = arg0_2.bg2:Find("boxes/2"):GetComponent(typeof(Image))
	arg0_2.box3 = arg0_2.bg2:Find("boxes/3"):GetComponent(typeof(Image))
	arg0_2.box4 = arg0_2.bg2:Find("boxes/4"):GetComponent(typeof(Image))
	arg0_2.skipBtn = arg0_2.bg2:Find("Button")
	arg0_2.animtion = arg0_2.bg2:GetComponent(typeof(Animation))
	arg0_2.aniEvt = arg0_2.bg2:GetComponent(typeof(DftAniEvent))
	arg0_2.boxes = arg0_2.bg2:Find("boxes")
	arg0_2.closeBg = arg0_2._tf:Find("bg")
	arg0_2.boxTF = arg0_2.bg2:Find("box")
	arg0_2.boxMove = arg0_2.bg2:Find("boxMove")
	arg0_2.tweenList = {}

	setActive(arg0_2.bg2, false)

	arg0_2.skip = false
	arg0_2.block = false

	onButton(arg0_2, arg0_2.closeBg, function()
		if arg0_2.block then
			return
		end

		arg0_2:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0_2.minusBtn, 0.5, function(arg0_4)
		if arg0_2.currCnt == 1 then
			arg0_4()

			return
		end

		arg0_2.currCnt = arg0_2.currCnt - 1

		arg0_2:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_2.addBtn, 0.5, function(arg0_5)
		if arg0_2.currCnt > CommanderConst.MAX_GETBOX_CNT - arg0_2.count - 1 then
			arg0_5()

			return
		end

		arg0_2.currCnt = arg0_2.currCnt + 1

		arg0_2:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_2, arg0_2.skipBtn, function()
		arg0_2.skip = true

		arg0_2.animtion:Stop()
		arg0_2:endAnim()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.maxBtn, function()
		local var0_7 = CommanderConst.MAX_GETBOX_CNT - arg0_2.count
		local var1_7 = getProxy(PlayerProxy):getRawData():getResById(1)
		local var2_7 = 0
		local var3_7 = 0
		local var4_7 = arg0_2.count + var0_7

		for iter0_7 = arg0_2.count, var4_7 - 1 do
			var3_7 = var3_7 + CommanderConst.getBoxComsume(iter0_7)

			if var1_7 < var3_7 then
				break
			else
				var2_7 = var2_7 + 1
			end
		end

		arg0_2.currCnt = math.max(1, var2_7)

		arg0_2:updateValue()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		if arg0_2.currCnt > 0 then
			arg0_2.skip = false

			arg0_2:OnConfirm(arg0_2.total, arg0_2.currCnt)
		end
	end, SFX_PANEL)
	setText(arg0_2._tf:Find("frame/bg1/tip"), i18n("commander_build_rate_tip"))
	setText(arg0_2._tf:Find("frame/bg1/label"), i18n("commander_get_box_tip"))
	setText(arg0_2._tf:Find("frame/bg1/label1"), i18n("commander_total_gold"))
	setText(arg0_2._tf:Find("frame/bg1/Text"), i18n("commander_get_box_tip_1"))
end

function var0_0.OnConfirm(arg0_9, arg1_9, arg2_9)
	local var0_9 = getProxy(PlayerProxy):getRawData()

	if arg1_9 > var0_9.gold then
		arg0_9:GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
			{
				59001,
				arg1_9 - var0_9.gold,
				arg1_9
			}
		})

		return
	end

	local var1_9 = arg1_9 <= 0 and "commander_get_1" or "commander_get"

	arg0_9.contextData.msgBox:ExecuteAction("Show", {
		content = i18n(var1_9, arg1_9, arg2_9),
		onYes = function()
			arg0_9:emit(CommanderCatMediator.RESERVE_BOX, arg2_9)
		end
	})
end

function var0_0.GoShoppingMsgBox(arg0_11, arg1_11, arg2_11, arg3_11)
	if arg3_11 then
		local var0_11 = ""

		for iter0_11, iter1_11 in ipairs(arg3_11) do
			local var1_11 = Item.getConfigData(iter1_11[1]).name

			var0_11 = var0_11 .. i18n(iter1_11[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_11, iter1_11[2])

			if iter0_11 < #arg3_11 then
				var0_11 = var0_11 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_11 ~= "" then
			arg1_11 = arg1_11 .. "\n" .. i18n("text_noRes_tip", var0_11)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		parent = rtf(pg.UIMgr.GetInstance().OverlayToast),
		content = arg1_11,
		weight = LayerWeightConst.TOP_LAYER,
		onYes = function()
			gotoChargeScene(arg2_11, arg3_11)
		end
	})
end

function var0_0.OnLoaded(arg0_13)
	arg0_13:bind(CommanderCatScene.MSG_RESERVE_BOX, function(arg0_14, arg1_14)
		arg0_13:OnReserveDone(arg1_14)
	end)
end

function var0_0.OnReserveDone(arg0_15, arg1_15)
	arg0_15.block = true

	seriesAsync({
		function(arg0_16)
			arg0_15:PlayAnim(arg1_15, arg0_16)
		end,
		function(arg0_17)
			arg0_15:Update()
			arg0_15:emit(BaseUI.ON_AWARD, {
				items = arg1_15
			})
			arg0_17()
		end
	}, function()
		arg0_15.block = false
	end)
end

function var0_0.updateValue(arg0_19)
	arg0_19.countTxt.text = arg0_19.currCnt

	local var0_19 = arg0_19.count + arg0_19.currCnt - 1
	local var1_19 = CommanderConst.getBoxComsume(var0_19)

	arg0_19.consumeTxt.text = var1_19
	arg0_19.total = 0

	for iter0_19 = arg0_19.count, var0_19 do
		arg0_19.total = arg0_19.total + CommanderConst.getBoxComsume(iter0_19)
	end

	local var2_19 = getProxy(PlayerProxy):getRawData()

	arg0_19.totalTxt.text = var2_19.gold < arg0_19.total and "<color=" .. COLOR_RED .. ">" .. arg0_19.total .. "</color>" or arg0_19.total
end

function var0_0.Update(arg0_20)
	arg0_20.count = getProxy(CommanderProxy):getBoxUseCnt()
	arg0_20.currCnt = 1
	arg0_20.total = 0

	arg0_20:updateValue()
	setActive(arg0_20.firstTip, arg0_20.count <= 0)
	arg0_20:Show()
end

function var0_0.endAnim(arg0_21)
	setActive(arg0_21.bg1, true)
	setActive(arg0_21.bg2, false)

	for iter0_21 = 0, arg0_21.boxMove.childCount - 1 do
		local var0_21 = arg0_21.boxMove:GetChild(iter0_21)

		Destroy(var0_21)
	end

	for iter1_21, iter2_21 in ipairs(arg0_21.tweenList) do
		if iter2_21 then
			LeanTween.cancel(iter2_21)
		end
	end

	arg0_21.tweenList = {}
	arg0_21.skip = false

	if arg0_21.callback then
		arg0_21.callback()

		arg0_21.callback = nil
	end
end

function var0_0.PlayAnim(arg0_22, arg1_22, arg2_22)
	assert(arg2_22)

	arg0_22.callback = arg2_22

	setActive(arg0_22.bg1, false)
	setActive(arg0_22.bg2, true)
	setActive(arg0_22.boxes, true)

	if arg0_22.skip then
		arg0_22:endAnim()
	else
		arg0_22.animtion:Play("reserve")

		local var0_22 = 0
		local var1_22 = 0

		arg0_22.aniEvt:SetTriggerEvent(function(arg0_23)
			for iter0_23, iter1_23 in ipairs(arg1_22) do
				var0_22 = var0_22 + iter0_23
			end

			for iter2_23, iter3_23 in ipairs(arg1_22) do
				for iter4_23 = 1, iter3_23.count do
					local var0_23 = LeanTween.delayedCall(0.2 + 1 * var1_22 + 1 * (iter4_23 - 1), System.Action(function()
						arg0_22:playBoxMove(iter3_23)
					end)).uniqueId

					table.insert(arg0_22.tweenList, var0_23)
				end

				var1_22 = var1_22 + iter3_23.count
			end

			table.insert(arg0_22.tweenList, LeanTween.delayedCall(0.2 + 1 * (var1_22 - 1), System.Action(function()
				setActive(arg0_22.boxes, false)
			end)).uniqueId)
			table.insert(arg0_22.tweenList, LeanTween.delayedCall(0.2 + 1 * (var1_22 - 1) + 2, System.Action(function()
				arg0_22:endAnim()
			end)).uniqueId)
		end)
	end
end

function var0_0.Show(arg0_27)
	setActive(arg0_27._tf, true)
	setActive(arg0_27.bg1, true)
	setActive(arg0_27.bg2, false)

	arg0_27.skip = false

	pg.UIMgr.GetInstance():BlurPanel(arg0_27._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_28)
	var0_0.super.Hide(arg0_28)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_28._tf, arg0_28._parentTf)
end

function var0_0.playBoxMove(arg0_29, arg1_29)
	local var0_29 = cloneTplTo(arg0_29.boxTF, arg0_29.boxMove)

	if arg1_29.id == 20011 then
		var0_29:GetComponent(typeof(Image)).sprite = arg0_29.box1.sprite
	elseif arg1_29.id == 20012 then
		var0_29:GetComponent(typeof(Image)).sprite = arg0_29.box2.sprite
	elseif arg1_29.id == 20013 then
		var0_29:GetComponent(typeof(Image)).sprite = arg0_29.box3.sprite
	end

	var0_29:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		Destroy(go(var0_29))
	end)
end

function var0_0.OnDestroy(arg0_31)
	if arg0_31:isShowing() then
		arg0_31:Hide()
	end
end

return var0_0
