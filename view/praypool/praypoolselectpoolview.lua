local var0_0 = class("PrayPoolSelectPoolView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PrayPoolSelectPoolView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.prayProxy = getProxy(PrayProxy)
	arg0_5.poolToggleList = {}
	arg0_5.selectedPoolType = nil
end

function var0_0.initUI(arg0_6)
	arg0_6.poolListContainer = arg0_6:findTF("PoolList")
	arg0_6.poolTpl = arg0_6:findTF("PoolTpl")
	arg0_6.preBtn = arg0_6:findTF("PreBtn")
	arg0_6.nextBtn = arg0_6:findTF("NextBtn")
	arg0_6.nextBtnCom = GetComponent(arg0_6.nextBtn, "Button")
	arg0_6.poolList = UIItemList.New(arg0_6.poolListContainer, arg0_6.poolTpl)

	arg0_6.poolList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg1_7 + 1
			local var1_7 = arg0_6:findTF("PoolImg", arg2_7)

			setImageSprite(var1_7, GetSpriteFromAtlas("ui/prayselectpoolpage_atlas", "pool" .. var0_7))
			onToggle(arg0_6, arg2_7, function(arg0_8)
				if arg0_8 then
					arg0_6.nextBtnCom.interactable = true
					arg0_6.selectedPoolType = var0_7

					arg0_6.prayProxy:setSelectedPoolNum(var0_7)
				else
					arg0_6.nextBtnCom.interactable = false
					arg0_6.selectedPoolType = nil

					arg0_6.prayProxy:setSelectedPoolNum(nil)
				end
			end, SFX_PANEL)

			arg0_6.poolToggleList[var0_7] = arg2_7
		end
	end)
	arg0_6.poolList:align(#pg.activity_ship_create.all)

	arg0_6.nextBtnCom.interactable = false

	onButton(arg0_6, arg0_6.preBtn, function()
		arg0_6.prayProxy:updatePageState(PrayProxy.STATE_HOME)
		arg0_6:emit(PrayPoolConst.SWITCH_TO_HOME_PAGE, PrayProxy.STATE_HOME)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.nextBtn, function()
		arg0_6.prayProxy:updateSelectedPool(arg0_6.selectedPoolType)
		arg0_6.prayProxy:updatePageState(PrayProxy.STAGE_SELECT_SHIP)
		arg0_6:emit(PrayPoolConst.SWITCH_TO_SELECT_SHIP_PAGE, PrayProxy.STAGE_SELECT_SHIP)
	end, SFX_PANEL)
	arg0_6:Show()
end

function var0_0.updateUI(arg0_11)
	local var0_11 = arg0_11.prayProxy:getSelectedPoolType()

	if var0_11 then
		triggerToggle(arg0_11.poolToggleList[var0_11], true)
	else
		return
	end
end

return var0_0
