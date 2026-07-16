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

function var0_0.init(arg0_8)
	arg0_8.uiAnim = arg0_8._tf:GetComponent(typeof(Animation))
	arg0_8.uiAnimEvent = arg0_8._tf:GetComponent(typeof(DftAniEvent))

	arg0_8.uiAnimEvent:SetEndEvent(function()
		arg0_8.playingHideAnim = false

		arg0_8:closeView(arg0_8)
	end)
	setText(arg0_8._tf:Find("tip"), i18n("island_card_close"))

	local var0_8 = arg0_8._tf:Find("panel")

	arg0_8.photoTF = var0_8:Find("photo/Image")
	arg0_8.photoSwitchBtn = var0_8:Find("photo/switch")
	arg0_8.likeTF = var0_8:Find("photo/like")
	arg0_8.labelsTF = var0_8:Find("labels")
	arg0_8.visitTF = var0_8:Find("btns/visit/Text")
	arg0_8.diyBtn = var0_8:Find("btns/diy")
	arg0_8.whitelistBtn = var0_8:Find("btns/whitelist")
	arg0_8.blacklistBtn = var0_8:Find("btns/blacklist")
	arg0_8.levelTF = var0_8:Find("level")
	arg0_8.wordTF = var0_8:Find("word")
	arg0_8.nameTF = var0_8:Find("name")
	arg0_8.addBtn = arg0_8.nameTF:Find("add")
	arg0_8.removeBtn = arg0_8.nameTF:Find("remove")
	arg0_8.editBtn = arg0_8.nameTF:Find("edit")
	arg0_8.editPanel = arg0_8._tf:Find("editPanel")
	arg0_8.editNameBtn = arg0_8.editPanel:Find("content/name")

	setText(arg0_8.editNameBtn:Find("Text"), i18n("island_card_edit_name"))

	arg0_8.editWordBtn = arg0_8.editPanel:Find("content/word")

	setText(arg0_8.editWordBtn:Find("Text"), i18n("island_card_edit_word"))

	arg0_8.shipTF = var0_8:Find("counts/ship/Text")
	arg0_8.achvTF = var0_8:Find("counts/achv/Text")
	arg0_8.bookTF = var0_8:Find("counts/book/Text")
	arg0_8.achvUIList = UIItemList.New(var0_8:Find("achvs"), var0_8:Find("achvs/tpl"))

	setText(var0_8:Find("achvs/tpl/empty/Text"), i18n("island_card_no_achv_self"))
	arg0_8:InitBoxs()
end

function var0_0.InitBoxs(arg0_10)
	arg0_10.editNameBox = IslandEditCardNameBox.New(arg0_10._tf, arg0_10.event)
	arg0_10.editWordBox = IslandEditCardWordBox.New(arg0_10._tf, arg0_10.event)
	arg0_10.setPhotoBox = IslandSetCardPhotoBox.New(arg0_10._tf, arg0_10.event)
	arg0_10.setAchvsBox = IslandSetCardAchvsBox.New(arg0_10._tf, arg0_10.event)
	arg0_10.showLabelBox = IslandShowCardLabelBox.New(arg0_10._tf, arg0_10.event)
end

function var0_0.didEnter(arg0_11)
	if not arg0_11.contextData.isIslandPage then
		pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf)
	end

	onButton(arg0_11, arg0_11._tf:Find("panel/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_helpbtn_card.tip
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11._tf:Find("close"), function()
		arg0_11:PlayHideAnim()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.photoSwitchBtn, function()
		local var0_14 = arg0_11.island:GetCardDiyAgency():GetIds()

		arg0_11.setPhotoBox:ExecuteAction("Show", var0_14, arg0_11.photoId)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.editBtn, function()
		arg0_11:ShowEditPanel()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.editPanel:Find("close"), function()
		arg0_11:HideEditPanel()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.editNameBtn, function()
		arg0_11.editNameBox:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.editWordBtn, function()
		arg0_11.editWordBox:ExecuteAction("Show")
	end, SFX_PANEL)
	arg0_11:InitAchvUIList()
	arg0_11:Flush()
end

function var0_0.InitAchvUIList(arg0_19)
	arg0_19.achvUIList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventInit then
			onButton(arg0_19, arg2_20, function()
				local var0_21 = arg0_19.island:GetAchievementAgency():GetGotGroupMaxStageList()

				arg0_19.setAchvsBox:ExecuteAction("Show", var0_21, Clone(arg0_19.card.achvList))
			end, SFX_PANEL)
		elseif arg0_20 == UIItemList.EventUpdate then
			arg0_19:UpdataAchvItem(arg1_20, arg2_20)
		end
	end)
