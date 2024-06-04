local var0 = class("WorldBossInfoAndRankPanel", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldBossInfoAndRankUI"
end

function var0.OnLoaded(arg0)
	arg0.toggleRank = arg0:findTF("rank")
	arg0.toggleInfo = arg0:findTF("info")
	arg0.myRankTF = arg0:findTF("rank_panel/tpl")
	arg0.rankList = UIItemList.New(arg0:findTF("rank_panel/list"), arg0.myRankTF)
	arg0.maxRankCnt = pg.gameset.joint_boss_fighter_max.key_value
	arg0.rankCnt1 = arg0:findTF("rank_panel/cnt/Text"):GetComponent(typeof(Text))
	arg0.rankTF = arg0:findTF("rank_panel")
	arg0.maskTF = arg0:findTF("rank_panel/mask")
	arg0.maskTxt = arg0:findTF("rank_panel/mask/Text"):GetComponent(typeof(Text))
	arg0.infoTitle = arg0:findTF("info_panel/title/Text"):GetComponent(typeof(Text))
	arg0.infoSkillList = UIItemList.New(arg0:findTF("info_panel/scrollrect/content"), arg0:findTF("info_panel/scrollrect/content/tpl"))
end

function var0.SetCallback(arg0, arg1, arg2)
	arg0.callback = arg1
	arg0.flushRankCallback = arg2
end

function var0.OnInit(arg0)
	arg0._tf:SetSiblingIndex(2)
	onToggle(arg0, arg0.toggleInfo, function(arg0)
		if arg0 then
			arg0:ResetInfoLayout()
		end
	end)
end

function var0.Flush(arg0, arg1, arg2)
	arg0.boss = arg1
	arg0.proxy = arg2

	arg0:FlushRank()
	arg0:FlushInfo()

	if not arg0.boss:IsFullHp() then
		triggerToggle(arg0.toggleRank, true)
	else
		triggerToggle(arg0.toggleInfo, true)
		arg0:ResetInfoLayout()
	end
end

function var0.FlushInfo(arg0)
	arg0.infoTitle.text = arg0.boss.config.name

	local var0 = arg0.boss.config.description

	arg0.infoSkillList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = var0[1]
			local var2 = var0[2]

			arg2:Find("color"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/WorldBossUI_atlas", "color_" .. var2)

			local var3 = arg2:Find("color/Text")

			setText(var3, var1)
		end
	end)
	arg0.infoSkillList:align(#var0)
end

function var0.ResetInfoLayout(arg0)
	local var0 = 28
	local var1 = arg0.boss.config.description

	onNextTick(function()
		if arg0.exited then
			return
		end

		arg0.infoSkillList:each(function(arg0, arg1)
			local var0 = var1[arg0 + 1][3]
			local var1 = arg1:Find("color/Text")
			local var2 = "　"
			local var3, var4 = math.modf(var1.sizeDelta.x / var0)
			local var5 = math.ceil(var0 * var4)

			for iter0 = 1, var3 do
				var2 = var2 .. "　"
			end

			if var4 > 0 then
				var2 = var2 .. "<size=" .. var5 .. ">　</size>"
			end

			setText(arg1:Find("Text"), var2 .. var0)
		end)
	end)
end

function var0.FlushRank(arg0)
	local var0 = arg0.boss

	if not var0 then
		return
	end

	local var1 = arg0.proxy:GetRank(var0.id)
	local var2 = 0

	if not var1 then
		arg0:emit(WorldBossMediator.ON_RANK_LIST, var0.id)
	else
		arg0.rankList:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = var1[arg1 + 1]

				arg0:UpdateRankTF(arg2, var0, arg1 + 1)
			end
		end)
		arg0.rankList:align(math.min(#var1, 3))
		arg0:UpdateSelfRank(var1)

		var2 = #var1
	end

	arg0.rankCnt1.text = var2 .. "<color=#A2A2A2>/" .. arg0.maxRankCnt .. "</color>"

	if arg0.flushRankCallback then
		arg0.flushRankCallback(var2, arg0.maxRankCnt)
	end

	arg0:AddWaitResultTimer()
end

function var0.AddWaitResultTimer(arg0)
	arg0:RemoveWaitTimer()

	local var0 = arg0.boss
	local var1 = var0:ShouldWaitForResult()

	setActive(arg0.maskTF, var1)

	if var1 then
		local var2 = var0:GetWaitForResultTime()

		arg0.waitTimer = Timer.New(function()
			local var0 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1 = var2 - var0

			if var1 < 0 then
				arg0:AddWaitResultTimer()

				if arg0.callback then
					arg0.callback(false)
				end
			else
				arg0.maskTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1)
			end
		end, 1, -1)

		arg0.waitTimer:Start()

		if arg0.callback then
			arg0.callback(true)
		end
	end
end

function var0.RemoveWaitTimer(arg0)
	if arg0.waitTimer then
		arg0.waitTimer:Stop()

		arg0.waitTimer = nil
	end
end

function var0.UpdateRankTF(arg0, arg1, arg2, arg3)
	setText(arg1:Find("name"), arg2.name)
	setText(arg1:Find("value/Text"), arg2.damage)
	setText(arg1:Find("number"), arg2.number or arg3)
	setActive(arg1:Find("value/view"), not arg2.isSelf)
	onButton(arg0, arg1:Find("value/view"), function()
		local var0 = arg0.boss

		arg0:emit(WorldBossMediator.FETCH_RANK_FORMATION, arg2.id, var0.id)
	end, SFX_PANEL)
end

function var0.UpdateSelfRank(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg1) do
		if iter1.isSelf then
			var0 = iter1
			var0.number = iter0

			break
		end
	end

	if var0 then
		arg0:UpdateRankTF(arg0.myRankTF, var0)
	end
end

function var0.OnDestroy(arg0)
	arg0:RemoveWaitTimer()
end

return var0
