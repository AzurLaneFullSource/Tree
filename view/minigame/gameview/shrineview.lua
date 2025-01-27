local var0_0 = class("ShrineView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "Shrine"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:initData()
	arg0_3.spineAnim:SetAction("normal", 0)
	arg0_3:updateView()
	arg0_3:updateBuff()
	arg0_3:updateWitchImg()
end

function var0_0.onBackPressed(arg0_4)
	if arg0_4.shrineBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.shrineBuffView:Destroy()
	elseif arg0_4.shrineResultView:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.shrineResultView:Destroy()
	else
		arg0_4:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_5, arg1_5)
	local var0_5 = arg1_5.argList
	local var1_5 = var0_5[1]
	local var2_5 = var0_5[2]

	if var1_5 == arg0_5.miniGameId then
		if var2_5 == 1 then
			arg0_5:updateView()
			arg0_5:updateWitchImg()
		elseif var2_5 == 2 then
			local var3_5 = getProxy(PlayerProxy):getData()

			var3_5:consume({
				gold = arg0_5:GetMGData():getConfig("config_data")[1]
			})
			getProxy(PlayerProxy):updatePlayer(var3_5)

			local var4_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHRINE)

			if var4_5 and not var4_5:isEnd() then
				var4_5.data2 = var4_5.data2 + 1

				getProxy(ActivityProxy):updateActivity(var4_5)
			end

			local var5_5 = var0_5[3]
			local var6_5 = pg.benefit_buff_template[var5_5].name
			local var7_5 = table.indexof(arg0_5:GetMGData():getConfig("config_data")[2], var5_5, 1)
			local var8_5 = i18n("tips_shrine_buff")

			arg0_5:playAnime(var8_5, var7_5)
			arg0_5:updateView()
			arg0_5:updateWitchImg()
		elseif var2_5 == 3 then
			local var9_5 = getProxy(PlayerProxy):getData()

			var9_5:consume({
				gold = arg0_5:GetMGData():getConfig("config_data")[1]
			})
			getProxy(PlayerProxy):updatePlayer(var9_5)

			local var10_5 = i18n("tips_shrine_nobuff")

			arg0_5:playAnime(var10_5)
			arg0_5:updateView()
			arg0_5:updateWitchImg()
		end
	end
end

function var0_0.OnModifyMiniGameDataDone(arg0_6, arg1_6)
	arg0_6:updateView()
end

function var0_0.willExit(arg0_7)
	if arg0_7.shrineBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0_7.shrineBuffView:Destroy()
	end

	if arg0_7.shrineResultView:CheckState(BaseSubView.STATES.INITED) then
		arg0_7.shrineResultView:Destroy()
	end

	arg0_7.spineAnim = nil

	if arg0_7._buffTextTimer then
		arg0_7._buffTextTimer:Stop()
	end

	if arg0_7._buffTimeCountDownTimer then
		arg0_7._buffTimeCountDownTimer:Stop()
	end

	if arg0_7.ringSE then
		arg0_7.ringSE:Stop(true)
	end
end

function var0_0.initData(arg0_8)
	arg0_8.miniGameId = arg0_8.contextData.miniGameId

	local var0_8 = getProxy(MiniGameProxy):GetHubByGameId(arg0_8.miniGameId)

	if not arg0_8:isInitedMiniGameData() then
		arg0_8:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0_8.miniGameId,
			1
		})
	end

	local var1_8 = {
		onSelect = function(arg0_9)
			local var0_9 = getProxy(PlayerProxy):getData()

			if arg0_8:GetMGData():getConfig("config_data")[1] > var0_9.gold then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			if arg0_8:GetMGData():GetRuntimeData("count") <= 0 then
				arg0_8:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0_8.miniGameId,
					3
				})
			else
				local var1_9 = arg0_8:GetMGData():getConfig("config_data")[2][arg0_9]

				arg0_8:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0_8.miniGameId,
					2,
					var1_9
				})
			end
		end,
		onClose = function()
			arg0_8.buffEffectAni.enabled = false
			arg0_8.bgImg.color = Color.New(1, 1, 1)

			setActive(arg0_8.noAdaptPanel, true)
			setActive(arg0_8.cloudTF, true)
			setActive(arg0_8.witchImg, arg0_8.activityWitch)
		end
	}

	arg0_8.shrineBuffView = ShrineBuffView.New(arg0_8._tf.parent, arg0_8.event, var1_8)
	arg0_8.shrineResultView = ShrineResultView.New(arg0_8._tf, arg0_8.event)
