local var0 = class("NewBulletinBoardLayer", import("..base.BaseUI"))

var0.CONTENT_TYPE = {
	BANNER = "BANNER",
	RICHTEXT = "RITCHTEXT"
}
var0.ICON_NAME = {
	"activity_common",
	"activity_summary",
	"activity_time_limit",
	"build_time_limit",
	"equibment_skin_new",
	"furniture_new",
	"info_common",
	"skin_new",
	"system_common"
}
var0.MAIN_TAB_GAMETIP = {
	"Announcements_Event_Notice",
	"Announcements_System_Notice",
	"Announcements_News"
}
var0.TITLE_IMAGE_HEIGHT_DEFAULT = 231
var0.TITLE_IMAGE_HEIGHT_FULL = 734

function var0.getUIName(arg0)
	return "NewBulletinBoardUI"
end

function var0.init(arg0)
	arg0._closeBtn = arg0:findTF("bg/close_btn")
	arg0._mainTabContainer = arg0:findTF("bg/notice_list")
	arg0._subTabGroup = arg0:findTF("bg/title_list/viewport/content"):GetComponent(typeof(ToggleGroup))
	arg0._subTabContainer = arg0:findTF("bg/title_list/viewport/content")
	arg0._tabTpl = arg0:findTF("bg/title_list/tab_btn_tpl")

	SetActive(arg0._tabTpl, false)

	arg0._subTabList = {}
	arg0._detailTitleImg = arg0:findTF("bg/content_view/viewport/content/title_img")
	arg0._detailTitleImgLayoutElement = arg0._detailTitleImg:GetComponent(typeof(LayoutElement))
	arg0._detailTitle = arg0:findTF("bg/content_view/viewport/content/title")
	arg0._detailTitleTxt = arg0:findTF("bg/content_view/viewport/content/title/title_txt/mask/scroll_txt")
	arg0._detailTimeTxt = arg0:findTF("bg/content_view/viewport/content/title/time_txt")
	arg0._detailLine = arg0:findTF("bg/content_view/viewport/content/line")
	arg0._contentContainer = arg0:findTF("bg/content_view/viewport/content/content_container")
	arg0._contentTxtTpl = arg0:findTF("bg/content_view/viewport/content/content_txt")

	setActive(arg0._contentTxtTpl, false)

	arg0._contentBannerTpl = arg0:findTF("bg/content_view/viewport/content/content_banner")

	setActive(arg0._contentBannerTpl, false)

	arg0._scrollRect = arg0:findTF("bg/content_view"):GetComponent(typeof(ScrollRect))
	arg0._dontshow = arg0:findTF("bg/dont_show")
	arg0._stopRemind = arg0:findTF("bg/dont_show/bottom")
	arg0._subTabAnims = {}
	arg0._mainAnim = arg0._tf:GetComponent(typeof(Animation))
	arg0._bgAnim = arg0:findTF("bg"):GetComponent(typeof(Animation))
	arg0._contentAnim = arg0:findTF("bg/content_view"):GetComponent(typeof(Animation))

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0._loadingFlag = {}
	arg0._contentList = {}
	arg0.noticeKeys = {}
	arg0.noticeVersions = {}
	arg0._noticeDic = {
		{},
		{},
		{}
	}
	arg0._redDic = {
		{},
		{},
		{}
	}
	arg0.LTList = {}
end

function var0.didEnter(arg0)
	arg0._mainAnim:Play("anim_BulletinBoard_in")
	onButton(arg0, arg0._closeBtn, function()
		arg0._mainAnim:Play("anim_BulletinBoard_out")
		LeanTween.delayedCall(0.2, System.Action(function()
			arg0:emit(var0.ON_CLOSE)
		end))
	end, SOUND_BACK)
	onToggle(arg0, arg0._stopRemind, function(arg0)
		arg0:emit(NewBulletinBoardMediator.SET_STOP_REMIND, arg0)
	end)

	local var0 = getProxy(ServerNoticeProxy):getStopRemind()

	triggerToggle(arg0._stopRemind, var0)
	setText(arg0._dontshow, i18n("Announcements_Donotshow"))
	LeanTween.rotateAroundLocal(rtf(arg0._detailTitleImg:Find("loading/Image")), Vector3(0, 0, -1), 360, 5):setLoopClamp()
end

