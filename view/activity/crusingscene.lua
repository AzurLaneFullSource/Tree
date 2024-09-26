local var0_0 = class("CrusingScene", import("view.base.BaseUI"))

var0_0.optionsPath = {
	"top/home"
}
var0_0.FrameSpeed = 10
var0_0.PlaySpeed = 1.5

function var0_0.getUIName(arg0_1)
	return "CrusingUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var1_2 = PoolMgr.GetInstance()
	local var2_2 = {}

	table.insert(var2_2, function(arg0_3)
		local var0_3 = pg.battlepass_event_pt[var0_2.id].crusing_map

		var1_2:GetPrefab("crusingmap/" .. var0_3, "", true, function(arg0_4)
			arg0_2.rtMap = tf(arg0_4)
			arg0_2.PhaseFrame, arg0_2.AllFrameCount = CrusingMapInfo.GetPhaseFrame(var0_3)

			arg0_3()
		end)
	end)
	table.insert(var2_2, function(arg0_5)
		var1_2:GetSpineChar(pg.battlepass_event_pt[var0_2.id].spine_name, true, function(arg0_6)
			arg0_2.rtModel = tf(arg0_6)

			arg0_5()
		end)
	end)
	parallelAsync(var2_2, function()
		setParent(arg0_2.rtModel, arg0_2.rtMap:Find("icon/model"))

		arg0_2.rtModel.localScale = Vector3.one

		arg1_2()
	end)
end

