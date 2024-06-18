local var0_0 = class("SVFloatPanel", import("view.base.BaseSubView"))

var0_0.ShowView = "SVFloatPanel.ShowView"
var0_0.HideView = "SVFloatPanel.HideView"
var0_0.ReturnCall = "SVFloatPanel.ReturnCall"

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

	arg0_3.toggleItemList:make(function(arg0_14, arg1_14, arg2_14)
		arg1_14 = arg1_14 + 1

		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_3.mapList[arg1_14]
			local var1_14, var2_14 = World.ReplacementMapType(arg0_3.entrance, var0_14)

			setText(arg2_14:Find("Text"), var2_14)
			onToggle(arg0_3, arg2_14, function(arg0_15)
				if arg0_15 then
					arg0_3:HideToggleMask()

					arg0_3.destIndex = arg1_14

					arg0_3:UpdatePanel()
				end
			end, SFX_PANEL)
			triggerToggle(arg2_14, false)
		end
	end)
end

function var0_0.OnDestroy(arg0_16)
	return
end

function var0_0.Show(arg0_17)
	setActive(arg0_17._tf, true)
end

function var0_0.Hide(arg0_18)
	setActive(arg0_18._tf, false)
end

function var0_0.Setup(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg0_19.entrance = arg1_19

	local var0_19 = arg4_19:GetMapScreenPos(Vector2(arg1_19.config.area_pos[1], arg1_19.config.area_pos[2]))

	setAnchoredPosition(arg0_19.rtBasePoint, arg0_19._tf:InverseTransformPoint(GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)):ScreenToWorldPoint(var0_19)))

	arg0_19.mapList = nowWorld():EntranceToReplacementMapList(arg1_19)

	local function var1_19()
		if arg2_19 then
			for iter0_20, iter1_20 in ipairs(arg0_19.mapList) do
				if iter1_20.id == arg2_19 then
					return iter0_20
				end
			end
		end

		if arg3_19 then
			for iter2_20, iter3_20 in ipairs(arg3_19) do
				for iter4_20, iter5_20 in ipairs(arg0_19.mapList) do
					if iter3_20 == World.ReplacementMapType(arg1_19, iter5_20) then
						return iter4_20
					end
				end
			end
		end

		if arg1_19.active then
			for iter6_20, iter7_20 in ipairs(arg0_19.mapList) do
				if iter7_20.active then
					return iter6_20
				end
			end
		end

		return 1
	end

	arg0_19.toggleItemList:align(#arg0_19.mapList)
	triggerToggle(arg0_19.rtToggles:GetChild(var1_19() - 1), true)
end

function var0_0.setColorfulImage(arg0_21, arg1_21, arg2_21, arg3_21)
	arg3_21 = defaultValue(arg3_21, true)

	setImageSprite(arg1_21, getImageSprite(arg0_21.rtRes:Find(arg1_21.name .. "/" .. arg2_21)), arg3_21)
end

function var0_0.UpdatePanel(arg0_22)
	local var0_22 = nowWorld()
	local var1_22 = arg0_22.mapList[arg0_22.destIndex]
	local var2_22, var3_22 = World.ReplacementMapType(arg0_22.entrance, var1_22)
	local var4_22 = var2_22 == "complete_chapter" and "safe" or WorldConst.GetMapIconState(var1_22.config.entrance_ui)
	local var5_22 = var1_22:IsMapOpen()

	arg0_22:setColorfulImage(arg0_22.rtBasePoint, var4_22)
	arg0_22:setColorfulImage(arg0_22.rtInfoPanel, var4_22, false)

	local var6_22 = GetSpriteFromAtlas("world/mapicon/" .. var1_22.config.entrance_mapicon, "")

	setImageSprite(arg0_22.rtInfoPanel:Find("icon"), var6_22)
	arg0_22:setColorfulImage(arg0_22.btnBack, var4_22)
	arg0_22:setColorfulImage(arg0_22.btnEnter, var4_22)
	arg0_22:setColorfulImage(arg0_22.rtMarking, var4_22)
	arg0_22:setColorfulImage(arg0_22.rtMarking:Find("mark_bg"), var4_22)
	arg0_22:setColorfulImage(arg0_22.rtMaskMarking, var4_22)
	arg0_22:setColorfulImage(arg0_22.rtMaskMarking:Find("mark_bg"), var4_22)
	setText(arg0_22.rtMarking:Find("Text"), var3_22)
	setText(arg0_22.rtMaskMarking:Find("Text"), var3_22)
	setActive(arg0_22.rtInfoPanel:Find("sairen"), var2_22 == "sairen_chapter")
	setText(arg0_22.rtInfoPanel:Find("sairen/Text"), i18n("area_yaosai_2"))
	setText(arg0_22.rtInfoPanel:Find("danger_text"), var5_22 and var1_22:GetDanger() or "?")
	changeToScrollText(arg0_22.rtInfoPanel:Find("title/name"), var1_22:GetName(arg0_22.entrance))

	local var7_22, var8_22, var9_22 = var0_22:CountAchievements(arg0_22.entrance)

	setText(arg0_22.rtInfoPanel:Find("title/achievement/number"), var7_22 + var8_22 .. "/" .. var9_22)

	local var10_22 = var0_22:GetPressingAward(var1_22.id)

	setActive(arg0_22.rtInfoPanel:Find("pressing_award"), var10_22 and var10_22.flag)

	if var10_22 and var10_22.flag then
		arg0_22.awardConfig = pg.world_event_complete[var10_22.id].tips_icon

		arg0_22.awardItemList:align(#arg0_22.awardConfig)
	end

	arg0_22:UpdateCost()

	local var11_22 = nowWorld():GetAtlas()
	local var12_22 = var11_22:GetActiveMap()
	local var13_22, var14_22 = var12_22:CkeckTransport()
	local var15_22 = false

	setActive(arg0_22.btnBack, not var15_22 and var11_22:GetActiveEntrance() == arg0_22.entrance and var12_22 == var1_22)

	var15_22 = var15_22 or isActive(arg0_22.btnBack)

	setActive(arg0_22.btnEnter, not var15_22 and var13_22 and var5_22 and var11_22.transportDic[arg0_22.entrance.id])

	var15_22 = var15_22 or isActive(arg0_22.btnEnter)

	setText(arg0_22.btnLock:Find("Text"), var5_22 and i18n("world_map_locked_border") or i18n("world_map_locked_stage"))
	setActive(arg0_22.btnLock, not var15_22 and var13_22)

	var15_22 = var15_22 or isActive(arg0_22.btnLock)

	setActive(arg0_22.btnReturn, not var15_22)

	local var16_22

	var16_22 = var15_22 or isActive(arg0_22.btnReturn)
end

function var0_0.UpdateCost(arg0_23)
	local var0_23 = arg0_23.mapList[arg0_23.destIndex]
	local var1_23 = arg0_23.btnEnter:Find("cost")

	setActive(var1_23, not var0_23.isCost)

	local var2_23 = nowWorld().staminaMgr:GetTotalStamina()
	local var3_23 = var0_23.config.enter_cost

	setText(var1_23:Find("Text"), setColorStr(var2_23, var2_23 < var3_23 and COLOR_RED or COLOR_GREEN) .. "/" .. var3_23)
end

function var0_0.ShowToggleMask(arg0_24)
	arg0_24.isTweening = true

	setActive(arg0_24.rtMarking, false)
	setActive(arg0_24.rtSelectMask, true)
	setActive(arg0_24.rtToggles, false)

	arg0_24.rtMaskMarking.position = arg0_24.rtMarking.position

	LeanTween.moveY(arg0_24.rtMaskMarking, arg0_24.rtMaskMarking.anchoredPosition.y + 150, 0.2):setOnComplete(System.Action(function()
		setActive(arg0_24.rtToggles, true)

		arg0_24.isTweening = false
	end))
	setActive(arg0_24.btnSwitch, false)
end

function var0_0.HideToggleMask(arg0_26)
	arg0_26.isTweening = true

	setActive(arg0_26.rtToggles, false)

	arg0_26.rtMaskMarking.position = arg0_26.rtMarking.position

	setAnchoredPosition(arg0_26.rtMaskMarking, {
		y = arg0_26.rtMaskMarking.anchoredPosition.y + 150
	})
	LeanTween.moveY(arg0_26.rtMaskMarking, arg0_26.rtMaskMarking.anchoredPosition.y - 150, 0.2):setOnComplete(System.Action(function()
		setActive(arg0_26.rtSelectMask, false)
		setActive(arg0_26.rtMarking, true)

		arg0_26.isTweening = false

		setActive(arg0_26.btnSwitch, #arg0_26.mapList > 1)
	end))
end

return var0_0