end

function var0_0.ShowEditPanel(arg0_22)
	local var0_22 = arg0_22._tf:InverseTransformPoint(arg0_22.editBtn.position)

	setAnchoredPosition(arg0_22.editPanel:Find("content"), var0_22)
	setActive(arg0_22.editPanel, true)
end

function var0_0.HideEditPanel(arg0_23)
	setActive(arg0_23.editPanel, false)
end

function var0_0.UpdataAchvItem(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.card.achvList[arg1_24 + 1]

	setActive(arg2_24:Find("empty"), not var0_24)
	setActive(arg2_24:Find("content"), var0_24)

	if var0_24 then
		local var1_24 = pg.island_achievement[var0_24]

		LoadImageSpriteAtlasAsync("islandachievement", "achv_stage_" .. var1_24.stage, arg2_24:Find("content/Image"), true)
		setText(arg2_24:Find("content/Text"), var1_24.name)
	end
end

function var0_0.Flush(arg0_25)
	arg0_25.card.achvList = getProxy(IslandProxy):GetIsland():GetAchievementAgency():UpdataAchLv(arg0_25.card.achvList)

	arg0_25:UpdataPhoto()
	arg0_25:UpdataLabels()
	arg0_25:UpdataInfos()
end

function var0_0.UpdataPhoto(arg0_26)
	arg0_26.photoId = tonumber(arg0_26.card.photoStr)

	if arg0_26.photoId then
		local var0_26 = pg.island_card_diy[arg0_26.photoId].resource

		LoadImageSpriteAsync(var0_26, arg0_26.photoTF, true)
	end
end

function var0_0.UpdataLabels(arg0_27)
	arg0_27.labels = arg0_27.card:GetLabelList()

	table.sort(arg0_27.labels, CompareFuncs({
		function(arg0_28)
			return -arg0_28.num
		end,
		function(arg0_29)
			return arg0_29.id
		end
	}))

	for iter0_27 = 1, var0_0.LABEL_SHOW_CNT + 1 do
		local var0_27 = arg0_27.labelsTF:GetChild(iter0_27 - 1)
		local var1_27 = iter0_27 <= #arg0_27.labels + 1

		setActive(var0_27, var1_27)

		if var1_27 then
			if iter0_27 <= #arg0_27.labels then
				arg0_27:UpdateNoramlLabel(var0_27, arg0_27.labels[iter0_27])
			else
				arg0_27:UpdateGrayLabel(var0_27)
			end
		end
	end
end

function var0_0.UpdateNoramlLabel(arg0_30, arg1_30, arg2_30)
	local var0_30 = pg.island_card_label[arg2_30.id]

	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "label_bg_" .. var0_30.color, arg1_30, true)

	local var1_30 = var0_0.COLORS[var0_30.color]

	setTextColor(arg1_30:Find("name"), Color.NewHex(var1_30))
	setTextColor(arg1_30:Find("value"), Color.NewHex(var1_30))
	setText(arg1_30:Find("name"), var0_30.name)
	setText(arg1_30:Find("value"), arg2_30.num)
	removeOnButton(arg1_30)
end

function var0_0.UpdateGrayLabel(arg0_31, arg1_31)
	LoadImageSpriteAtlasAsync("ui/islandcardui_atlas", "bg_label_gray", arg1_31, true)

	local var0_31 = #arg0_31.labels == 0

	setTextColor(arg1_31:Find("name"), Color.NewHex("#F7F7F7"))
	setText(arg1_31:Find("name"), var0_31 and i18n("island_card_no_label") or i18n("island_card_view_detaills"))
	setText(arg1_31:Find("value"), "")

	if not var0_31 then
		onButton(arg0_31, arg1_31, function()
			arg0_31.showLabelBox:ExecuteAction("Show", arg0_31.labels)
		end, SFX_PANEL)
	else
		removeOnButton(arg1_31)
	end
