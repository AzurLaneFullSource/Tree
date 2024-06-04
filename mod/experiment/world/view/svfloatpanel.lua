local var0 = class("SVFloatPanel", import("view.base.BaseSubView"))

var0.ShowView = "SVFloatPanel.ShowView"
var0.HideView = "SVFloatPanel.HideView"
var0.ReturnCall = "SVFloatPanel.ReturnCall"

function var0.getUIName(arg0)
	return "SVFloatPanel"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.rtBasePoint = arg0._tf:Find("point")
	arg0.rtInfoPanel = arg0.rtBasePoint:Find("line/bg")
	arg0.rtMarking = arg0.rtInfoPanel:Find("icon/marking")
	arg0.rtRes = arg0._tf:Find("res")
	arg0.awardItemList = UIItemList.New(arg0.rtInfoPanel:Find("pressing_award"), arg0.rtInfoPanel:Find("pressing_award/award_tpl"))

	arg0.awardItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.awardConfig[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2:Find("IconTpl"), var1)
			onButton(arg0, arg2:Find("IconTpl"), function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)

			local var2 = arg0.mapList[arg0.destIndex]

			setActive(arg2:Find("is_pressing"), var2.isPressing)
			setActive(arg2:Find("IconTpl"), not var2.isPressing)
		end
	end)

	arg0.btnBack = arg0.rtInfoPanel:Find("back")

	onButton(arg0, arg0.btnBack, function()
		arg0:emit(WorldScene.SceneOp, "OpSetInMap", true)
	end, SFX_CONFIRM)

	arg0.btnEnter = arg0.rtInfoPanel:Find("enter")

	onButton(arg0, arg0.btnEnter, function()
		local var0 = {}
		local var1 = arg0.mapList[arg0.destIndex]

		if WorldConst.HasDangerConfirm(var1.config.entrance_ui) then
			table.insert(var0, function(arg0)
				arg0:emit(WorldScene.SceneOp, "OpCall", function(arg0)
					arg0()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_map_dangerous_confirm"),
						onYes = arg0
					})
				end)
			end)
		end

		seriesAsync(var0, function()
			local var0 = nowWorld().staminaMgr

			if not var1.isCost and var1.config.enter_cost > var0:GetTotalStamina() then
				var0:Show()
			else
				arg0:emit(WorldScene.SceneOp, "OpTransport", arg0.entrance, var1)
			end
		end)
	end, SFX_CONFIRM)

	arg0.btnLock = arg0.rtInfoPanel:Find("lock")
	arg0.btnReturn = arg0.rtInfoPanel:Find("return")

	onButton(arg0, arg0.btnReturn, function()
		arg0:emit(var0.ReturnCall, arg0.entrance)
	end, SFX_CONFIRM)

	arg0.btnSwitch = arg0.rtInfoPanel:Find("switch")

	onButton(arg0, arg0.btnSwitch, function()
		if arg0.isTweening then
			return
		end

		arg0:ShowToggleMask()
	end, SFX_PANEL)

	arg0.rtSelectMask = arg0._tf:Find("select_mask")

	onButton(arg0, arg0.rtSelectMask:Find("bg"), function()
		if arg0.isTweening then
			return
		end

		arg0:HideToggleMask()
	end, SFX_PANEL)

	arg0.rtMaskMarking = arg0.rtSelectMask:Find("marking")
	arg0.rtToggles = arg0.rtMaskMarking:Find("toggles")
	arg0.toggleItemList = UIItemList.New(arg0.rtToggles, arg0.rtToggles:Find("toggle"))

	arg0.toggleItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.mapList[arg1]
			local var1, var2 = World.ReplacementMapType(arg0.entrance, var0)

			setText(arg2:Find("Text"), var2)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0:HideToggleMask()

					arg0.destIndex = arg1

					arg0:UpdatePanel()
				end
			end, SFX_PANEL)
			triggerToggle(arg2, false)
		end
	end)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	setActive(arg0._tf, false)
end

