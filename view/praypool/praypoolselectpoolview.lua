local var0_0 = class("PrayPoolSelectPoolView", import("..base.BaseSubView"))

function var0_0.getResource(arg0_1)
	local var0_1 = {
		"ui/prayselectpoolpage_atlas"
	}

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "PrayPoolSelectPoolView"
end

function var0_0.OnInit(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:updateUI()
end

function var0_0.OnDestroy(arg0_4)
	return
end

function var0_0.OnBackPress(arg0_5)
	return
end

function var0_0.initData(arg0_6)
	arg0_6.prayProxy = getProxy(PrayProxy)
	arg0_6.poolToggleList = {}
	arg0_6.selectedPoolType = nil
end

function var0_0.initUI(arg0_7)
	arg0_7.poolListContainer = arg0_7._tf:Find("PoolList")
	arg0_7.poolTpl = arg0_7._tf:Find("PoolTpl")
	arg0_7.preBtn = arg0_7._tf:Find("PreBtn")
	arg0_7.nextBtn = arg0_7._tf:Find("NextBtn")
	arg0_7.nextBtnCom = GetComponent(arg0_7.nextBtn, "Button")
	arg0_7.poolList = UIItemList.New(arg0_7.poolListContainer, arg0_7.poolTpl)

	arg0_7.poolList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg1_8 + 1
			local var1_8 = arg2_8:Find("PoolImg")

			setImageSprite(var1_8, GetSpriteFromAtlas("ui/prayselectpoolpage_atlas", "pool" .. var0_8))
			onToggle(arg0_7, arg2_8, function(arg0_9)
				if arg0_9 then
					arg0_7.nextBtnCom.interactable = true
					arg0_7.selectedPoolType = var0_8

					arg0_7.prayProxy:setSelectedPoolNum(var0_8)
				else
					arg0_7.nextBtnCom.interactable = false
					arg0_7.selectedPoolType = nil

					arg0_7.prayProxy:setSelectedPoolNum(nil)
				end
			end, SFX_PANEL)

			arg0_7.poolToggleList[var0_8] = arg2_8
		end
	end)
	arg0_7.poolList:align(#pg.activity_ship_create.all)

	arg0_7.nextBtnCom.interactable = false

	onButton(arg0_7, arg0_7.preBtn, function()
		arg0_7.prayProxy:updatePageState(PrayProxy.STATE_HOME)
		arg0_7:emit(PrayPoolConst.SWITCH_TO_HOME_PAGE, PrayProxy.STATE_HOME)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.nextBtn, function()
		arg0_7.prayProxy:updateSelectedPool(arg0_7.selectedPoolType)
		arg0_7.prayProxy:updatePageState(PrayProxy.STAGE_SELECT_SHIP)
		arg0_7:emit(PrayPoolConst.SWITCH_TO_SELECT_SHIP_PAGE, PrayProxy.STAGE_SELECT_SHIP)
	end, SFX_PANEL)
	arg0_7:Show()
end

function var0_0.updateUI(arg0_12)
	local var0_12 = arg0_12.prayProxy:getSelectedPoolType()

	if var0_12 then
		triggerToggle(arg0_12.poolToggleList[var0_12], true)
	else
		return
	end
end

return var0_0
