local var0_0 = class("NewBulletinBoardLayer", import("..base.BaseUI"))

var0_0.CONTENT_TYPE = {
	BANNER = "BANNER",
	RICHTEXT = "RITCHTEXT"
}
var0_0.ICON_NAME = {
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
var0_0.MAIN_TAB_GAMETIP = {
	"Announcements_Event_Notice",
	"Announcements_System_Notice",
	"Announcements_News"
}
var0_0.TITLE_IMAGE_HEIGHT_DEFAULT = 231
var0_0.TITLE_IMAGE_HEIGHT_FULL = 734

function var0_0.getUIName(arg0_1)
	return "NewBulletinBoardUI"
end

function var0_0.init(arg0_2)
	arg0_2._closeBtn = arg0_2:findTF("bg/close_btn")
	arg0_2._mainTabContainer = arg0_2:findTF("bg/notice_list")
	arg0_2._subTabGroup = arg0_2:findTF("bg/title_list/viewport/content"):GetComponent(typeof(ToggleGroup))
	arg0_2._subTabContainer = arg0_2:findTF("bg/title_list/viewport/content")
	arg0_2._tabTpl = arg0_2:findTF("bg/title_list/tab_btn_tpl")

	SetActive(arg0_2._tabTpl, false)

	arg0_2._subTabList = {}
	arg0_2._contentTF = arg0_2:findTF("bg/content_view/viewport/content")
	arg0_2._detailTitleImg = arg0_2:findTF("title_img", arg0_2._contentTF)
	arg0_2._detailTitleImgLayoutElement = arg0_2._detailTitleImg:GetComponent(typeof(LayoutElement))
	arg0_2._detailTitle = arg0_2:findTF("title", arg0_2._contentTF)
	arg0_2._detailTitleTxt = arg0_2:findTF("title/title_txt/mask/scroll_txt", arg0_2._contentTF)
	arg0_2._detailTimeTxt = arg0_2:findTF("title/time_txt", arg0_2._contentTF)
	arg0_2._detailLine = arg0_2:findTF("line", arg0_2._contentTF)
	arg0_2._bottom = arg0_2:findTF("bottom", arg0_2._contentTF)
	arg0_2._contentContainer = arg0_2:findTF("content_container", arg0_2._contentTF)
	arg0_2._contentTxtTpl = arg0_2:findTF("content_txt", arg0_2._contentTF)

	setActive(arg0_2._contentTxtTpl, false)

	arg0_2._contentBannerTpl = arg0_2:findTF("content_banner", arg0_2._contentTF)

	setActive(arg0_2._contentBannerTpl, false)

	arg0_2._scrollRect = arg0_2:findTF("bg/content_view"):GetComponent(typeof(ScrollRect))
	arg0_2._dontshow = arg0_2:findTF("bg/dont_show")
	arg0_2._stopRemind = arg0_2:findTF("bg/dont_show/bottom")
	arg0_2._subTabAnims = {}
	arg0_2._mainAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2._bgAnim = arg0_2:findTF("bg"):GetComponent(typeof(Animation))
	arg0_2._contentAnim = arg0_2:findTF("bg/content_view"):GetComponent(typeof(Animation))

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_2._loadingFlag = {}
	arg0_2._contentList = {}
	arg0_2._noticeDic = {
		{},
		{},
		{}
	}
	arg0_2._redDic = {
		{},
		{},
		{}
	}
	arg0_2.noticeKeys = {}
	arg0_2.noticeVersions = {}
	arg0_2.LTList = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3._mainAnim:Play("anim_BulletinBoard_in")
	onButton(arg0_3, arg0_3._closeBtn, function()
		arg0_3._mainAnim:Play("anim_BulletinBoard_out")
		LeanTween.delayedCall(0.2, System.Action(function()
			arg0_3:emit(var0_0.ON_CLOSE)
		end))
	end, SOUND_BACK)
	onToggle(arg0_3, arg0_3._stopRemind, function(arg0_6)
		arg0_3:emit(NewBulletinBoardMediator.SET_STOP_REMIND, arg0_6)
	end)

	local var0_3 = getProxy(ServerNoticeProxy):getStopRemind()

	triggerToggle(arg0_3._stopRemind, var0_3)
	setText(arg0_3._dontshow, i18n("Announcements_Donotshow"))
	LeanTween.rotateAroundLocal(rtf(arg0_3._detailTitleImg:Find("loading/Image")), Vector3(0, 0, -1), 360, 5):setLoopClamp()
end

function var0_0.updateRed(arg0_7)
	for iter0_7 = 1, 3 do
		local var0_7 = false

		for iter1_7, iter2_7 in pairs(arg0_7._noticeDic[iter0_7]) do
			arg0_7._redDic[iter0_7][iter1_7] = PlayerPrefs.HasKey(iter2_7.code)

			if not arg0_7._redDic[iter0_7][iter1_7] then
				var0_7 = true
			end
		end

		setActive(arg0_7._mainTabContainer:GetChild(iter0_7 - 1):Find("Text/red"), var0_7)
	end

	for iter3_7 = 1, #arg0_7._subTabList do
		setActive(arg0_7._subTabList[iter3_7]:Find("red"), not arg0_7._redDic[arg0_7.currentMainTab][iter3_7])
	end
end

function var0_0.checkNotice(arg0_8, arg1_8)
	return arg1_8.type and arg1_8.type > 0 and arg1_8.type < 4 and (arg1_8.paramType == nil or arg1_8.paramType == 1 and type(arg1_8.param) == "string" or arg1_8.paramType == 2 and type(arg1_8.param) == "string" or arg1_8.paramType == 3 and type(arg1_8.param) == "number" or arg1_8.paramType == 4 and type(arg1_8.param) == "number" and pg.activity_banner_notice[arg1_8.param] ~= nil)
end

function var0_0.initNotices(arg0_9, arg1_9)
	arg0_9.defaultMainTab = arg0_9.contextData.defaultMainTab
	arg0_9.defaultSubTab = arg0_9.contextData.defaultSubTab

	local var0_9
	local var1_9

	for iter0_9, iter1_9 in pairs(arg1_9) do
		if arg0_9:checkNotice(iter1_9) then
			table.insert(arg0_9._noticeDic[iter1_9.type], iter1_9)
			table.insert(arg0_9._redDic[iter1_9.type], PlayerPrefs.HasKey(iter1_9.code))

			if not var1_9 or var1_9 < iter1_9.priority then
				var1_9 = iter1_9.priority
				var0_9 = iter1_9.type
			end

			table.insert(arg0_9.noticeKeys, tostring(iter1_9.id))
			table.insert(arg0_9.noticeVersions, iter1_9.version)
		else
			Debugger.LogWarning("公告配置错误  id = " .. iter1_9.id)
		end
	end

	for iter2_9 = 1, 3 do
		local var2_9 = arg0_9._mainTabContainer:GetChild(iter2_9 - 1)
		local var3_9 = var2_9:Find("selected"):GetComponent(typeof(Animation))

		setText(var2_9:Find("Text"), i18n(var0_0.MAIN_TAB_GAMETIP[iter2_9]))
		onToggle(arg0_9, var2_9, function(arg0_10)
			if arg0_10 then
				if arg0_9.currentMainTab and arg0_9.currentMainTab == iter2_9 then
					return
				end

				if arg0_9.currentMainTab then
					var3_9:Play(arg0_9.currentMainTab > iter2_9 and "anim_BB_toptitle_R_in" or "anim_BB_toptitle_L_in")
					arg0_9._bgAnim:Play(arg0_9.currentMainTab > iter2_9 and "anim_BulletinBoard_Rin_change" or "anim_BulletinBoard_Lin_change")
				end

				arg0_9.currentMainTab = iter2_9
				arg0_9.defaultSubTab = arg0_9.tempSubTab
				arg0_9.tempSubTab = nil

				arg0_9:setNotices(arg0_9._noticeDic[iter2_9])
			end
		end)

		if #arg0_9._noticeDic[iter2_9] == 0 then
			setActive(var2_9, false)
		end
	end

	arg0_9.defaultMainTab = arg0_9.defaultMainTab or var0_9

	if arg0_9.defaultMainTab then
		arg0_9.tempSubTab = arg0_9.defaultSubTab

		triggerToggle(arg0_9._mainTabContainer:GetChild(arg0_9.defaultMainTab - 1), true)
	end

	BulletinBoardMgr.Inst:ClearCache(arg0_9.noticeKeys, arg0_9.noticeVersions)
end

function var0_0.setNotices(arg0_11, arg1_11)
	arg0_11:clearTab()

	for iter0_11, iter1_11 in pairs(arg1_11) do
		local var0_11 = cloneTplTo(arg0_11._tabTpl, arg0_11._subTabContainer)

		SetActive(var0_11, true)
		table.insert(arg0_11._subTabList, var0_11)
		table.insert(arg0_11._subTabAnims, var0_11:Find("select_state"):GetComponent(typeof(Animation)))
		setScrollText(var0_11:Find("common_state/mask/Text"), iter1_11.btnTitle)
		setScrollText(var0_11:Find("select_state/mask/Text"), iter1_11.btnTitle)
		GetSpriteFromAtlasAsync("ui/newbulletinboardui_atlas", var0_0.ICON_NAME[iter1_11.icon], function(arg0_12)
			setImageSprite(var0_11:Find("common_state/icon"), arg0_12)
		end)
		GetSpriteFromAtlasAsync("ui/newbulletinboardui_atlas", var0_0.ICON_NAME[iter1_11.icon] .. "_selected", function(arg0_13)
			setImageSprite(var0_11:Find("select_state/icon"), arg0_13)
		end)
		onToggle(arg0_11, var0_11, function(arg0_14)
			if arg0_14 then
				setActive(var0_11:Find("select_state"), true)

				if arg0_11.currentSubTab and arg0_11.currentSubTab == iter0_11 then
					return
				end

				if arg0_11.currentSubTab then
					local var0_14 = arg0_11.currentSubTab

					arg0_11._subTabAnims[iter0_11]:Play(var0_14 > iter0_11 and "anim_BB_lefttitle_B_in" or "anim_BB_lefttitle_T_in")
					arg0_11._subTabAnims[var0_14]:Play(var0_14 > iter0_11 and "anim_BB_lefttitle_T_out" or "anim_BB_lefttitle_B_out")

					arg0_11.subTabLT = LeanTween.delayedCall(0.26, System.Action(function()
						setActive(arg0_11._subTabList[var0_14]:Find("select_state"), false)
					end)).uniqueId

					arg0_11._contentAnim:Play(var0_14 > iter0_11 and "anim_BB_view_B_in" or "anim_BB_view_T_in")
				end

				arg0_11.currentSubTab = iter0_11

				PlayerPrefs.SetInt(arg0_11._noticeDic[arg0_11.currentMainTab][iter0_11].code, 0)
				arg0_11:updateRed()
				arg0_11:setNoticeDetail(iter1_11)
			end
		end, SFX_PANEL)
	end

	arg0_11.defaultSubTab = arg0_11.defaultSubTab or 1

	triggerToggle(arg0_11._subTabList[arg0_11.defaultSubTab], true)
end

function var0_0.setImage(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	local var0_16 = arg4_16:Find("img"):GetComponent(typeof(Image))
	local var1_16 = arg4_16:Find("loading")

	var0_16.color = Color.New(0, 0, 0, 0.4)

	setActive(var1_16, true)

	arg0_16._loadingFlag[arg3_16] = true

	BulletinBoardMgr.Inst:GetSprite(arg1_16, arg2_16, arg3_16, UnityEngine.Events.UnityAction_UnityEngine_Sprite(function(arg0_17)
		if arg0_16._loadingFlag == nil then
			return
		end

		arg0_16._loadingFlag[arg3_16] = nil

		if arg0_17 ~= nil and not IsNil(arg4_16) then
			setImageSprite(var0_16, arg0_17, false)

			var0_16.color = Color.New(1, 1, 1)

			setActive(var1_16, false)
		end
	end))
end

function var0_0.setNoticeDetail(arg0_18, arg1_18)
	local function var0_18(arg0_19)
		local var0_19 = cloneTplTo(arg0_18._contentBannerTpl, arg0_18._contentContainer)

		table.insert(arg0_18._contentList, var0_19)
		arg0_18:setImage(arg1_18.id, arg1_18.version, arg0_19, var0_19, true, nil)
	end

	local function var1_18(arg0_20)
		local var0_20 = cloneTplTo(arg0_18._contentTxtTpl, arg0_18._contentContainer)

		table.insert(arg0_18._contentList, var0_20)
		setText(var0_20, SwitchSpecialChar(arg0_20, true))
		var0_20:GetComponent("RichText"):AddListener(function(arg0_21, arg1_21)
			if arg0_21 == "url" then
				Application.OpenURL(arg1_21)
			end
		end)
	end

	arg0_18:clearLoadingPic()
	arg0_18:clearLeanTween()
	arg0_18:clearContent()

	if arg1_18.paramType then
		setActive(arg0_18._detailTitle, false)
		setActive(arg0_18._detailLine, false)
		setActive(arg0_18._contentContainer, false)
		setActive(arg0_18._bottom, false)

		arg0_18._detailTitleImgLayoutElement.preferredHeight = var0_0.TITLE_IMAGE_HEIGHT_FULL

		arg0_18:setImage(arg1_18.id, arg1_18.version, arg1_18.titleImage, arg0_18._detailTitleImg)
		onButton(arg0_18, arg0_18._detailTitleImg, function()
			if arg1_18.paramType == 1 then
				Application.OpenURL(arg1_18.param)
				arg0_18:emit(NewBulletinBoardMediator.TRACK_OPEN_URL, arg1_18.track)
			elseif arg1_18.paramType == 2 then
				arg0_18:emit(NewBulletinBoardMediator.GO_SCENE, arg1_18.param)
			elseif arg1_18.paramType == 3 then
				arg0_18:emit(NewBulletinBoardMediator.GO_SCENE, SCENE.ACTIVITY, {
					id = arg1_18.param
				})
			elseif arg1_18.paramType == 4 then
				local var0_22 = pg.activity_banner_notice[arg1_18.param].param

				arg0_18:emit(NewBulletinBoardMediator.GO_SCENE, var0_22[1], var0_22[2])
			end

			arg0_18.contextData.defaultMainTab = arg0_18.currentMainTab
			arg0_18.contextData.defaultSubTab = arg0_18.currentSubTab
		end, SFX_PANEL)
	else
		setActive(arg0_18._detailTitle, true)
		setActive(arg0_18._detailLine, true)
		setActive(arg0_18._contentContainer, true)
		setActive(arg0_18._bottom, true)
		setScrollText(arg0_18._detailTitleTxt, arg1_18.pageTitle)
		setText(arg0_18._detailTimeTxt, arg1_18.timeDes)

		arg0_18._detailTitleImgLayoutElement.preferredHeight = var0_0.TITLE_IMAGE_HEIGHT_DEFAULT

		arg0_18:setImage(arg1_18.id, arg1_18.version, arg1_18.titleImage, arg0_18._detailTitleImg)
		removeOnButton(arg0_18._detailTitleImg)

		local function var2_18(arg0_23)
			local var0_23 = #arg0_23

			if #arg0_23 == 0 then
				return ""
			end

			local var1_23, var2_23 = string.find(arg0_23, "^[ ]*\n")

			var2_23 = var2_23 or 0

			local var3_23 = string.find(arg0_23, "\n[ ]*$") or var0_23 + 1

			return string.sub(arg0_23, var2_23 + 1, var3_23 - 1)
		end

		arg0_18._contentInfo = {}

		local var3_18 = 1

		for iter0_18 in string.gmatch(arg1_18.content, "<banner>%S-</banner>") do
			local var4_18, var5_18 = string.find(iter0_18, "<banner>")
			local var6_18, var7_18 = string.find(iter0_18, "</banner>")
			local var8_18 = string.sub(iter0_18, var5_18 + 1, var6_18 - 1)
			local var9_18, var10_18 = string.find(arg1_18.content, iter0_18, var3_18, true)

			if var9_18 ~= nil then
				local var11_18 = var2_18(string.sub(arg1_18.content, var3_18, var9_18 - 1))

				if #var11_18 > 0 then
					table.insert(arg0_18._contentInfo, {
						type = var0_0.CONTENT_TYPE.RICHTEXT,
						text = var11_18
					})
				end
			end

			table.insert(arg0_18._contentInfo, {
				type = var0_0.CONTENT_TYPE.BANNER,
				text = var8_18
			})

			var3_18 = var10_18 + 1
		end

		if var3_18 < #arg1_18.content then
			table.insert(arg0_18._contentInfo, {
				type = var0_0.CONTENT_TYPE.RICHTEXT,
				text = var2_18(string.sub(arg1_18.content, var3_18, #arg1_18.content))
			})
		end

		for iter1_18, iter2_18 in pairs(arg0_18._contentInfo) do
			if iter2_18.type == var0_0.CONTENT_TYPE.RICHTEXT then
				var1_18(iter2_18.text)
			elseif iter2_18.type == var0_0.CONTENT_TYPE.BANNER then
				var0_18(iter2_18.text)
			end
		end

		arg0_18:bannerRotate()
	end
end

function var0_0.bannerRotate(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24._contentList) do
		local var0_24 = iter1_24:Find("loading/Image")

		if var0_24 then
			table.insert(arg0_24.LTList, LeanTween.rotateAroundLocal(rtf(var0_24), Vector3(0, 0, -1), 360, 5):setLoopClamp().uniqueId)
		end
	end
end

function var0_0.clearLeanTween(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.LTList or {}) do
		LeanTween.cancel(iter1_25)
	end
end

function var0_0.clearContent(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26._contentList) do
		Destroy(iter1_26)
	end

	arg0_26._contentList = {}
end

function var0_0.clearTab(arg0_27)
	if arg0_27.subTabLT then
		LeanTween.cancel(arg0_27.subTabLT)

		arg0_27.subTabLT = nil
	end

	arg0_27.currentSubTab = nil

	for iter0_27, iter1_27 in pairs(arg0_27._subTabList) do
		Destroy(iter1_27)
	end

	arg0_27._subTabList = {}
	arg0_27._subTabAnims = {}
end

function var0_0.clearLoadingPic(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28._loadingFlag) do
		BulletinBoardMgr.Inst:StopLoader(iter0_28)

		arg0_28._loadingFlag[iter0_28] = nil
	end
end

function var0_0.willExit(arg0_29)
	arg0_29:clearLoadingPic()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_29._tf)
end

return var0_0
