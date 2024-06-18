local var0_0 = class("BulletinBoardLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BulletinBoardUI"
end

function var0_0.init(arg0_2)
	arg0_2._closeBtn = arg0_2:findTF("close_btn")
	arg0_2._tabGroup = arg0_2:findTF("title_list/viewport/content"):GetComponent(typeof(ToggleGroup))
	arg0_2._tabContainer = arg0_2:findTF("title_list/viewport/content")
	arg0_2._tabTpl = arg0_2:findTF("title_list/tab_btn_tpl")

	SetActive(arg0_2._tabTpl, false)

	arg0_2._tabList = {}
	arg0_2._detailTitleImg = arg0_2:findTF("content_view/viewport/content/title_img/img")
	arg0_2._detailTitleImgComp = arg0_2._detailTitleImg:GetComponent(typeof(Image))
	arg0_2._detailTitleLoading = arg0_2:findTF("content_view/viewport/content/title_img/loading")
	arg0_2._detailTitleTxt = arg0_2:findTF("content_view/viewport/content/title_txt")
	arg0_2._detailTimeTxt = arg0_2:findTF("content_view/viewport/content/time_txt")
	arg0_2._detailContentTxt = arg0_2:findTF("content_view/viewport/content/content_txt")
	arg0_2._detailContentTxtComp = arg0_2._detailContentTxt:GetComponent("RichText")

	arg0_2._detailContentTxtComp:AddListener(function(arg0_3, arg1_3)
		if arg0_3 == "url" then
			Application.OpenURL(arg1_3)
		end
	end)

	arg0_2._scrollRect = arg0_2:findTF("content_view"):GetComponent(typeof(ScrollRect))
	arg0_2._stopRemind = arg0_2:findTF("dontshow_tab")

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_2._loadingFlag = {}
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._closeBtn, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onToggle(arg0_4, arg0_4._stopRemind, function(arg0_6)
		arg0_4:emit(BulletinBoardMediator.SET_STOP_REMIND, arg0_6)
	end)

	local var0_4 = getProxy(ServerNoticeProxy):getStopRemind()

	triggerToggle(arg0_4._stopRemind, var0_4)
end

function var0_0.setNotices(arg0_7, arg1_7)
	local var0_7 = {}
	local var1_7 = {}

	for iter0_7, iter1_7 in pairs(arg1_7) do
		table.insert(var0_7, tostring(iter1_7.id))
		table.insert(var1_7, iter1_7.version)

		local var2_7 = cloneTplTo(arg0_7._tabTpl, arg0_7._tabContainer)

		setScrollText(var2_7:Find("common_state/title_mask/title_txt"), iter1_7.btnTitle)
		setScrollText(var2_7:Find("select_state/title_mask/title_txt"), iter1_7.btnTitle)
		changeToScrollText(var2_7:Find("common_state/time_txt"), iter1_7.title)
		changeToScrollText(var2_7:Find("select_state/time_txt"), iter1_7.title)
		table.insert(arg0_7._tabList, var2_7)
		SetActive(var2_7, true)

		GetComponent(var2_7, typeof(Toggle)).group = arg0_7._tabGroup

		onToggle(arg0_7, var2_7, function(arg0_8)
			if arg0_8 then
				arg0_7:setNoticeDetail(iter1_7)
			end

			setActive(var2_7:Find("common_state"), not arg0_8)
		end, SFX_PANEL)
	end

	triggerToggle(arg0_7._tabList[1], true)
	BulletinBoardMgr.Inst:ClearCache(var0_7, var1_7)
end

function var0_0.setNoticeDetail(arg0_9, arg1_9)
	arg0_9:clearLoadingPic()
	setText(arg0_9._detailTitleTxt, arg1_9.pageTitle)
	setText(arg0_9._detailTimeTxt, arg1_9.timeDes)

	arg0_9._detailTitleImgComp.color = Color.New(0, 0, 0, 0.4)

	setActive(arg0_9._detailTitleLoading, true)

	arg0_9._loadingFlag[arg1_9.titleImage] = true

	BulletinBoardMgr.Inst:GetSprite(arg1_9.id, arg1_9.version, arg1_9.titleImage, UnityEngine.Events.UnityAction_UnityEngine_Sprite(function(arg0_10)
		arg0_9._loadingFlag[arg1_9.titleImage] = nil

		if arg0_10 ~= nil then
			setImageSprite(arg0_9._detailTitleImg, arg0_10, false)

			arg0_9._detailTitleImgComp.color = Color.New(1, 1, 1, 1)

			setActive(arg0_9._detailTitleLoading, false)
		end
	end))

	arg0_9.tempContent = arg1_9.content
	arg0_9.realContent = arg1_9.content
	arg0_9.loadingCount = 0
	arg0_9.loadPic = {}

	for iter0_9 in string.gmatch(arg1_9.content, "<imgHref>%S-</imgHref>") do
		local var0_9, var1_9 = string.find(iter0_9, "<imgHref>")
		local var2_9, var3_9 = string.find(iter0_9, "</imgHref>")
		local var4_9 = string.sub(iter0_9, var1_9 + 1, var2_9 - 1)
		local var5_9 = "<icon name=" .. var4_9 .. " w=2 h=2/>"
		local var6_9 = string.gsub(iter0_9, "%.", "%%.")
		local var7_9 = string.gsub(var6_9, "%-", "%%-")
		local var8_9 = string.gsub(var7_9, "%?", "%%?")

		arg0_9.realContent = string.gsub(arg0_9.realContent, var8_9, var5_9)
		arg0_9.tempContent = string.gsub(arg0_9.tempContent, var8_9, "")

		table.insert(arg0_9.loadPic, var4_9)
	end

	local var9_9 = SwitchSpecialChar(arg0_9.tempContent, true)

	setText(arg0_9._detailContentTxt, var9_9)

	arg0_9.loadingCount = #arg0_9.loadPic

	for iter1_9, iter2_9 in ipairs(arg0_9.loadPic) do
		arg0_9._loadingFlag[iter2_9] = true

		BulletinBoardMgr.Inst:GetSprite(arg1_9.id, arg1_9.version, iter2_9, UnityEngine.Events.UnityAction_UnityEngine_Sprite(function(arg0_11)
			arg0_9._loadingFlag[iter2_9] = nil

			if arg0_11 ~= nil then
				arg0_9.loadingCount = arg0_9.loadingCount - 1

				arg0_9._detailContentTxtComp:AddSprite(arg0_11.name, arg0_11)

				if arg0_9.loadingCount <= 0 then
					setText(arg0_9._detailContentTxt, SwitchSpecialChar(arg0_9.realContent, true))
				end
			end
		end))
	end
end

function var0_0.clearLoadingPic(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12._loadingFlag) do
		BulletinBoardMgr.Inst:StopLoader(iter0_12)

		arg0_12._loadingFlag[iter0_12] = nil
	end
end

function var0_0.willExit(arg0_13)
	arg0_13:clearLoadingPic()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf)
end

return var0_0
