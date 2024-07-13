local var0_0 = class("LinkDunHuangPage", import(".JavelinComicSkinPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("items/item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.bgImg = arg0_1.bg:GetComponent(typeof(Image))
	arg0_1.isReplaceBG = false
end

function var0_0.GetLinkId(arg0_2)
	return arg0_2.activity:getConfig("config_client").link_act
end

function var0_0.UpdatePuzzle(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg2_3 and not table.contains(arg0_3.chargeIDList, arg3_3) then
		table.insert(arg0_3.chargeIDList, arg3_3)
		arg0_3:DoPieceAnimation(arg1_3, 1, 0, function()
			setActive(arg1_3, not arg2_3)
			arg0_3:CheckFinalAward()
		end)
	else
		setActive(arg1_3, not arg2_3)
	end
end

function var0_0.DoPieceAnimation(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	if LeanTween.isTweening(arg1_5) then
		LeanTween.cancel(go(arg1_5), true)

		arg0_5.animations[arg1_5] = nil
	end

	pg.UIMgr.GetInstance():LoadingOn(false)

	arg0_5.animations[arg1_5] = true

	LeanTween.value(arg1_5.gameObject, 1, 0, 1):setOnUpdate(System.Action_float(function(arg0_6)
		setFillAmount(arg1_5, arg0_6)
	end)):setFrom(1):setOnComplete(System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff()
		arg4_5()
	end))
end

function var0_0.RegisterEvent(arg0_8)
	return
end

function var0_0.UpdateMainView(arg0_9, arg1_9)
	if arg1_9 and not arg0_9.isReplaceBG then
		arg0_9:ReplaceBg()
	end
end

function var0_0.PlayStory(arg0_10)
	return
end

function var0_0.FetchFinalAward(arg0_11)
	var0_0.super.FetchFinalAward(arg0_11)

	local var0_11 = arg0_11.activity:getConfig("config_client").story[arg0_11.nday] or {}

	if var0_11[1] then
		pg.NewStoryMgr.GetInstance():Play(var0_11[1])
	end
end

function var0_0.OnFetchFinalAwardDone(arg0_12)
	local var0_12 = {}
	local var1_12 = arg0_12.activity:getConfig("config_client").story

	for iter0_12, iter1_12 in ipairs(var1_12 or {}) do
		local var2_12 = var1_12[iter0_12] or {}

		if var2_12[1] and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_12[1]) then
			table.insert(var0_12, var2_12[1])
		end
	end

	pg.NewStoryMgr.GetInstance():SeriesPlay(var0_12)
end

function var0_0.ReplaceBg(arg0_13)
	arg0_13.isReplaceBG = true
	arg0_13.bgImg.sprite = GetSpriteFromAtlas("ui/activityuipage/LinkDunhuangPage_atlas", "bg_finish")
end

return var0_0
