local var0_0 = class("IslandSelfCardLayer", import("view.base.BaseUI"))

var0_0.LABEL_SHOW_CNT = 2
var0_0.ACHV_SHOW_CNT = 4
var0_0.COLORS = {
	"#A38759",
	"#AB7B7B",
	"#B1B284",
	"#8B99AC",
	"#8AAD8B",
	"#9D87A9"
}

function var0_0.getUIName(arg0_1)
	return "IslandSelfCardUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(PlayerProxy):getData().id

	seriesAsync({
		function(arg0_3)
			local var0_3 = getProxy(IslandProxy):GetIsland()

			if var0_3 then
				arg0_2.island = var0_3

				arg0_3()
			else
				pg.m02:sendNotification(GAME.ISLAND_GET_DATA, {
					isCardRequest = true,
					id = var0_2,
					list = {},
					callback = function()
						arg0_2.island = getProxy(IslandProxy):GetIsland()

						arg0_3()
					end
				})
			end
		end,
		function(arg0_5)
			pg.m02:sendNotification(GAME.ISLAND_GET_CARD_DATA, {
				userId = var0_2,
				callback = function(arg0_6)
					arg0_2.card = arg0_6

					arg0_5()
				end
			})
		end
	}, function()
		arg1_2()
	end)
end

function var0_0.getResource(arg0_8)
	local var0_8 = var0_0.super.getResource(arg0_8)
	local var1_8 = {
		"islandachievement",
		"islandphoto",
		"ui/islandcardui_atlas"
	}

	for iter0_8, iter1_8 in ipairs(var1_8 or {}) do
		if not table.contains(var0_8, iter1_8) then
			table.insert(var0_8, iter1_8)
		end
	end

	return var0_8
end

function var0_0.init(arg0_9)
	arg0_9.uiAnim = arg0_9._tf:GetComponent(typeof(Animation))
	arg0_9.uiAnimEvent = arg0_9._tf:GetComponent(typeof(DftAniEvent))

	arg0_9.uiAnimEvent:SetEndEvent(function()
		arg0_9.playingHideAnim = false

		arg0_9:closeView(arg0_9)
	end)
	setText(arg0_9._tf:Find("tip"), i18n("island_card_close"))

	local var0_9 = arg0_9._tf:Find("panel")

	arg0_9.photoTF = var0_9:Find("photo/Image")
	arg0_9.photoSwitchBtn = var0_9:Find("photo/switch")
	arg0_9.likeTF = var0_9:Find("photo/like")
	arg0_9.labelsTF = var0_9:Find("labels")
	arg0_9.visitTF = var0_9:Find("btns/visit/Text")
	arg0_9.diyBtn = var0_9:Find("btns/diy")
	arg0_9.whitelistBtn = var0_9:Find("btns/whitelist")
	arg0_9.blacklistBtn = var0_9:Find("btns/blacklist")
	arg0_9.levelTF = var0_9:Find("level")
	arg0_9.wordTF = var0_9:Find("word")
	arg0_9.nameTF = var0_9:Find("name")
	arg0_9.addBtn = arg0_9.nameTF:Find("add")
	arg0_9.removeBtn = arg0_9.nameTF:Find("remove")
	arg0_9.editBtn = arg0_9.nameTF:Find("edit")
	arg0_9.editPanel = arg0_9._tf:Find("editPanel")
	arg0_9.editNameBtn = arg0_9.editPanel:Find("content/name")

	setText(arg0_9.editNameBtn:Find("Text"), i18n("island_card_edit_name"))

	arg0_9.editWordBtn = arg0_9.editPanel:Find("content/word")

	setText(arg0_9.editWordBtn:Find("Text"), i18n("island_card_edit_word"))

	arg0_9.shipTF = var0_9:Find("counts/ship/Text")
	arg0_9.achvTF = var0_9:Find("counts/achv/Text")
	arg0_9.bookTF = var0_9:Find("counts/book/Text")
	arg0_9.achvUIList = UIItemList.New(var0_9:Find("achvs"), var0_9:Find("achvs/tpl"))

	setText(var0_9:Find("achvs/tpl/empty/Text"), i18n("island_card_no_achv_self"))
	arg0_9:InitBoxs()
end

function var0_0.InitBoxs(arg0_11)
	arg0_11.editNameBox = IslandEditCardNameBox.New(arg0_11._tf, arg0_11.event)
	arg0_11.editWordBox = IslandEditCardWordBox.New(arg0_11._tf, arg0_11.event)
	arg0_11.setPhotoBox = IslandSetCardPhotoBox.New(arg0_11._tf, arg0_11.event)
	arg0_11.setAchvsBox = IslandSetCardAchvsBox.New(arg0_11._tf, arg0_11.event)
	arg0_11.showLabelBox = IslandShowCardLabelBox.New(arg0_11._tf, arg0_11.event)
