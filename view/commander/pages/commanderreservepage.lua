local var0 = class("CommanderReservePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderReserveUI"
end

function var0.OnInit(arg0)
	arg0.bg1 = arg0._tf:Find("frame/bg1")

	setActive(arg0.bg1, true)

	arg0.minusBtn = arg0.bg1:Find("count/min")
	arg0.addBtn = arg0.bg1:Find("count/add")
	arg0.countTxt = arg0.bg1:Find("count/Text"):GetComponent(typeof(Text))
	arg0.consumeTxt = arg0.bg1:Find("price/Text"):GetComponent(typeof(Text))
	arg0.totalTxt = arg0.bg1:Find("price_all/Text"):GetComponent(typeof(Text))
	arg0.firstTip = arg0.bg1:Find("firstTip")
	arg0.confirmBtn = arg0.bg1:Find("Button")
	arg0.maxBtn = arg0.bg1:Find("max")
	arg0.bg2 = arg0._tf:Find("frame/bg2")
	arg0.box1 = arg0.bg2:Find("boxes/1"):GetComponent(typeof(Image))
	arg0.box2 = arg0.bg2:Find("boxes/2"):GetComponent(typeof(Image))
	arg0.box3 = arg0.bg2:Find("boxes/3"):GetComponent(typeof(Image))
	arg0.box4 = arg0.bg2:Find("boxes/4"):GetComponent(typeof(Image))
	arg0.skipBtn = arg0.bg2:Find("Button")
	arg0.animtion = arg0.bg2:GetComponent(typeof(Animation))
	arg0.aniEvt = arg0.bg2:GetComponent(typeof(DftAniEvent))
	arg0.boxes = arg0.bg2:Find("boxes")
	arg0.closeBg = arg0._tf:Find("bg")
	arg0.boxTF = arg0.bg2:Find("box")
	arg0.boxMove = arg0.bg2:Find("boxMove")
	arg0.tweenList = {}

	setActive(arg0.bg2, false)

	arg0.skip = false
	arg0.block = false

	onButton(arg0, arg0.closeBg, function()
		if arg0.block then
			return
		end

		arg0:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0.minusBtn, 0.5, function(arg0)
		if arg0.currCnt == 1 then
			arg0()

			return
		end

		arg0.currCnt = arg0.currCnt - 1

		arg0:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0.addBtn, 0.5, function(arg0)
		if arg0.currCnt > CommanderConst.MAX_GETBOX_CNT - arg0.count - 1 then
			arg0()

			return
		end

		arg0.currCnt = arg0.currCnt + 1

		arg0:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0.skipBtn, function()
		arg0.skip = true

		arg0.animtion:Stop()
		arg0:endAnim()
	end, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		local var0 = CommanderConst.MAX_GETBOX_CNT - arg0.count
		local var1 = getProxy(PlayerProxy):getRawData():getResById(1)
		local var2 = 0
		local var3 = 0
		local var4 = arg0.count + var0

		for iter0 = arg0.count, var4 - 1 do
			var3 = var3 + CommanderConst.getBoxComsume(iter0)

			if var1 < var3 then
				break
			else
				var2 = var2 + 1
			end
		end

		arg0.currCnt = math.max(1, var2)

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.currCnt > 0 then
			arg0.skip = false

			arg0:OnConfirm(arg0.total, arg0.currCnt)
		end
	end, SFX_PANEL)
	setText(arg0._tf:Find("frame/bg1/tip"), i18n("commander_build_rate_tip"))
	setText(arg0._tf:Find("frame/bg1/label"), i18n("commander_get_box_tip"))
	setText(arg0._tf:Find("frame/bg1/label1"), i18n("commander_total_gold"))
	setText(arg0._tf:Find("frame/bg1/Text"), i18n("commander_get_box_tip_1"))
end

function var0.OnConfirm(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData()

	if arg1 > var0.gold then
		arg0:GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
			{
				59001,
				arg1 - var0.gold,
				arg1
			}
		})

		return
	end

	local var1 = arg1 <= 0 and "commander_get_1" or "commander_get"

	arg0.contextData.msgBox:ExecuteAction("Show", {
		content = i18n(var1, arg1, arg2),
		onYes = function()
			arg0:emit(CommanderCatMediator.RESERVE_BOX, arg2)
		end
	})
end