end

function var0_0.UpdataInfos(arg0_33)
	setText(arg0_33.nameTF, arg0_33.card.name)
	setText(arg0_33.levelTF, "Lv." .. arg0_33.card.level)
	setText(arg0_33.wordTF, arg0_33.card.word)
	setText(arg0_33.likeTF, arg0_33.card.likeCnt)
	setText(arg0_33.visitTF, arg0_33.card.visitCnt)
	setText(arg0_33.shipTF, arg0_33.card.shipCnt)
	setText(arg0_33.achvTF, arg0_33.card.achvCnt)
	setText(arg0_33.bookTF, arg0_33.card.bookCnt)
	arg0_33.achvUIList:align(var0_0.ACHV_SHOW_CNT)
end

function var0_0.OnSetNameDone(arg0_34, arg1_34)
	arg0_34:HideEditPanel()
	arg0_34.editNameBox:ExecuteAction("Hide")

	arg0_34.card.name = arg1_34

	setText(arg0_34.nameTF, arg0_34.card.name)
end

function var0_0.OnSetWordDone(arg0_35, arg1_35)
	arg0_35:HideEditPanel()
	arg0_35.editWordBox:ExecuteAction("Hide")

	arg0_35.card.word = arg1_35

	setText(arg0_35.wordTF, arg0_35.card.word)
end

function var0_0.OnSetPhotoDone(arg0_36, arg1_36)
	arg0_36.setPhotoBox:ExecuteAction("Hide")

	arg0_36.card.photoStr = arg1_36

	arg0_36:UpdataPhoto()
end

function var0_0.OnSetAchvsDone(arg0_37, arg1_37)
	arg0_37.setAchvsBox:ExecuteAction("Hide")

	arg0_37.card.achvList = getProxy(IslandProxy):GetIsland():GetAchievementAgency():UpdataAchLv(arg1_37)

	arg0_37.achvUIList:align(var0_0.ACHV_SHOW_CNT)

	local var0_37 = {}

	arg0_37.achvUIList:eachActive(function(arg0_38, arg1_38)
		if arg0_37.card.achvList[arg0_38 + 1] then
			local var0_38 = arg1_38:Find("content/Image")

			var0_38:GetComponent(typeof(CanvasGroup)).alpha = 0

			table.insert(var0_37, function(arg0_39)
				arg1_38:GetComponent(typeof(Animation)):Play()

				var0_38:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0_37:managedTween(LeanTween.delayedCall, function()
					arg0_39()
				end, 0.08, nil)
			end)
		end
	end)
	seriesAsync(var0_37)
end

function var0_0.PlayHideAnim(arg0_41)
	if arg0_41.playingHideAnim then
		return
	end

	arg0_41.uiAnim:Play("anim_IslandSelfCardUI_out")

	arg0_41.playingHideAnim = true
end

function var0_0.willExit(arg0_42)
	arg0_42.uiAnimEvent:SetEndEvent(nil)

	if not arg0_42.contextData.isIslandPage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_42._tf)
	end

	if arg0_42.editNameBox then
		arg0_42.editNameBox:Destroy()

		arg0_42.editNameBox = nil
	end

	if arg0_42.editWordBox then
		arg0_42.editWordBox:Destroy()

		arg0_42.editWordBox = nil
	end

	if arg0_42.setPhotoBox then
		arg0_42.setPhotoBox:Destroy()

		arg0_42.setPhotoBox = nil
	end

	if arg0_42.setAchvsBox then
		arg0_42.setAchvsBox:Destroy()

		arg0_42.setAchvsBox = nil
	end

	if arg0_42.showLabelBox then
		arg0_42.showLabelBox:Destroy()

		arg0_42.showLabelBox = nil
	end
end

return var0_0