end

function var0_0.didEnter(arg0_12)
	if not arg0_12.contextData.isIslandPage then
		pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	end

	onButton(arg0_12, arg0_12._tf:Find("panel/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_helpbtn_card.tip
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf:Find("close"), function()
		arg0_12:PlayHideAnim()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.photoSwitchBtn, function()
		local var0_15 = arg0_12.island:GetCardDiyAgency():GetIds()

		arg0_12.setPhotoBox:ExecuteAction("Show", var0_15, arg0_12.photoId)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.editBtn, function()
		arg0_12:ShowEditPanel()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.editPanel:Find("close"), function()
		arg0_12:HideEditPanel()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.editNameBtn, function()
		arg0_12.editNameBox:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.editWordBtn, function()
		arg0_12.editWordBox:ExecuteAction("Show")
	end, SFX_PANEL)
	arg0_12:InitAchvUIList()
	arg0_12:Flush()
end

function var0_0.InitAchvUIList(arg0_20)
	arg0_20.achvUIList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventInit then
			onButton(arg0_20, arg2_21, function()
				local var0_22 = arg0_20.island:GetAchievementAgency():GetGotGroupMaxStageList()

				arg0_20.setAchvsBox:ExecuteAction("Show", var0_22, Clone(arg0_20.card.achvList))
			end, SFX_PANEL)
		elseif arg0_21 == UIItemList.EventUpdate then
			arg0_20:UpdataAchvItem(arg1_21, arg2_21)
		end
	end)
end

function var0_0.ShowEditPanel(arg0_23)
	local var0_23 = arg0_23._tf:InverseTransformPoint(arg0_23.editBtn.position)

	setAnchoredPosition(arg0_23.editPanel:Find("content"), var0_23)
	setActive(arg0_23.editPanel, true)
end

function var0_0.HideEditPanel(arg0_24)
	setActive(arg0_24.editPanel, false)
end

function var0_0.UpdataAchvItem(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.card.achvList[arg1_25 + 1]

	setActive(arg2_25:Find("empty"), not var0_25)
	setActive(arg2_25:Find("content"), var0_25)

	if var0_25 then
		local var1_25 = pg.island_achievement[var0_25]

		LoadImageSpriteAtlasAsync("islandachievement", "achv_stage_" .. var1_25.stage, arg2_25:Find("content/Image"), true)
		setText(arg2_25:Find("content/Text"), var1_25.name)
	end
end

function var0_0.Flush(arg0_26)
	arg0_26.card.achvList = getProxy(IslandProxy):GetIsland():GetAchievementAgency():UpdataAchLv(arg0_26.card.achvList)

	arg0_26:UpdataPhoto()
	arg0_26:UpdataLabels()
	arg0_26:UpdataInfos()
end

function var0_0.UpdataPhoto(arg0_27)
	arg0_27.photoId = tonumber(arg0_27.card.photoStr)

	if arg0_27.photoId then
		local var0_27 = pg.island_card_diy[arg0_27.photoId].resource

		LoadImageSpriteAsync(var0_27, arg0_27.photoTF, true)
	end
end

function var0_0.UpdataLabels(arg0_28)
	arg0_28.labels = arg0_28.card:GetLabelList()

	table.sort(arg0_28.labels, CompareFuncs({
		function(arg0_29)
			return -arg0_29.num
		end,
		function(arg0_30)
			return arg0_30.id
		end
	}))

	for iter0_28 = 1, var0_0.LABEL_SHOW_CNT + 1 do
		local var0_28 = arg0_28.labelsTF:GetChild(iter0_28 - 1)
		local var1_28 = iter0_28 <= #arg0_28.labels + 1

		setActive(var0_28, var1_28)

		if var1_28 then
			if iter0_28 <= #arg0_28.labels then
				arg0_28:UpdateNoramlLabel(var0_28, arg0_28.labels[iter0_28])
			else
				arg0_28:UpdateGrayLabel(var0_28)
			end
		end
	end
end

function var0_0.UpdateNoramlLabel(arg0_31, arg1_31, arg2_31)
	local var0_31 = pg.island_card_label[arg2_31.id]

	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "label_bg_" .. var0_31.color, arg1_31, true)

	local var1_31 = var0_0.COLORS[var0_31.color]

	setTextColor(arg1_31:Find("name"), Color.NewHex(var1_31))
	setTextColor(arg1_31:Find("value"), Color.NewHex(var1_31))
	setText(arg1_31:Find("name"), var0_31.name)
	setText(arg1_31:Find("value"), arg2_31.num)
	removeOnButton(arg1_31)