end

function var0_0.findUI(arg0_11)
	arg0_11.noAdaptPanel = arg0_11:findTF("noAdaptPanel")
	arg0_11.buffTF = arg0_11:findTF("Buff", arg0_11.noAdaptPanel)
	arg0_11.buffImg = arg0_11:findTF("BuffTypeImg", arg0_11.buffTF)
	arg0_11.buffEffectAni = GetComponent(arg0_11.buffImg, "Animator")
	arg0_11.buffText = arg0_11:findTF("BuffText", arg0_11.buffTF)
	arg0_11.buffDftAniEvent = GetComponent(arg0_11.buffImg, "DftAniEvent")
	arg0_11.bgImg = arg0_11:findTF("BGImg"):GetComponent(typeof(Image))
	arg0_11.bgImg.color = Color.New(1, 1, 1)
	arg0_11.cloudTF = arg0_11:findTF("BG/cloud")

	local var0_11 = arg0_11:findTF("Top", arg0_11.noAdaptPanel)

	arg0_11.topTF = var0_11
	arg0_11.backBtn = arg0_11:findTF("BackBtn", var0_11)
	arg0_11.helpBtn = arg0_11:findTF("HelpBtn", var0_11)
	arg0_11.timesText = arg0_11:findTF("Times/Text", var0_11)
	arg0_11.goldText = arg0_11:findTF("Gold/Text", var0_11)

	local var1_11 = arg0_11:findTF("Main")

	arg0_11.witchImg = arg0_11:findTF("Witch", var1_11)
	arg0_11.rope = arg0_11:findTF("Rope", var1_11)
	arg0_11.spineAnim = GetComponent(arg0_11.rope, "SpineAnimUI")
	arg0_11.press = GetComponent(arg0_11.rope, "EventTriggerListener")
end

function var0_0.addListener(arg0_12)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_newyear_shrine.tip
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.rope, function()
		arg0_12.bgImg.color = Color.New(0, 0, 0)

		setActive(arg0_12.noAdaptPanel, false)
		setActive(arg0_12.cloudTF, false)
		setActive(arg0_12.witchImg, false)
		arg0_12.shrineBuffView:Reset()
		arg0_12.shrineBuffView:Load()
	end)
	onButton(arg0_12, arg0_12.buffImg, function()
		arg0_12:updateBuffDesc()
	end, SFX_PANEL)
	arg0_12.buffDftAniEvent:SetStartEvent(function()
		setButtonEnabled(arg0_12.rope, false)
	end)
	arg0_12.buffDftAniEvent:SetEndEvent(function()
		setButtonEnabled(arg0_12.rope, true)
	end)
end

function var0_0.playAnime(arg0_19, arg1_19, arg2_19)
	setButtonEnabled(arg0_19.rope, false)

	arg0_19.ringSE = pg.CriMgr.GetInstance():PlaySE_V3("ui-shensheling")

	if arg0_19.spineAnim then
		arg0_19.spineAnim:SetAction("action", 0)
		arg0_19.spineAnim:SetActionCallBack(function(arg0_20)
			if arg0_20 == "finish" then
				arg0_19.spineAnim:SetActionCallBack(nil)

				if arg0_19.ringSE then
					arg0_19.ringSE:Stop(true)
				end

				arg0_19.shrineResultView:Reset()
				arg0_19.shrineResultView:Load()
				arg0_19.shrineResultView:ActionInvoke("updateView", arg1_19, arg2_19)
				arg0_19.shrineResultView:ActionInvoke("setCloseFunc", function()
					if arg2_19 then
						arg0_19:updateBuff()

						arg0_19.buffEffectAni.enabled = true
					end

					setButtonEnabled(arg0_19.rope, true)
				end)
				arg0_19.spineAnim:SetAction("normal", 0)
			end
		end)
	end
