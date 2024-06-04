local var0 = class("BulletinBoardLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "BulletinBoardUI"
end

function var0.init(arg0)
	arg0._closeBtn = arg0:findTF("close_btn")
	arg0._tabGroup = arg0:findTF("title_list/viewport/content"):GetComponent(typeof(ToggleGroup))
	arg0._tabContainer = arg0:findTF("title_list/viewport/content")
	arg0._tabTpl = arg0:findTF("title_list/tab_btn_tpl")

	SetActive(arg0._tabTpl, false)

	arg0._tabList = {}
	arg0._detailTitleImg = arg0:findTF("content_view/viewport/content/title_img/img")
	arg0._detailTitleImgComp = arg0._detailTitleImg:GetComponent(typeof(Image))
	arg0._detailTitleLoading = arg0:findTF("content_view/viewport/content/title_img/loading")
	arg0._detailTitleTxt = arg0:findTF("content_view/viewport/content/title_txt")
	arg0._detailTimeTxt = arg0:findTF("content_view/viewport/content/time_txt")
	arg0._detailContentTxt = arg0:findTF("content_view/viewport/content/content_txt")
	arg0._detailContentTxtComp = arg0._detailContentTxt:GetComponent("RichText")

	arg0._detailContentTxtComp:AddListener(function(arg0, arg1)
		if arg0 == "url" then
			Application.OpenURL(arg1)
		end
	end)

	arg0._scrollRect = arg0:findTF("content_view"):GetComponent(typeof(ScrollRect))
	arg0._stopRemind = arg0:findTF("dontshow_tab")

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0._loadingFlag = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	onToggle(arg0, arg0._stopRemind, function(arg0)
		arg0:emit(BulletinBoardMediator.SET_STOP_REMIND, arg0)
	end)

	local var0 = getProxy(ServerNoticeProxy):getStopRemind()

	triggerToggle(arg0._stopRemind, var0)
end

function var0.setNotices(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in pairs(arg1) do
		table.insert(var0, tostring(iter1.id))
		table.insert(var1, iter1.version)

		local var2 = cloneTplTo(arg0._tabTpl, arg0._tabContainer)

		setScrollText(var2:Find("common_state/title_mask/title_txt"), iter1.btnTitle)
		setScrollText(var2:Find("select_state/title_mask/title_txt"), iter1.btnTitle)
		changeToScrollText(var2:Find("common_state/time_txt"), iter1.title)
		changeToScrollText(var2:Find("select_state/time_txt"), iter1.title)
		table.insert(arg0._tabList, var2)
		SetActive(var2, true)

		GetComponent(var2, typeof(Toggle)).group = arg0._tabGroup

		onToggle(arg0, var2, function(arg0)
			if arg0 then
				arg0:setNoticeDetail(iter1)
			end

			setActive(var2:Find("common_state"), not arg0)
		end, SFX_PANEL)
	end

	triggerToggle(arg0._tabList[1], true)
	BulletinBoardMgr.Inst:ClearCache(var0, var1)
end

function var0.setNoticeDetail(arg0, arg1)
	arg0:clearLoadingPic()
	setText(arg0._detailTitleTxt, arg1.pageTitle)
	setText(arg0._detailTimeTxt, arg1.timeDes)

	arg0._detailTitleImgComp.color = Color.New(0, 0, 0, 0.4)

	setActive(arg0._detailTitleLoading, true)

	arg0._loadingFlag[arg1.titleImage] = true

	BulletinBoardMgr.Inst:GetSprite(arg1.id, arg1.version, arg1.titleImage, UnityEngine.Events.UnityAction_UnityEngine_Sprite(function(arg0)
		arg0._loadingFlag[arg1.titleImage] = nil

		if arg0 ~= nil then
			setImageSprite(arg0._detailTitleImg, arg0, false)

			arg0._detailTitleImgComp.color = Color.New(1, 1, 1, 1)

			setActive(arg0._detailTitleLoading, false)
		end
	end))

	arg0.tempContent = arg1.content
	arg0.realContent = arg1.content
	arg0.loadingCount = 0
	arg0.loadPic = {}

	for iter0 in string.gmatch(arg1.content, "<imgHref>%S-</imgHref>") do
		local var0, var1 = string.find(iter0, "<imgHref>")
		local var2, var3 = string.find(iter0, "</imgHref>")
		local var4 = string.sub(iter0, var1 + 1, var2 - 1)
		local var5 = "<icon name=" .. var4 .. " w=2 h=2/>"
		local var6 = string.gsub(iter0, "%.", "%%.")
		local var7 = string.gsub(var6, "%-", "%%-")
		local var8 = string.gsub(var7, "%?", "%%?")

		arg0.realContent = string.gsub(arg0.realContent, var8, var5)
		arg0.tempContent = string.gsub(arg0.tempContent, var8, "")

		table.insert(arg0.loadPic, var4)
	end

	local var9 = SwitchSpecialChar(arg0.tempContent, true)

	setText(arg0._detailContentTxt, var9)

	arg0.loadingCount = #arg0.loadPic

	for iter1, iter2 in ipairs(arg0.loadPic) do
		arg0._loadingFlag[iter2] = true

		BulletinBoardMgr.Inst:GetSprite(arg1.id, arg1.version, iter2, UnityEngine.Events.UnityAction_UnityEngine_Sprite(function(arg0)
			arg0._loadingFlag[iter2] = nil

			if arg0 ~= nil then
				arg0.loadingCount = arg0.loadingCount - 1

				arg0._detailContentTxtComp:AddSprite(arg0.name, arg0)

				if arg0.loadingCount <= 0 then
					setText(arg0._detailContentTxt, SwitchSpecialChar(arg0.realContent, true))
				end
			end
		end))
	end
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
