local var0 = class("CatterySettlementPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CatterySettlementPage"
end

function var0.OnLoaded(arg0)
	arg0.painting = arg0:findTF("painting")
	arg0.uilist = UIItemList.New(arg0:findTF("frame/commanders"), arg0:findTF("frame/commanders/tpl"))

	setText(arg0:findTF("dialogue/label/Text1"), i18n("cattery_settlement_dialogue_1"))
	setText(arg0:findTF("dialogue/label/Text3"), i18n("cattery_settlement_dialogue_2"))
	setText(arg0:findTF("dialogue/label1/Text1"), i18n("cattery_settlement_dialogue_3"))
	setText(arg0:findTF("dialogue/label1/Text3"), i18n("cattery_settlement_dialogue_4"))

	arg0.timeTxt = arg0:findTF("dialogue/label/Text2"):GetComponent(typeof(Text))
	arg0.expTxt = arg0:findTF("dialogue/label1/Text2"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("comfirm")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Destroy()
	end, SFX_PANEL)

	arg0.cards = {}

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.displays[arg1 + 1]

			arg0:UpdateCommander(arg2, var0)
		end
	end)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.home = arg1

	arg0:SetPainting()
	arg0:UpdateCommanders()
	arg0:UpdateDialogue()

	arg0.UIMgr = pg.UIMgr.GetInstance()

	arg0.UIMgr:BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0.UIMgr:UnblurPanel(arg0._tf, arg0.UIMgr._normalUIMain)
end

function var0.GetCurrentFlagship(arg0)
	return Ship.New({
		id = 999,
		configId = 312011
	})
end

function var0.SetPainting(arg0)
	arg0:ReturnPainting()

	local var0 = arg0:GetCurrentFlagship():getPainting()

	arg0.paintingName = var0

	setPaintingPrefabAsync(arg0.painting, var0, "jiesuan")
end

function var0.UpdateCommanders(arg0)
	local var0 = arg0.home:GetCatteries()

	arg0.displays = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(arg0.displays, iter1)
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return arg0:GetCommanderId() > arg1:GetCommanderId()
	end)
	arg0.uilist:align(#arg0.displays)
end

function var0.UpdateCommander(arg0, arg1, arg2)
	local var0 = arg0.cards[arg1]

	if not var0 then
		var0 = CatterySettlementCard.New(arg1)
		arg0.cards[arg1] = var0
	end

	var0:Update(arg2, arg2:GetCacheExp())
	var0:Action(function()
		return
	end)
end

function var0.UpdateDialogue(arg0)
	local var0 = arg0.home:GetCatteries()
	local var1 = 0
	local var2 = 0

	for iter0, iter1 in pairs(var0) do
		var1 = var1 + iter1:GetCacheExp()

		local var3 = iter1:GetCacheExpTime()

		if var2 < var3 then
			var2 = var3
		end
	end

	arg0.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2)
	arg0.expTxt.text = var1
end

function var0.ReturnPainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.painting, arg0.paintingName)

		arg0.paintingName = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:ReturnPainting()

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0:Hide()

	arg0.cards = nil
end

return var0
