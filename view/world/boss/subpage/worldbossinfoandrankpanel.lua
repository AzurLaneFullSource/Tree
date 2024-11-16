local var0_0 = class("WorldBossInfoAndRankPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldBossInfoAndRankUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.toggleRank = arg0_2:findTF("rank")
	arg0_2.toggleInfo = arg0_2:findTF("info")
	arg0_2.myRankTF = arg0_2:findTF("rank_panel/tpl")
	arg0_2.rankList = UIItemList.New(arg0_2:findTF("rank_panel/list"), arg0_2.myRankTF)
	arg0_2.maxRankCnt = pg.gameset.joint_boss_fighter_max.key_value
	arg0_2.rankCnt1 = arg0_2:findTF("rank_panel/cnt/Text"):GetComponent(typeof(Text))
	arg0_2.rankTF = arg0_2:findTF("rank_panel")
	arg0_2.maskTF = arg0_2:findTF("rank_panel/mask")
	arg0_2.maskTxt = arg0_2:findTF("rank_panel/mask/Text"):GetComponent(typeof(Text))
	arg0_2.infoTitle = arg0_2:findTF("info_panel/title/Text"):GetComponent(typeof(Text))
	arg0_2.infoSkillList = UIItemList.New(arg0_2:findTF("info_panel/scrollrect/content"), arg0_2:findTF("info_panel/scrollrect/content/tpl"))
end

function var0_0.SetCallback(arg0_3, arg1_3, arg2_3)
	arg0_3.callback = arg1_3
	arg0_3.flushRankCallback = arg2_3
end

function var0_0.OnInit(arg0_4)
	arg0_4._tf:SetSiblingIndex(2)
	onToggle(arg0_4, arg0_4.toggleInfo, function(arg0_5)
		if arg0_5 then
			arg0_4:ResetInfoLayout()
		end
	end)
end

function var0_0.Flush(arg0_6, arg1_6, arg2_6)
	arg0_6.boss = arg1_6
	arg0_6.proxy = arg2_6

	arg0_6:FlushRank()
	arg0_6:FlushInfo()

	if not arg0_6.boss:IsFullHp() then
		triggerToggle(arg0_6.toggleRank, true)
	else
		triggerToggle(arg0_6.toggleInfo, true)
		arg0_6:ResetInfoLayout()
	end
end

function var0_0.FlushInfo(arg0_7)
	arg0_7.infoTitle.text = arg0_7.boss.config.name

	local var0_7 = arg0_7.boss.config.description

	arg0_7.infoSkillList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var0_7[arg1_8 + 1]
			local var1_8 = var0_8[1]
			local var2_8 = var0_8[2]

			GetSpriteFromAtlasAsync("ui/WorldBossUI_atlas", "color_" .. var2_8, function(arg0_9)
				arg2_8:Find("color"):GetComponent(typeof(Image)).sprite = arg0_9
			end)

			local var3_8 = arg2_8:Find("color/Text")

			setText(var3_8, var1_8)
		end
	end)
	arg0_7.infoSkillList:align(#var0_7)
end

function var0_0.ResetInfoLayout(arg0_10)
	local var0_10 = 28
	local var1_10 = arg0_10.boss.config.description

	onNextTick(function()
		if arg0_10.exited then
			return
		end

		arg0_10.infoSkillList:each(function(arg0_12, arg1_12)
			local var0_12 = var1_10[arg0_12 + 1][3]
			local var1_12 = arg1_12:Find("color/Text")
			local var2_12 = "　"
			local var3_12, var4_12 = math.modf(var1_12.sizeDelta.x / var0_10)
			local var5_12 = math.ceil(var0_10 * var4_12)

			for iter0_12 = 1, var3_12 do
				var2_12 = var2_12 .. "　"
			end

			if var4_12 > 0 then
				var2_12 = var2_12 .. "<size=" .. var5_12 .. ">　</size>"
			end

			setText(arg1_12:Find("Text"), var2_12 .. var0_12)
		end)
	end)
end

function var0_0.FlushRank(arg0_13)
	local var0_13 = arg0_13.boss

	if not var0_13 then
		return
	end

	local var1_13 = arg0_13.proxy:GetRank(var0_13.id)
	local var2_13 = 0

	if not var1_13 then
		arg0_13:emit(WorldBossMediator.ON_RANK_LIST, var0_13.id)
	else
		arg0_13.rankList:make(function(arg0_14, arg1_14, arg2_14)
			if arg0_14 == UIItemList.EventUpdate then
				local var0_14 = var1_13[arg1_14 + 1]

				arg0_13:UpdateRankTF(arg2_14, var0_14, arg1_14 + 1)
			end
		end)
		arg0_13.rankList:align(math.min(#var1_13, 3))
		arg0_13:UpdateSelfRank(var1_13)

		var2_13 = #var1_13
	end

	arg0_13.rankCnt1.text = var2_13 .. "<color=#A2A2A2>/" .. arg0_13.maxRankCnt .. "</color>"

	if arg0_13.flushRankCallback then
		arg0_13.flushRankCallback(var2_13, arg0_13.maxRankCnt)
	end

	arg0_13:AddWaitResultTimer()
end

function var0_0.AddWaitResultTimer(arg0_15)
	arg0_15:RemoveWaitTimer()

	local var0_15 = arg0_15.boss
	local var1_15 = var0_15:ShouldWaitForResult()

	setActive(arg0_15.maskTF, var1_15)

	if var1_15 then
		local var2_15 = var0_15:GetWaitForResultTime()

		arg0_15.waitTimer = Timer.New(function()
			local var0_16 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_16 = var2_15 - var0_16

			if var1_16 < 0 then
				arg0_15:AddWaitResultTimer()

				if arg0_15.callback then
					arg0_15.callback(false)
				end
			else
				arg0_15.maskTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_16)
			end
		end, 1, -1)

		arg0_15.waitTimer:Start()

		if arg0_15.callback then
			arg0_15.callback(true)
		end
	end
end

function var0_0.RemoveWaitTimer(arg0_17)
	if arg0_17.waitTimer then
		arg0_17.waitTimer:Stop()

		arg0_17.waitTimer = nil
	end
end

function var0_0.UpdateRankTF(arg0_18, arg1_18, arg2_18, arg3_18)
	setText(arg1_18:Find("name"), arg2_18.name)
	setText(arg1_18:Find("value/Text"), arg2_18.damage)
	setText(arg1_18:Find("number"), arg2_18.number or arg3_18)
	setActive(arg1_18:Find("value/view"), not arg2_18.isSelf)
	onButton(arg0_18, arg1_18:Find("value/view"), function()
		local var0_19 = arg0_18.boss

		arg0_18:emit(WorldBossMediator.FETCH_RANK_FORMATION, arg2_18.id, var0_19.id)
	end, SFX_PANEL)
end

function var0_0.UpdateSelfRank(arg0_20, arg1_20)
	local var0_20

	for iter0_20, iter1_20 in ipairs(arg1_20) do
		if iter1_20.isSelf then
			var0_20 = iter1_20
			var0_20.number = iter0_20

			break
		end
	end

	if var0_20 then
		arg0_20:UpdateRankTF(arg0_20.myRankTF, var0_20)
	end
end

function var0_0.OnDestroy(arg0_21)
	arg0_21:RemoveWaitTimer()
end

return var0_0
