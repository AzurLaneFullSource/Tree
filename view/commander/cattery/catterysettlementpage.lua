local var0_0 = class("CatterySettlementPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CatterySettlementPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.painting = arg0_2:findTF("painting")
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("frame/commanders"), arg0_2:findTF("frame/commanders/tpl"))

	setText(arg0_2:findTF("dialogue/label/Text1"), i18n("cattery_settlement_dialogue_1"))
	setText(arg0_2:findTF("dialogue/label/Text3"), i18n("cattery_settlement_dialogue_2"))
	setText(arg0_2:findTF("dialogue/label1/Text1"), i18n("cattery_settlement_dialogue_3"))
	setText(arg0_2:findTF("dialogue/label1/Text3"), i18n("cattery_settlement_dialogue_4"))

	arg0_2.timeTxt = arg0_2:findTF("dialogue/label/Text2"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("dialogue/label1/Text2"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("comfirm")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Destroy()
	end, SFX_PANEL)

	arg0_3.cards = {}

	arg0_3.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_3.displays[arg1_5 + 1]

			arg0_3:UpdateCommander(arg2_5, var0_5)
		end
	end)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.home = arg1_6

	arg0_6:SetPainting()
	arg0_6:UpdateCommanders()
	arg0_6:UpdateDialogue()

	arg0_6.UIMgr = pg.UIMgr.GetInstance()

	arg0_6.UIMgr:BlurPanel(arg0_6._tf)
end

function var0_0.Hide(arg0_7)
	var0_0.super.Hide(arg0_7)
	arg0_7.UIMgr:UnblurPanel(arg0_7._tf, arg0_7.UIMgr._normalUIMain)
end

function var0_0.GetCurrentFlagship(arg0_8)
	return Ship.New({
		id = 999,
		configId = 312011
	})
end

function var0_0.SetPainting(arg0_9)
	arg0_9:ReturnPainting()

	local var0_9 = arg0_9:GetCurrentFlagship():getPainting()

	arg0_9.paintingName = var0_9

	setPaintingPrefabAsync(arg0_9.painting, var0_9, "jiesuan")
end

function var0_0.UpdateCommanders(arg0_10)
	local var0_10 = arg0_10.home:GetCatteries()

	arg0_10.displays = {}

	for iter0_10, iter1_10 in pairs(var0_10) do
		table.insert(arg0_10.displays, iter1_10)
	end

	table.sort(arg0_10.displays, function(arg0_11, arg1_11)
		return arg0_11:GetCommanderId() > arg1_11:GetCommanderId()
	end)
	arg0_10.uilist:align(#arg0_10.displays)
end

function var0_0.UpdateCommander(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.cards[arg1_12]

	if not var0_12 then
		var0_12 = CatterySettlementCard.New(arg1_12)
		arg0_12.cards[arg1_12] = var0_12
	end

	var0_12:Update(arg2_12, arg2_12:GetCacheExp())
	var0_12:Action(function()
		return
	end)
end

function var0_0.UpdateDialogue(arg0_14)
	local var0_14 = arg0_14.home:GetCatteries()
	local var1_14 = 0
	local var2_14 = 0

	for iter0_14, iter1_14 in pairs(var0_14) do
		var1_14 = var1_14 + iter1_14:GetCacheExp()

		local var3_14 = iter1_14:GetCacheExpTime()

		if var2_14 < var3_14 then
			var2_14 = var3_14
		end
	end

	arg0_14.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2_14)
	arg0_14.expTxt.text = var1_14
end

function var0_0.ReturnPainting(arg0_15)
	if arg0_15.paintingName then
		retPaintingPrefab(arg0_15.painting, arg0_15.paintingName)

		arg0_15.paintingName = nil
	end
end

function var0_0.OnDestroy(arg0_16)
	arg0_16:ReturnPainting()

	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		iter1_16:Dispose()
	end

	arg0_16:Hide()

	arg0_16.cards = nil
end

return var0_0
