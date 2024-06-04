local var0 = class("LinkDunHuangPage", import(".JavelinComicSkinPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("items/item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
	arg0.bgImg = arg0.bg:GetComponent(typeof(Image))
	arg0.isReplaceBG = false
end

function var0.GetLinkId(arg0)
	return arg0.activity:getConfig("config_client").link_act
end

function var0.UpdatePuzzle(arg0, arg1, arg2, arg3)
	if arg2 and not table.contains(arg0.chargeIDList, arg3) then
		table.insert(arg0.chargeIDList, arg3)
		arg0:DoPieceAnimation(arg1, 1, 0, function()
			setActive(arg1, not arg2)
			arg0:CheckFinalAward()
		end)
	else
		setActive(arg1, not arg2)
	end
end

function var0.DoPieceAnimation(arg0, arg1, arg2, arg3, arg4)
	if LeanTween.isTweening(arg1) then
		LeanTween.cancel(go(arg1), true)

		arg0.animations[arg1] = nil
	end

	pg.UIMgr.GetInstance():LoadingOn(false)

	arg0.animations[arg1] = true

	LeanTween.value(arg1.gameObject, 1, 0, 1):setOnUpdate(System.Action_float(function(arg0)
		setFillAmount(arg1, arg0)
	end)):setFrom(1):setOnComplete(System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff()
		arg4()
	end))
end

function var0.RegisterEvent(arg0)
	return
end

function var0.UpdateMainView(arg0, arg1)
	if arg1 and not arg0.isReplaceBG then
		arg0:ReplaceBg()
	end
end

function var0.PlayStory(arg0)
	return
end

function var0.FetchFinalAward(arg0)
	var0.super.FetchFinalAward(arg0)

	local var0 = arg0.activity:getConfig("config_client").story[arg0.nday] or {}

	if var0[1] then
		pg.NewStoryMgr.GetInstance():Play(var0[1])
	end
end

function var0.OnFetchFinalAwardDone(arg0)
	local var0 = {}
	local var1 = arg0.activity:getConfig("config_client").story

	for iter0, iter1 in ipairs(var1 or {}) do
		local var2 = var1[iter0] or {}

		if var2[1] and not pg.NewStoryMgr.GetInstance():IsPlayed(var2[1]) then
			table.insert(var0, var2[1])
		end
	end

	pg.NewStoryMgr.GetInstance():SeriesPlay(var0)
end

function var0.ReplaceBg(arg0)
	arg0.isReplaceBG = true
	arg0.bgImg.sprite = GetSpriteFromAtlas("ui/activityuipage/LinkDunhuangPage_atlas", "bg_finish")
end

return var0
