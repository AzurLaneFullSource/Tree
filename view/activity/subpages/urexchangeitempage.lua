local var0 = class("UrExchangeItemPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.exchangeBtn = arg0:findTF("AD/exchange")
	arg0.exchangeTip = arg0:findTF("AD/exchange/tip")
	arg0.battleBtn = arg0:findTF("AD/battle")
	arg0.taskBtn = arg0:findTF("AD/task")
	arg0.progress = arg0:findTF("AD/progress/Image")
	arg0.progressTxt = arg0:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0.itemTF = arg0:findTF("AD/item")
	arg0.helpBtn = arg0:findTF("AD/help")
	arg0.moreBtn = arg0:findTF("AD/more")

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ur_exchange_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.moreBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ur_exchange_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.exchangeBtn, function()
		local var0 = getProxy(PlayerProxy):getRawData()
		local var1, var2 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "FragmentShop")

		if not var1 then
			pg.TipsMgr:GetInstance():ShowTips(var2)

			return
		end

		arg0:emit(ActivityMediator.GO_SHOPS_LAYER_STEEET, {
			warp = NewShopsScene.TYPE_FRAGMENT
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.taskBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
end

function var0.OnFirstFlush(arg0)
	local var0 = pg.gameset.urpt_chapter_max.description
	local var1 = var0[1]
	local var2 = var0[2]
	local var3 = getProxy(BagProxy):GetLimitCntById(var1)

	arg0.progressTxt.text = var3 .. "/" .. var2

	setFillAmount(arg0.progress, var3 / var2)
	updateDrop(arg0.itemTF, Drop.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = var1
	}))
	setActive(arg0.exchangeTip, NotifyTipHelper.ShouldShowUrTip())
end

function var0.OnUpdateFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0
