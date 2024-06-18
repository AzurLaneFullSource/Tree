local var0_0 = class("EducateResPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateResPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.moneyBtn = findTF(arg0_2._go, "res/money")
	arg0_2.moneyValue = findTF(arg0_2._go, "res/money/value"):GetComponent(typeof(Text))
	arg0_2.moodBtn = findTF(arg0_2._go, "res/mood")
	arg0_2.moodValue = findTF(arg0_2._go, "res/mood/value"):GetComponent(typeof(Text))
	arg0_2.moodMaxValue = pg.child_resource[EducateChar.RES_MOOD_ID].max_value
	arg0_2.siteBtn = findTF(arg0_2._go, "res/site")
	arg0_2.siteValue = findTF(arg0_2._go, "res/site/value"):GetComponent(typeof(Text))
	arg0_2.siteMaxValue = pg.child_resource[EducateChar.RES_SITE_ID].max_value

	local var0_2 = findTF(arg0_2._go, "res"):GetComponent(typeof(Image))

	if arg0_2.contextData and arg0_2.contextData.showBg then
		var0_2.enabled = true

		pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2._tf, {
			pbList = {
				findTF(arg0_2._go, "res")
			},
			groupName = LayerWeightConst.GROUP_EDUCATE
		})
	else
		var0_2.enabled = false
	end

	arg0_2:addListener()
	arg0_2:Flush()
end

function var0_0.addListener(arg0_3)
	onButton(arg0_3, arg0_3.moneyBtn, function()
		arg0_3:ShowResBox(EducateChar.RES_MONEY_ID)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.moodBtn, function()
		arg0_3:ShowResBox(EducateChar.RES_MOOD_ID)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.siteBtn, function()
		arg0_3:ShowResBox(EducateChar.RES_SITE_ID)
	end, SFX_PANEL)
end

function var0_0.ShowResBox(arg0_7, arg1_7)
	arg0_7:emit(EducateBaseUI.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_RES,
			id = arg1_7
		}
	})
end

function var0_0.Flush(arg0_8)
	if not arg0_8:GetLoaded() then
		return
	end

	arg0_8.char = getProxy(EducateProxy):GetCharData()
	arg0_8.siteMaxValue = arg0_8.char:GetSiteCnt()
	arg0_8.moneyValue.text = arg0_8.char.money
	arg0_8.moodValue.text = arg0_8.char.mood .. "/" .. arg0_8.moodMaxValue
	arg0_8.siteValue.text = arg0_8.char.site .. "/" .. arg0_8.siteMaxValue
end

function var0_0.FlushAddValue(arg0_9, arg1_9, arg2_9)
	if not arg0_9:GetLoaded() then
		return
	end

	arg0_9.moodValue.text = arg0_9.char.mood .. arg1_9
	arg0_9.moneyValue.text = arg0_9.char.money .. arg2_9
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10.contextData and arg0_10.contextData.showBg then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf)
	end
end

return var0_0