function var0.updateRed(arg0)
	for iter0 = 1, 3 do
		local var0 = false

		for iter1, iter2 in pairs(arg0._noticeDic[iter0]) do
			arg0._redDic[iter0][iter1] = PlayerPrefs.HasKey(iter2.code)

			if not arg0._redDic[iter0][iter1] then
				var0 = true
			end
		end

		setActive(arg0._mainTabContainer:GetChild(iter0 - 1):Find("Text/red"), var0)
	end

	for iter3 = 1, #arg0._subTabList do
		setActive(arg0._subTabList[iter3]:Find("red"), not arg0._redDic[arg0.currentMainTab][iter3])
	end
end

function var0.checkNotice(arg0, arg1)
	return arg1.type and arg1.type > 0 and arg1.type < 4 and (arg1.paramType == nil or arg1.paramType == 1 and type(arg1.param) == "string" or arg1.paramType == 2 and type(arg1.param) == "string" or arg1.paramType == 3 and type(arg1.param) == "number")
end

function var0.initNotices(arg0, arg1)
	arg0.defaultMainTab = arg0.contextData.defaultMainTab
	arg0.defaultSubTab = arg0.contextData.defaultSubTab

	for iter0, iter1 in pairs(arg1) do
		local var0 = string.match(iter1.titleImage, "<config.*/>")
		local var1 = Clone(iter1)
		local var2 = var0 and string.match(var0, "link%s*=%s*([^%s]+)") or nil
		local var3 = var0 and tonumber(string.match(var0, "type%s*=%s*(%d+)")) or nil
		local var4

		if var3 then
			if var3 == 1 then
				var4 = string.match(var0, "param%s*=%s*'(.*)'")
			elseif var3 == 2 then
				var4 = string.match(var0, "param%s*=%s*'(.*)'")
			elseif var3 == 3 then
				var4 = string.match(var0, "param%s*=%s*(%d+)")
				var4 = var4 and tonumber(var4) or var4
			end
		end

		var1.param = var4
		var1.link = var2
		var1.paramType = var3
		var1.titleImage = var0 and string.gsub(var1.titleImage, var0, "") or var1.titleImage
		var1.code = var1:prefKey()

		if arg0:checkNotice(var1) then
			table.insert(arg0._noticeDic[var1.type], var1)
			table.insert(arg0._redDic[var1.type], PlayerPrefs.HasKey(var1.code))
		else
			Debugger.LogWarning("公告配置错误  id = " .. var1.id)
		end
	end

	for iter2 = 1, 3 do
		local var5 = arg0._mainTabContainer:GetChild(iter2 - 1)
		local var6 = var5:Find("selected"):GetComponent(typeof(Animation))

		setText(var5:Find("Text"), i18n(var0.MAIN_TAB_GAMETIP[iter2]))
		onToggle(arg0, var5, function(arg0)
			if arg0 then
				if arg0.currentMainTab and arg0.currentMainTab == iter2 then
					return
				end

				if arg0.currentMainTab then
					var6:Play(arg0.currentMainTab > iter2 and "anim_BB_toptitle_R_in" or "anim_BB_toptitle_L_in")
					arg0._bgAnim:Play(arg0.currentMainTab > iter2 and "anim_BulletinBoard_Rin_change" or "anim_BulletinBoard_Lin_change")
				end

				arg0.currentMainTab = iter2
				arg0.defaultSubTab = arg0.tempSubTab
				arg0.tempSubTab = nil

				arg0:setNotices(arg0._noticeDic[iter2])
			end
		end)

		if #arg0._noticeDic[iter2] == 0 then
			setActive(var5, false)
		else
			arg0.defaultMainTab = arg0.defaultMainTab or iter2
		end
	end

	if arg0.defaultMainTab then
		arg0.tempSubTab = arg0.defaultSubTab

		triggerToggle(arg0._mainTabContainer:GetChild(arg0.defaultMainTab - 1), true)
	end
end

