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

function var0_0.getResource(arg0_8)
	local var0_8 = var0_0.super.getResource(arg0_8)
	local var1_8 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var1_8 then
		local var2_8 = pg.battlepass_event_pt[var1_8.id]
		local var3_8 = {
			var2_8.crusing_map and "crusingmap/" .. var2_8.crusing_map,
			var2_8.spine_name and "char/" .. var2_8.spine_name
		}

		for iter0_8, iter1_8 in ipairs(var3_8) do
			if noEmptyStr(iter1_8) and not table.contains(var0_8, iter1_8) then
				table.insert(var0_8, iter1_8)
			end
		end
	end

	return var0_8
end

function var0_0.init(arg0_9)
	arg0_9.rtBg = arg0_9._tf:Find("bg")
	arg0_9.scrollMap = arg0_9.rtBg:Find("map_scroll")
	arg0_9.btnTask = arg0_9.rtBg:Find("task_btn")
	arg0_9.textTip = arg0_9.rtBg:Find("tip")
	arg0_9.rtAward = arg0_9._tf:Find("award_panel")
	arg0_9.textPhase = arg0_9.rtAward:Find("phase/Text")
	arg0_9.sliderPt = arg0_9.rtAward:Find("Slider")
	arg0_9.comScroll = GetComponent(arg0_9.rtAward:Find("view/content"), "LScrollRect")

	function arg0_9.comScroll.onUpdateItem(arg0_10, arg1_10)
		arg0_9:updateAwardInfo(tf(arg1_10), arg0_9.awardList[arg0_10 + 1])
	end

	arg0_9.rtNextAward = arg0_9.rtAward:Find("next")
	arg0_9.btnAll = arg0_9.rtAward:Find("btn_all")
	arg0_9.btnPay = arg0_9.rtAward:Find("btn_pay")
	arg0_9.btnAfter = arg0_9.rtAward:Find("btn_after")
	arg0_9.btnFinish = arg0_9.rtAward:Find("btn_finish")
	arg0_9.rtTop = arg0_9._tf:Find("top")
	arg0_9.btnBack = arg0_9.rtTop:Find("back")
	arg0_9.btnHelp = arg0_9.rtTop:Find("help")
	arg0_9.textDay = arg0_9.rtTop:Find("day/Text")
	arg0_9.chargeTipWindow = ChargeTipWindow.New(arg0_9._tf, arg0_9.event)
	arg0_9.LTDic = {}
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.btnBack, function()
		arg0_11:closeView()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.btnTask, function()
		if arg0_11.phase < #arg0_11.awardList then
			arg0_11:emit(CrusingMediator.EVENT_OPEN_TASK)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_complete"))
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.btnAll, function()
		local var0_14 = arg0_11.activity:GetCrusingUnreceiveAward()

		if #var0_14 > 0 then
			local var1_14 = {}

			if arg0_11:checkLimitMax(var0_14) then
				table.insert(var1_14, function(arg0_15)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("player_expResource_mail_fullBag"),
						onYes = arg0_15
					})
				end)
			end

			seriesAsync(var1_14, function()
				arg0_11:emit(CrusingMediator.EVENT_GET_AWARD_ALL)
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0_11, arg0_11.btnPay, function()
		arg0_11:openBuyPanel()
	end, SFX_CONFIRM)
	onButton(arg0_11, arg0_11.btnAfter, function()
		local var0_18 = arg0_11.activity:GetCrusingUnreceiveAward()

		if #var0_18 > 0 then
			local var1_18 = {}

			if arg0_11:checkLimitMax(var0_18) then
				table.insert(var1_18, function(arg0_19)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("player_expResource_mail_fullBag"),
						onYes = arg0_19
					})
				end)
			end

			seriesAsync(var1_18, function()
				arg0_11:emit(CrusingMediator.EVENT_GET_AWARD_ALL)
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0_11, arg0_11.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("battlepass_main_help_" .. pg.battlepass_event_pt[arg0_11.activity.id].map_name)
		})
	end, SFX_PANEL)

	local function var0_11(arg0_22)
		local var0_22 = {
			_tf = arg0_22,
			rtLine = arg0_22:Find("line"),
			rtIcon = arg0_22:Find("icon"),
			rtSimple = arg0_22:Find("simple")
		}

		setParent(arg0_22, arg0_11.scrollMap)
		SetCompomentEnabled(arg0_22, typeof(Image), false)

		arg0_22.name = "map_tpl"

		SetAction(var0_22.rtIcon:Find("model"):GetChild(0), "normal")

		return var0_22
	end

	arg0_11.maps = {
		var0_11(arg0_11.rtMap)
	}

	while #arg0_11.maps < 3 do
		table.insert(arg0_11.maps, var0_11(tf(Instantiate(arg0_11.rtMap))))
	end

	Canvas.ForceUpdateCanvases()

	for iter0_11, iter1_11 in ipairs(arg0_11.maps) do
		setParent(iter1_11.rtLine, arg0_11.scrollMap:Find("bg"), true)
	end

	GetComponent(arg0_11.textTip, "RichText"):AddSprite("pt", GetSpriteFromAtlas(Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_11.ptId
	}):getIcon(), ""))
	setText(arg0_11.textTip, i18n("battlepass_main_tip_" .. pg.battlepass_event_pt[arg0_11.activity.id].map_name))

	local var1_11 = arg0_11.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	setText(arg0_11.textDay, i18n("battlepass_main_time", math.floor(var1_11 / 86400), math.floor(var1_11 % 86400 / 3600)))

	local var2_11 = GetComponent(arg0_11.scrollMap, typeof(ScrollRect))
	local var3_11 = var2_11.content.rect.width
	local var4_11 = var2_11.viewport.rect.width
	local var5_11 = var3_11 / 3 / (var3_11 - var4_11)

	onScroll(arg0_11, arg0_11.scrollMap, function(arg0_23)
		if arg0_23.x < 0.1 then
			local var0_23 = var2_11.velocity
			local var1_23 = var2_11.normalizedPosition

			var1_23.x = arg0_23.x + var5_11
			var2_11.normalizedPosition = var1_23
			var2_11.velocity = var0_23
		elseif arg0_23.x > 0.9 then
			local var2_23 = var2_11.velocity
			local var3_23 = var2_11.normalizedPosition

			var3_23.x = arg0_23.x - var5_11
			var2_11.normalizedPosition = var3_23
			var2_11.velocity = var2_23
		end
	end)
	arg0_11:onScroll(arg0_11.comScroll, function(arg0_24)
		arg0_11:updateNextAward(arg0_24.y)
	end)
	arg0_11:updateAwardPanel()
	arg0_11:buildPhaseAwardScrollPos()

	if arg0_11.phase == 0 then
		arg0_11.comScroll:ScrollTo(0)
	elseif arg0_11.phase == #arg0_11.awardList then
		arg0_11.comScroll:ScrollTo(1)
	else
		arg0_11.comScroll:ScrollTo(math.clamp(arg0_11.phasePos[arg0_11.phase], 0, 1))
	end

	arg0_11:updateMapStatus()
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_11.ptId
	}):getIcon(), "", arg0_11.sliderPt:Find("Text/icon"), true)
	arg0_11:updateMapWay()
