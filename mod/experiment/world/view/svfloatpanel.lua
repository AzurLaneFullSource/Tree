local var0_0 = class("SVFloatPanel", import("view.base.BaseSubView"))

var0_0.ShowView = "SVFloatPanel.ShowView"
var0_0.HideView = "SVFloatPanel.HideView"
var0_0.ReturnCall = "SVFloatPanel.ReturnCall"
var0_0.DelegateCall = "SVFloatPanel.DelegateCall"

function var0_0.getUIName(arg0_1)
	return "SVFloatPanel"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.rtBasePoint = arg0_3._tf:Find("point")
	arg0_3.rtInfoPanel = arg0_3.rtBasePoint:Find("line/bg")
	arg0_3.rtMarking = arg0_3.rtInfoPanel:Find("icon/marking")
	arg0_3.rtRes = arg0_3._tf:Find("res")
	arg0_3.awardItemList = UIItemList.New(arg0_3.rtInfoPanel:Find("pressing_award"), arg0_3.rtInfoPanel:Find("pressing_award/award_tpl"))

	arg0_3.awardItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.awardConfig[arg1_4 + 1]
			local var1_4 = {
				type = var0_4[1],
				id = var0_4[2],
				count = var0_4[3]
			}

			updateDrop(arg2_4:Find("IconTpl"), var1_4)
			onButton(arg0_3, arg2_4:Find("IconTpl"), function()
				arg0_3:emit(BaseUI.ON_DROP, var1_4)
			end, SFX_PANEL)

			local var2_4 = arg0_3.mapList[arg0_3.destIndex]

			setActive(arg2_4:Find("is_pressing"), var2_4.isPressing)
			setActive(arg2_4:Find("IconTpl"), not var2_4.isPressing)
		end
	end)

	arg0_3.btnBack = arg0_3.rtInfoPanel:Find("back")

	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:emit(WorldScene.SceneOp, "OpSetInMap", true)
	end, SFX_CONFIRM)

	arg0_3.btnEnter = arg0_3.rtInfoPanel:Find("enter")

	onButton(arg0_3, arg0_3.btnEnter, function()
		local var0_7 = {}
		local var1_7 = arg0_3.mapList[arg0_3.destIndex]

		if WorldConst.HasDangerConfirm(var1_7.config.entrance_ui) then
			table.insert(var0_7, function(arg0_8)
				arg0_3:emit(WorldScene.SceneOp, "OpCall", function(arg0_9)
					arg0_9()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_map_dangerous_confirm"),
						onYes = arg0_8
					})
				end)
			end)
		end

		seriesAsync(var0_7, function()
			local var0_10 = nowWorld().staminaMgr

			if not var1_7.isCost and var1_7.config.enter_cost > var0_10:GetTotalStamina() then
				var0_10:Show()
			else
				arg0_3:emit(WorldScene.SceneOp, "OpTransport", arg0_3.entrance, var1_7)
			end
		end)
	end, SFX_CONFIRM)

	arg0_3.btnDelegate = arg0_3.btnEnter:Find("delegate")

	onButton(arg0_3, arg0_3.btnDelegate, function()
		local var0_11 = arg0_3.mapList[arg0_3.destIndex]

		arg0_3:emit(var0_0.DelegateCall, var0_11.id)
	end, SFX_PANEL)
	setText(arg0_3.btnDelegate:Find("lock/Text"), i18n("world_auto_buy_unlock"))

	arg0_3.btnLock = arg0_3.rtInfoPanel:Find("lock")
	arg0_3.btnReturn = arg0_3.rtInfoPanel:Find("return")

	onButton(arg0_3, arg0_3.btnReturn, function()
		arg0_3:emit(var0_0.ReturnCall, arg0_3.entrance)
	end, SFX_CONFIRM)

	arg0_3.btnSwitch = arg0_3.rtInfoPanel:Find("switch")

	onButton(arg0_3, arg0_3.btnSwitch, function()
		if arg0_3.isTweening then
			return
		end

		arg0_3:ShowToggleMask()
	end, SFX_PANEL)

	arg0_3.rtSelectMask = arg0_3._tf:Find("select_mask")

	onButton(arg0_3, arg0_3.rtSelectMask:Find("bg"), function()
		if arg0_3.isTweening then
			return
		end

		arg0_3:HideToggleMask()
	end, SFX_PANEL)

	arg0_3.rtMaskMarking = arg0_3.rtSelectMask:Find("marking")
	arg0_3.rtToggles = arg0_3.rtMaskMarking:Find("toggles")
	arg0_3.toggleItemList = UIItemList.New(arg0_3.rtToggles, arg0_3.rtToggles:Find("toggle"))

	arg0_3.toggleItemList:make(function(arg0_15, arg1_15, arg2_15)
		arg1_15 = arg1_15 + 1

		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_3.mapList[arg1_15]
			local var1_15, var2_15 = World.ReplacementMapType(arg0_3.entrance, var0_15)

			setText(arg2_15:Find("Text"), var2_15)
			onToggle(arg0_3, arg2_15, function(arg0_16)
				if arg0_16 then
					arg0_3:HideToggleMask()

					arg0_3.destIndex = arg1_15

					arg0_3:UpdatePanel()
				end
			end, SFX_PANEL)
			triggerToggle(arg2_15, false)
		end
	end)