function var0_0.init(arg0_8)
	arg0_8.rtBg = arg0_8._tf:Find("bg")
	arg0_8.scrollMap = arg0_8.rtBg:Find("map_scroll")
	arg0_8.btnTask = arg0_8.rtBg:Find("task_btn")
	arg0_8.textTip = arg0_8.rtBg:Find("tip")
	arg0_8.rtAward = arg0_8._tf:Find("award_panel")
	arg0_8.textPhase = arg0_8.rtAward:Find("phase/Text")
	arg0_8.sliderPt = arg0_8.rtAward:Find("Slider")
	arg0_8.comScroll = GetComponent(arg0_8.rtAward:Find("view/content"), "LScrollRect")

	function arg0_8.comScroll.onUpdateItem(arg0_9, arg1_9)
		arg0_8:updateAwardInfo(tf(arg1_9), arg0_8.awardList[arg0_9 + 1])
	end

	arg0_8.rtNextAward = arg0_8.rtAward:Find("next")
	arg0_8.btnAll = arg0_8.rtAward:Find("btn_all")
	arg0_8.btnPay = arg0_8.rtAward:Find("btn_pay")
	arg0_8.btnAfter = arg0_8.rtAward:Find("btn_after")
	arg0_8.btnFinish = arg0_8.rtAward:Find("btn_finish")
	arg0_8.rtTop = arg0_8._tf:Find("top")
	arg0_8.btnBack = arg0_8.rtTop:Find("back")
	arg0_8.btnHelp = arg0_8.rtTop:Find("help")
	arg0_8.textDay = arg0_8.rtTop:Find("day/Text")
	arg0_8.chargeTipWindow = ChargeTipWindow.New(arg0_8._tf, arg0_8.event)
	arg0_8.LTDic = {}
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.btnBack, function()
		arg0_10:closeView()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.btnTask, function()
		if arg0_10.phase < #arg0_10.awardList then
			arg0_10:emit(CrusingMediator.EVENT_OPEN_TASK)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_complete"))
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.btnAll, function()
		local var0_13 = arg0_10.activity:GetCrusingUnreceiveAward()

		if #var0_13 > 0 then
			local var1_13 = {}

			if arg0_10:checkLimitMax(var0_13) then
				table.insert(var1_13, function(arg0_14)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("player_expResource_mail_fullBag"),
						onYes = arg0_14
					})
				end)
			end

			seriesAsync(var1_13, function()
				arg0_10:emit(CrusingMediator.EVENT_GET_AWARD_ALL)
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0_10, arg0_10.btnPay, function()
		arg0_10:openBuyPanel()
	end, SFX_CONFIRM)
	onButton(arg0_10, arg0_10.btnAfter, function()
		local var0_17 = arg0_10.activity:GetCrusingUnreceiveAward()

		if #var0_17 > 0 then
			local var1_17 = {}

			if arg0_10:checkLimitMax(var0_17) then
				table.insert(var1_17, function(arg0_18)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("player_expResource_mail_fullBag"),
						onYes = arg0_18
					})
				end)
			end

			seriesAsync(var1_17, function()
				arg0_10:emit(CrusingMediator.EVENT_GET_AWARD_ALL)
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0_10, arg0_10.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("battlepass_main_help_" .. pg.battlepass_event_pt[arg0_10.activity.id].map_name)
		})
	end, SFX_PANEL)

	local function var0_10(arg0_21)
		local var0_21 = {
			_tf = arg0_21,
			rtLine = arg0_21:Find("line"),
			rtIcon = arg0_21:Find("icon"),
			rtSimple = arg0_21:Find("simple")
		}

		setParent(arg0_21, arg0_10.scrollMap)
		SetCompomentEnabled(arg0_21, typeof(Image), false)

		arg0_21.name = "map_tpl"

		SetAction(var0_21.rtIcon:Find("model"):GetChild(0), "normal")

		return var0_21
	end

	arg0_10.maps = {
		var0_10(arg0_10.rtMap)
	}

	while #arg0_10.maps < 3 do
		table.insert(arg0_10.maps, var0_10(tf(Instantiate(arg0_10.rtMap))))
	end

	Canvas.ForceUpdateCanvases()

	for iter0_10, iter1_10 in ipairs(arg0_10.maps) do
		setParent(iter1_10.rtLine, arg0_10.scrollMap:Find("bg"), true)
	end

	GetComponent(arg0_10.textTip, "RichText"):AddSprite("pt", GetSpriteFromAtlas(Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_10.ptId
	}):getIcon(), ""))
	setText(arg0_10.textTip, i18n("battlepass_main_tip_" .. pg.battlepass_event_pt[arg0_10.activity.id].map_name))

	local var1_10 = arg0_10.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	setText(arg0_10.textDay, i18n("battlepass_main_time", math.floor(var1_10 / 86400), math.floor(var1_10 % 86400 / 3600)))

	local var2_10 = GetComponent(arg0_10.scrollMap, typeof(ScrollRect))
	local var3_10 = var2_10.content.rect.width
	local var4_10 = var2_10.viewport.rect.width
	local var5_10 = var3_10 / 3 / (var3_10 - var4_10)

	onScroll(arg0_10, arg0_10.scrollMap, function(arg0_22)
		if arg0_22.x < 0.1 then
			local var0_22 = var2_10.velocity
			local var1_22 = var2_10.normalizedPosition

			var1_22.x = arg0_22.x + var5_10
			var2_10.normalizedPosition = var1_22
			var2_10.velocity = var0_22
		elseif arg0_22.x > 0.9 then
			local var2_22 = var2_10.velocity
			local var3_22 = var2_10.normalizedPosition

			var3_22.x = arg0_22.x - var5_10
			var2_10.normalizedPosition = var3_22
			var2_10.velocity = var2_22
		end
	end)
	arg0_10:onScroll(arg0_10.comScroll, function(arg0_23)
		arg0_10:updateNextAward(arg0_23.y)
	end)
	arg0_10:updateAwardPanel()
	arg0_10:buildPhaseAwardScrollPos()

	if arg0_10.phase == 0 then
		arg0_10.comScroll:ScrollTo(0)
	elseif arg0_10.phase == #arg0_10.awardList then
		arg0_10.comScroll:ScrollTo(1)
	else
		arg0_10.comScroll:ScrollTo(math.clamp(arg0_10.phasePos[arg0_10.phase], 0, 1))
	end

	arg0_10:updateMapStatus()
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_10.ptId
	}):getIcon(), "", arg0_10.sliderPt:Find("Text/icon"), true)
	arg0_10:updateMapWay()
end