end

function var0_0.willExit(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.LTDic) do
		if iter1_25 then
			LeanTween.cancel(iter0_25)
		end
	end

	local var0_25 = PoolMgr.GetInstance()
	local var1_25 = pg.battlepass_event_pt[arg0_25.activity.id].crusing_map
	local var2_25 = pg.battlepass_event_pt[arg0_25.activity.id].spine_name

	for iter2_25, iter3_25 in ipairs(arg0_25.maps) do
		setParent(iter3_25.rtLine, iter3_25._tf, true)
		var0_25:ReturnSpineChar(var2_25, go(iter3_25.rtIcon:Find("model"):GetChild(0)))
		var0_25:ReturnPrefab("crusingmap/" .. var1_25, "", go(iter3_25._tf))
	end

	if arg0_25.chargeTipWindow then
		arg0_25.chargeTipWindow:Destroy()

		arg0_25.chargeTipWindow = nil
	end
end

function var0_0.setActivity(arg0_26, arg1_26)
	arg0_26.activity = arg1_26

	for iter0_26, iter1_26 in pairs(arg1_26:GetCrusingInfo()) do
		arg0_26[iter0_26] = iter1_26
	end
end

function var0_0.setPlayer(arg0_27, arg1_27)
	arg0_27.player = arg1_27