function var0.setNotices(arg0, arg1)
	arg0:clearTab()

	for iter0, iter1 in pairs(arg1) do
		table.insert(arg0.noticeKeys, tostring(iter1.id))
		table.insert(arg0.noticeVersions, iter1.version)

		local var0 = cloneTplTo(arg0._tabTpl, arg0._subTabContainer)

		SetActive(var0, true)
		table.insert(arg0._subTabList, var0)
		table.insert(arg0._subTabAnims, var0:Find("select_state"):GetComponent(typeof(Animation)))
		setScrollText(var0:Find("common_state/mask/Text"), iter1.btnTitle)
		setScrollText(var0:Find("select_state/mask/Text"), iter1.btnTitle)
		GetSpriteFromAtlasAsync("ui/newbulletinboardui_atlas", var0.ICON_NAME[iter1.icon], function(arg0)
			setImageSprite(var0:Find("common_state/icon"), arg0)
		end)
		GetSpriteFromAtlasAsync("ui/newbulletinboardui_atlas", var0.ICON_NAME[iter1.icon] .. "_selected", function(arg0)
			setImageSprite(var0:Find("select_state/icon"), arg0)
		end)
		onToggle(arg0, var0, function(arg0)
			if arg0 then
				setActive(var0:Find("select_state"), true)

				if arg0.currentSubTab and arg0.currentSubTab == iter0 then
					return
				end

				if arg0.currentSubTab then
					local var0 = arg0.currentSubTab

					arg0._subTabAnims[iter0]:Play(var0 > iter0 and "anim_BB_lefttitle_B_in" or "anim_BB_lefttitle_T_in")
					arg0._subTabAnims[var0]:Play(var0 > iter0 and "anim_BB_lefttitle_T_out" or "anim_BB_lefttitle_B_out")

					arg0.subTabLT = LeanTween.delayedCall(0.26, System.Action(function()
						setActive(arg0._subTabList[var0]:Find("select_state"), false)
					end)).uniqueId

					arg0._contentAnim:Play(var0 > iter0 and "anim_BB_view_B_in" or "anim_BB_view_T_in")
				end

				arg0.currentSubTab = iter0

				PlayerPrefs.SetInt(arg0._noticeDic[arg0.currentMainTab][iter0].code, 0)
				arg0:updateRed()
				arg0:setNoticeDetail(iter1)
			end
		end, SFX_PANEL)
	end

	arg0.defaultSubTab = arg0.defaultSubTab or 1

	triggerToggle(arg0._subTabList[arg0.defaultSubTab], true)
	BulletinBoardMgr.Inst:ClearCache(arg0.noticeKeys, arg0.noticeVersions)
end

