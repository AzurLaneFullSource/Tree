local var0_0 = class("DreamlandHandbookPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "DreamlandHandbookUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("bg/close")
	arg0_2.tags = {
		[var1_0] = arg0_2:findTF("bg/tags/area"),
		[var2_0] = arg0_2:findTF("bg/tags/ex")
	}
	arg0_2.tagTip = {}

	for iter0_2, iter1_2 in pairs(arg0_2.tags) do
		arg0_2.tagTip[iter0_2] = iter1_2:Find("tip")
	end

	arg0_2.mapContent = arg0_2:findTF("bg/area/content")
	arg0_2.mapNameTxt = arg0_2:findTF("bg/area/content/name"):GetComponent(typeof(Text))
	arg0_2.mapDescTxt = arg0_2:findTF("bg/area/content/scrollrect/desc"):GetComponent(typeof(Text))
	arg0_2.mapGoBtn = arg0_2:findTF("bg/area/content/btn_go")
	arg0_2.mapGetBtn = arg0_2:findTF("bg/area/content/btn_get")
	arg0_2.mapGotBtn = arg0_2:findTF("bg/area/content/btn_got")
	arg0_2.mapAwardList = UIItemList.New(arg0_2:findTF("bg/area/content/awards/list"), arg0_2:findTF("bg/area/content/awards/list/award"))
	arg0_2.lineUIList = UIItemList.New(arg0_2:findTF("bg/area/content/scrollrect/desc/lines"), arg0_2:findTF("bg/area/content/scrollrect/desc/lines/tpl"))
	arg0_2.exGoBtn = arg0_2:findTF("bg/ex/content/btn_go")
	arg0_2.exGetBtn = arg0_2:findTF("bg/ex/content/btn_get")
	arg0_2.exGotBtn = arg0_2:findTF("bg/ex/content/btn_got")
	arg0_2.exAwardList = UIItemList.New(arg0_2:findTF("bg/ex/content/awards/list"), arg0_2:findTF("bg/ex/content/awards/list/award"))
	arg0_2.exContentList = UIItemList.New(arg0_2:findTF("bg/ex/content/scrollrect/content"), arg0_2:findTF("bg/ex/content/scrollrect/content/tpl"))
	arg0_2.exContent = arg0_2:findTF("bg/ex/content")
	arg0_2.areaList = UIItemList.New(arg0_2:findTF("bg/area/list"), arg0_2:findTF("bg/area/list/1"))
	arg0_2.exploreList = UIItemList.New(arg0_2:findTF("bg/ex/list"), arg0_2:findTF("bg/ex/list/tpl"))

	setText(arg0_2:findTF("bg/tags/area/Text"), i18n("dreamland_label_area"))
	setText(arg0_2:findTF("bg/tags/ex/Text"), i18n("dreamland_label_explore"))
	setText(arg0_2:findTF("bg/ex/content/award_desc"), i18n("dreamland_label_explore_award_tip"))

	arg0_2.tipTr = arg0_2:findTF("tip")
	arg0_2.tipTxt = arg0_2.tipTr:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	local var0_3 = Color.New(0.5843138, 0.5843138, 0.5843138, 1)
	local var1_3 = Color.New(1, 1, 1, 1)

	local function var2_3(arg0_6, arg1_6)
		local var0_6 = arg0_6:Find("icon"):GetComponent(typeof(Image))
		local var1_6 = arg0_6:Find("Text"):GetComponent(typeof(Text))

		var0_6.color = arg1_6 and var1_3 or var0_3
		var1_6.color = arg1_6 and var1_3 or var0_3
	end

	for iter0_3, iter1_3 in pairs(arg0_3.tags) do
		onToggle(arg0_3, iter1_3, function(arg0_7)
			arg0_3:SwitchPage(iter0_3)
			var2_3(iter1_3, arg0_7)
		end, SFX_PANEL)
		var2_3(iter1_3, false)
	end

	arg0_3:bind(DreamlandScene.ON_DATA_UPDATE, function(arg0_8, arg1_8)
		arg0_3:OnDataUpdate(arg1_8)
	end)
end

function var0_0.OnDataUpdate(arg0_9, arg1_9)
	arg0_9.gameData = arg1_9.data

	if not arg0_9:isShowing() then
		return
	end

	if arg1_9.cmd == DreamlandData.OP_GET_MAP_AWARD then
		arg0_9:UpdateAreaPage()
	elseif arg1_9.cmd == DreamlandData.OP_GET_EXPLORE_AWARD then
		arg0_9:UpdateExplorePage()
	end

	arg0_9:UpdateTip()
end

function var0_0.Show(arg0_10, arg1_10)
	var0_0.super.Show(arg0_10)

	arg0_10.gameData = arg1_10
	arg0_10.selectedMapId = 1
	arg0_10.selectedExploreId = 1

	arg0_10:UpdateTip()
	triggerToggle(arg0_10.tags[1], true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
end

function var0_0.UpdateTip(arg0_11)
	setActive(arg0_11.tagTip[var1_0], arg0_11.gameData:ExistAnyMapAward())
	setActive(arg0_11.tagTip[var2_0], arg0_11.gameData:ExistAnyExploreAward())
end

function var0_0.Hide(arg0_12)
	var0_0.super.Hide(arg0_12)
	arg0_12:RemoveHideTimer()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parentTf)
end

function var0_0.SwitchPage(arg0_13, arg1_13)
	if arg1_13 == var1_0 then
		arg0_13:UpdateAreaPage()
	elseif arg1_13 == var2_0 then
		arg0_13:HideTip()
		arg0_13:UpdateExplorePage()
	end
end

function var0_0.InitArea(arg0_14, arg1_14, arg2_14)
	local var0_14

	var0_14.sprite, var0_14 = GetSpriteFromAtlas("ui/DlHandBookUI_atlas", "area" .. arg1_14), arg2_14:GetComponent(typeof(Image))

	var0_14:SetNativeSize()

	local var1_14 = arg2_14:Find("selected")

	onToggle(arg0_14, arg2_14, function(arg0_15)
		if arg0_15 then
			arg0_14:UpdateArea(arg1_14)
		end

		local var0_15 = arg0_15 and not arg0_14.gameData:IsUnlockMap(arg1_14)

		if var0_15 and not arg0_14.initFlag then
			arg0_14:ShowTip(i18n("dreamland_area_lock_tip"))
		end

		if var0_15 then
			setActive(var1_14, false)
		end
	end, SFX_PANEL)
end

function var0_0.GetLineCunt(arg0_16, arg1_16)
	local var0_16 = arg1_16.gameObject.transform.sizeDelta.y
	local var1_16 = arg0_16.lineUIList.container:GetComponent(typeof(VerticalLayoutGroup)).spacing

	return math.max(math.ceil(var0_16 / var1_16), 4)
end

function var0_0.UpdateArea(arg0_17, arg1_17)
	local var0_17 = arg0_17.gameData:IsUnlockMap(arg1_17)

	if not var0_17 then
		setActive(arg0_17.mapContent, false)

		return
	end

	setActive(arg0_17.mapContent, true)

	arg0_17.selectedMapId = arg1_17

	local var1_17 = arg0_17.gameData:FindMap(arg1_17)

	arg0_17.mapNameTxt.text = var1_17.name
	arg0_17.mapDescTxt.text = HXSet.hxLan(var1_17.desc)

	onNextTick(function()
		local var0_18 = arg0_17:GetLineCunt(arg0_17.mapDescTxt)

		arg0_17.lineUIList:align(var0_18)
	end)

	local var2_17 = arg0_17.gameData:IsReceiveMapAward(arg1_17)

	setActive(arg0_17.mapGoBtn, not var0_17)
	setActive(arg0_17.mapGetBtn, var0_17 and not var2_17)
	setActive(arg0_17.mapGotBtn, var0_17 and var2_17)

	local var3_17 = var1_17.unlock_drop_display

	arg0_17.mapAwardList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			arg0_17:UpdateDrop(arg2_19, var3_17[arg1_19 + 1], var0_17 and var2_17)
		end
	end)
	arg0_17.mapAwardList:align(#var3_17)
	onButton(arg0_17, arg0_17.mapGetBtn, function()
		if var0_17 and not var2_17 then
			arg0_17:CheckAwardOverflow(var3_17, function()
				arg0_17:emit(DreamlandMediator.GET_MAP_AWARD, arg0_17.gameData:GetActivityId(), arg1_17)
			end)
		end
	end, SFX_PANEL)
end

function var0_0.InitAreaPage(arg0_22)
	arg0_22.areaTrs = {}

	local var0_22 = arg0_22.gameData:GetAllMapId()

	arg0_22.areaList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			arg0_22:InitArea(var0_22[arg1_23 + 1], arg2_23)

			arg0_22.areaTrs[var0_22[arg1_23 + 1]] = arg2_23
		end
	end)
	arg0_22.areaList:align(#var0_22)
end

function var0_0.UpdateAreaPage(arg0_24)
	if not arg0_24.isInitAreaPage then
		arg0_24:InitAreaPage()

		arg0_24.isInitAreaPage = true
	end

	for iter0_24, iter1_24 in pairs(arg0_24.areaTrs) do
		local var0_24 = arg0_24.gameData:IsUnlockMap(iter0_24)

		setActive(iter1_24:Find("tip"), var0_24 and not arg0_24.gameData:IsReceiveMapAward(iter0_24))
		setActive(iter1_24:Find("mask"), not var0_24)
	end

	arg0_24.initFlag = true

	triggerToggle(arg0_24.areaTrs[arg0_24.selectedMapId], true)

	arg0_24.initFlag = false
end

function var0_0.InitExplore(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.gameData:FindMap(arg2_25)
	local var1_25

	var1_25.sprite, var1_25 = GetSpriteFromAtlas("ui/DlHandBookUI_atlas", "ex_print" .. arg2_25), arg1_25:Find("num"):GetComponent(typeof(Image))

	var1_25:SetNativeSize()

	local var2_25 = arg1_25:Find("Text"):GetComponent(typeof(Text))
	local var3_25 = Color.New(0.3058824, 0.3058824, 0.3607843)
	local var4_25 = Color.New(0.145098, 0.3215686, 0.9254902)

	onToggle(arg0_25, arg1_25, function(arg0_26)
		if arg0_26 then
			arg0_25:UpdateExplore(arg2_25)
		end

		if arg0_26 and not arg0_25.gameData:IsUnlockMap(arg2_25) then
			setActive(arg1_25:Find("selected"), false)
		end

		var2_25.color = arg0_26 and var4_25 or var3_25
	end, SFX_PANEL)
	onButton(arg0_25, arg1_25:Find("lock"), function(arg0_27)
		arg0_25:ShowTip(i18n("dreamland_area_lock_tip"))
	end, SFX_PANEL)
end

function var0_0.UpdateExplore(arg0_28, arg1_28)
	if not arg0_28.gameData:IsUnlockMap(arg1_28) then
		setActive(arg0_28.exContent, false)

		return
	end

	arg0_28.selectedExploreId = arg1_28

	setActive(arg0_28.exContent, true)

	local var0_28 = arg0_28.gameData:FindMap(arg1_28)
	local var1_28 = arg0_28.gameData:IsFinishMapExplore(arg1_28)
	local var2_28 = arg0_28.gameData:IsReceiveExploreAward(arg1_28)

	setActive(arg0_28.exGoBtn, not var1_28)
	setActive(arg0_28.exGetBtn, var1_28 and not var2_28)
	setActive(arg0_28.exGotBtn, var1_28 and var2_28)

	local var3_28 = var0_28.explore_drop_display

	arg0_28.exAwardList:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			arg0_28:UpdateDrop(arg2_29, var3_28[arg1_29 + 1], var1_28 and var2_28)
		end
	end)
	arg0_28.exAwardList:align(#var3_28)

	local var4_28 = arg0_28.gameData:GetMainExploreInMap(var0_28)

	arg0_28.exContentList:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			arg0_28:UpdateExploreObj(arg2_30, arg1_30 + 1, var4_28[arg1_30 + 1])
		end
	end)
	arg0_28.exContentList:align(#var4_28)
	onButton(arg0_28, arg0_28.exGetBtn, function(arg0_31)
		if var1_28 and not var2_28 then
			arg0_28:CheckAwardOverflow(var3_28, function()
				arg0_28:emit(DreamlandMediator.GET_EXPLORE_AWARD, arg0_28.gameData:GetActivityId(), arg1_28)
			end)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateExploreObj(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = arg0_33.gameData:FindExploreObj(arg3_33)
	local var1_33 = arg1_33:Find("1")
	local var2_33 = arg1_33:Find("2")
	local var3_33 = arg2_33 % 2 == 0 and var2_33 or var1_33

	setActive(var1_33, var3_33 == var1_33)
	setActive(var2_33, var3_33 == var2_33)

	local var4_33 = var3_33:Find("icon"):GetComponent(typeof(Image))

	LoadSpriteAsync("exploreObj/" .. var0_33.pic, function(arg0_34)
		var4_33.sprite = arg0_34
	end)

	local var5_33 = var3_33:Find("tip"):GetComponent(typeof(Text))
	local var6_33 = var3_33:Find("scrollrect/desc"):GetComponent(typeof(Text))
	local var7_33 = arg0_33.gameData:IsRecordExplore(arg3_33)

	setActive(var3_33:Find("tipbg"), not var7_33)

	var6_33.text = HXSet.hxLan(var7_33 and var0_33.dispaly_desc or "")
	var5_33.text = HXSet.hxLan(var7_33 and "" or var0_33.tip_desc)

	setActive(var3_33:Find("lock"), not var7_33)

	var4_33.color = var7_33 and Color.New(1, 1, 1, 1) or Color.New(1, 1, 1, 0.25)
end

function var0_0.InitExplorePage(arg0_35)
	arg0_35.exploreTrs = {}

	local var0_35 = arg0_35.gameData:GetAllMapId()

	arg0_35.exploreList:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventUpdate then
			arg0_35:InitExplore(arg2_36, var0_35[arg1_36 + 1])

			arg0_35.exploreTrs[var0_35[arg1_36 + 1]] = arg2_36
		end
	end)
	arg0_35.exploreList:align(#var0_35)
end

function var0_0.UpdateExplorePage(arg0_37)
	if not arg0_37.isInitExplorePage then
		arg0_37:InitExplorePage()

		arg0_37.isInitExplorePage = true
	end

	for iter0_37, iter1_37 in pairs(arg0_37.exploreTrs) do
		local var0_37 = arg0_37.gameData:IsUnlockMap(iter0_37)

		setText(iter1_37:Find("Text"), var0_37 and arg0_37.gameData:FindMap(iter0_37).name or "")
		setActive(iter1_37:Find("lock"), not var0_37)
		setToggleEnabled(iter1_37, var0_37)

		iter1_37:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.3058824, 0.3058824, 0.3607843)

		setActive(iter1_37:Find("tip"), arg0_37.gameData:IsFinishMapExplore(iter0_37) and not arg0_37.gameData:IsReceiveExploreAward(iter0_37))
	end

	triggerToggle(arg0_37.exploreTrs[arg0_37.selectedExploreId], true)
end

function var0_0.CheckAwardOverflow(arg0_38, arg1_38, arg2_38)
	local var0_38, var1_38 = Task.StaticJudgeOverflow(false, false, false, true, true, arg1_38)

	if var0_38 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("award_max_warning"),
			items = var1_38,
			onYes = arg2_38
		})
	else
		arg2_38()
	end
end

function var0_0.UpdateDrop(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = Drop.New({
		type = arg2_39[1],
		id = arg2_39[2],
		count = arg2_39[3]
	})

	updateDrop(arg1_39:Find("mask_1"), var0_39)
	onButton(arg0_39, arg1_39, function()
		arg0_39:emit(BaseUI.ON_DROP, var0_39)
	end, SFX_PANEL)
	setActive(arg1_39:Find("mask"), arg3_39)
end

function var0_0.ShowTip(arg0_41, arg1_41)
	arg0_41.tipTxt.text = arg1_41

	setActive(arg0_41.tipTr, true)
	arg0_41:AddHideTimer()
end

function var0_0.HideTip(arg0_42)
	arg0_42:RemoveHideTimer()
	setActive(arg0_42.tipTr, false)
end

function var0_0.AddHideTimer(arg0_43)
	arg0_43:RemoveHideTimer()

	arg0_43.timer = Timer.New(function()
		arg0_43:RemoveHideTimer()
		setActive(arg0_43.tipTr, false)

		arg0_43.tipTxt.text = ""
	end, 3, 1)

	arg0_43.timer:Start()
end

function var0_0.RemoveHideTimer(arg0_45)
	if arg0_45.timer then
		arg0_45.timer:Stop()

		arg0_45.timer = nil
	end
end

function var0_0.OnDestroy(arg0_46)
	if arg0_46:isShowing() then
		arg0_46:Hide()
	end
end

return var0_0