end

function var0_0.updateAwardInfo(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28.pt <= arg0_28.pt

	if arg1_28:Find("mask") then
		setActive(arg1_28:Find("mask"), not var0_28)
	end

	setText(arg1_28:Find("Text"), arg2_28.id)

	local var1_28 = Drop.Create(arg2_28.award)

	updateDrop(arg1_28:Find("award"), var1_28)
	setActive(arg1_28:Find("award/get"), var0_28 and not arg0_28.awardDic[arg2_28.pt])
	setActive(arg1_28:Find("award/got"), arg0_28.awardDic[arg2_28.pt])
	setActive(arg1_28:Find("award/mask"), arg0_28.awardDic[arg2_28.pt])
	onButton(arg0_28, arg1_28:Find("award"), function()
		arg0_28:emit(var0_0.ON_DROP, var1_28)
	end, SFX_CONFIRM)

	local var2_28 = Drop.Create(arg2_28.award_pay)

	updateDrop(arg1_28:Find("award_pay"), var2_28)
	setActive(arg1_28:Find("award_pay/lock"), not arg0_28.isPay)
	setActive(arg1_28:Find("award_pay/get"), arg0_28.isPay and var0_28 and not arg0_28.awardPayDic[arg2_28.pt])
	setActive(arg1_28:Find("award_pay/got"), arg0_28.awardPayDic[arg2_28.pt])
	setActive(arg1_28:Find("award_pay/mask"), not arg0_28.isPay or arg0_28.awardPayDic[arg2_28.pt])
	onButton(arg0_28, arg1_28:Find("award_pay"), function()
		arg0_28:emit(var0_0.ON_DROP, var2_28)
	end, SFX_CONFIRM)
end

function var0_0.updateAwardPanel(arg0_31)
	setText(arg0_31.textPhase, arg0_31.phase)

	if arg0_31.phase < #arg0_31.awardList then
		local var0_31 = arg0_31.phase == 0 and 0 or arg0_31.awardList[arg0_31.phase].pt
		local var1_31 = arg0_31.pt - var0_31
		local var2_31 = arg0_31.awardList[arg0_31.phase + 1].pt - var0_31

		setSlider(arg0_31.sliderPt, 0, var2_31, var1_31)
		setText(arg0_31.sliderPt:Find("Text"), var1_31 .. "/" .. var2_31)
	else
		setSlider(arg0_31.sliderPt, 0, 1, 1)
		setText(arg0_31.sliderPt:Find("Text"), "MAX")
	end

	arg0_31.nextAward = nil

	arg0_31.comScroll:SetTotalCount(#arg0_31.awardList - 1)
	arg0_31:updateNextAward(arg0_31.comScroll.value)

	local var3_31 = #arg0_31.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0_31.btnAll, not arg0_31.isPay and var3_31)
	setActive(arg0_31.btnPay, not arg0_31.isPay)
	setActive(arg0_31.rtAward:Find("text_image_3"), not arg0_31.isPay)
	setActive(arg0_31.btnFinish, arg0_31.isPay and arg0_31.phase == #arg0_31.awardList and not var3_31)
	setActive(arg0_31.btnAfter, arg0_31.isPay and not isActive(arg0_31.btnFinish))
	setButtonEnabled(arg0_31.btnAfter, var3_31)
end

function var0_0.updateMapStatus(arg0_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.maps) do
		local var0_32
		local var1_32 = {}

		eachChild(iter1_32.rtLine, function(arg0_33)
			local var0_33 = tonumber(arg0_33.name)

			if var0_33 > arg0_32.phase then
				if not var0_32 then
					var0_32 = var0_33

					table.insert(var1_32, arg0_33)
					setActive(arg0_33, true)
				elseif var0_33 < var0_32 then
					while #var1_32 > 0 do
						setActive(table.remove(var1_32), false)
					end

					var0_32 = var0_33

					table.insert(var1_32, arg0_33)
					setActive(arg0_33, true)
				elseif var0_32 == var0_33 then
					table.insert(var1_32, arg0_33)
					setActive(arg0_33, true)
				else
					setActive(arg0_33, false)
				end
			else
				setActive(arg0_33, true)
			end

			local var1_33 = var0_33 > arg0_32.phase

			setGray(arg0_33, not var1_33, false)
			setImageAlpha(arg0_33, var1_33 and 1 or 0.9)

			if isActive(arg0_33) then
				local var2_33

				local function var3_33(arg0_34, arg1_34)
					local var0_34 = getImageSprite(arg0_34)

					if var0_34 then
						setImageSprite(arg1_34, var0_34)
					end

					eachChild(arg0_34, function(arg0_35)
						var3_33(arg0_35, arg1_34:Find(arg0_35.name))
					end)
				end

				local var4_33 = iter1_32.rtSimple:Find(var1_33 and "active" or "gray")

				eachChild(arg0_33, function(arg0_36)
					var3_33(var4_33:Find(arg0_36.name), arg0_36)
				end)
			end
		end)
	end
end

function var0_0.updateMapWay(arg0_37)
	if arg0_37.exited or arg0_37.contextData.frozenMapUpdate then
		return
	end

	local var0_37 = PlayerPrefs.GetInt(string.format("crusing_%d_phase_display", arg0_37.activity.id), 0)

	PlayerPrefs.SetInt(string.format("crusing_%d_phase_display", arg0_37.activity.id), arg0_37.phase)

	for iter0_37, iter1_37 in ipairs(arg0_37.maps) do
		local var1_37 = GetComponent(iter1_37.rtIcon, typeof(Animator))

		if var0_37 < arg0_37.phase then
			local var2_37 = arg0_37.PhaseFrame[var0_37]
			local var3_37 = arg0_37.PhaseFrame[arg0_37.phase]

			var1_37.speed = var0_0.PlaySpeed

			var1_37:Play("empty")
			var1_37:Play("mix", 0, var2_37 / arg0_37.AllFrameCount)

			if iter1_37.rtIcon:Find("model").childCount > 0 then
				SetAction(iter1_37.rtIcon:Find("model"):GetChild(0), "move")
			end

			local var4_37

			var4_37 = LeanTween.delayedCall((var3_37 - var2_37) / var0_0.FrameSpeed / var0_0.PlaySpeed, System.Action(function()
				var1_37.speed = 0

				var1_37:Play("empty")
				var1_37:Play("mix", 0, var3_37 / arg0_37.AllFrameCount)

				arg0_37.LTDic[var4_37] = false

				if iter1_37.rtIcon:Find("model").childCount > 0 then
					SetAction(iter1_37.rtIcon:Find("model"):GetChild(0), "normal")
				end
			end)).uniqueId
			arg0_37.LTDic[var4_37] = true
		else
			var1_37.speed = 0

			var1_37:Play("empty")
			var1_37:Play("mix", 0, arg0_37.PhaseFrame[arg0_37.phase] / arg0_37.AllFrameCount)
		end
	end
end

function var0_0.buildPhaseAwardScrollPos(arg0_39)
	arg0_39.phasePos = {}

	for iter0_39 = 1, #arg0_39.awardList - 1 do
		table.insert(arg0_39.phasePos, arg0_39.comScroll:HeadIndexToValue(iter0_39 - 1))
	end
end

function var0_0.onScroll(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40.onValueChanged

	assert(arg2_40, "callback should exist")
	var0_40:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_40, var0_40)
	var0_40:AddListener(arg2_40)
end

function var0_0.updateNextAward(arg0_41, arg1_41)
	if not arg0_41.phasePos then
		return
	end

	local var0_41 = arg0_41.phasePos[#arg0_41.phasePos] - 1
	local var1_41 = #arg0_41.awardList

	for iter0_41 = var1_41 - 1, 1, -1 do
		local var2_41 = arg0_41.awardList[iter0_41]

		if arg0_41.phasePos[iter0_41] < arg1_41 + var0_41 or var2_41.pt <= arg0_41.pt then
			break
		elseif var2_41.isImportent then
			var1_41 = iter0_41
		end
	end

	if arg0_41.nextAward ~= var1_41 then
		arg0_41.nextAward = var1_41

		arg0_41:updateAwardInfo(arg0_41.rtNextAward, arg0_41.awardList[var1_41])
	end
end

function var0_0.checkLimitMax(arg0_42, arg1_42)
	local var0_42 = arg0_42.player

	for iter0_42, iter1_42 in ipairs(arg1_42) do
		if iter1_42.type == DROP_TYPE_RESOURCE then
			if iter1_42.id == 1 then
				if var0_42:GoldMax(iter1_42.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_42.id == 2 and var0_42:OilMax(iter1_42.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_42.type == DROP_TYPE_ITEM then
			local var1_42 = Item.getConfigData(iter1_42.id)

			if var1_42.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_42.id) + iter1_42.count > var1_42.max_num then
				return true
			end
		end
	end

	return false
end

function var0_0.openBuyPanel(arg0_43)
	local var0_43 = arg0_43:getPassID()
	local var1_43 = Goods.Create({
		shop_id = var0_43
	}, Goods.TYPE_CHARGE)
	local var2_43 = var1_43:getConfig("tag")
	local var3_43 = var1_43:GetExtraServiceItem()
	local var4_43 = var1_43:GetExtraDrop()
	local var5_43
	local var6_43
	local var7_43
	local var8_43 = i18n("battlepass_pay_tip")
	local var9_43 = {
		isChargeType = true,
		commodity = var1_43,
		infoTip = var1_43:GetInfoTip(),
		icon = "chargeicon/" .. var1_43:getConfig("picture"),
		name = var1_43:getConfig("name_display"),
		tipExtra = var8_43,
		extraItems = var3_43,
		price = var1_43:getConfig("money"),
		isLocalPrice = var1_43:IsLocalPrice(),
		tagType = var2_43,
		isMonthCard = var1_43:isMonthCard(),
		tipBonus = var7_43,
		bonusItem = var5_43,
		extraDrop = var4_43,
		descExtra = var1_43:getConfig("descrip_extra"),
		onYes = function()
			if ChargeConst.isNeedSetBirth() then
				arg0_43:emit(CrusingMediator.EVENT_OPEN_BIRTHDAY)
			else
				pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
					shopId = var1_43.id
				})
			end
		end
	}

	arg0_43:emit(CrusingMediator.EVENT_GO_CHARGE, var9_43)
end

function var0_0.getPassID(arg0_45)
	local var0_45 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_45 and not var0_45:isEnd() then
		for iter0_45, iter1_45 in ipairs(pg.pay_data_display.all) do
			local var1_45 = pg.pay_data_display[iter1_45]

			if var1_45.sub_display and type(var1_45.sub_display) == "table" and var1_45.sub_display[1] == var0_45.id then
				return iter1_45
			end
		end
	end
end

function var0_0.OnChargeSuccess(arg0_46, arg1_46)
	arg0_46.chargeTipWindow:ExecuteAction("Show", arg1_46)
end

return var0_0
