local var0 = class("ShrineView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "Shrine"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:initData()
	arg0.spineAnim:SetAction("normal", 0)
	arg0:updateView()
	arg0:updateBuff()
	arg0:updateWitchImg()
end

function var0.onBackPressed(arg0)
	if arg0.shrineBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineBuffView:Destroy()
	elseif arg0.shrineResultView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineResultView:Destroy()
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	local var0 = arg1.argList
	local var1 = var0[1]
	local var2 = var0[2]

	if var1 == arg0.miniGameId then
		if var2 == 1 then
			arg0:updateView()
			arg0:updateWitchImg()
		elseif var2 == 2 then
			local var3 = getProxy(PlayerProxy):getData()

			var3:consume({
				gold = arg0:GetMGData():getConfig("config_data")[1]
			})
			getProxy(PlayerProxy):updatePlayer(var3)

			local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHRINE)

			if var4 and not var4:isEnd() then
				var4.data2 = var4.data2 + 1

				getProxy(ActivityProxy):updateActivity(var4)
			end

			local var5 = var0[3]
			local var6 = pg.benefit_buff_template[var5].name
			local var7 = table.indexof(arg0:GetMGData():getConfig("config_data")[2], var5, 1)
			local var8 = i18n("tips_shrine_buff")

			arg0:playAnime(var8, var7)
			arg0:updateView()
			arg0:updateWitchImg()
		elseif var2 == 3 then
			local var9 = getProxy(PlayerProxy):getData()

			var9:consume({
				gold = arg0:GetMGData():getConfig("config_data")[1]
			})
			getProxy(PlayerProxy):updatePlayer(var9)

			local var10 = i18n("tips_shrine_nobuff")

			arg0:playAnime(var10)
			arg0:updateView()
			arg0:updateWitchImg()
		end
	end
end

function var0.OnModifyMiniGameDataDone(arg0, arg1)
	arg0:updateView()
end

function var0.willExit(arg0)
	if arg0.shrineBuffView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineBuffView:Destroy()
	end

	if arg0.shrineResultView:CheckState(BaseSubView.STATES.INITED) then
		arg0.shrineResultView:Destroy()
	end

	arg0.spineAnim = nil

	if arg0._buffTextTimer then
		arg0._buffTextTimer:Stop()
	end

	if arg0._buffTimeCountDownTimer then
		arg0._buffTimeCountDownTimer:Stop()
	end

	if arg0.ringSE then
		arg0.ringSE:Stop(true)
	end
end

function var0.initData(arg0)
	arg0.miniGameId = arg0.contextData.miniGameId

	local var0 = getProxy(MiniGameProxy):GetHubByGameId(arg0.miniGameId)

	if not arg0:isInitedMiniGameData() then
		arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0.miniGameId,
			1
		})
	end

	local var1 = {
		onSelect = function(arg0)
			local var0 = getProxy(PlayerProxy):getData()

			if arg0:GetMGData():getConfig("config_data")[1] > var0.gold then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			if arg0:GetMGData():GetRuntimeData("count") <= 0 then
				arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0.miniGameId,
					3
				})
			else
				local var1 = arg0:GetMGData():getConfig("config_data")[2][arg0]

				arg0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
					arg0.miniGameId,
					2,
					var1
				})
			end
		end,
		onClose = function()
			arg0.buffEffectAni.enabled = false
			arg0.bgImg.color = Color.New(1, 1, 1)

			setActive(arg0.noAdaptPanel, true)
			setActive(arg0.cloudTF, true)
			setActive(arg0.witchImg, arg0.activityWitch)
		end
	}

	arg0.shrineBuffView = ShrineBuffView.New(arg0._tf.parent, arg0.event, var1)
	arg0.shrineResultView = ShrineResultView.New(arg0._tf, arg0.event)
end

function var0.findUI(arg0)
	arg0.noAdaptPanel = arg0:findTF("noAdaptPanel")
	arg0.buffTF = arg0:findTF("Buff", arg0.noAdaptPanel)
	arg0.buffImg = arg0:findTF("BuffTypeImg", arg0.buffTF)
	arg0.buffEffectAni = GetComponent(arg0.buffImg, "Animator")
	arg0.buffText = arg0:findTF("BuffText", arg0.buffTF)
	arg0.buffDftAniEvent = GetComponent(arg0.buffImg, "DftAniEvent")
	arg0.bgImg = arg0:findTF("BGImg"):GetComponent(typeof(Image))
	arg0.bgImg.color = Color.New(1, 1, 1)
	arg0.cloudTF = arg0:findTF("BG/cloud")

	local var0 = arg0:findTF("Top", arg0.noAdaptPanel)

	arg0.topTF = var0
	arg0.backBtn = arg0:findTF("BackBtn", var0)
	arg0.helpBtn = arg0:findTF("HelpBtn", var0)
	arg0.timesText = arg0:findTF("Times/Text", var0)
	arg0.goldText = arg0:findTF("Gold/Text", var0)

	local var1 = arg0:findTF("Main")

	arg0.witchImg = arg0:findTF("Witch", var1)
	arg0.rope = arg0:findTF("Rope", var1)
	arg0.spineAnim = GetComponent(arg0.rope, "SpineAnimUI")
	arg0.press = GetComponent(arg0.rope, "EventTriggerListener")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_newyear_shrine.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.rope, function()
		arg0.bgImg.color = Color.New(0, 0, 0)

		setActive(arg0.noAdaptPanel, false)
		setActive(arg0.cloudTF, false)
		setActive(arg0.witchImg, false)
		arg0.shrineBuffView:Reset()
		arg0.shrineBuffView:Load()
	end)
	onButton(arg0, arg0.buffImg, function()
		arg0:updateBuffDesc()
	end, SFX_PANEL)
	arg0.buffDftAniEvent:SetStartEvent(function()
		setButtonEnabled(arg0.rope, false)
	end)
	arg0.buffDftAniEvent:SetEndEvent(function()
		setButtonEnabled(arg0.rope, true)
	end)
