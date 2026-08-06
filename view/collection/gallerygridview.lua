local var0_0 = class("GalleryGridView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.owner = arg2_1
	arg0_1.gridPanel = arg1_1
	arg0_1.rootTF = arg1_1.parent
	arg0_1.isDisposed = false

	arg0_1:initUIRefs()
	arg0_1:initData()
	arg0_1:initScrollCallbacks()
end

function var0_0.initUIRefs(arg0_2)
	arg0_2.scrollListContainer = arg0_2.gridPanel:Find("Content")
	arg0_2.scrollRect = GetComponent(arg0_2.scrollListContainer, "LScrollRect")

	arg0_2.scrollRect:BeginLayout()
	arg0_2.scrollRect:EndLayout()

	arg0_2.cardTpl = arg0_2.gridPanel:Find("Card")
end

function var0_0.initData(arg0_3)
	arg0_3.resLoader = AutoLoader.New()
	arg0_3.cardTFList = {}
end

function var0_0.dispose(arg0_4)
	arg0_4.isDisposed = true

	arg0_4.resLoader:Clear()
end

function var0_0.isDestroyed(arg0_5)
	return arg0_5.isDisposed or not arg0_5.owner or arg0_5.owner.exited
end

function var0_0.initScrollCallbacks(arg0_6)
	function arg0_6.scrollRect.onInitItem(arg0_7)
		arg0_6:onInitItem(arg0_7)
	end

	function arg0_6.scrollRect.onUpdateItem(arg0_8, arg1_8)
		arg0_6:onUpdateItem(arg0_8, arg1_8)
	end

	function arg0_6.scrollRect.onReturnItem(arg0_9, arg1_9)
		arg0_6:onReturnItem(arg0_9, arg1_9)
	end
end

function var0_0.onInitItem(arg0_10, arg1_10)
	local var0_10 = tf(arg1_10)

	setActive(var0_10, true)
end

function var0_0.onUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11 + 1
	local var1_11 = tf(arg2_11)

	arg0_11.cardTFList[var0_11] = var1_11

	if arg0_11:getPicInfoForShowByIndex(var0_11) == false then
		arg0_11:updateEmptyCard(var1_11)
	else
		arg0_11:updateCard(var0_11, var1_11)
	end
end

function var0_0.onReturnItem(arg0_12, arg1_12, arg2_12)
	arg0_12.cardTFList[arg1_12 + 1] = nil
end

function var0_0.refresh(arg0_13, arg1_13)
	if arg0_13:isDestroyed() then
		return
	end

	arg1_13 = arg1_13 or {}
	arg0_13.cardTFList = {}

	arg0_13.resLoader:Clear()
	arg0_13.scrollRect:SetTotalCount(#arg1_13, -1)
end

function var0_0.openPicViewLayer(arg0_14, arg1_14)
	local var0_14 = arg0_14:getPicInfoForShowByIndex(arg1_14)

	if not var0_14 then
		return
	end

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AppreciatePicViewMediator,
		viewComponent = AppreciatePicViewLayer,
		data = {
			isShowLikeBtn = true,
			curPicInfo = var0_14,
			picInfoList = arg0_14:getPicInfoListForShow()
		},
		onRemoved = function()
			if not arg0_14:isDestroyed() then
				arg0_14:refreshVisibleCards()
			end
		end
	}))
end