end

function var0_0.OnDestroy(arg0_17)
	return
end

function var0_0.Show(arg0_18)
	setActive(arg0_18._tf, true)
end

function var0_0.Hide(arg0_19)
	setActive(arg0_19._tf, false)
end

function var0_0.Setup(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	arg0_20.entrance = arg1_20

	local var0_20 = arg4_20:GetMapScreenPos(Vector2(arg1_20.config.area_pos[1], arg1_20.config.area_pos[2]))

	setAnchoredPosition(arg0_20.rtBasePoint, arg0_20._tf:InverseTransformPoint(GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)):ScreenToWorldPoint(var0_20)))

	arg0_20.mapList = nowWorld():EntranceToReplacementMapList(arg1_20)

	local function var1_20()
		if arg2_20 then
			for iter0_21, iter1_21 in ipairs(arg0_20.mapList) do
				if iter1_21.id == arg2_20 then
					return iter0_21
				end
			end
		end

		if arg3_20 then
			for iter2_21, iter3_21 in ipairs(arg3_20) do
				for iter4_21, iter5_21 in ipairs(arg0_20.mapList) do
					if iter3_21 == World.ReplacementMapType(arg1_20, iter5_21) then
						return iter4_21
					end
				end
			end
		end

		if arg1_20.active then
			for iter6_21, iter7_21 in ipairs(arg0_20.mapList) do
				if iter7_21.active then
					return iter6_21
				end
			end
		end

		return 1
	end

	arg0_20.toggleItemList:align(#arg0_20.mapList)
	triggerToggle(arg0_20.rtToggles:GetChild(var1_20() - 1), true)
end

function var0_0.setColorfulImage(arg0_22, arg1_22, arg2_22, arg3_22)
	arg3_22 = defaultValue(arg3_22, true)

	setImageSprite(arg1_22, getImageSprite(arg0_22.rtRes:Find(arg1_22.name .. "/" .. arg2_22)), arg3_22)
end

function var0_0.UpdatePanel(arg0_23)
	local var0_23 = nowWorld()
	local var1_23 = arg0_23.mapList[arg0_23.destIndex]
	local var2_23, var3_23 = World.ReplacementMapType(arg0_23.entrance, var1_23)
	local var4_23 = var2_23 == "complete_chapter" and "safe" or WorldConst.GetMapIconState(var1_23.config.entrance_ui)
	local var5_23 = var1_23:IsMapOpen()

	arg0_23:setColorfulImage(arg0_23.rtBasePoint, var4_23)
	arg0_23:setColorfulImage(arg0_23.rtInfoPanel, var4_23, false)

	local var6_23 = GetSpriteFromAtlas("world/mapicon/" .. var1_23.config.entrance_mapicon, "")

	setImageSprite(arg0_23.rtInfoPanel:Find("icon"), var6_23)
	arg0_23:setColorfulImage(arg0_23.btnBack, var4_23)
	arg0_23:setColorfulImage(arg0_23.btnEnter, var4_23)
	arg0_23:setColorfulImage(arg0_23.rtMarking, var4_23)
	arg0_23:setColorfulImage(arg0_23.rtMarking:Find("mark_bg"), var4_23)
	arg0_23:setColorfulImage(arg0_23.rtMaskMarking, var4_23)
	arg0_23:setColorfulImage(arg0_23.rtMaskMarking:Find("mark_bg"), var4_23)
	setText(arg0_23.rtMarking:Find("Text"), var3_23)
	setText(arg0_23.rtMaskMarking:Find("Text"), var3_23)
	setActive(arg0_23.rtInfoPanel:Find("sairen"), var2_23 == "sairen_chapter")
	setText(arg0_23.rtInfoPanel:Find("sairen/Text"), i18n("area_yaosai_2"))
	setText(arg0_23.rtInfoPanel:Find("danger_text"), var5_23 and var1_23:GetDanger() or "?")
	changeToScrollText(arg0_23.rtInfoPanel:Find("title/name"), var1_23:GetName(arg0_23.entrance))

	local var7_23, var8_23, var9_23 = var0_23:CountAchievements(arg0_23.entrance)

	setText(arg0_23.rtInfoPanel:Find("title/achievement/number"), var7_23 + var8_23 .. "/" .. var9_23)

	local var10_23 = var0_23:GetPressingAward(var1_23.id)

	setActive(arg0_23.rtInfoPanel:Find("pressing_award"), var10_23 and var10_23.flag)

	if var10_23 and var10_23.flag then
		arg0_23.awardConfig = pg.world_event_complete[var10_23.id].tips_icon

		arg0_23.awardItemList:align(#arg0_23.awardConfig)
	end

	arg0_23:UpdateCost()
	arg0_23:UpdateDelegate()

	local var11_23 = nowWorld():GetAtlas()
	local var12_23 = var11_23:GetActiveMap()
	local var13_23, var14_23 = var12_23:CkeckTransport()
	local var15_23 = false
	local var16_23 = getProxy(ChapterAutoProxy):HasTypeCommission(ChapterAutoProxy.TYPE.WORLD)

	setActive(arg0_23.btnLock, var16_23)

	if var16_23 then
		setText(arg0_23.btnLock:Find("Text"), i18n("world_auto_plan_in_progress"))
	end

	var15_23 = var15_23 or isActive(arg0_23.btnLock)

	setActive(arg0_23.btnBack, not var15_23 and var11_23:GetActiveEntrance() == arg0_23.entrance and var12_23 == var1_23)

	var15_23 = var15_23 or isActive(arg0_23.btnBack)

	setActive(arg0_23.btnEnter, not var15_23 and var13_23 and var5_23 and var11_23.transportDic[arg0_23.entrance.id])

	var15_23 = var15_23 or isActive(arg0_23.btnEnter)

	if not var16_23 then
		setText(arg0_23.btnLock:Find("Text"), var5_23 and i18n("world_map_locked_border") or i18n("world_map_locked_stage"))
		setActive(arg0_23.btnLock, not var15_23 and var13_23)
	end

	var15_23 = var15_23 or isActive(arg0_23.btnLock)

	setActive(arg0_23.btnReturn, not var15_23)

	local var17_23

	var17_23 = var15_23 or isActive(arg0_23.btnReturn)
end

function var0_0.UpdateCost(arg0_24)
	local var0_24 = arg0_24.mapList[arg0_24.destIndex]
	local var1_24 = arg0_24.btnEnter:Find("cost")

	setActive(var1_24, not var0_24.isCost)

	local var2_24 = nowWorld().staminaMgr:GetTotalStamina()
	local var3_24 = var0_24.config.enter_cost

	setText(var1_24:Find("Text"), setColorStr(var2_24, var2_24 < var3_24 and COLOR_RED or COLOR_GREEN) .. "/" .. var3_24)
end

function var0_0.UpdateDelegate(arg0_25)
	local var0_25 = nowWorld()

	if not var0_25:IsSystemOpen(WorldConst.SystemAutoSwitch) then
		setActive(arg0_25.btnDelegate, false)

		return
	end

	local var1_25 = arg0_25.mapList[arg0_25.destIndex]
	local var2_25 = pg.world_auto_statistics[var1_25.id]

	setActive(arg0_25.btnDelegate, var2_25 and not var1_25.isCost)
	setActive(arg0_25.btnDelegate:Find("lock"), not var0_25:GetGobalFlag("treasure_flag"))
end

function var0_0.ShowToggleMask(arg0_26)
	arg0_26.isTweening = true

	setActive(arg0_26.rtMarking, false)
	setActive(arg0_26.rtSelectMask, true)
	setActive(arg0_26.rtToggles, false)

	arg0_26.rtMaskMarking.position = arg0_26.rtMarking.position

	LeanTween.moveY(arg0_26.rtMaskMarking, arg0_26.rtMaskMarking.anchoredPosition.y + 150, 0.2):setOnComplete(System.Action(function()
		setActive(arg0_26.rtToggles, true)

		arg0_26.isTweening = false
	end))
	setActive(arg0_26.btnSwitch, false)
end

function var0_0.HideToggleMask(arg0_28)
	arg0_28.isTweening = true

	setActive(arg0_28.rtToggles, false)

	arg0_28.rtMaskMarking.position = arg0_28.rtMarking.position

	setAnchoredPosition(arg0_28.rtMaskMarking, {
		y = arg0_28.rtMaskMarking.anchoredPosition.y + 150
	})
	LeanTween.moveY(arg0_28.rtMaskMarking, arg0_28.rtMaskMarking.anchoredPosition.y - 150, 0.2):setOnComplete(System.Action(function()
		setActive(arg0_28.rtSelectMask, false)
		setActive(arg0_28.rtMarking, true)

		arg0_28.isTweening = false

		setActive(arg0_28.btnSwitch, #arg0_28.mapList > 1)
	end))
end

return var0_0