function var0.GoShoppingMsgBox(arg0, arg1, arg2, arg3)
	if arg3 then
		local var0 = ""

		for iter0, iter1 in ipairs(arg3) do
			local var1 = Item.getConfigData(iter1[1]).name

			var0 = var0 .. i18n(iter1[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1, iter1[2])

			if iter0 < #arg3 then
				var0 = var0 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0 ~= "" then
			arg1 = arg1 .. "\n" .. i18n("text_noRes_tip", var0)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		parent = rtf(pg.UIMgr.GetInstance().OverlayToast),
		content = arg1,
		weight = LayerWeightConst.TOP_LAYER,
		onYes = function()
			gotoChargeScene(arg2, arg3)
		end
	})
end

function var0.OnLoaded(arg0)
	arg0:bind(CommanderCatScene.MSG_RESERVE_BOX, function(arg0, arg1)
		arg0:OnReserveDone(arg1)
	end)
end

function var0.OnReserveDone(arg0, arg1)
	arg0.block = true

	seriesAsync({
		function(arg0)
			arg0:PlayAnim(arg1, arg0)
		end,
		function(arg0)
			arg0:Update()
			arg0:emit(BaseUI.ON_AWARD, {
				items = arg1
			})
			arg0()
		end
	}, function()
		arg0.block = false
	end)
end

function var0.updateValue(arg0)
	arg0.countTxt.text = arg0.currCnt

	local var0 = arg0.count + arg0.currCnt - 1
	local var1 = CommanderConst.getBoxComsume(var0)

	arg0.consumeTxt.text = var1
	arg0.total = 0

	for iter0 = arg0.count, var0 do
		arg0.total = arg0.total + CommanderConst.getBoxComsume(iter0)
	end

	local var2 = getProxy(PlayerProxy):getRawData()

	arg0.totalTxt.text = var2.gold < arg0.total and "<color=" .. COLOR_RED .. ">" .. arg0.total .. "</color>" or arg0.total
end

function var0.Update(arg0)
	arg0.count = getProxy(CommanderProxy):getBoxUseCnt()
	arg0.currCnt = 1
	arg0.total = 0

	arg0:updateValue()
	setActive(arg0.firstTip, arg0.count <= 0)
	arg0:Show()
end

function var0.endAnim(arg0)
	setActive(arg0.bg1, true)
	setActive(arg0.bg2, false)

	for iter0 = 0, arg0.boxMove.childCount - 1 do
		local var0 = arg0.boxMove:GetChild(iter0)

		Destroy(var0)
	end

	for iter1, iter2 in ipairs(arg0.tweenList) do
		if iter2 then
			LeanTween.cancel(iter2)
		end
	end

	arg0.tweenList = {}
	arg0.skip = false

	if arg0.callback then
		arg0.callback()

		arg0.callback = nil
	end
end

function var0.PlayAnim(arg0, arg1, arg2)
	assert(arg2)

	arg0.callback = arg2

	setActive(arg0.bg1, false)
	setActive(arg0.bg2, true)
	setActive(arg0.boxes, true)

	if arg0.skip then
		arg0:endAnim()
	else
		arg0.animtion:Play("reserve")

		local var0 = 0
		local var1 = 0

		arg0.aniEvt:SetTriggerEvent(function(arg0)
			for iter0, iter1 in ipairs(arg1) do
				var0 = var0 + iter0
			end

			for iter2, iter3 in ipairs(arg1) do
				for iter4 = 1, iter3.count do
					local var0 = LeanTween.delayedCall(0.2 + 1 * var1 + 1 * (iter4 - 1), System.Action(function()
						arg0:playBoxMove(iter3)
					end)).uniqueId

					table.insert(arg0.tweenList, var0)
				end

				var1 = var1 + iter3.count
			end

			table.insert(arg0.tweenList, LeanTween.delayedCall(0.2 + 1 * (var1 - 1), System.Action(function()
				setActive(arg0.boxes, false)
			end)).uniqueId)
			table.insert(arg0.tweenList, LeanTween.delayedCall(0.2 + 1 * (var1 - 1) + 2, System.Action(function()
				arg0:endAnim()
			end)).uniqueId)
		end)
	end
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	setActive(arg0.bg1, true)
	setActive(arg0.bg2, false)

	arg0.skip = false

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.playBoxMove(arg0, arg1)
	local var0 = cloneTplTo(arg0.boxTF, arg0.boxMove)

	if arg1.id == 20011 then
		var0:GetComponent(typeof(Image)).sprite = arg0.box1.sprite
	elseif arg1.id == 20012 then
		var0:GetComponent(typeof(Image)).sprite = arg0.box2.sprite
	elseif arg1.id == 20013 then
		var0:GetComponent(typeof(Image)).sprite = arg0.box3.sprite
	end

	var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		Destroy(go(var0))
	end)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
