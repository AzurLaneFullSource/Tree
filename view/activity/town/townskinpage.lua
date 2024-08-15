local var0_0 = class("TownSkinPage", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TownSkinPageUI"
end

function var0_0.init(arg0_2)
	arg0_2.activity = getProxy(ActivityProxy):getActivityById(5535)
	arg0_2.story = arg0_2.activity:getConfig("config_client").story
	arg0_2.storyStateDic = {}

	arg0_2:ShowMask(false)

	arg0_2.isPlaying = false

	arg0_2:InitStoryState()
	arg0_2:UpdateStoryView()
	arg0_2:UpdateItemView(arg0_2.activity)
end

function var0_0.InitStoryState(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.story) do
		if checkExist(arg0_3.story, {
			iter0_3
		}, {
			1
		}) then
			local var0_3 = false
			local var1_3 = iter1_3[1]

			if pg.NewStoryMgr.GetInstance():IsPlayed(var1_3) then
				var0_3 = true
			end

			local var2_3 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_3)

			arg0_3.storyStateDic[var2_3] = var0_3
		end
	end
end

function var0_0.UpdateStoryView(arg0_4)
	local var0_4 = {
		"pittsburgh",
		"indiana",
		"fargo",
		"kersaint",
		"friedrich",
		"painleve"
	}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var1_4 = arg0_4.story[iter0_4][1]
		local var2_4 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_4)
		local var3_4 = arg0_4.storyStateDic[var2_4]
		local var4_4 = arg0_4._tf:Find("frame/bg/" .. iter1_4 .. "/locked")
		local var5_4 = arg0_4._tf:Find("frame/bg/" .. iter1_4 .. "/unlocked")

		setActive(var4_4, not var3_4)
		setActive(var5_4, var3_4)

		if var3_4 then
			onButton(arg0_4, var5_4, function()
				pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var2_4), nil, true)
			end)
		else
			onButton(arg0_4, var4_4, function()
				if getProxy(ActivityProxy):getActivityById(5535).data1 <= 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_0815_town_memory"))

					return
				end

				pg.m02:sendNotification(GAME.ACTIVITY_UNLOCKSTORYT, {
					cmd = 1,
					activity_id = arg0_4.activity.id,
					arg1 = var2_4
				})
			end)
		end
	end
end

function var0_0.UpdateItemView(arg0_7, arg1_7)
	setText(arg0_7._tf:Find("frame/des/count"), tostring(arg1_7.data1))
end

function var0_0.UpdataStoryState(arg0_8, arg1_8)
	local var0_8 = arg1_8.storyId

	arg0_8.storyStateDic[var0_8] = true

	local var1_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.story) do
		local var2_8 = iter1_8[1]

		if pg.NewStoryMgr.GetInstance():StoryName2StoryId(var2_8) == var0_8 then
			var1_8 = iter0_8
		end
	end

	local var3_8 = {
		"pittsburgh",
		"indiana",
		"fargo",
		"kersaint",
		"friedrich",
		"painleve"
	}

	for iter2_8, iter3_8 in ipairs(var3_8) do
		if iter2_8 == var1_8 then
			local var4_8 = arg0_8.storyStateDic[var0_8]
			local var5_8 = arg0_8._tf:Find("frame/bg/" .. iter3_8 .. "/locked")
			local var6_8 = arg0_8._tf:Find("frame/bg/" .. iter3_8 .. "/unlocked")
			local var7_8 = var5_8:GetComponent(typeof(Animation))
			local var8_8 = var7_8:GetClip("anim_cowboy_skin_fargo_unlock").length

			var7_8:Play("anim_cowboy_skin_fargo_unlock")
			arg0_8:ShowMask(true)

			arg0_8.isPlaying = true

			onDelayTick(function()
				arg0_8.isPlaying = false

				arg0_8:ShowMask(false)
				setActive(var5_8, not var4_8)
				setActive(var6_8, var4_8)
				pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var0_8))
			end, var8_8)

			if var4_8 then
				onButton(arg0_8, var6_8, function()
					pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var0_8), nil, true)
				end)
			else
				onButton(arg0_8, var5_8, function()
					if getProxy(ActivityProxy):getActivityById(5535).data1 <= 0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("activity_0815_town_memory"))

						return
					end

					pg.m02:sendNotification(GAME.ACTIVITY_UNLOCKSTORYT, {
						cmd = 1,
						activity_id = arg0_8.activity.id,
						arg1 = var0_8
					})
				end)
			end
		end
	end
end

function var0_0.didEnter(arg0_12)
	onButton(arg0_12, arg0_12._tf:Find("frame/back"), function()
		arg0_12:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf:Find("bg"), function()
		arg0_12:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf:Find("frame/des/itemDes"), function()
		local var0_15 = getProxy(ActivityProxy):getActivityById(5535).data1
		local var1_15 = {
			type = DROP_TYPE_VITEM,
			id = arg0_12.activity:getConfig("config_id"),
			count = var0_15
		}

		arg0_12:emit(BaseUI.ON_DROP, var1_15)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
end

function var0_0.ShowMask(arg0_16, arg1_16)
	local var0_16 = arg0_16._tf:Find("mask")

	GetOrAddComponent(var0_16, typeof(CanvasGroup)).blocksRaycasts = arg1_16
end

function var0_0.willExit(arg0_17)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf)
end

function var0_0.onBackPressed(arg0_18)
	if arg0_18.isPlaying then
		return
	end

	arg0_18.super.onBackPressed(arg0_18)
end

return var0_0
