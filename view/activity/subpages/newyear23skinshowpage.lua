local var0_0 = class("NewYear23SkinShowPage", import("...base.BaseActivityPage"))

function var0_0.OnLoaded(arg0_1)
	return
end

function var0_0.OnInit(arg0_2)
	arg0_2.goBtn = arg0_2:findTF("BtnGO")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")

	onButton(arg0_2, arg0_2.skinShopBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.goBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NEWYEAR_BACKHILL_2023)
	end, SFX_PANEL)

	arg0_2.rtBg = arg0_2._tf:Find("AD")
	arg0_2.rtFront = arg0_2.rtBg:Find("front")
end

function var0_0.OnDataSetting(arg0_5)
	local var0_5 = pg.TimeMgr.GetInstance()

	arg0_5.showList = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.activity:getConfig("config_client").display_link) do
		if iter1_5[2] == 0 or var0_5:inTime(pg.shop_template[iter1_5[2]].time) then
			table.insert(arg0_5.showList, math.random(#arg0_5.showList + 1), iter1_5[1])
		end
	end
end

function var0_0.OnFirstFlush(arg0_6)
	arg0_6:ActionInvoke("ShowOrHide", false)

	arg0_6.index = 1

	GetSpriteFromAtlasAsync("clutter/newyear23skinshowpage_" .. arg0_6.showList[arg0_6.index], "", function(arg0_7)
		if arg0_6._state == var0_0.STATES.DESTROY then
			return
		end

		setImageSprite(arg0_6.rtBg, arg0_7)
		setImageAlpha(arg0_6.rtFront, 0)
		arg0_6:ActionInvoke("ShowOrHide", true)
		arg0_6:DelayCall()
	end)
end

function var0_0.DelayCall(arg0_8)
	local var0_8 = {}

	table.insert(var0_8, function(arg0_9)
		arg0_8.uniqueId = LeanTween.delayedCall(3, System.Action(arg0_9)).uniqueId
	end)
	table.insert(var0_8, function(arg0_10)
		arg0_8.index = arg0_8.index % #arg0_8.showList + 1

		GetSpriteFromAtlasAsync("clutter/newyear23skinshowpage_" .. arg0_8.showList[arg0_8.index], "", function(arg0_11)
			if arg0_8._state == var0_0.STATES.DESTROY then
				return
			end

			arg0_8.nextSprite = arg0_11

			arg0_10()
		end)
	end)
	parallelAsync(var0_8, function()
		setImageSprite(arg0_8.rtFront, getImageSprite(arg0_8.rtBg))
		setImageAlpha(arg0_8.rtFront, 1)
		setImageSprite(arg0_8.rtBg, arg0_8.nextSprite)

		arg0_8.uniqueId = LeanTween.alpha(arg0_8.rtFront, 0, 0.5):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
			arg0_8:DelayCall()
		end)).uniqueId
	end)
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.uniqueId then
		LeanTween.cancel(arg0_14.uniqueId)
	end
end

return var0_0
