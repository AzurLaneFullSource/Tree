local var0_0 = class("BackYardThemeTemplateDescPage", import("....base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = {
	{
		"text_desc",
		"text_allin"
	},
	{
		"text_delete",
		"text_upload",
		"text_cancel_upload"
	},
	{
		"text_desc",
		"text_allin"
	}
}

local function var5_0(arg0_1)
	return var4_0[arg0_1]
end

function var0_0.getUIName(arg0_2)
	return "BackYardThemeTemplateDescPage"
end

function var0_0.ThemeTemplateUpdate(arg0_3, arg1_3)
	if arg0_3.template and arg0_3.template.id == arg1_3.id then
		arg0_3.template = arg1_3

		arg0_3:Flush()
	end
end

function var0_0.UpdateDorm(arg0_4, arg1_4)
	arg0_4.dorm = arg1_4
end

function var0_0.PlayerUpdated(arg0_5, arg1_5)
	arg0_5.player = arg1_5
end

function var0_0.OnLoaded(arg0_6)
	arg0_6.adpter = arg0_6:findTF("adpter")
	arg0_6.frame = arg0_6:findTF("adpter/frame")
	arg0_6.icon = arg0_6:findTF("adpter/frame/icon"):GetComponent(typeof(Image))
	arg0_6.idTxt = arg0_6:findTF("adpter/frame/ID"):GetComponent(typeof(Text))
	arg0_6.idLabel = arg0_6:findTF("adpter/frame/ID_label"):GetComponent(typeof(Text))
	arg0_6.copyBtn = arg0_6:findTF("adpter/frame/copy")
	arg0_6.nameTxt = arg0_6:findTF("adpter/frame/name"):GetComponent(typeof(Text))
	arg0_6.mainPanel = arg0_6:findTF("adpter/frame/main")
	arg0_6.timeTxt = arg0_6.mainPanel:Find("time"):GetComponent(typeof(Text))
	arg0_6.btn1 = arg0_6.mainPanel:Find("desc_btn")
	arg0_6.btn1Txt = arg0_6.mainPanel:Find("desc_btn/Text"):GetComponent(typeof(Text))
	arg0_6.btn2 = arg0_6.mainPanel:Find("push_btn")
	arg0_6.btn2Txt = arg0_6.mainPanel:Find("push_btn/Text"):GetComponent(typeof(Text))
	arg0_6.heart = arg0_6.mainPanel:Find("heart")
	arg0_6.heartSel = arg0_6.mainPanel:Find("heart/sel")
	arg0_6.heartTxt = arg0_6.mainPanel:Find("heart/Text"):GetComponent(typeof(Text))
	arg0_6.collection = arg0_6.mainPanel:Find("collection")
	arg0_6.collectionSel = arg0_6.mainPanel:Find("collection/sel")
	arg0_6.collectionTxt = arg0_6.mainPanel:Find("collection/Text"):GetComponent(typeof(Text))
	arg0_6.idLabel.text = i18n("word_theme") .. "ID:"
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7.copyBtn, function()
		if arg0_7.player then
			UniPasteBoard.SetClipBoardString(arg0_7.template.id)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
		end
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	arg0_9.pageType = arg1_9
	arg0_9.template = arg2_9
	arg0_9.dorm = arg3_9
	arg0_9.player = arg4_9

	arg0_9:RefreshSortBtn()
	arg0_9:Flush()
	arg0_9:Show()
end

function var0_0.RefreshSortBtn(arg0_10)
	local var0_10
	local var1_10

	if arg0_10.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var2_10

		var2_10, var1_10 = BackYardConst.ServerIndex2ThemeSortIndex(getProxy(DormProxy).TYPE)
	else
		local var3_10

		var3_10, var1_10 = 1, true
	end

	arg0_10.sortFlag = var1_10
end

function var0_0.Flush(arg0_11)
	arg0_11:UpdateWindow()
	arg0_11:UpdatePlayer()
	arg0_11:UpdateLikeInfo()
	arg0_11["Update" .. arg0_11.pageType](arg0_11)
end

function var0_0.Update1(arg0_12)
	onButton(arg0_12, arg0_12.btn1, function()
		arg0_12.contextData.infoPage:ExecuteAction("SetUp", arg0_12.template, arg0_12.dorm, arg0_12.player)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.btn2, function()
		arg0_12.contextData.msgBox:ExecuteAction("SetUp", {
			type = BackYardThemeTemplateMsgBox.TYPE_IMAGE,
			content = i18n("backyard_theme_apply_tip2"),
			srpiteName = arg0_12.template:GetTextureIconName(),
			md5 = arg0_12.template:GetIconMd5(),
			onYes = function()
				arg0_12:emit(NewBackYardThemeTemplateMediator.ON_APPLY_TEMPLATE, arg0_12.template, function()
					triggerButton(arg0_12.btn1)
				end)
			end
		})
	end, SFX_PANEL)

	arg0_12.btn1Txt.text = i18n("courtyard_label_detail")
	arg0_12.btn2Txt.text = i18n("courtyard_label_place_pnekey")
end

function var0_0.Update2(arg0_17)
	local var0_17 = arg0_17.template
	local var1_17 = var0_17:IsPushed()

	onButton(arg0_17, arg0_17.btn1, function()
		arg0_17:emit(NewBackYardThemeTemplateMediator.ON_DELETE_TEMPLATE, var0_17)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.btn2, function()
		if var1_17 then
			arg0_17:emit(NewBackYardThemeTemplateMediator.ON_CANCEL_UPLOAD_TEMPLATE, var0_17)
		else
			arg0_17:emit(NewBackYardThemeTemplateMediator.ON_UPLOAD_TEMPLATE, var0_17)
		end
	end, SFX_PANEL)

	if not var1_17 then
		local var2_17 = getProxy(DormProxy):GetUploadThemeTemplateCnt()

		arg0_17.timeTxt.text = i18n("backyard_theme_upload_cnt", var2_17, BackYardConst.MAX_UPLOAD_THEME_CNT)
	end

	arg0_17.btn1Txt.text = i18n("courtyard_label_delete")
	arg0_17.btn2Txt.text = var1_17 and i18n("courtyard_label_cancel_share") or i18n("courtyard_label_share")
end

function var0_0.Update3(arg0_20)
	arg0_20:Update1()

	arg0_20.timeTxt.text = i18n("backyard_theme_template_collection_cnt") .. getProxy(DormProxy):GetThemeTemplateCollectionCnt() .. "/" .. BackYardConst.MAX_COLLECTION_CNT
	arg0_20.btn1Txt.text = i18n("courtyard_label_detail")
	arg0_20.btn2Txt.text = i18n("courtyard_label_place_pnekey")
end

function var0_0.UpdatePlayer(arg0_21)
	if not arg0_21.template:ExistPlayerInfo() then
		arg0_21:emit(NewBackYardThemeTemplateMediator.GET_TEMPLATE_PLAYERINFO, arg0_21.pageType, arg0_21.template)
	else
		local var0_21 = arg0_21.template.player

		arg0_21.player = var0_21
		arg0_21.nameTxt.text = var0_21:GetName()
		arg0_21.idTxt.text = arg0_21.template.id
		arg0_21.timeTxt.text = i18n("backyard_theme_upload_time") .. arg0_21.template:GetUploadTime()

		LoadSpriteAsync("qicon/" .. var0_21:getPainting(), function(arg0_22)
			if IsNil(arg0_21.icon) then
				return
			end

			arg0_21.icon.sprite = arg0_22
		end)

		if arg0_21.preLoadIcon then
			local var1_21 = arg0_21.preLoadIcon.name

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1_21, var1_21, arg0_21.preLoadIcon)
		end

		local var2_21 = AttireFrame.attireFrameRes(var0_21, var0_21.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var0_21.propose)

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_21, var2_21, true, function(arg0_23)
			if arg0_21.icon then
				arg0_23.name = var2_21
				findTF(arg0_23.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

				setParent(arg0_23, arg0_21.icon.gameObject, false)

				arg0_21.preLoadIcon = arg0_23
			end
		end)
		onButton(arg0_21, arg0_21.icon, function()
			if var0_21.id == getProxy(PlayerProxy):getRawData().id then
				return
			end

			local var0_24 = tf(arg0_21.icon.gameObject).position
			local var1_24 = arg0_21.template:GetName()

			arg0_21:emit(NewBackYardThemeTemplateMediator.ON_DISPLAY_PLAYER_INFO, var0_21.id, var0_24, arg0_21.template.id)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateLikeInfo(arg0_25)
	local var0_25 = arg0_25.template

	arg0_25.heartTxt.text = i18n("backyard_theme_word_like") .. var0_25:GetLikeCnt()
	arg0_25.collectionTxt.text = i18n("backyard_theme_word_collection") .. var0_25:GetCollectionCnt()

	local var1_25 = arg0_25.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM
	local var2_25 = var0_25:IsLiked()

	onButton(arg0_25, arg0_25.heart, function()
		if arg0_25.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			return
		end

		if not var2_25 then
			arg0_25:emit(NewBackYardThemeTemplateMediator.ON_LIKE_THEME, arg0_25.template, arg0_25.template.time)
		end
	end, SFX_PANEL)
	setActive(arg0_25.heartSel, var2_25 or var1_25)

	local var3_25 = var0_25:IsCollected()

	onButton(arg0_25, arg0_25.collection, function()
		if arg0_25.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			return
		end

		if var3_25 then
			arg0_25.contextData.msgBox:ExecuteAction("SetUp", {
				content = i18n("backyard_theme_cancel_collection"),
				onYes = function()
					arg0_25:emit(NewBackYardThemeTemplateMediator.ON_COLECT_THEME, arg0_25.template, true, arg0_25.template.time)
				end
			})
		else
			arg0_25:emit(NewBackYardThemeTemplateMediator.ON_COLECT_THEME, arg0_25.template, false, arg0_25.template.time)
		end
	end, SFX_PANEL)
	setActive(arg0_25.collectionSel, var3_25 or var1_25)
end

function var0_0.UpdateWindow(arg0_29)
	local var0_29 = true

	if arg0_29.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_29.frame.sizeDelta = Vector2(arg0_29.frame.sizeDelta.x, 456)
	elseif arg0_29.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		if arg0_29.template:IsPushed() then
			arg0_29.frame.sizeDelta = Vector2(arg0_29.frame.sizeDelta.x, 456)
		else
			var0_29 = false
			arg0_29.frame.sizeDelta = Vector2(arg0_29.frame.sizeDelta.x, 395)
		end
	elseif arg0_29.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_29.frame.sizeDelta = Vector2(arg0_29.frame.sizeDelta.x, 456)
	end

	setActive(arg0_29.heart, var0_29)
	setActive(arg0_29.collection, var0_29)
end

function var0_0.Show(arg0_30)
	arg0_30.isShowing = true

	var0_0.super.Show(arg0_30)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_30.adpter, {
		pbList = {
			arg0_30:findTF("adpter/frame")
		}
	})
end

function var0_0.Hide(arg0_31)
	arg0_31.isShowing = false

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_31.adpter, arg0_31._tf)
	var0_0.super.Hide(arg0_31)
end

function var0_0.OnDestroy(arg0_32)
	if arg0_32.isShowing then
		arg0_32:Hide()
	end

	if arg0_32.preLoadIcon then
		local var0_32 = arg0_32.preLoadIcon.name

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_32, var0_32, arg0_32.preLoadIcon)
	end
end

return var0_0