function var0.Setup(arg0, arg1, arg2, arg3, arg4)
	arg0.entrance = arg1

	local var0 = arg4:GetMapScreenPos(Vector2(arg1.config.area_pos[1], arg1.config.area_pos[2]))

	setAnchoredPosition(arg0.rtBasePoint, arg0._tf:InverseTransformPoint(GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)):ScreenToWorldPoint(var0)))

	arg0.mapList = nowWorld():EntranceToReplacementMapList(arg1)

	local function var1()
		if arg2 then
			for iter0, iter1 in ipairs(arg0.mapList) do
				if iter1.id == arg2 then
					return iter0
				end
			end
		end

		if arg3 then
			for iter2, iter3 in ipairs(arg3) do
				for iter4, iter5 in ipairs(arg0.mapList) do
					if iter3 == World.ReplacementMapType(arg1, iter5) then
						return iter4
					end
				end
			end
		end

		if arg1.active then
			for iter6, iter7 in ipairs(arg0.mapList) do
				if iter7.active then
					return iter6
				end
			end
		end

		return 1
	end

	arg0.toggleItemList:align(#arg0.mapList)
	triggerToggle(arg0.rtToggles:GetChild(var1() - 1), true)
end

function var0.setColorfulImage(arg0, arg1, arg2, arg3)
	arg3 = defaultValue(arg3, true)

	setImageSprite(arg1, getImageSprite(arg0.rtRes:Find(arg1.name .. "/" .. arg2)), arg3)
end

function var0.UpdatePanel(arg0)
	local var0 = nowWorld()
	local var1 = arg0.mapList[arg0.destIndex]
	local var2, var3 = World.ReplacementMapType(arg0.entrance, var1)
	local var4 = var2 == "complete_chapter" and "safe" or WorldConst.GetMapIconState(var1.config.entrance_ui)
	local var5 = var1:IsMapOpen()

	arg0:setColorfulImage(arg0.rtBasePoint, var4)
	arg0:setColorfulImage(arg0.rtInfoPanel, var4, false)

	local var6 = GetSpriteFromAtlas("world/mapicon/" .. var1.config.entrance_mapicon, "")

	setImageSprite(arg0.rtInfoPanel:Find("icon"), var6)
	arg0:setColorfulImage(arg0.btnBack, var4)
	arg0:setColorfulImage(arg0.btnEnter, var4)
	arg0:setColorfulImage(arg0.rtMarking, var4)
	arg0:setColorfulImage(arg0.rtMarking:Find("mark_bg"), var4)
	arg0:setColorfulImage(arg0.rtMaskMarking, var4)
	arg0:setColorfulImage(arg0.rtMaskMarking:Find("mark_bg"), var4)
	setText(arg0.rtMarking:Find("Text"), var3)
	setText(arg0.rtMaskMarking:Find("Text"), var3)
	setActive(arg0.rtInfoPanel:Find("sairen"), var2 == "sairen_chapter")
	setText(arg0.rtInfoPanel:Find("sairen/Text"), i18n("area_yaosai_2"))
	setText(arg0.rtInfoPanel:Find("danger_text"), var5 and var1:GetDanger() or "?")
	changeToScrollText(arg0.rtInfoPanel:Find("title/name"), var1:GetName(arg0.entrance))

	local var7, var8, var9 = var0:CountAchievements(arg0.entrance)

	setText(arg0.rtInfoPanel:Find("title/achievement/number"), var7 + var8 .. "/" .. var9)

	local var10 = var0:GetPressingAward(var1.id)

	setActive(arg0.rtInfoPanel:Find("pressing_award"), var10 and var10.flag)

	if var10 and var10.flag then
		arg0.awardConfig = pg.world_event_complete[var10.id].tips_icon

		arg0.awardItemList:align(#arg0.awardConfig)
	end

	arg0:UpdateCost()

	local var11 = nowWorld():GetAtlas()
	local var12 = var11:GetActiveMap()
	local var13, var14 = var12:CkeckTransport()
	local var15 = false

	setActive(arg0.btnBack, not var15 and var11:GetActiveEntrance() == arg0.entrance and var12 == var1)

	var15 = var15 or isActive(arg0.btnBack)

	setActive(arg0.btnEnter, not var15 and var13 and var5 and var11.transportDic[arg0.entrance.id])

	var15 = var15 or isActive(arg0.btnEnter)

	setText(arg0.btnLock:Find("Text"), var5 and i18n("world_map_locked_border") or i18n("world_map_locked_stage"))
	setActive(arg0.btnLock, not var15 and var13)

	var15 = var15 or isActive(arg0.btnLock)

	setActive(arg0.btnReturn, not var15)

	local var16

	var16 = var15 or isActive(arg0.btnReturn)
end

function var0.UpdateCost(arg0)
	local var0 = arg0.mapList[arg0.destIndex]
	local var1 = arg0.btnEnter:Find("cost")

	setActive(var1, not var0.isCost)

	local var2 = nowWorld().staminaMgr:GetTotalStamina()
	local var3 = var0.config.enter_cost

	setText(var1:Find("Text"), setColorStr(var2, var2 < var3 and COLOR_RED or COLOR_GREEN) .. "/" .. var3)
end

function var0.ShowToggleMask(arg0)
	arg0.isTweening = true

	setActive(arg0.rtMarking, false)
	setActive(arg0.rtSelectMask, true)
	setActive(arg0.rtToggles, false)

	arg0.rtMaskMarking.position = arg0.rtMarking.position

	LeanTween.moveY(arg0.rtMaskMarking, arg0.rtMaskMarking.anchoredPosition.y + 150, 0.2):setOnComplete(System.Action(function()
		setActive(arg0.rtToggles, true)

		arg0.isTweening = false
	end))
	setActive(arg0.btnSwitch, false)
end

function var0.HideToggleMask(arg0)
	arg0.isTweening = true

	setActive(arg0.rtToggles, false)

	arg0.rtMaskMarking.position = arg0.rtMarking.position

	setAnchoredPosition(arg0.rtMaskMarking, {
		y = arg0.rtMaskMarking.anchoredPosition.y + 150
	})
	LeanTween.moveY(arg0.rtMaskMarking, arg0.rtMaskMarking.anchoredPosition.y - 150, 0.2):setOnComplete(System.Action(function()
		setActive(arg0.rtSelectMask, false)
		setActive(arg0.rtMarking, true)

		arg0.isTweening = false

		setActive(arg0.btnSwitch, #arg0.mapList > 1)
	end))
end

return var0
