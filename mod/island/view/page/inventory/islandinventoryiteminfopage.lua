local var0_0 = class("IslandInventoryItemInfoPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandInventoryItemInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTxt = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.originTxt = arg0_2:findTF("frame/origin"):GetComponent(typeof(Text))
	arg0_2.compositionTxt = arg0_2:findTF("frame/composition"):GetComponent(typeof(Text))
	arg0_2.calcPanel = arg0_2:findTF("frame/calc")
	arg0_2.addBtn = arg0_2:findTF("add", arg0_2.calcPanel)
	arg0_2.reduceBtn = arg0_2:findTF("reduce", arg0_2.calcPanel)
	arg0_2.valueTxt = arg0_2:findTF("value/Text", arg0_2.calcPanel):GetComponent(typeof(Text))
	arg0_2.sellBtn = arg0_2:findTF("sell", arg0_2.calcPanel)
	arg0_2.priceTxt = arg0_2:findTF("Text", arg0_2.sellBtn):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)

	arg0_5.nameTxt.text = arg1_5:GetName()
	arg0_5.descTxt.text = arg1_5:GetDesc()

	setActive(arg0_5.originTxt.gameObject, arg1_5:IsMaterial())

	arg0_5.originTxt.text = i18n1("来源:") .. arg1_5:GetMaterialFacility()

	setActive(arg0_5.compositionTxt.gameObject, arg1_5:IsMaterial())

	arg0_5.compositionTxt.text = i18n1("合成:")

	local var0_5 = arg1_5:CanSell()

	setActive(arg0_5.calcPanel, var0_5)

	arg0_5.count = 0

	if var0_5 then
		arg0_5:InitCalcPanel(arg1_5)
	end
end

function var0_0.InitCalcPanel(arg0_6, arg1_6)
	arg0_6.count = 1
	arg0_6.maxCnt = arg1_6:GetCount()

	pressPersistTrigger(arg0_6.reduceBtn, 0.5, function(arg0_7)
		if arg0_6.count == 1 then
			if arg0_7 then
				arg0_7()
			end

			return
		end

		arg0_6.count = math.max(1, arg0_6.count - 1)

		arg0_6:UpdateValue(arg1_6)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_6.addBtn, 0.5, function(arg0_8)
		if arg0_6.count == arg0_6.maxCnt then
			if arg0_8 then
				arg0_8()
			end

			return
		end

		arg0_6.count = math.min(arg0_6.maxCnt, arg0_6.count + 1)

		arg0_6:UpdateValue(arg1_6)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_6, arg0_6.sellBtn, function()
		local var0_9 = arg1_6:GetSellingPrice()
		local var1_9 = getDropInfo({
			{
				var0_9.type,
				var0_9.id,
				var0_9.count * arg0_6.count
			}
		})

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n1("确认出售" .. arg1_6:GetName() .. "X" .. arg0_6.count .. "\n获得" .. var1_9),
			onYes = function()
				arg0_6:emit(IslandMediator.ON_SELL_ITEM, arg1_6.id, arg0_6.count)
			end
		})
	end, SFX_PANEL)
	arg0_6:UpdateValue(arg1_6)
end

function var0_0.UpdateValue(arg0_11, arg1_11)
	arg0_11.valueTxt.text = arg0_11.count

	local var0_11 = arg1_11:GetSellingPrice()

	arg0_11.priceTxt.text = arg0_11.count * var0_11.count
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
