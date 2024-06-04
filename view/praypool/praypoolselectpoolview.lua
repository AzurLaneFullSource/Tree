local var0 = class("PrayPoolSelectPoolView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "PrayPoolSelectPoolView"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	return
end

function var0.initData(arg0)
	arg0.prayProxy = getProxy(PrayProxy)
	arg0.poolToggleList = {}
	arg0.selectedPoolType = nil
end

function var0.initUI(arg0)
	arg0.poolListContainer = arg0:findTF("PoolList")
	arg0.poolTpl = arg0:findTF("PoolTpl")
	arg0.preBtn = arg0:findTF("PreBtn")
	arg0.nextBtn = arg0:findTF("NextBtn")
	arg0.nextBtnCom = GetComponent(arg0.nextBtn, "Button")
	arg0.poolList = UIItemList.New(arg0.poolListContainer, arg0.poolTpl)

	arg0.poolList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("PoolImg", arg2)

			setImageSprite(var1, GetSpriteFromAtlas("ui/prayselectpoolpage_atlas", "pool" .. var0))
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.nextBtnCom.interactable = true
					arg0.selectedPoolType = var0

					arg0.prayProxy:setSelectedPoolNum(var0)
				else
					arg0.nextBtnCom.interactable = false
					arg0.selectedPoolType = nil

					arg0.prayProxy:setSelectedPoolNum(nil)
				end
			end, SFX_PANEL)

			arg0.poolToggleList[var0] = arg2
		end
	end)
	arg0.poolList:align(#pg.activity_ship_create.all)

	arg0.nextBtnCom.interactable = false

	onButton(arg0, arg0.preBtn, function()
		arg0.prayProxy:updatePageState(PrayProxy.STATE_HOME)
		arg0:emit(PrayPoolConst.SWITCH_TO_HOME_PAGE, PrayProxy.STATE_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		arg0.prayProxy:updateSelectedPool(arg0.selectedPoolType)
		arg0.prayProxy:updatePageState(PrayProxy.STAGE_SELECT_SHIP)
		arg0:emit(PrayPoolConst.SWITCH_TO_SELECT_SHIP_PAGE, PrayProxy.STAGE_SELECT_SHIP)
	end, SFX_PANEL)
	arg0:Show()
end

function var0.updateUI(arg0)
	local var0 = arg0.prayProxy:getSelectedPoolType()

	if var0 then
		triggerToggle(arg0.poolToggleList[var0], true)
	else
		return
	end
end

return var0