end

function var0_0.updateView(arg0_22)
	if not arg0_22:isInitedMiniGameData() then
		return
	end

	local var0_22 = arg0_22:GetMGData():GetRuntimeData("count")

	setText(arg0_22.timesText, var0_22)

	local var1_22 = getProxy(PlayerProxy):getData().gold

	setText(arg0_22.goldText, var1_22)
end

function var0_0.updateBuff(arg0_23, arg1_23)
	if arg1_23 then
		setImageSprite(arg0_23.buffImg, GetSpriteFromAtlas("ui/shrineui_atlas", "buff_type_" .. arg1_23))
		setActive(arg0_23.buffImg, true)
	else
		local var0_23 = getProxy(PlayerProxy):getData()
		local var1_23 = arg0_23:GetMGData():getConfig("config_data")[2]
		local var2_23

		for iter0_23, iter1_23 in ipairs(var0_23.buff_list) do
			var2_23 = table.indexof(var1_23, iter1_23.id, 1)

			if var2_23 then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter1_23.timestamp then
					setImageSprite(arg0_23.buffImg, GetSpriteFromAtlas("ui/shrineui_atlas", "buff_type_" .. var2_23))
					setActive(arg0_23.buffImg, true)

					break
				end

				var2_23 = nil

				break
			end
		end

		if not var2_23 then
			setActive(arg0_23.buffImg, false)
		end
	end
end

function var0_0.updateBuffDesc(arg0_24)
	local var0_24
	local var1_24 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	if var1_24 and not var1_24:isEnd() then
		local var2_24 = arg0_24:GetMGData():getConfig("config_data")[2]
		local var3_24 = getProxy(PlayerProxy):getData()

		for iter0_24, iter1_24 in pairs(var3_24.buff_list) do
			if table.contains(var2_24, iter1_24.id) then
				var0_24 = ActivityBuff.New(var1_24.id, iter1_24.id, iter1_24.timestamp)

				break
			end
		end
	end

	if arg0_24._buffTimeCountDownTimer then
		arg0_24._buffTimeCountDownTimer:Stop()
	end

	if arg0_24._buffTextTimer then
		arg0_24._buffTextTimer:Stop()
	end

	local var4_24 = var0_24:getConfig("desc")

	if var0_24:getConfig("max_time") > 0 then
		local var5_24 = pg.TimeMgr.GetInstance():GetServerTime()
		local var6_24 = var0_24.timestamp

		if var6_24 then
			local var7_24 = var6_24 - var5_24
			local var8_24 = pg.TimeMgr.GetInstance():DescCDTime(var7_24)

			setText(arg0_24.buffText:Find("Text"), string.gsub(var4_24, "$" .. 1, var8_24))

			arg0_24._buffTimeCountDownTimer = Timer.New(function()
				if var7_24 > 0 then
					var7_24 = var7_24 - 1

					local var0_25 = pg.TimeMgr.GetInstance():DescCDTime(var7_24)

					setText(arg0_24.buffText:Find("Text"), string.gsub(var4_24, "$" .. 1, var0_25))
				else
					arg0_24._buffTimeCountDownTimer:Stop()
					setActive(arg0_24.buffText, false)
					setActive(arg0_24.buffImg, false)
				end
			end, 1, -1)

			setActive(arg0_24.buffText, true)
			arg0_24._buffTimeCountDownTimer:Start()
		end
	end

	arg0_24._buffTextTimer = Timer.New(function()
		setActive(arg0_24.buffText, false)
		arg0_24._buffTimeCountDownTimer:Stop()
	end, 7, 1)

	arg0_24._buffTextTimer:Start()
end

function var0_0.updateWitchImg(arg0_27)
	arg0_27.activityWitch = false

	if not arg0_27:isInitedMiniGameData() then
		return
	end

	if arg0_27:GetMGData():GetRuntimeData("serverGold") >= arg0_27:GetMGData():getConfig("simple_config_data").target then
		arg0_27.activityWitch = true

		setActive(arg0_27.witchImg, true)
	end
end

function var0_0.isInitedMiniGameData(arg0_28)
	if not arg0_28:GetMGData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

return var0_0