function var0_0.willExit(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.LTDic) do
		if iter1_24 then
			LeanTween.cancel(iter0_24)
		end
	end

	local var0_24 = PoolMgr.GetInstance()
	local var1_24 = pg.battlepass_event_pt[arg0_24.activity.id].crusing_map
	local var2_24 = pg.battlepass_event_pt[arg0_24.activity.id].spine_name

	for iter2_24, iter3_24 in ipairs(arg0_24.maps) do
		setParent(iter3_24.rtLine, iter3_24._tf, true)
		var0_24:ReturnSpineChar(var2_24, go(iter3_24.rtIcon:Find("model"):GetChild(0)))
		var0_24:ReturnPrefab("crusingmap/" .. var1_24, "", go(iter3_24._tf))
	end

	if arg0_24.chargeTipWindow then
		arg0_24.chargeTipWindow:Destroy()

		arg0_24.chargeTipWindow = nil
	end
end

function var0_0.setActivity(arg0_25, arg1_25)
	arg0_25.activity = arg1_25

	for iter0_25, iter1_25 in pairs(arg1_25:GetCrusingInfo()) do
		arg0_25[iter0_25] = iter1_25
	end
end

function var0_0.setPlayer(arg0_26, arg1_26)
	arg0_26.player = arg1_26
end