end

function var0.playAnime(arg0, arg1, arg2)
	setButtonEnabled(arg0.rope, false)

	arg0.ringSE = pg.CriMgr.GetInstance():PlaySE_V3("ui-shensheling")

	if arg0.spineAnim then
		arg0.spineAnim:SetAction("action", 0)
		arg0.spineAnim:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0.spineAnim:SetActionCallBack(nil)

				if arg0.ringSE then
					arg0.ringSE:Stop(true)
				end

				arg0.shrineResultView:Reset()
				arg0.shrineResultView:Load()
				arg0.shrineResultView:ActionInvoke("updateView", arg1, arg2)
				arg0.shrineResultView:ActionInvoke("setCloseFunc", function()
					if arg2 then
						arg0:updateBuff()

						arg0.buffEffectAni.enabled = true
					end

					setButtonEnabled(arg0.rope, true)
				end)
				arg0.spineAnim:SetAction("normal", 0)
			end
		end)
	end
end

function var0.updateView(arg0)
	if not arg0:isInitedMiniGameData() then
		return
	end

	local var0 = arg0:GetMGData():GetRuntimeData("count")

	setText(arg0.timesText, var0)

	local var1 = getProxy(PlayerProxy):getData().gold

	setText(arg0.goldText, var1)
end

function var0.updateBuff(arg0, arg1)
	if arg1 then
		setImageSprite(arg0.buffImg, GetSpriteFromAtlas("ui/shrineui_atlas", "buff_type_" .. arg1))
		setActive(arg0.buffImg, true)
	else
		local var0 = getProxy(PlayerProxy):getData()
		local var1 = arg0:GetMGData():getConfig("config_data")[2]
		local var2

		for iter0, iter1 in ipairs(var0.buff_list) do
			var2 = table.indexof(var1, iter1.id, 1)

			if var2 then
				if pg.TimeMgr.GetInstance():GetServerTime() < iter1.timestamp then
					setImageSprite(arg0.buffImg, GetSpriteFromAtlas("ui/shrineui_atlas", "buff_type_" .. var2))
					setActive(arg0.buffImg, true)

					break
				end

				var2 = nil

				break
			end
		end

		if not var2 then
			setActive(arg0.buffImg, false)
		end
	end
end

function var0.updateBuffDesc(arg0)
	local var0
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

	if var1 and not var1:isEnd() then
		local var2 = arg0:GetMGData():getConfig("config_data")[2]
		local var3 = getProxy(PlayerProxy):getData()

		for iter0, iter1 in pairs(var3.buff_list) do
			if table.contains(var2, iter1.id) then
				var0 = ActivityBuff.New(var1.id, iter1.id, iter1.timestamp)

				break
			end
		end
	end

	if arg0._buffTimeCountDownTimer then
		arg0._buffTimeCountDownTimer:Stop()
	end

	if arg0._buffTextTimer then
		arg0._buffTextTimer:Stop()
	end

	local var4 = var0:getConfig("desc")

	if var0:getConfig("max_time") > 0 then
		local var5 = pg.TimeMgr.GetInstance():GetServerTime()
		local var6 = var0.timestamp

		if var6 then
			local var7 = var6 - var5
			local var8 = pg.TimeMgr.GetInstance():DescCDTime(var7)

			setText(arg0.buffText:Find("Text"), string.gsub(var4, "$" .. 1, var8))

			arg0._buffTimeCountDownTimer = Timer.New(function()
				if var7 > 0 then
					var7 = var7 - 1

					local var0 = pg.TimeMgr.GetInstance():DescCDTime(var7)

					setText(arg0.buffText:Find("Text"), string.gsub(var4, "$" .. 1, var0))
				else
					arg0._buffTimeCountDownTimer:Stop()
					setActive(arg0.buffText, false)
					setActive(arg0.buffImg, false)
				end
			end, 1, -1)

			setActive(arg0.buffText, true)
			arg0._buffTimeCountDownTimer:Start()
		end
	end

	arg0._buffTextTimer = Timer.New(function()
		setActive(arg0.buffText, false)
		arg0._buffTimeCountDownTimer:Stop()
	end, 7, 1)

	arg0._buffTextTimer:Start()
end

function var0.updateWitchImg(arg0)
	arg0.activityWitch = false

	if not arg0:isInitedMiniGameData() then
		return
	end

	if arg0:GetMGData():GetRuntimeData("serverGold") >= arg0:GetMGData():getConfig("simple_config_data").target then
		arg0.activityWitch = true

		setActive(arg0.witchImg, true)
	end
end

function var0.isInitedMiniGameData(arg0)
	if not arg0:GetMGData():GetRuntimeData("isInited") then
		return false
	else
		return true
	end
end

return var0
