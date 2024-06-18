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

			arg2_8:Find("color"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/WorldBossUI_atlas", "color_" .. var2_8)

			local var3_8 = arg2_8:Find("color/Text")

			setText(var3_8, var1_8)
		end
	end)
	arg0_7.infoSkillList:align(#var0_7)
end

function var0_0.ResetInfoLayout(arg0_9)
	local var0_9 = 28
	local var1_9 = arg0_9.boss.config.description

	onNextTick(function()
		if arg0_9.exited then
			return
		end

		arg0_9.infoSkillList:each(function(arg0_11, arg1_11)
			local var0_11 = var1_9[arg0_11 + 1][3]
			local var1_11 = arg1_11:Find("color/Text")
			local var2_11 = "　"
			local var3_11, var4_11 = math.modf(var1_11.sizeDelta.x / var0_9)
			local var5_11 = math.ceil(var0_9 * var4_11)

			for iter0_11 = 1, var3_11 do
				var2_11 = var2_11 .. "　"
			end

			if var4_11 > 0 then
				var2_11 = var2_11 .. "<size=" .. var5_11 .. ">　</size>"
			end

			setText(arg1_11:Find("Text"), var2_11 .. var0_11)
		end)
	end)
end

function var0_0.FlushRank(arg0_12)
	local var0_12 = arg0_12.boss

	if not var0_12 then
		return
	end

	local var1_12 = arg0_12.proxy:GetRank(var0_12.id)
	local var2_12 = 0

	if not var1_12 then
		arg0_12:emit(WorldBossMediator.ON_RANK_LIST, var0_12.id)
	else
		arg0_12.rankList:make(function(arg0_13, arg1_13, arg2_13)
			if arg0_13 == UIItemList.EventUpdate then
				local var0_13 = var1_12[arg1_13 + 1]

				arg0_12:UpdateRankTF(arg2_13, var0_13, arg1_13 + 1)
			end
		end)
		arg0_12.rankList:align(math.min(#var1_12, 3))
		arg0_12:UpdateSelfRank(var1_12)

		var2_12 = #var1_12
	end

	arg0_12.rankCnt1.text = var2_12 .. "<color=#A2A2A2>/" .. arg0_12.maxRankCnt .. "</color>"

	if arg0_12.flushRankCallback then
		arg0_12.flushRankCallback(var2_12, arg0_12.maxRankCnt)
	end

	arg0_12:AddWaitResultTimer()
end

function var0_0.AddWaitResultTimer(arg0_14)
	arg0_14:RemoveWaitTimer()

	local var0_14 = arg0_14.boss
	local var1_14 = var0_14:ShouldWaitForResult()

	setActive(arg0_14.maskTF, var1_14)

	if var1_14 then
		local var2_14 = var0_14:GetWaitForResultTime()

		arg0_14.waitTimer = Timer.New(function()
			local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_15 = var2_14 - var0_15

			if var1_15 < 0 then
				arg0_14:AddWaitResultTimer()

				if arg0_14.callback then
					arg0_14.callback(false)
				end
			else
				arg0_14.maskTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_15)
			end
		end, 1, -1)

		arg0_14.waitTimer:Start()

		if arg0_14.callback then
			arg0_14.callback(true)
		end
	end
end

function var0_0.RemoveWaitTimer(arg0_16)
	if arg0_16.waitTimer then
		arg0_16.waitTimer:Stop()

		arg0_16.waitTimer = nil
	end
end

function var0_0.UpdateRankTF(arg0_17, arg1_17, arg2_17, arg3_17)
	setText(arg1_17:Find("name"), arg2_17.name)
	setText(arg1_17:Find("value/Text"), arg2_17.damage)
	setText(arg1_17:Find("number"), arg2_17.number or arg3_17)
	setActive(arg1_17:Find("value/view"), not arg2_17.isSelf)
	onButton(arg0_17, arg1_17:Find("value/view"), function()
		local var0_18 = arg0_17.boss

		arg0_17:emit(WorldBossMediator.FETCH_RANK_FORMATION, arg2_17.id, var0_18.id)
	end, SFX_PANEL)
end

function var0_0.UpdateSelfRank(arg0_19, arg1_19)
	local var0_19

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		if iter1_19.isSelf then
			var0_19 = iter1_19
			var0_19.number = iter0_19

			break
		end
	end

	if var0_19 then
		arg0_19:UpdateRankTF(arg0_19.myRankTF, var0_19)
	end
end

function var0_0.OnDestroy(arg0_20)
	arg0_20:RemoveWaitTimer()
end

return var0_0