function var0_0.updateAwardInfo(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg2_27.pt <= arg0_27.pt

	if arg1_27:Find("mask") then
		setActive(arg1_27:Find("mask"), not var0_27)
	end

	setText(arg1_27:Find("Text"), arg2_27.id)

	local var1_27 = Drop.Create(arg2_27.award)

	updateDrop(arg1_27:Find("award"), var1_27)
	setActive(arg1_27:Find("award/get"), var0_27 and not arg0_27.awardDic[arg2_27.pt])
	setActive(arg1_27:Find("award/got"), arg0_27.awardDic[arg2_27.pt])
	setActive(arg1_27:Find("award/mask"), arg0_27.awardDic[arg2_27.pt])
	onButton(arg0_27, arg1_27:Find("award"), function()
		arg0_27:emit(var0_0.ON_DROP, var1_27)
	end, SFX_CONFIRM)

	local var2_27 = Drop.Create(arg2_27.award_pay)

	updateDrop(arg1_27:Find("award_pay"), var2_27)
	setActive(arg1_27:Find("award_pay/lock"), not arg0_27.isPay)
	setActive(arg1_27:Find("award_pay/get"), arg0_27.isPay and var0_27 and not arg0_27.awardPayDic[arg2_27.pt])
	setActive(arg1_27:Find("award_pay/got"), arg0_27.awardPayDic[arg2_27.pt])
	setActive(arg1_27:Find("award_pay/mask"), not arg0_27.isPay or arg0_27.awardPayDic[arg2_27.pt])
	onButton(arg0_27, arg1_27:Find("award_pay"), function()
		arg0_27:emit(var0_0.ON_DROP, var2_27)
	end, SFX_CONFIRM)
end

function var0_0.updateAwardPanel(arg0_30)
	setText(arg0_30.textPhase, arg0_30.phase)

	if arg0_30.phase < #arg0_30.awardList then
		local var0_30 = arg0_30.phase == 0 and 0 or arg0_30.awardList[arg0_30.phase].pt
		local var1_30 = arg0_30.pt - var0_30
		local var2_30 = arg0_30.awardList[arg0_30.phase + 1].pt - var0_30

		setSlider(arg0_30.sliderPt, 0, var2_30, var1_30)
		setText(arg0_30.sliderPt:Find("Text"), var1_30 .. "/" .. var2_30)
	else
		setSlider(arg0_30.sliderPt, 0, 1, 1)
		setText(arg0_30.sliderPt:Find("Text"), "MAX")
	end

	arg0_30.nextAward = nil

	arg0_30.comScroll:SetTotalCount(#arg0_30.awardList - 1)
	arg0_30:updateNextAward(arg0_30.comScroll.value)

	local var3_30 = #arg0_30.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0_30.btnAll, not arg0_30.isPay and var3_30)
	setActive(arg0_30.btnPay, not arg0_30.isPay)
	setActive(arg0_30.rtAward:Find("text_image_3"), not arg0_30.isPay)
	setActive(arg0_30.btnFinish, arg0_30.isPay and arg0_30.phase == #arg0_30.awardList and not var3_30)
	setActive(arg0_30.btnAfter, arg0_30.isPay and not isActive(arg0_30.btnFinish))
	setButtonEnabled(arg0_30.btnAfter, var3_30)
end

function var0_0.updateMapStatus(arg0_31)
	for iter0_31, iter1_31 in ipairs(arg0_31.maps) do
		local var0_31
		local var1_31 = {}

		eachChild(iter1_31.rtLine, function(arg0_32)
			local var0_32 = tonumber(arg0_32.name)

			if var0_32 > arg0_31.phase then
				if not var0_31 then
					var0_31 = var0_32

					table.insert(var1_31, arg0_32)
					setActive(arg0_32, true)
				elseif var0_32 < var0_31 then
					while #var1_31 > 0 do
						setActive(table.remove(var1_31), false)
					end

					var0_31 = var0_32

					table.insert(var1_31, arg0_32)
					setActive(arg0_32, true)
				elseif var0_31 == var0_32 then
					table.insert(var1_31, arg0_32)
					setActive(arg0_32, true)
				else
					setActive(arg0_32, false)
				end
			else
				setActive(arg0_32, true)
			end

			local var1_32 = var0_32 > arg0_31.phase

			setGray(arg0_32, not var1_32, false)
			setImageAlpha(arg0_32, var1_32 and 1 or 0.9)

			if isActive(arg0_32) then
				local var2_32

				local function var3_32(arg0_33, arg1_33)
					local var0_33 = getImageSprite(arg0_33)

					if var0_33 then
						setImageSprite(arg1_33, var0_33)
					end

					eachChild(arg0_33, function(arg0_34)
						var3_32(arg0_34, arg1_33:Find(arg0_34.name))
					end)
				end

				local var4_32 = iter1_31.rtSimple:Find(var1_32 and "active" or "gray")

				eachChild(arg0_32, function(arg0_35)
					var3_32(var4_32:Find(arg0_35.name), arg0_35)
				end)
			end
		end)
	end
end

function var0_0.updateMapWay(arg0_36)
	if arg0_36.exited or arg0_36.contextData.frozenMapUpdate then
		return
	end

	local var0_36 = PlayerPrefs.GetInt(string.format("crusing_%d_phase_display", arg0_36.activity.id), 0)

	PlayerPrefs.SetInt(string.format("crusing_%d_phase_display", arg0_36.activity.id), arg0_36.phase)

	for iter0_36, iter1_36 in ipairs(arg0_36.maps) do
		local var1_36 = GetComponent(iter1_36.rtIcon, typeof(Animator))

		if var0_36 < arg0_36.phase then
			local var2_36 = arg0_36.PhaseFrame[var0_36]
			local var3_36 = arg0_36.PhaseFrame[arg0_36.phase]

			var1_36.speed = var0_0.PlaySpeed

			var1_36:Play("empty")
			var1_36:Play("mix", 0, var2_36 / arg0_36.AllFrameCount)

			if iter1_36.rtIcon:Find("model").childCount > 0 then
				SetAction(iter1_36.rtIcon:Find("model"):GetChild(0), "move")
			end

			local var4_36

			var4_36 = LeanTween.delayedCall((var3_36 - var2_36) / var0_0.FrameSpeed / var0_0.PlaySpeed, System.Action(function()
				var1_36.speed = 0

				var1_36:Play("empty")
				var1_36:Play("mix", 0, var3_36 / arg0_36.AllFrameCount)

				arg0_36.LTDic[var4_36] = false

				if iter1_36.rtIcon:Find("model").childCount > 0 then
					SetAction(iter1_36.rtIcon:Find("model"):GetChild(0), "normal")
				end
			end)).uniqueId
			arg0_36.LTDic[var4_36] = true
		else
			var1_36.speed = 0

			var1_36:Play("empty")
			var1_36:Play("mix", 0, arg0_36.PhaseFrame[arg0_36.phase] / arg0_36.AllFrameCount)
		end
	end
end

function var0_0.buildPhaseAwardScrollPos(arg0_38)
	arg0_38.phasePos = {}

	for iter0_38 = 1, #arg0_38.awardList - 1 do
		table.insert(arg0_38.phasePos, arg0_38.comScroll:HeadIndexToValue(iter0_38 - 1))
	end
end

function var0_0.onScroll(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39.onValueChanged

	assert(arg2_39, "callback should exist")
	var0_39:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_39, var0_39)
	var0_39:AddListener(arg2_39)
end

function var0_0.updateNextAward(arg0_40, arg1_40)
	if not arg0_40.phasePos then
		return
	end

	local var0_40 = arg0_40.phasePos[#arg0_40.phasePos] - 1
	local var1_40 = #arg0_40.awardList

	for iter0_40 = var1_40 - 1, 1, -1 do
		local var2_40 = arg0_40.awardList[iter0_40]

		if arg0_40.phasePos[iter0_40] < arg1_40 + var0_40 or var2_40.pt <= arg0_40.pt then
			break
		elseif var2_40.isImportent then
			var1_40 = iter0_40
		end
	end

	if arg0_40.nextAward ~= var1_40 then
		arg0_40.nextAward = var1_40

		arg0_40:updateAwardInfo(arg0_40.rtNextAward, arg0_40.awardList[var1_40])
	end
end

function var0_0.checkLimitMax(arg0_41, arg1_41)
	local var0_41 = arg0_41.player

	for iter0_41, iter1_41 in ipairs(arg1_41) do
		if iter1_41.type == DROP_TYPE_RESOURCE then
			if iter1_41.id == 1 then
				if var0_41:GoldMax(iter1_41.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_41.id == 2 and var0_41:OilMax(iter1_41.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_41.type == DROP_TYPE_ITEM then
			local var1_41 = Item.getConfigData(iter1_41.id)

			if var1_41.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_41.id) + iter1_41.count > var1_41.max_num then
				return true
			end
		end
	end

	return false
end

function var0_0.openBuyPanel(arg0_42)
	local var0_42 = arg0_42:getPassID()
	local var1_42 = Goods.Create({
		shop_id = var0_42
	}, Goods.TYPE_CHARGE)
	local var2_42 = var1_42:getConfig("tag")
	local var3_42 = var1_42:GetExtraServiceItem()
	local var4_42 = var1_42:GetExtraDrop()
	local var5_42
	local var6_42
	local var7_42
	local var8_42 = i18n("battlepass_pay_tip")
	local var9_42 = {
		isChargeType = true,
		icon = "chargeicon/" .. var1_42:getConfig("picture"),
		name = var1_42:getConfig("name_display"),
		tipExtra = var8_42,
		extraItems = var3_42,
		price = var1_42:getConfig("money"),
		isLocalPrice = var1_42:IsLocalPrice(),
		tagType = var2_42,
		isMonthCard = var1_42:isMonthCard(),
		tipBonus = var7_42,
		bonusItem = var5_42,
		extraDrop = var4_42,
		descExtra = var1_42:getConfig("descrip_extra"),
		onYes = function()
			if ChargeConst.isNeedSetBirth() then
				arg0_42:emit(CrusingMediator.EVENT_OPEN_BIRTHDAY)
			else
				pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
					shopId = var1_42.id
				})
			end
		end
	}

	arg0_42:emit(CrusingMediator.EVENT_GO_CHARGE, var9_42)
end

function var0_0.getPassID(arg0_44)
	local var0_44 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_44 and not var0_44:isEnd() then
		for iter0_44, iter1_44 in ipairs(pg.pay_data_display.all) do
			local var1_44 = pg.pay_data_display[iter1_44]

			if var1_44.sub_display and type(var1_44.sub_display) == "table" and var1_44.sub_display[1] == var0_44.id then
				return iter1_44
			end
		end
	end
end

function var0_0.OnChargeSuccess(arg0_45, arg1_45)
	arg0_45.chargeTipWindow:ExecuteAction("Show", arg1_45)
end

return var0_0
