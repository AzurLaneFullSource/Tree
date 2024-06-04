local var0 = class("NewYear23SkinShowPage", import("...base.BaseActivityPage"))

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.goBtn = arg0:findTF("BtnGO")
	arg0.skinShopBtn = arg0:findTF("BtnShop")

	onButton(arg0, arg0.skinShopBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NEWYEAR_BACKHILL_2023)
	end, SFX_PANEL)

	arg0.rtBg = arg0._tf:Find("AD")
	arg0.rtFront = arg0.rtBg:Find("front")
end

function var0.OnDataSetting(arg0)
	local var0 = pg.TimeMgr.GetInstance()

	arg0.showList = {}

	for iter0, iter1 in ipairs(arg0.activity:getConfig("config_client").display_link) do
		if iter1[2] == 0 or var0:inTime(pg.shop_template[iter1[2]].time) then
			table.insert(arg0.showList, math.random(#arg0.showList + 1), iter1[1])
		end
	end
end

function var0.OnFirstFlush(arg0)
	arg0:ActionInvoke("ShowOrHide", false)

	arg0.index = 1

	GetSpriteFromAtlasAsync("clutter/newyear23skinshowpage_" .. arg0.showList[arg0.index], "", function(arg0)
		if arg0._state == var0.STATES.DESTROY then
			return
		end

		setImageSprite(arg0.rtBg, arg0)
		setImageAlpha(arg0.rtFront, 0)
		arg0:ActionInvoke("ShowOrHide", true)
		arg0:DelayCall()
	end)
end

function var0.DelayCall(arg0)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0.uniqueId = LeanTween.delayedCall(3, System.Action(arg0)).uniqueId
	end)
	table.insert(var0, function(arg0)
		arg0.index = arg0.index % #arg0.showList + 1

		GetSpriteFromAtlasAsync("clutter/newyear23skinshowpage_" .. arg0.showList[arg0.index], "", function(arg0)
			if arg0._state == var0.STATES.DESTROY then
				return
			end

			arg0.nextSprite = arg0

			arg0()
		end)
	end)
	parallelAsync(var0, function()
		setImageSprite(arg0.rtFront, getImageSprite(arg0.rtBg))
		setImageAlpha(arg0.rtFront, 1)
		setImageSprite(arg0.rtBg, arg0.nextSprite)

		arg0.uniqueId = LeanTween.alpha(arg0.rtFront, 0, 0.5):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
			arg0:DelayCall()
		end)).uniqueId
	end)
end

function var0.OnDestroy(arg0)
	if arg0.uniqueId then
		LeanTween.cancel(arg0.uniqueId)
	end
end

return var0
