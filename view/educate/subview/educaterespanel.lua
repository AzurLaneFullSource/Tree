local var0 = class("EducateResPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateResPanel"
end

function var0.OnInit(arg0)
	arg0.moneyBtn = findTF(arg0._go, "res/money")
	arg0.moneyValue = findTF(arg0._go, "res/money/value"):GetComponent(typeof(Text))
	arg0.moodBtn = findTF(arg0._go, "res/mood")
	arg0.moodValue = findTF(arg0._go, "res/mood/value"):GetComponent(typeof(Text))
	arg0.moodMaxValue = pg.child_resource[EducateChar.RES_MOOD_ID].max_value
	arg0.siteBtn = findTF(arg0._go, "res/site")
	arg0.siteValue = findTF(arg0._go, "res/site/value"):GetComponent(typeof(Text))
	arg0.siteMaxValue = pg.child_resource[EducateChar.RES_SITE_ID].max_value

	local var0 = findTF(arg0._go, "res"):GetComponent(typeof(Image))

	if arg0.contextData and arg0.contextData.showBg then
		var0.enabled = true

		pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
			pbList = {
				findTF(arg0._go, "res")
			},
			groupName = LayerWeightConst.GROUP_EDUCATE
		})
	else
		var0.enabled = false
	end

	arg0:addListener()
	arg0:Flush()
end

function var0.addListener(arg0)
	onButton(arg0, arg0.moneyBtn, function()
		arg0:ShowResBox(EducateChar.RES_MONEY_ID)
	end, SFX_PANEL)
	onButton(arg0, arg0.moodBtn, function()
		arg0:ShowResBox(EducateChar.RES_MOOD_ID)
	end, SFX_PANEL)
	onButton(arg0, arg0.siteBtn, function()
		arg0:ShowResBox(EducateChar.RES_SITE_ID)
	end, SFX_PANEL)
end

function var0.ShowResBox(arg0, arg1)
	arg0:emit(EducateBaseUI.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_RES,
			id = arg1
		}
	})
end

function var0.Flush(arg0)
	if not arg0:GetLoaded() then
		return
	end

	arg0.char = getProxy(EducateProxy):GetCharData()
	arg0.siteMaxValue = arg0.char:GetSiteCnt()
	arg0.moneyValue.text = arg0.char.money
	arg0.moodValue.text = arg0.char.mood .. "/" .. arg0.moodMaxValue
	arg0.siteValue.text = arg0.char.site .. "/" .. arg0.siteMaxValue
end

function var0.FlushAddValue(arg0, arg1, arg2)
	if not arg0:GetLoaded() then
		return
	end

	arg0.moodValue.text = arg0.char.mood .. arg1
	arg0.moneyValue.text = arg0.char.money .. arg2
end

function var0.OnDestroy(arg0)
	if arg0.contextData and arg0.contextData.showBg then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	end
end

return var0