function var0_0.updateCard(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:getPicInfoForShowByIndex(arg1_16)

	setActive(arg2_16, true)

	local var1_16 = arg2_16:Find("Update")
	local var2_16 = var1_16:Find("Progress")

	setActive(var1_16, false)
	setActive(var2_16, false)

	local var3_16 = arg2_16:Find("Image")
	local var4_16 = arg2_16:Find("NumText")
	local var5_16 = arg2_16:Find("NewTag")

	arg0_16:updateCardImg(var0_16, var3_16)
	setActive(var4_16, true)
	setText(var4_16, string.format("%d", arg1_16))
	setActive(var5_16, arg0_16:isPicNew(var0_16))
	onButton(arg0_16.owner, arg2_16, function()
		arg0_16:openPicViewLayer(arg1_16)
	end, SFX_PANEL)
end

function var0_0.updateCardImg(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18:getPreviewPicPath(arg1_18)
	local var1_18 = GetFileName(var0_18)
	local var2_18 = GetComponent(arg2_18, typeof(Image)).sprite

	if not IsNil(var2_18) then
		local var3_18 = var2_18.name

		if string.lower(var3_18) ~= string.lower(var1_18) then
			arg0_18.resLoader:LoadSprite(var0_18, var1_18, arg2_18, false)
		end
	else
		arg0_18.resLoader:LoadSprite(var0_18, var1_18, arg2_18, false)
	end
end

function var0_0.updateEmptyCard(arg0_19, arg1_19)
	setActive(arg1_19, true)

	local var0_19

	for iter0_19, iter1_19 in ipairs(arg0_19.owner.picInfoListForShow) do
		if iter1_19 then
			var0_19 = iter1_19

			break
		end
	end

	if not var0_19 then
		return
	end

	local var1_19 = arg1_19:Find("Image")
	local var2_19 = arg1_19:Find("NumText")
	local var3_19 = arg1_19:Find("NewTag")

	arg0_19:updateCardImg(var0_19, var1_19)
	setActive(var2_19, false)
	setActive(var3_19, false)
	arg0_19:updateEmptyCardDownloadState(arg1_19)
end

function var0_0.updateEmptyCardDownloadState(arg0_20, arg1_20)
	local var0_20 = arg1_20:Find("Update")
	local var1_20 = var0_20:Find("Btn")
	local var2_20 = var1_20:Find("Text")
	local var3_20 = var0_20:Find("Progress")
	local var4_20 = var3_20:Find("Slider")
	local var5_20 = arg0_20.owner:isGalleryDownloading()
	local var6_20, var7_20 = arg0_20.owner:getGalleryDownloadProgress()

	setActive(var0_20, true)
	setActive(var1_20, not var5_20)
	setActive(var3_20, var5_20)

	if var5_20 then
		setText(var2_20, i18n("word_manga_updating", var6_20, var7_20))
		setSlider(var4_20, 0, math.max(var7_20, 1), var6_20)
	elseif arg0_20.owner:isGalleryDownloadFailed() then
		setText(var2_20, i18n("word_manga_updatefailure"))
		setSlider(var4_20, 0, 1, 0)
	else
		setText(var2_20, i18n("word_manga_checktoupdate"))
		setSlider(var4_20, 0, 1, 0)
	end

	onButton(arg0_20.owner, var1_20, function()
		arg0_20.owner:showDownloadMsgBox()
	end, SFX_PANEL)
end

function var0_0.updateEmptyCardDownloadStateList(arg0_22)
	if arg0_22:isDestroyed() then
		return
	end

	for iter0_22, iter1_22 in pairs(arg0_22.cardTFList) do
		if iter1_22 and arg0_22:getPicInfoForShowByIndex(iter0_22) == false then
			arg0_22:updateEmptyCardDownloadState(iter1_22)

			break
		end
	end
end

function var0_0.refreshVisibleCards(arg0_23)
	if arg0_23:isDestroyed() then
		return
	end

	for iter0_23, iter1_23 in pairs(arg0_23.cardTFList) do
		local var0_23 = arg0_23:getPicInfoForShowByIndex(iter0_23)

		if iter1_23 and var0_23 then
			arg0_23:updateCard(iter0_23, iter1_23)
		end
	end
end

function var0_0.getPreviewPicPath(arg0_24, arg1_24)
	return GalleryConst.GetGalleryPicPathByID(arg1_24.id)
end

function var0_0.isPicNew(arg0_25, arg1_25)
	return AppreciatePicConst.isNewPicInfo(arg1_25)
end

function var0_0.getPicInfoListForShow(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in ipairs(arg0_26.owner.picInfoListForShow) do
		if iter1_26 then
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26
end

function var0_0.getPicInfoForShowByIndex(arg0_27, arg1_27)
	return arg0_27.owner:getPicInfoForShowByIndex(arg1_27)
end

return var0_0