end

function var0_0.UpdateGrayLabel(arg0_32, arg1_32)
	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "bg_label_gray", arg1_32, true)

	local var0_32 = #arg0_32.labels == 0

	setTextColor(arg1_32:Find("name"), Color.NewHex("#F7F7F7"))
	setText(arg1_32:Find("name"), var0_32 and i18n("island_card_no_label") or i18n("island_card_view_detaills"))
	setText(arg1_32:Find("value"), "")

	if not var0_32 then
		onButton(arg0_32, arg1_32, function()
			arg0_32.showLabelBox:ExecuteAction("Show", arg0_32.labels)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_32)
	end
end

function var0_0.UpdataInfos(arg0_34)
	setText(arg0_34.nameTF, arg0_34.card.name)
	setText(arg0_34.levelTF, "Lv." .. arg0_34.card.level)
	setText(arg0_34.wordTF, arg0_34.card.word)
	setText(arg0_34.likeTF, arg0_34.card.likeCnt)
	setText(arg0_34.visitTF, arg0_34.card.visitCnt)
	setText(arg0_34.shipTF, arg0_34.card.shipCnt)
	setText(arg0_34.achvTF, arg0_34.card.achvCnt)
	setText(arg0_34.bookTF, arg0_34.card.bookCnt)
	arg0_34.achvUIList:align(var0_0.ACHV_SHOW_CNT)
end

function var0_0.OnSetNameDone(arg0_35, arg1_35)
	arg0_35:HideEditPanel()
	arg0_35.editNameBox:ExecuteAction("Hide")

	arg0_35.card.name = arg1_35

	setText(arg0_35.nameTF, arg0_35.card.name)
end

function var0_0.OnSetWordDone(arg0_36, arg1_36)
	arg0_36:HideEditPanel()
	arg0_36.editWordBox:ExecuteAction("Hide")

	arg0_36.card.word = arg1_36

	setText(arg0_36.wordTF, arg0_36.card.word)
end

function var0_0.OnSetPhotoDone(arg0_37, arg1_37)
	arg0_37.setPhotoBox:ExecuteAction("Hide")

	arg0_37.card.photoStr = arg1_37

	arg0_37:UpdataPhoto()
end

function var0_0.OnSetAchvsDone(arg0_38, arg1_38)
	arg0_38.setAchvsBox:ExecuteAction("Hide")

	arg0_38.card.achvList = getProxy(IslandProxy):GetIsland():GetAchievementAgency():UpdataAchLv(arg1_38)

	arg0_38.achvUIList:align(var0_0.ACHV_SHOW_CNT)

	local var0_38 = {}

	arg0_38.achvUIList:eachActive(function(arg0_39, arg1_39)
		if arg0_38.card.achvList[arg0_39 + 1] then
			local var0_39 = arg1_39:Find("content/Image")

			var0_39:GetComponent(typeof(CanvasGroup)).alpha = 0

			table.insert(var0_38, function(arg0_40)
				arg1_39:GetComponent(typeof(Animation)):Play()

				var0_39:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0_38:managedTween(LeanTween.delayedCall, function()
					arg0_40()
				end, 0.08, nil)
			end)
		end
	end)
	seriesAsync(var0_38)
end

function var0_0.PlayHideAnim(arg0_42)
	if arg0_42.playingHideAnim then
		return
	end

	arg0_42.uiAnim:Play("anim_IslandSelfCardUI_out")

	arg0_42.playingHideAnim = true
end

function var0_0.willExit(arg0_43)
	arg0_43.uiAnimEvent:SetEndEvent(nil)

	if not arg0_43.contextData.isIslandPage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_43._tf)
	end

	if arg0_43.editNameBox then
		arg0_43.editNameBox:Destroy()

		arg0_43.editNameBox = nil
	end

	if arg0_43.editWordBox then
		arg0_43.editWordBox:Destroy()

		arg0_43.editWordBox = nil
	end

	if arg0_43.setPhotoBox then
		arg0_43.setPhotoBox:Destroy()

		arg0_43.setPhotoBox = nil
	end

	if arg0_43.setAchvsBox then
		arg0_43.setAchvsBox:Destroy()

		arg0_43.setAchvsBox = nil
	end

	if arg0_43.showLabelBox then
		arg0_43.showLabelBox:Destroy()

		arg0_43.showLabelBox = nil
	end
end

return var0_0
