local var0 = class("BackYardThemeTemplateDescPage", import("....base.BaseSubView"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = {
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

local function var5(arg0)
	return var4[arg0]
end

function var0.getUIName(arg0)
	return "BackYardThemeTemplateDescPage"
end

function var0.ThemeTemplateUpdate(arg0, arg1)
	if arg0.template and arg0.template.id == arg1.id then
		arg0.template = arg1

		arg0:Flush()
	end
end

function var0.UpdateDorm(arg0, arg1)
	arg0.dorm = arg1
end

function var0.PlayerUpdated(arg0, arg1)
	arg0.player = arg1
end

function var0.OnLoaded(arg0)
	arg0.adpter = arg0:findTF("adpter")
	arg0.frame = arg0:findTF("adpter/frame")
	arg0.icon = arg0:findTF("adpter/frame/icon"):GetComponent(typeof(Image))
	arg0.idTxt = arg0:findTF("adpter/frame/ID"):GetComponent(typeof(Text))
	arg0.idLabel = arg0:findTF("adpter/frame/ID_label"):GetComponent(typeof(Text))
	arg0.copyBtn = arg0:findTF("adpter/frame/copy")
	arg0.nameTxt = arg0:findTF("adpter/frame/name"):GetComponent(typeof(Text))
	arg0.mainPanel = arg0:findTF("adpter/frame/main")
	arg0.timeTxt = arg0.mainPanel:Find("time"):GetComponent(typeof(Text))
	arg0.btn1 = arg0.mainPanel:Find("desc_btn")
	arg0.btn1Txt = arg0.mainPanel:Find("desc_btn/Text"):GetComponent(typeof(Text))
	arg0.btn2 = arg0.mainPanel:Find("push_btn")
	arg0.btn2Txt = arg0.mainPanel:Find("push_btn/Text"):GetComponent(typeof(Text))
	arg0.heart = arg0.mainPanel:Find("heart")
	arg0.heartSel = arg0.mainPanel:Find("heart/sel")
	arg0.heartTxt = arg0.mainPanel:Find("heart/Text"):GetComponent(typeof(Text))
	arg0.collection = arg0.mainPanel:Find("collection")
	arg0.collectionSel = arg0.mainPanel:Find("collection/sel")
	arg0.collectionTxt = arg0.mainPanel:Find("collection/Text"):GetComponent(typeof(Text))
	arg0.idLabel.text = i18n("word_theme") .. "ID:"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.copyBtn, function()
		if arg0.player then
			UniPasteBoard.SetClipBoardString(arg0.template.id)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
		end
	end, SFX_PANEL)
end

function var0.SetUp(arg0, arg1, arg2, arg3, arg4)
	arg0.pageType = arg1
	arg0.template = arg2
	arg0.dorm = arg3
	arg0.player = arg4

	arg0:RefreshSortBtn()
	arg0:Flush()
	arg0:Show()
end

function var0.RefreshSortBtn(arg0)
	local var0
	local var1

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var2

		var2, var1 = BackYardConst.ServerIndex2ThemeSortIndex(getProxy(DormProxy).TYPE)
	else
		local var3

		var3, var1 = 1, true
	end

	arg0.sortFlag = var1
end

function var0.Flush(arg0)
	arg0:UpdateWindow()
	arg0:UpdatePlayer()
	arg0:UpdateLikeInfo()
	arg0["Update" .. arg0.pageType](arg0)
end

function var0.Update1(arg0)
	onButton(arg0, arg0.btn1, function()
		arg0.contextData.infoPage:ExecuteAction("SetUp", arg0.template, arg0.dorm, arg0.player)
	end, SFX_PANEL)
	onButton(arg0, arg0.btn2, function()
		arg0.contextData.msgBox:ExecuteAction("SetUp", {
			type = BackYardThemeTemplateMsgBox.TYPE_IMAGE,
			content = i18n("backyard_theme_apply_tip2"),
			srpiteName = arg0.template:GetTextureIconName(),
			md5 = arg0.template:GetIconMd5(),
			onYes = function()
				arg0:emit(NewBackYardThemeTemplateMediator.ON_APPLY_TEMPLATE, arg0.template, function()
					triggerButton(arg0.btn1)
				end)
			end
		})
	end, SFX_PANEL)

	arg0.btn1Txt.text = i18n("courtyard_label_detail")
	arg0.btn2Txt.text = i18n("courtyard_label_place_pnekey")
end

function var0.Update2(arg0)
	local var0 = arg0.template
	local var1 = var0:IsPushed()

	onButton(arg0, arg0.btn1, function()
		arg0:emit(NewBackYardThemeTemplateMediator.ON_DELETE_TEMPLATE, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.btn2, function()
		if var1 then
			arg0:emit(NewBackYardThemeTemplateMediator.ON_CANCEL_UPLOAD_TEMPLATE, var0)
		else
			arg0:emit(NewBackYardThemeTemplateMediator.ON_UPLOAD_TEMPLATE, var0)
		end
	end, SFX_PANEL)

	if not var1 then
		local var2 = getProxy(DormProxy):GetUploadThemeTemplateCnt()

		arg0.timeTxt.text = i18n("backyard_theme_upload_cnt", var2, BackYardConst.MAX_UPLOAD_THEME_CNT)
	end

	arg0.btn1Txt.text = i18n("courtyard_label_delete")
	arg0.btn2Txt.text = var1 and i18n("courtyard_label_cancel_share") or i18n("courtyard_label_share")
end

function var0.Update3(arg0)
	arg0:Update1()

	arg0.timeTxt.text = i18n("backyard_theme_template_collection_cnt") .. getProxy(DormProxy):GetThemeTemplateCollectionCnt() .. "/" .. BackYardConst.MAX_COLLECTION_CNT
	arg0.btn1Txt.text = i18n("courtyard_label_detail")
	arg0.btn2Txt.text = i18n("courtyard_label_place_pnekey")
end

function var0.UpdatePlayer(arg0)
	if not arg0.template:ExistPlayerInfo() then
		arg0:emit(NewBackYardThemeTemplateMediator.GET_TEMPLATE_PLAYERINFO, arg0.pageType, arg0.template)
	else
		local var0 = arg0.template.player

		arg0.player = var0
		arg0.nameTxt.text = var0:GetName()
		arg0.idTxt.text = arg0.template.id
		arg0.timeTxt.text = i18n("backyard_theme_upload_time") .. arg0.template:GetUploadTime()

		LoadSpriteAsync("qicon/" .. var0:getPainting(), function(arg0)
			if IsNil(arg0.icon) then
				return
			end

			arg0.icon.sprite = arg0
		end)

		if arg0.preLoadIcon then
			local var1 = arg0.preLoadIcon.name

			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1, var1, arg0.preLoadIcon)
		end

		local var2 = AttireFrame.attireFrameRes(var0, var0.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var0.propose)

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2, var2, true, function(arg0)
			if arg0.icon then
				arg0.name = var2
				findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

				setParent(arg0, arg0.icon.gameObject, false)

				arg0.preLoadIcon = arg0
			end
		end)
		onButton(arg0, arg0.icon, function()
			if var0.id == getProxy(PlayerProxy):getRawData().id then
				return
			end

			local var0 = tf(arg0.icon.gameObject).position
			local var1 = arg0.template:GetName()

			arg0:emit(NewBackYardThemeTemplateMediator.ON_DISPLAY_PLAYER_INFO, var0.id, var0, arg0.template.id)
		end, SFX_PANEL)
	end
end

function var0.UpdateLikeInfo(arg0)
	local var0 = arg0.template

	arg0.heartTxt.text = i18n("backyard_theme_word_like") .. var0:GetLikeCnt()
	arg0.collectionTxt.text = i18n("backyard_theme_word_collection") .. var0:GetCollectionCnt()

	local var1 = arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM
	local var2 = var0:IsLiked()

	onButton(arg0, arg0.heart, function()
		if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			return
		end

		if not var2 then
			arg0:emit(NewBackYardThemeTemplateMediator.ON_LIKE_THEME, arg0.template, arg0.template.time)
		end
	end, SFX_PANEL)
	setActive(arg0.heartSel, var2 or var1)

	local var3 = var0:IsCollected()

	onButton(arg0, arg0.collection, function()
		if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			return
		end

		if var3 then
			arg0.contextData.msgBox:ExecuteAction("SetUp", {
				content = i18n("backyard_theme_cancel_collection"),
				onYes = function()
					arg0:emit(NewBackYardThemeTemplateMediator.ON_COLECT_THEME, arg0.template, true, arg0.template.time)
				end
			})
		else
			arg0:emit(NewBackYardThemeTemplateMediator.ON_COLECT_THEME, arg0.template, false, arg0.template.time)
		end
	end, SFX_PANEL)
	setActive(arg0.collectionSel, var3 or var1)
end

function var0.UpdateWindow(arg0)
	local var0 = true

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0.frame.sizeDelta = Vector2(arg0.frame.sizeDelta.x, 456)
	elseif arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		if arg0.template:IsPushed() then
			arg0.frame.sizeDelta = Vector2(arg0.frame.sizeDelta.x, 456)
		else
			var0 = false
			arg0.frame.sizeDelta = Vector2(arg0.frame.sizeDelta.x, 395)
		end
	elseif arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0.frame.sizeDelta = Vector2(arg0.frame.sizeDelta.x, 456)
	end

	setActive(arg0.heart, var0)
	setActive(arg0.collection, var0)
end

function var0.Show(arg0)
	arg0.isShowing = true

	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.adpter, {
		pbList = {
			arg0:findTF("adpter/frame")
		}
	})
end

function var0.Hide(arg0)
	arg0.isShowing = false

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.adpter, arg0._tf)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	if arg0.isShowing then
		arg0:Hide()
	end

	if arg0.preLoadIcon then
		local var0 = arg0.preLoadIcon.name

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0, var0, arg0.preLoadIcon)
	end
end

return var0