function var0.setImage(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg4:Find("img"):GetComponent(typeof(Image))
	local var1 = arg4:Find("loading")

	var0.color = Color.New(0, 0, 0, 0.4)

	setActive(var1, true)

	arg0._loadingFlag[arg3] = true

	BulletinBoardMgr.Inst:GetSprite(arg1, arg2, arg3, UnityEngine.Events.UnityAction_UnityEngine_Sprite(function(arg0)
		if arg0._loadingFlag == nil then
			return
		end

		arg0._loadingFlag[arg3] = nil

		if arg0 ~= nil and not IsNil(arg4) then
			setImageSprite(var0, arg0, false)

			var0.color = Color.New(1, 1, 1)

			setActive(var1, false)
		end
	end))
end

function var0.setNoticeDetail(arg0, arg1)
	local function var0(arg0)
		local var0 = cloneTplTo(arg0._contentBannerTpl, arg0._contentContainer)

		table.insert(arg0._contentList, var0)
		arg0:setImage(arg1.id, arg1.version, arg0, var0, true, nil)
	end

	local function var1(arg0)
		local var0 = cloneTplTo(arg0._contentTxtTpl, arg0._contentContainer)

		table.insert(arg0._contentList, var0)
		setText(var0, SwitchSpecialChar(arg0, true))
		var0:GetComponent("RichText"):AddListener(function(arg0, arg1)
			if arg0 == "url" then
				Application.OpenURL(arg1)
			end
		end)
	end

	arg0:clearLoadingPic()
	arg0:clearLeanTween()
	arg0:clearContent()

	if arg1.paramType or arg1.link then
		setActive(arg0._detailTitle, false)
		setActive(arg0._detailLine, false)
		setActive(arg0._contentContainer, false)

		arg0._detailTitleImgLayoutElement.preferredHeight = var0.TITLE_IMAGE_HEIGHT_FULL

		arg0:setImage(arg1.id, arg1.version, arg1.titleImage, arg0._detailTitleImg)
		onButton(arg0, arg0._detailTitleImg, function()
			if arg1.link then
				if arg1.link == "activity" then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.ACTIVITY)
				elseif arg1.link == "build" then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.GETBOAT)
				elseif arg1.link == "furniture" then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.COURTYARD, {
						OpenShop = true
					})
				elseif arg1.link == "skin" then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.SKINSHOP)
				elseif arg1.link == "shop" then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.SHOP)
				elseif arg1.link == "dewenjun" then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.OTHERWORLD_MAP, {
						openTerminal = true,
						terminalPage = OtherworldTerminalLayer.PAGE_ADVENTURE
					})
				else
					Application.OpenURL(arg1.link)
					arg0:emit(NewBulletinBoardMediator.TRACK_OPEN_URL, arg1.track)
				end
			end

			if arg1.paramType then
				if arg1.paramType == 1 then
					Application.OpenURL(arg1.param)
					arg0:emit(NewBulletinBoardMediator.TRACK_OPEN_URL, arg1.track)
				elseif arg1.paramType == 2 then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, arg1.param)
				elseif arg1.paramType == 3 then
					arg0:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.ACTIVITY, {
						id = arg1.param
					})
				end
			end

			arg0.contextData.defaultMainTab = arg0.currentMainTab
			arg0.contextData.defaultSubTab = arg0.currentSubTab
		end, SFX_PANEL)
	else
		setActive(arg0._detailTitle, true)
		setActive(arg0._detailLine, true)
		setActive(arg0._contentContainer, true)
		setScrollText(arg0._detailTitleTxt, arg1.pageTitle)
		setText(arg0._detailTimeTxt, arg1.timeDes)

		arg0._detailTitleImgLayoutElement.preferredHeight = var0.TITLE_IMAGE_HEIGHT_DEFAULT

		arg0:setImage(arg1.id, arg1.version, arg1.titleImage, arg0._detailTitleImg)
		removeOnButton(arg0._detailTitleImg)

		arg0._contentInfo = {}

		local var2 = 1

		for iter0 in string.gmatch(arg1.content, "<banner>%S-</banner>") do
			local var3, var4 = string.find(iter0, "<banner>")
			local var5, var6 = string.find(iter0, "</banner>")
			local var7 = string.sub(iter0, var4 + 1, var5 - 1)
			local var8, var9 = string.find(arg1.content, iter0, var2, true)

			if var8 ~= nil then
				local var10 = string.sub(arg1.content, var2, var8 - 1)

				if #var10 > 0 then
					table.insert(arg0._contentInfo, {
						type = var0.CONTENT_TYPE.RICHTEXT,
						text = var10
					})
				end
			end

			table.insert(arg0._contentInfo, {
				type = var0.CONTENT_TYPE.BANNER,
				text = var7
			})

			var2 = var9 + 1
		end

		if var2 < #arg1.content then
			table.insert(arg0._contentInfo, {
				type = var0.CONTENT_TYPE.RICHTEXT,
				text = string.sub(arg1.content, var2, #arg1.content)
			})
		end

		for iter1, iter2 in pairs(arg0._contentInfo) do
			if iter2.type == var0.CONTENT_TYPE.RICHTEXT then
				var1(iter2.text)
			elseif iter2.type == var0.CONTENT_TYPE.BANNER then
				var0(iter2.text)
			end
		end

		arg0:bannerRotate()
	end
end

function var0.bannerRotate(arg0)
	for iter0, iter1 in pairs(arg0._contentList) do
		local var0 = iter1:Find("loading/Image")

		if var0 then
			table.insert(arg0.LTList, LeanTween.rotateAroundLocal(rtf(var0), Vector3(0, 0, -1), 360, 5):setLoopClamp().uniqueId)
		end
	end
end

function var0.clearLeanTween(arg0)
	for iter0, iter1 in pairs(arg0.LTList or {}) do
		LeanTween.cancel(iter1)
	end
end

function var0.clearContent(arg0)
	for iter0, iter1 in pairs(arg0._contentList) do
		Destroy(iter1)
	end

	arg0._contentList = {}
end

function var0.clearTab(arg0)
	if arg0.subTabLT then
		LeanTween.cancel(arg0.subTabLT)

		arg0.subTabLT = nil
	end

	arg0.currentSubTab = nil

	for iter0, iter1 in pairs(arg0._subTabList) do
		Destroy(iter1)
	end

	arg0._subTabList = {}
	arg0._subTabAnims = {}
end

function var0.clearLoadingPic(arg0)
	for iter0, iter1 in pairs(arg0._loadingFlag) do
		BulletinBoardMgr.Inst:StopLoader(iter0)

		arg0._loadingFlag[iter0] = nil
	end
end

function var0.willExit(arg0)
	arg0:clearLoadingPic()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
